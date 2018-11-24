-- is the master controller currently in the process of taxing all plots?
local m_Taxing = false

-- DAB TODO EDIT MODE: Automatically attach edit controller
if(ServerSettings.EditMode) then
	this:AddModule("editmode_controller")
end

-- Cluster Controller: This module is attached to the cluster_controller object that is automatically
-- created by the engine at Loc(0.1,0.1,0.1) on the map. 

-- DAB TODO: We should be tracking the users online in the engine
-- This way is messy because regions that crash will not clear their users
-- so everyone who looks at this list has to validate each region entry
-- against the GetClusterRegions function

regionAddress = ServerSettings.RegionAddress

MASTER_CONTROLLER_PULSE_SPEED = TimeSpan.FromMinutes(1)
isMasterController = false

function OnLoad()
	this:SetObjectTag("ClusterController")

	-- DAB TODO: When we support graceful shutdown of regions in a cluster
	-- we need to have another region take master control
	--DebugMessage("[ClusterControl] SERVER_STARTTIME: "..tostring(SERVER_STARTTIME))
	local lastStartTime = GlobalVarReadKey("ClusterControl", "LastStartTime")
	--DebugMessage("[ClusterControl] lastStartTime: "..lastStartTime)
	if ( lastStartTime == nil or lastStartTime ~= SERVER_STARTTIME ) then
		--DebugMessage("[ClusterControl] attempting to take control")
		SetGlobalVar("ClusterControl", function(record)
			-- double check that another region didn't already assume the role of master cluster
			if ( lastStartTime == SERVER_STARTTIME ) then return false end
			record.LastStartTime = SERVER_STARTTIME
			record.Master = this
			return true
		end, function(success)
			if ( success ) then
				-- if successful, we are the master controller, clear User.Online and start the master controller pulse
				DebugMessage("[ClusterControl] "..regionAddress.." is the master controller")
				isMasterController = true
				if ( GlobalVarRead("User.Online") ) then
					DelGlobalVar("User.Online", function()
						this:ScheduleTimerDelay(MASTER_CONTROLLER_PULSE_SPEED,"MasterControllerPulse")
					end)
				else
					this:ScheduleTimerDelay(MASTER_CONTROLLER_PULSE_SPEED,"MasterControllerPulse")
				end
			else
				-- if start time is correct, another region beat us to master controller, double check that is the case
				if ( GlobalVarReadKey("ClusterControl", "LastStartTime") ~= SERVER_STARTTIME ) then
					DebugMessage("ERROR: ClusterControl global var write failed. No master controller detected!!")
				end
			end
		end)
	end
end
mNextGroupScrub = nil
function ValidateGroupData()
	local now = DateTime.UtcNow
	if ( mNextGroupScrub == nil or now > mNextGroupScrub ) then
		mNextGroupScrub = now:Subtract(TimeSpan.FromHours(1))
		GroupScrubStaleRecords()
	end
end

RegisterEventHandler(EventType.CreatedObject, "MarkerCreated", 
	function(success, objRef, markerEntry)
		if (success) then
			objRef:SetObjVar("TooltipName", markerEntry.Tooltip)
		end
	end)

RegisterEventHandler(EventType.Timer,"MasterControllerPulse",
	function ()
		ValidateGroupData()

		-- prevent taxing while taxing
		if not( m_Taxing ) then
			m_Taxing = true
			Plot.SaleAll(this, function()
				Plot.TaxAll(this, function()
					m_Taxing = false
				end)
			end)
		end

		this:ScheduleTimerDelay(MASTER_CONTROLLER_PULSE_SPEED,"MasterControllerPulse")
	end)

RegisterEventHandler(EventType.Message, "ForceTaxAll", function()
	m_Taxing = true
	Plot.TaxAll(this, function()
		DebugMessage("Forced Tax Done.")
		m_Taxing = false
	end, true)
end)
RegisterEventHandler(EventType.Message, "ForceSaleAll", function()
	m_Taxing = true
	Plot.SaleAll(this, function()
		DebugMessage("Forced Sale Done.")
		m_Taxing = false
	end, true)
end)
RegisterEventHandler(EventType.Message, "DoPlotTax", function()
	Create.Temp.AtLoc("plot_tax_controller", Loc(5,0,5))
end)
RegisterEventHandler(EventType.Message, "DoPlotSale", function()
	Create.Temp.AtLoc("plot_sale_controller", Loc(5,0,6))
end)


RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ()		
		OnLoad()			
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ()
		OnLoad()
	end)

RegisterEventHandler(EventType.Message,"UserLogin",
	function(user, type)
		if ( type == "ChangeWorld" ) then

		elseif ( type == "Connect" ) then
			-- write function to write user as online globally
			local writeOnline = function(record)
				record[user] = true
				return true
			end
			-- kick off the global writes
			SetGlobalVar("User.Online", writeOnline)

			-- tell all groups members about it
			GroupLoginMember(user)
		end

	end)

RegisterEventHandler(EventType.Message,"UserLogout",
	function(user, clear)
		-- write function to remove user as online globally
		local write = function(record)
			record[user] = nil
			return true
		end
		-- write user as offline
		SetGlobalVar("User.Online", write)

		-- tell all groups members about it
		GroupLogoutMember(user)
	end)

-- to set objvars on a remotely created object pass a table where 
-- the keys are objvar names and the values are the objvar valuse
--       Example: { Destination=Loc(0,0,0), RegionAddress="Home" }
RegisterEventHandler(EventType.Message,"CreateObject",
	function(template,targetLoc,targetModules,targetObjVars)
		if(targetModules ~= nil or targetObjVars ~= nil) then
			local eventIdentifier = uuid()
			CreateObj(template,targetLoc,eventIdentifier)			
			RegisterSingleEventHandler(EventType.CreatedObject,eventIdentifier,
				function(success,objRef)
					if(success) then
						for i,moduleName in pairs(targetModules or {}) do 
							objRef:AddModule(moduleName)
						end

						for objVarName,objVarValue in pairs(targetObjVars or {}) do 
							objRef:SetObjVar(objVarName,objVarValue)
						end
					end
				end)
		else
			CreateObj(template,targetLoc)
		end
	end)


--- FRAMETIME MONITORING CODE ---

FRAMETIME_EMAIL_THRESHOLD = 0.200
-- dont send emails more than once an hour
FRAMETIME_EMAIL_THROTTLE = 60*60

-- give the server 5 minutes to start up before we start monitoring
this:ScheduleTimerDelay(TimeSpan.FromSeconds(60*5),"frametime_monitor")
RegisterEventHandler(EventType.Timer,"frametime_monitor",
	function ( ... )
		local avgFrameTime = DebugGetAvgFrameTime()
		if(avgFrameTime >= FRAMETIME_EMAIL_THRESHOLD) then
			SendEmail(BUG_REPORT_EMAIL,"Lag Report: "..os.date().." from "..tostring(ServerSettings.RegionAddress),"Average Frame Time: "..tostring(avgFrameTime))
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(FRAMETIME_EMAIL_THROTTLE),"frametime_monitor")
		else
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"frametime_monitor")
		end
	end)

RegisterEventHandler(EventType.Message, "ValidatePortalLoc",
	function (user, dest)
		local invalidMessage, newDestLoc = ValidatePortalSpawnLoc(user, dest)
		local regionalName = GetRegionalName(dest)

		user:SendMessageGlobal("PortalLocValidated", invalidMessage, newDestLoc, regionalName)
	end)

RegisterEventHandler(EventType.Message, "MapMarkerRequest",
	function(user)
		local worldName = ServerSettings.WorldName
		local subregionName = ServerSettings.SubregionName
		local mapMarkers = GetControllerMapMarkers()

		if (mapMarkers ~= nil and subregionName ~= nil and worldName ~= nil) then
			user:SendMessageGlobal("ClusterControllerMapMarkerResponse", worldName, subregionName, mapMarkers)
		end
		
	end)

RegisterEventHandler(EventType.Message, "PlotRateRequest", function(playerObj, controller)
	playerObj:SendMessageGlobal("PlotRateResponse", Plot.CalculateRateController(controller))
end)

RegisterEventHandler(EventType.Message, "PlayerResurrected", UpdateCorpseOnPlayerResurrected)