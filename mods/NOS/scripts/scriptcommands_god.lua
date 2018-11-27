function DoShutdown(reason,shouldRestart)	
	local reasonMessage = reason or "Unspecified"
	if(shouldRestart == nil) then shouldRestart = false end	

	ServerBroadcast(reasonMessage,true)
	ShutdownServer(shouldRestart)
end

-- DAB Make sure the shutdown timer is not stuck on a god character
this:RemoveTimer("shutdown")
RegisterEventHandler(EventType.Timer, "shutdown",
	function(reason,shouldRestart)
		DoShutdown(reason,shouldRestart)
	end)

RegisterEventHandler(EventType.Timer,"FrameTimeTimer",
	function()
		local frameTimeWindow = DynamicWindow("FrameTimeWindow","Frame Time",100,100)
		frameTimeWindow:AddLabel(100,30,tostring(DebugGetAvgFrameTime()))
		
		this:OpenDynamicWindow(frameTimeWindow)

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"FrameTimeTimer")
	end)

RegisterEventHandler(EventType.DynamicWindowResponse,"FrameTimeWindow",
	function()
		this:RemoveTimer("FrameTimeTimer")
	end)

RegisterEventHandler(EventType.DestroyAllComplete,"WorldReset",
	function ()
		DebugMessage("--- (WorldReset) OBJECTS DESTROYED --- LOADING SEEDS ---")
		LoadSeeds()
		ResetPermanentObjectStates()

		local plots = FindObjects(SearchTemplate("plot_controller"))
		for i=1,#plots do
			plots[i]:AddModule("plot_control_world_reset")
		end
	end)

relpos1Target = nil
RegisterEventHandler(EventType.ClientTargetAnyObjResponse,"relpos1",
	function (target,user)
		if(target ~= nil) then
			this:SystemMessage("[$2458]")
			relpos1Target = target
			this:RequestClientTargetAnyObj(this,"relpos2")
		end
	end)

RegisterEventHandler(EventType.ClientTargetAnyObjResponse,"relpos2",
	function (target,user)
		if(target ~= nil) then
			local target1Loc = relpos1Target:GetLoc()			
			local target1Rot = Loc(0,0,0)
			if not(relpos1Target:IsPermanent()) then
				target1Rot = relpos1Target:GetRotation()
			end
			local relPos = target1Loc - target:GetLoc()
			ClientDialog.Show{
					TargetUser = this,
				    TitleStr = "Relative Position",
				    DescStr = "Relative Position: " .. string.format("%.2f",relPos.X) .. "," .. string.format("%.2f",target1Loc.Y) .. "," .. string.format("%.2f",relPos.Z)
				    			.. "\nRotation: " .. string.format("%.2f",target1Rot.X) .. "," .. string.format("%.2f",target1Rot.Y) .. "," .. string.format("%.2f",target1Rot.Z)
				    			.. "\nDistance: ".. target1Loc:Distance2(target:GetLoc()),
				    Button1Str = "Ok",					
			}		
		end
	end)

frameTimes = {}

RegisterEventHandler(EventType.Timer,"RecordFrameTime",
	function ( ... )
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"RecordFrameTime")
		local avgTime = DebugGetAvgFrameTime()
		this:SystemMessage(tostring(#frameTimes)..": "..tostring(string.format("%.8f",avgTime)))
		table.insert(frameTimes,avgTime)
	end)

RegisterEventHandler(EventType.CreatedObject,"create_all_items",
	function (success,objRef,category,unique)
		local createCount = 0
		objRef:SetName(category)
		local templatesListTable = GetAllTemplateNames(category)
		for i, templateName in pairs(templatesListTable) do
			local templateData = GetTemplateData(templateName)
			if(not(unique) or not(createAllIds[templateData.ClientId])) then				
				local weight = templateData.SharedObjectProperties.Weight
				if(weight ~= -1) then
					if(unique) then createAllIds[templateData.ClientId] = true end
					local randomLoc = GetRandomDropPosition(objRef)
					CreateObjInContainer(templateName, objRef, randomLoc)		
					createCount = createCount + 1
				end
			end
		end

		if(createCount == 0) then
			objRef:Destroy()
		end
	end)

visualStateName = nil
RegisterEventHandler(EventType.ClientTargetAnyObjResponse,"SetVisualState",
	function(target,user)
		if(visualStateName and target and target:IsPermanent()) then
			target:SetVisualState(visualStateName)
		end
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse,"npcsit_chair",
	function (target,user)
		if(target and target:HasModule("chair")) then
			target:SendMessage("ForceSit",npcToSit)
		else
			this:SystemMessage("Request cancelled","info")
		end
	end)

npcToSit = nil
RegisterEventHandler(EventType.ClientTargetGameObjResponse,"npcsit",
	function (target,user)
		if(target and target:IsMobile()) then
			npcToSit = target
			this:SystemMessage("Select chair","info")
			this:RequestClientTargetGameObj(this,"npcsit_chair")
		else
			this:SystemMessage("Request cancelled","info")
		end
	end)


GodCommandFuncs = {
	FrameTime = function ()
		this:FireTimer("FrameTimeTimer")
	end,

	CompleteAchievement = function(AchievementCategory,AchievementType, AchievementLevel)
		if (AchievementCategory ~= nil and AchievementType ~= nil) then
			local achievementCategory =string.sub(AchievementCategory,2)
			local achievementCStart = string.sub(AchievementCategory,1,1)
			AchievementCategory = string.upper(achievementCStart) .. achievementCategory

			local achievementType = string.sub(AchievementType,2)
			local achievementTStart = string.sub(AchievementType,1,1)
			AchievementType = string.upper(achievementTStart) .. achievementType
			local reference = {}
			if (AchievementCategory == "Skill") then
				AchievementType = AchievementType.."Skill"
				reference.TitleCheck = "Skill"
			elseif (AchievementCategory == "Karma") then
				reference.TitleCheck = "Karma"
			end

			CheckAchievementStatus(this, AchievementCategory, AchievementType, tonumber(AchievementLevel), reference)
		end
	end,

	CompleteAllAchievements = function(AchievementCategory)
		if (AchievementCategory == nil) then
			return
		end
		local achievementCategory = string.sub(AchievementCategory,2)
		local achievementCStart = string.sub(AchievementCategory,1,1)
		AchievementCategory = string.upper(achievementCStart)..achievementCategory

		local achievementTab = AchievementCategory.."Achievements"
		if (AllAchievements[achievementTab] ~= nil) then
			local reference = {}
			reference.NoRestriction = true
			if (AchievementCategory == "Skill") then
				reference.TitleCheck = "Skill"
			elseif (AchievementCategory == "Karma") then
				reference.TitleCheck = "Karma"
			end

			for key,value in pairs(AllAchievements[achievementTab]) do
				CheckAchievementStatus(this, AchievementCategory, key, 1, reference)
			end
		end
	end,

	TransferAll = function (targetRegion)		
		for i,userEntry in pairs(FindGlobalUsers()) do
			if(userEntry.RegionAddress ~= targetRegion) then
				userEntry.Obj:SendMessageGlobal("transfer",targetRegion)			
			end
		end
	end,

	DoString = function (...)
		local line = CombineArgs(...)
		f = load(line)
		f()
	end,

	ShowProps = function(id)
		local obj = GameObj(tonumber(id))
		this:SystemMessage("Showing Properties for "..id)
		this:SystemMessage("----------------------------")
		for propName,propValue in pairs(obj:GetAllSharedObjectProperties()) do 
			this:SystemMessage(propName..": "..tostring(propValue))
		end
	end,

	SetObjProp = function(...)
		local arg = table.pack(...)	
		if(#arg < 3) then
			Usage("setobjprop")
			return
		end

		local gameObj = this
		if( arg[1] ~= "self" ) then
			gameObj = GameObj(tonumber(arg[1]))
		end

		local curProp = gameObj:GetSharedObjectProperty(arg[2])
		if(curProp == nil) then
			this:SystemMessage("Invalid object property: "..arg[2])
		end

		if(arg[3]:sub(0,3) == "Str") then
			local str = ""
			for i = 4,#arg do str = str .. tostring(arg[i]) .. " " end
			gameObj:SetSharedObjectProperty(arg[2],str)
		elseif(arg[3]:sub(0,4) == "Bool") then
			local val = false;
			if(arg[4]:lower() == "true") then
				val = true
			end
			gameObj:SetSharedObjectProperty(arg[2],val)
		elseif( tonumber(arg[3]) ~= nil ) then
			gameObj:SetSharedObjectProperty(arg[2],tonumber(arg[3]))
		else
			gameObj:SetSharedObjectProperty(arg[2],arg[3])
		end
	end,	

	TeleportAll = function()
		local found = FindPlayersInRegion()
		for index, obj in pairs(found) do
			obj:SetWorldPosition(this:GetLoc())
		end
	end,	

	Shutdown = function(timeSecs,...)			
		if( timeSecs ~= nil ) then
			local arg = table.pack(...)
			local reason = "Server is shutting down in "..timeSecs.." seconds."
			if(#arg > 0) then
				reason = ""
				for i = 1,#arg do reason = reason .. tostring(arg[i]) .. " " end
			end
			
			ServerBroadcast(reason,true)
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(tonumber(timeSecs)),"shutdown",reason)
		else
			Usage("shutdown")
		end		
	end,

	Restart = function(timeSecs,...)			
		if( timeSecs ~= nil ) then
			local arg = table.pack(...)
			local reason = "Server is restarting in "..timeSecs.." seconds."
			if(#arg > 0) then
				reason = ""
				for i = 1,#arg do reason = reason .. tostring(arg[i]) .. " " end
			end

			ServerBroadcast(reason,true)
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(tonumber(timeSecs)),"shutdown",reason,true)
		else
			Usage("shutdown")
		end		
	end,

	-- Testing / Debug Commands

	ReloadBehavior = function(behaviorName)
		if( behaviorName == nil ) then
			Usage("reloadbehavior")
		end

		ReloadModule(behaviorName)
	end,

	ReloadTemplates = function()
		ReloadTemplates()
	end,

	Log = function(...)
		local line = CombineArgs(...)
		if( line == nil ) then Usage("log") return end

		DebugMessage("Player Log:",this,":",line)
	end,

	

	PlaySound = function(soundName)				
		if( soundName ~= nil) then
			this:PlayObjectSound(soundName,false)
		else
			Usage("playsound")
		end
	end,

	PlayMusic = function(soundName)				
		if( soundName ~= nil) then
			this:PlayMusic(soundName)
		else
			Usage("playmusic")
		end
	end,

	PlayAnim = function(...)				
		local arg = table.pack(...)
		if( #arg >= 2) then
			local targetObj = GameObj(tonumber(arg[1]))
			if( targetObj:IsValid() ) then
				targetObj:PlayAnimation(arg[2])
			end
		elseif( #arg >= 1) then
			this:PlayAnimation(arg[1])
		else
			Usage("playanim")
		end
	end,

	HasTimer = function(...)
		local arg = table.pack(...)
		if(#arg ~= 2) then
			Usage("hastimer")
			return
		end

		local gameObj = GameObj(tonumber(arg[1]))
		this:SystemMessage("HAS SWING" .. tostring(arg[2]) .. tostring(gameObj:HasTimer(arg[2])))
	end,	
	
	SetFacing = function(...)				
		local arg = table.pack(...)
		if( #arg < 1) then
			Usage("setfacing")
			return
		end

		local targetObj = GameObj(tonumber(arg[1]))
		if( targetObj:IsValid() ) then
			if( #arg > 1 ) then
				targetObj:SetFacing(arg[2])
			else
				targetObj:SetFacing(this:GetFacing())
			end
		end
	end,

	PlayEffect = function(effectName,effectArgs)		
		if( effectName ~= nil and effectName ~= "" ) then
			this:PlayEffectWithArgs(effectName,0.0,"Bone=Ground")
		else
			Usage("playeffect")
		end
	end,

	IsPassable = function()
		local isPassable = IsPassable(this:GetLoc())
		this:SystemMessage("Passable: "..tostring(isPassable))
		DebugMessage("Passable: "..tostring(isPassable))
		if not(isPassable) then
			local collisionInfo = GetCollisionInfoAtLoc(this:GetLoc())
			for i,infoStr in pairs(collisionInfo) do
				this:SystemMessage(infoStr)
				DebugMessage(infoStr)
			end
		end
	end,

	SetVisualState = function (stateName)
		visualStateName = stateName
		this:RequestClientTargetAnyObj(this,"SetVisualState")
	end,

	LuaDebug = function(level)
		if( level == nil ) then
			Usage("luadebug")
			return
		end

		SetLuaDebugLevel(level)
		this:SystemMessage("New Log Level: "..level)
		DebugMessage("New Log Level: "..level)
	end,

	ToggleLuaProfile = function()
		isEnabled = not GetLuaProfilingEnabled()
		SetLuaProfilingEnabled(isEnabled)
		this:SystemMessage("Lua Profiling "..tostring(isEnabled))
		DebugMessage("Lua Profiling "..tostring(isEnabled))
	end,

	SaveHotbar = function(filename)
		-- defined in base_player_hotbar
		SaveHotbarToXML(filename)
	end,

	LoadHotbar = function (filename)
		LoadHotbarFromXML(filename)		
	end,

	LuaGC = function(arg,arg2,arg3)
		if(arg == nil) then
			Usage("luagc")			
		elseif(arg == 'collect') then
			LuaGCAll("collect")
		elseif(arg == 'count') then			
			LuaGCAll("collect")
			LuaGCAll("collect")
			local vmUsage = tostring(LuaGCAll("memusage"))
			DebugMessage("VM USAGE: "..vmUsage)
			this:SystemMessage("VM USAGE: "..vmUsage)
		elseif(arg == 'stop') then			
			LuaGCAll("stop")
			DebugMessage("WARNING: LUA GC HALTED!")
			this:SystemMessage("WARNING: LUA GC HALTED!")
		elseif(arg == 'restart') then			
			LuaGCAll("restart")
		elseif(arg == 'memusage') then
			local vmUsage = tostring(LuaGCAll("memusage"))
			DebugMessage("VM USAGE W/O GC STEP: "..vmUsage)
			this:SystemMessage("VM USAGE W/O GC STEP: "..vmUsage)
		elseif(arg == 'mb') then
            MemBegin()
        elseif(arg == 'me') then
        	MemEnd()
        elseif(arg == 'write') then
        	if(arg2=='reg') then
        		DebugMessage("DUMPING REGISTRY")
        		dump_registry_to_xml()
        	elseif(arg2=='globals') then
        		DebugMessage("DUMPING GLOBALS")
        		dump_globals_to_xml()
        	elseif(arg2=='object') then
        		DebugMessage("DUMPING OBJECT "..arg3)
        		dump_object_to_xml(GameObj(tonumber(arg3)))
			elseif(arg2=='allobjects') then
        		DebugMessage("DUMPING ALL OBJECTS")
        		dump_all_objects_to_xml()        		
        	end        	
        	DebugMessage("DONE")
		end
	end,

	Backup = function()
		ForceBackup()
	end,

	ResetWorld = function(arg)
		if(arg and arg:match("force")) then		
			DestroyAllObjects(false,"WorldReset")			
		else
			ClientDialog.Show{
			    TargetUser = this,
			    DialogId = "ResetWorldDialog",
			    TitleStr = "Are you sure?",
			    DescStr = "[$2465]",
			    Button1Str = "Yes",
			    Button2Str = "No",
			    ResponseFunc = function ( user, buttonId )
					buttonId = tonumber(buttonId)
					if( buttonId == 0) then				
						DestroyAllObjects(false,"WorldReset")	
					else
						this:SystemMessage("World reset cancelled")
					end
				end
			}
		end
	end,

	DestroyAll = function(arg)
		if(arg and arg:match("force")) then
			DestroyAllObjects(true)
		elseif(arg and arg:match("ignorenoreset")) then
			DestroyAllObjects(false)
		else
			ClientDialog.Show{
			    TargetUser = this,
			    DialogId = "DestroyAllDialog",
			    TitleStr = "WARNING",
			    DescStr = "[$2466]",
			    Button1Str = "Yes",
			    Button2Str = "No",
			    ResponseFunc = function ( user, buttonId )
					buttonId = tonumber(buttonId)
					if( buttonId == 0) then				
						DestroyAllObjects(true)
					else
						this:SystemMessage("Destroy All cancelled")
					end
				end
			}
		end
	end,

	UpdateRange = function(range)
		if( range == nil ) then Usage("updaterange") return end

		this:SetUpdateRange(tonumber(range))

		rangeStr = range or "[Default]"
		this:SystemMessage("Update range set to "..rangeStr)
	end,	

	RelativePos = function()
		this:SystemMessage("[$2469]")
		this:RequestClientTargetAnyObj(this,"relpos1")
	end,
	
	DebugFrameTime = function (arg)
		if( arg == nil ) then Usage("debugframetime") return end

		if(arg == "begin") then
			frameTimeStart = DateTime.Now
			frameTimes = {}
			this:FireTimer("RecordFrameTime")
			this:SystemMessage("Recording average frame time stats.")
		else
			local frameTimeFile = io.open("frametimes.csv","a")
			io.output(frameTimeFile)
			io.write("---------------------------------\n")
			io.write("Begin "..frameTimeStart:ToString().." : End "..DateTime.Now:ToString().."\n")
			io.output(frameTimeFile)
			local totalCumulative = 0
			for i,frameTime in pairs(frameTimes) do
				totalCumulative = totalCumulative + frameTime
				io.write(tostring(i).."\t"..tostring(string.format("%.8f",frameTime)).."\n")
			end			
			io.write("---------------------------------\n")
			io.write("Total Average: "..tostring(string.format("%.8f",totalCumulative/(#frameTimes))).."\n")
			io.write("---------------------------------\n")
			io.close(frameTimeFile)
			this:RemoveTimer("RecordFrameTime")
			this:SystemMessage("Frame time stats written to frametimes.csv.")
		end
	end,

	ListMobs = function()
		for i,mobObj in pairs(FindObjects(SearchMobileInRange(9999))) do
			DebugMessage(i .. ": ".. mobObj:GetName() .. " | ".. mobObj:GetCreationTemplateId())
		end
	end,

	CreateAllItems = function (unique)
		local templateCategories = GetTemplateCategories()
		local xPos = this:GetLoc().X
		local zPos = this:GetLoc().Z

		if(unique) then
			createAllIds = {}
		end

		for i, category in pairs(templateCategories) do
			CreateObj("treasurechest",Loc(xPos,0,zPos),"create_all_items",category,unique)
			xPos = xPos + 1
		end
	end,

	SitNpc = function ()
		this:SystemMessage("Select mobile","info")
		this:RequestClientTargetGameObj(this, "npcsit")
	end,

	NpcCommand = function (command,...)
		for i,nearbyNpc in pairs(FindObjects(SearchMobileInRange(50))) do
			if not(nearbyNpc:IsPlayer()) then
				nearbyNpc:SendMessage(command,...)
			end
		end
	end,	
}

RegisterCommand{ Command="teleportall", Category = "God Power", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.TeleportAll, Desc="[$2484]" }			
RegisterCommand{ Command="props", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.ShowProps, Usage="<target_id|self>", Desc="List all object properties on an object." }
RegisterCommand{ Command="setobjprop", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.SetObjProp, Usage="[$2501]", Desc="Set an object property (see TagDefinitions.xml) for the specified object. Can use 'self' in place of id. If no type specified, defaults to number or one word string." }
RegisterCommand{ Command="setfacing", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.SetFacing, Usage="<id> [<direction>]", Desc="[$2502]" }
RegisterCommand{ Command="playeffect", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.PlayEffect, Usage="<effect_name>", Desc="Play a particle effect at your location." }
RegisterCommand{ Command="playsound", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.PlaySound, Usage="<sound_name>", Desc="Play a sound at your location" }
RegisterCommand{ Command="playmusic", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.PlayMusic, Usage="<sound_name>", Desc="Play music (only yourself)" }
RegisterCommand{ Command="playanim", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.PlayAnim, Usage="[<target_id>] <anim_name>", Desc="Play an animation on your character" }	
RegisterCommand{ Command="shutdown", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.Shutdown, Usage="<delay_seconds> [<reason>]", Desc="[$2504]" }	
RegisterCommand{ Command="restart", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.Restart, Usage="<delay_seconds> [<reason>]", Desc="[$2505]" }	
RegisterCommand{ Command="savehotbar", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.SaveHotbar, Usage="<filename>", Desc="[DEBUG COMMAND] Save hotbar to xml file." }
RegisterCommand{ Command="loadhotbar", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.LoadHotbar, Usage="<filename>", Desc="[DEBUG COMMAND] Load hotbar from xml file." }
RegisterCommand{ Command="setvisualstate", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.SetVisualState, Desc="[DEBUG COMMAND] Manually set the visual state of a permanent object. For development only!" }
RegisterCommand{ Command="luadebug", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.LuaDebug, Usage="<Off|Error|Warning|Information|Verbose>", Desc="[$2506]" }
RegisterCommand{ Command="luagc", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.LuaGC, Usage="<collect|count|memusage|mb|me|write>", Desc="Various lua memory debugging commands." }
RegisterCommand{ Command="toggleluaprofile", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.ToggleLuaProfile, Desc="[DEBUG COMMAND] Toggles lua profiling on and off" }
RegisterCommand{ Command="backup", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.Backup, Desc="[DEBUG COMMAND] Force a backup to take place." } 
RegisterCommand{ Command="resetworld", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.ResetWorld, Desc="[$2508]" } 
RegisterCommand{ Command="destroyall", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.DestroyAll, Desc="[$2509]" } 
RegisterCommand{ Command="updaterange", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.UpdateRange, Usage="<range>", Desc="[$2510]" } 
RegisterCommand{ Command="reloadbehavior", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.ReloadBehavior, Usage="<behavior>", Desc="[DEBUG COMMAND] Reload the behavior in memory.", Aliases={"reload"}}
RegisterCommand{ Command="reloadtemplates", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.ReloadTemplates, Desc="[DEBUG COMMAND] Reload all templates in memory." }
RegisterCommand{ Command="log", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.Log, Usage="<log string>", Desc="[DEBUG COMMAND] Write a line to the lua log" }

RegisterCommand{ Command="ispassable", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.IsPassable, Desc="[$2511]"}
RegisterCommand{ Command="hastimer", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.HasTimer, Usage="<target_id> <timer_name>", Desc="[$2512]" }	
RegisterCommand{ Command="transferall", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.TransferAll, Usage="<transferregion>", Desc="[$2513]"}
RegisterCommand{ Command="dostring", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.DoString, Usage="<lua code>", Desc="[$2514]"}
RegisterCommand{ Command="relativepos", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.RelativePos, Desc="[$2515]"}
RegisterCommand{ Command="frametime", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.FrameTime, Desc="Opens a window that shows the average frame time" }
RegisterCommand{ Command="debugframetime", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.DebugFrameTime, Usage="<begin,end>", Desc="Record average frame time statistics. end writes report to a file" }
RegisterCommand{ Command="listmobs", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.ListMobs, Desc="List all mobs on the server region." }
RegisterCommand{ Command="createallitems", Category = "Debug", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.CreateAllItems, Usage="<unique>", Desc="Create every carryable item inside containers. If passed 'unique' then only one of each client id is created" }
RegisterCommand{ Command="setspeed", AccessLevel = AccessLevel.God, Func=function(speed) SetMobileMod(this, "MoveSpeedPlus", "GodCommand", tonumber(speed))  end, Desc="Add the number given to your movement speed. If no speed is provided, it will remove the modifer." }
RegisterCommand{ Command="makebook", AccessLevel = AccessLevel.God, Func=function(a,b) PrestigeCommandMakeBook(this,a,b) end, Desc="Make a prestige book.", Usage="<PrestigeAbility>" }
RegisterCommand{ Command="prestige", AccessLevel = AccessLevel.God, Func=function(a,b,c,d) PrestigeAbilityWindow(this,a,b,c,d) end, Desc="Handy dandy prestige window." }
RegisterCommand{ Command="reloadglobals", AccessLevel = AccessLevel.God, Func=function()ChangeWorld(true) end, Desc="Reload current server instance, only works on Standalone servers." }
RegisterCommand{ Command="forcedisconnect", AccessLevel = AccessLevel.God, Func=function(objectId)ForceDisconnect(objectId) end, Desc="Forces a player character to be immediately disconnected and logged out of the server, not waiting for a character save." }
RegisterCommand{ Command="learnrecipes", AccessLevel = AccessLevel.God, Func=function(user)LearnAllRecipes(this) end, Desc="Learn all crafting recipes." }
RegisterCommand{ Command="createmission", AccessLevel = AccessLevel.God, Func=function(missionKey)AddMission(this, missionKey, this:GetLoc()) end, Desc="Add a mission to the player and spawn the mission controller at their feet." }
RegisterCommand{ Command="completeachievement", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.CompleteAchievement, Desc="Complete one achievement.", Usage="<AchievementCategory> <AchievementType> <AchievementLevel>"}
RegisterCommand{ Command="completeallachievements", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.CompleteAllAchievements, Desc="Complete all achievements in one tab.", Usage="<AchievementCategory>"}
RegisterCommand{ Command="sitnpc", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.SitNpc, Desc="Force an NPC to sit in a chair."}
RegisterCommand{ Command="npccommand", AccessLevel = AccessLevel.God, Func=GodCommandFuncs.NpcCommand, Desc="Send a message to all nearby NPCs"}
RegisterCommand{ Command="createmapmarker", AccessLevel = AccessLevel.God, Func=function(tooltip,icon)CreateMapMarker(this:GetLoc(), tooltip, icon) end, Desc="Create a static map marker that can be discovered by the player." }
RegisterCommand{ Command="closewindow", AccessLevel = AccessLevel.God, Func=function(window) this:CloseDynamicWindow(window) end, Desc="Close a Dynamic Window by ID." }