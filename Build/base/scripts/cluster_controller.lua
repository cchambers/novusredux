-- DAB TODO EDIT MODE: Automatically attach edit controller
if(EDITMODE) then
	this:AddModule("editmode_controller")
end

-- Cluster Controller: This module is attached to the cluster_controller object that is automatically
-- created by the engine at Loc(0.1,0.1,0.1) on the map. 

-- DAB TODO: We should be tracking the users online in the engine
-- This way is messy because regions that crash will not clear their users
-- so everyone who looks at this list has to validate each region entry
-- against the GetClusterRegions function

regionAddress = GetRegionAddress()

MASTER_CONTROLLER_PULSE_SPEED = TimeSpan.FromSeconds(5)
isMasterController = false

function OnLoad()
	this:SetObjectTag("ClusterController")
	
	local allUsers = FindPlayersInRegion()
	-- clear out the users online record

	-- DAB TODO: When we support graceful shutdown of regions in a cluster
	-- we need to have another region take master control
	--DebugMessage("[ClusterControl] SERVER_STARTTIME: "..tostring(SERVER_STARTTIME))
	local clusterControlData = GlobalVarRead("ClusterControl")
	--DebugMessage("[ClusterControl] clusterControlData: "..DumpTable(clusterControlData))
	if(clusterControlData == nil or clusterControlData.LastStartTime ~= SERVER_STARTTIME) then
		--DebugMessage("[ClusterControl] attempting to take control")
		GlobalVarWrite("ClusterControl","MasterControllerRequest",
			function(record)
				-- DOUBLE CHECK TO MAKE SURE SOMEONE ELSE DIDNT SNEAK MASTER CONTROL
				if(record.LastStartTime ~= SERVER_STARTTIME) then
					DebugMessage("[ClusterControl] "..regionAddress.." is the master controller")
					record.LastStartTime = SERVER_STARTTIME
					record.Master = this
					
					return true
				end
			end)

		RegisterSingleEventHandler(EventType.GlobalVarUpdateResult,"MasterControllerRequest",
			function(success,recordName,recordData)
				if(success) then
					-- delete online users
					RegisterSingleEventHandler(EventType.GlobalVarUpdateResult, "UserOnlineDelete", function(success)
						if not(success) then
							DebugMessage("ERROR: MasterControllerRequest failed to clear online users.")
						end
						this:ScheduleTimerDelay(MASTER_CONTROLLER_PULSE_SPEED,"MasterControllerPulse")
					end)
					GlobalVarDelete("User.Online", "UserOnlineDelete")
					isMasterController = true
				else
					DebugMessage("ERROR: MasterControllerRequest global var write failed with recordName of " ..tostring(recordName))
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

RegisterEventHandler(EventType.Timer,"MasterControllerPulse",
	function ()
		this:ScheduleTimerDelay(MASTER_CONTROLLER_PULSE_SPEED,"MasterControllerPulse")
		ValidateGroupData()
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
	function(user)

		-- write function to write user as online globally
		local writeOnline = function(record)
			record[user] = true
			return true
		end
		-- kick off the global writes
		SetGlobalVar("User.Online", writeOnline)

		-- update the name if different/not set
		local name = StripColorFromString(user:GetName())
		if ( GlobalVarReadKey("User.Name", user) ~= name ) then
			-- write function to write name for user globally
			local writeName = function(record)
				record[user] = name
				return true
			end
			SetGlobalVar("User.Name", writeName)
		end

		-- update the region address if different/not set
		if ( GlobalVarReadKey("User.Address", user) ~= regionAddress ) then
			local writeAddress = function(record)
				record[user] = regionAddress
				return true
			end
			SetGlobalVar("User.Address", writeAddress)
		end

		-- tell all groups members about it
		GroupLoginMember(user)

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

		-- when deleting, we clear these values out as well.
		if ( clear ) then
			-- remove name from list
			SetGlobalVar("User.Name", write)
			-- remove address from list
			SetGlobalVar("User.Address", write)
		end

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
			SendEmail(BUG_REPORT_EMAIL,"Lag Report: "..os.date().." from "..tostring(GetRegionAddress()),"Average Frame Time: "..tostring(avgFrameTime))
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