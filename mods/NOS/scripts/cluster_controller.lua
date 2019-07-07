
require 'clusterglobal_request_response'

-- is the master controller currently in the process of taxing all plots?
local m_Taxing = false

-- DAB TODO EDIT MODE: Automatically attach edit controller
if(ServerSettings.EditMode) then
	this:AddModule("editmode_controller")
end

-- prevent pulse from firing immediately if loading from a backup
this:RemoveTimer("MasterControllerPulse")

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
			if ( record.LastStartTime == SERVER_STARTTIME ) then
				DebugMessage("[ClusterControl] Prevented Duplicate Master Controller.")
				return false
			end
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
						this:ScheduleTimerDelay(TimeSpan.FromMinutes(5),"MasterControllerPulse")
					end)
				else
					this:ScheduleTimerDelay(TimeSpan.FromMinutes(5),"MasterControllerPulse")
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

local pulseCount = 1
RegisterEventHandler(EventType.Timer,"MasterControllerPulse", function ()
	-- double check we are infact the master controller.
	if ( GlobalVarReadKey("ClusterControl", "Master") ~= this ) then
		DebugMessage("[ClusterControl] Preventing incorrect master controller from performing master pulse.")
		return
	end
	--first pulse
	if ( pulseCount == 1 ) then
		DebugMessage("[ClusterControl] Checking for a new Allegiance season")
		CheckForAndStartNewSeason()
	end

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



	pulseCount = pulseCount + 1
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

RegisterEventHandler(EventType.Message,"UpdateValidCharactersAllegianceVars",
	function()
		local favorHolders = FindObjects(SearchHasObjVar("Favor"))
		for k, v in pairs(favorHolders) do
			UpdateAllegiancePlayerVars(k)
		end
	end)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ()		
		OnLoad()			
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"", function ()
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

			FriendSystemOnLogin(user)
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

		FriendSystemOnLogout(user)
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

-- do the autofix on world items.
CallFunctionDelayed(TimeSpan.FromSeconds(5), function()
	DoWorldAutoFix(this)
end)

--- fix desync'd global var/region data thereby fixing plots for broken players (this can be removed after desync issues are solved)
CallFunctionDelayed(TimeSpan.FromSeconds(10), function()
	local plots = GlobalVarListRecords("Plot.")
	DebugMessage("Remove globalvars for invalid plots on this region.")
	local deletePlots = {}
	for i=1,#plots do
		local val = GlobalVarRead(plots[i]) or {}
		if (
			-- same region
			val.Region == ServerSettings.RegionAddress
			and
			-- controller is invalid
			(
				not val
				or
				not val.Controller
				or
				not val.Controller:IsValid()
			)
		) then
			deletePlots[#deletePlots+1] = plots[i]
			DebugMessage("Record '"..plots[i].."' does not have a valid plot.")
		end
	end
	if ( #deletePlots > 0 ) then
		for i=1,#deletePlots do
			-- slowly fix all of them
			CallFunctionDelayed(TimeSpan.FromSeconds(i*1), function()
				local owner = GlobalVarReadKey(deletePlots[i], "Owner")
				if ( owner ) then
					-- delete all of user plots (we only allow one currently)
					DelGlobalVar("User.Plots."..owner, function(success)
						DebugMessage("Delete 'User.Plots."..owner.."' success:", success)
					end)
				end
				DelGlobalVar(deletePlots[i], function(success)
					DebugMessage("Delete '"..deletePlots[i].."' success:", success)
				end)
			end)
		end
	end
	DebugMessage("Total of "..#deletePlots.." plot global records will be removed. Please wait for finish.")
	CallFunctionDelayed(TimeSpan.FromSeconds(#deletePlots), function()
		DebugMessage("Global var plots cleanup finished. Starting User Record Cleanup.")
		CallFunctionDelayed(TimeSpan.FromSeconds(2), function()
			local userPlotKeys = GlobalVarListRecords("User.Plots.")
			local deleteUserPlots = {}
			for i=1,#userPlotKeys do
				local userPlot = GlobalVarRead(userPlotKeys[i])
				if ( userPlot ) then
					userPlot = userPlot[1] -- only need to check first since we've only allowed a single plot thus far
					if ( userPlot and userPlot.Id and not GlobalVarRead("Plot."..userPlot.Id) ) then
						deleteUserPlots[#deleteUserPlots+1] = userPlotKeys[i]
					end
				end
			end
			DebugMessage("Total User Records without co-existing plot record to be removed:", #deleteUserPlots, "Please wait for finish.")
			for i=1,#deleteUserPlots do
				CallFunctionDelayed(TimeSpan.FromSeconds(1*i), function()
					DelGlobalVar(deleteUserPlots[i])
				end)
			end
			CallFunctionDelayed(TimeSpan.FromSeconds(#deleteUserPlots), function()
				DebugMessage("User Record Cleanup Finished.")
			end)
		end)
	end)
end)
CallFunctionDelayed(TimeSpan.FromSeconds(10), function()
	local controllers = FindObjects(SearchTemplate("plot_controller"))
	DebugMessage("Destroying Plots that do not have have a global variable.")
	DebugMessage(#controllers.." plot_controller GameObjs found.")
	local total = 0
	for i=1,#controllers do
		if ( GlobalVarRead("Plot."..controllers[i].Id) == nil ) then
			DebugMessage(controllers[i].Id.." does not have a global record!")
			-- no global record here, delete the plot.
			--[[
			CallFunctionDelayed(TimeSpan.FromSeconds(1*total), function()
				Plot.Destroy(controllers[i], function(success)
					DebugMessage("Plot Destroy ("..controllers[i].Id..") success:", success)
				end)
			end)]]
			total = total + 1
		end
	end
	--[[
	DebugMessage("Total of "..total.." plots where destroyed. Please wait for finish.")
	CallFunctionDelayed(TimeSpan.FromSeconds(total), function()
		DebugMessage("Finished Destroying Plots.")
	end)]]
end)