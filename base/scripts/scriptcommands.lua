require 'incl_player_titles'
require 'incl_gametime'
require 'incl_faction'
require 'incl_regions'
require 'scriptcommands_UI_edit'
require 'scriptcommands_UI_info'
require 'scriptcommands_UI_goto'
require 'scriptcommands_UI_customcommand'
require 'scriptcommands_UI_create'
require 'scriptcommands_UI_createcustom'
require 'scriptcommands_UI_search'
require 'scriptcommands_UI_globalvar'
require 'base_player_guild'
require 'base_player_emotes'
require 'base_bug_report'

-- This list is populated with the RegisterCommand function, all built in commands are
-- registered at the bottom of this file
CommandList = {}

-- Command functions

function GetCommandInfo(commandName)
	for i, commandInfo in pairs(CommandList) do
		if( commandInfo.Command == commandName 
			or (commandInfo.Aliases ~= nil and IsInTableArray(commandInfo.Aliases,commandName)) ) then
			-- we also return the index as the second parameter
			return commandInfo, i		
		end
	end
end

function Usage(commandName)
	local commandInfo = GetCommandInfo(commandName)
	local usageStr = "Usage: /"..commandName
	if( commandInfo.Usage ~= nil ) then
		usageStr = usageStr.." "..commandInfo.Usage
	end
	this:SystemMessage(usageStr)
end	

-- Note: This function replaces any existing command with the same name
-- This makes it easy for mods to replace existing commands
function RegisterCommand(commandInfo)
	if( commandInfo.Func == nil ) then
		DebugMessage("[scriptcommands][RegisterCommand] ERROR: Invalid command function!")
	end

	-- remove old command with this name
	local oldCommandInfo, oldIndex = GetCommandInfo(commandInfo.Command)
	if(oldCommandInfo ~= nil) then
		-- unregister the user command event handlers
		local oldCommandNames = oldCommandInfo.Aliases or {}
    	table.insert(oldCommandNames,oldCommandInfo.Command)
    	for i,commandName in pairs(oldCommandNames) do
    		UnregisterEventHandler('scriptcommands',EventType.ClientUserCommand,commandName)
    	end
    	-- replace the old command in the list
    	CommandList[oldIndex] = commandInfo
	else
		-- add this new command to the end
		table.insert(CommandList,commandInfo)
	end

	local commandNames = commandInfo.Aliases or {}
    table.insert(commandNames,commandInfo.Command)

	for i,commandName in pairs(commandNames) do
		RegisterEventHandler(EventType.ClientUserCommand, commandName, 
			function (...)
				if ( LuaCheckAccessLevel(this,commandInfo.AccessLevel) or this:HasObjVar("IsGod") ) then
					if ( this:HasTimer("RecentCommand") ) then return end
					this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.2), "RecentCommand")
					commandInfo.Func(...)			
				end
			end)
	end
end

-- Helper functions/event handlers for commands

function GetTemplateMatch(templateSearchStr)
	templateList = GetAllTemplateNames()

	-- if we have an exact match, then return it
	if( IsInTableArray(templateList,templateSearchStr) ) then
		return templateSearchStr
	end

	matches = {}
	for i, templateName in pairs(templateList) do		
		if (templateName:find(templateSearchStr) ~= nil) then
			matches[#matches+1] = templateName
		end
	end

	if( #matches == 1 ) then
		return matches[1]
	elseif( #matches > 1 ) then
		resultStr = "Multiple templates match: "
		for i, match in pairs(matches) do
			resultStr = resultStr .. ", " .. match
		end
		this:SystemMessage(resultStr)
		return nil		
	else
		this:SystemMessage("No template matches search string")
	end
end

function GetPlayerByNameOrIdGlobal(partialNameOrId)
	local found = FindGlobalUsers(partialNameOrId)

	if( #found == 0 ) then
		this:SystemMessage("No players found by that name")
	elseif( #found == 1 ) then
		return found[1]
	else
		this:SystemMessage("Multiple matches found (use /command [id] instead)")
		local matches = ""
		for user,y in pairs(found) do
			local name = "Unknown"
			if ( user:IsValid() ) then
				name = StripColorFromString(user:GetName())
			else
				name = GlobalVarReadKey("User.Name", user)
			end
			matches = string.format("%s%s:%s ,", matches, name, user.Id)
		end
		this:SystemMessage(matches)
	end
end

function GetPlayerByNameOrId(arg)
	if tonumber(arg) ~= nil then
		local targetObj = GameObj(tonumber(arg))
		if( targetObj:IsValid() or isGlobal ) then
			return targetObj		
		else
			this:SystemMessage("No players found by that id")
		end
	else
		local found = GetPlayersByName(arg)
		if( #found == 0 ) then
			this:SystemMessage("No players found by that name")
		elseif( #found == 1 ) then
			return found[1]
		else
			this:SystemMessage("Multiple matches found (use /command [id] instead)")
			local matches = ""
			for index, obj in pairs(found) do
				matches = matches .. obj:GetName() .. ":"..obj.Id..", "
			end
			this:SystemMessage(matches)
		end
	end
end

-- Handlers for commands

bodyTemplateId = nil

RegisterEventHandler(EventType.Message,"PrivateMessage",
	function(sourceName,line,sourceObj)
		if (line == nil) then return end
		this:SystemMessage("[E352EA]From "..StripColorFromString(sourceName)..":[-] "..line.. " (use /r to reply)","custom")
		mLastTeller = sourceObj
		this:SystemMessage("You have received a message.","event")
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "body",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		if not( target:IsMobile() ) then
			this:SystemMessage("Error: /setbody only works on mobiles")
		end

		target:SetAppearanceFromTemplate(bodyTemplateId)
		target:SetObjVar("FormTemplate",bodyTemplateId)
	end
)

mMobToCopy = nil
RegisterEventHandler(EventType.ClientTargetGameObjResponse,"copyformselect",
	function(target,user)
		if (not IsDemiGod(this)) then return end

		if (target == nil) then return end

		mMobToCopy = target
		user:SystemMessage("Which mob do you wish to change?")

		this:RequestClientTargetGameObj(this, "copyform")
	end)
RegisterEventHandler(EventType.ClientTargetGameObjResponse, "copyform",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		if not( target:IsMobile() ) then
			this:SystemMessage("Error: /changeform only works on mobiles")
		end

		target:SendMessage("CopyOtherMobile",mMobToCopy)
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "form",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		if not( target:IsMobile() ) then
			this:SystemMessage("Error: /changeform only works on mobiles")
		end

		target:SendMessage("ChangeMobileToTemplate",bodyTemplateId,{LoadLoot=false})
	end)

newScale = nil

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "possess",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end
		--DebugMessage("possess",tostring(target))
		DoPossession(this,target)
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "tamecmd",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end
		SetCreatureAsPet(target, this)
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "editchar",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end
		OpenCharEditWindow(target)
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "scale",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SetScale(Loc(newScale,newScale,newScale))
	end
)

newColor = nil

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "color",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SetColor(newColor)
	end
)

newHue = nil

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "hue",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SetHue(newHue)
	end
)


scriptName = nil

RegisterEventHandler(
	EventType.ClientTargetGameObjResponse, "attach",
	function(target,user)
		if( target ~= nil and target:IsValid() ) then
			if( not target:AddModule(scriptName) ) then
				this:SystemMessage("Failed to attach module "..scriptName..".")
			else
				this:SystemMessage("Module "..scriptName.." attached.")
			end
		end	
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "resTarget",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SendMessage("Resurrect",1.0)
	end
)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "resTargetForce",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SendMessage("Resurrect",1.0,nil,true)
	end
)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "healTarget",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		local curHealth = math.floor(GetCurHealth(target))
		local healAmount = GetMaxHealth(target) - curHealth

		SetCurHealth(target,curHealth + healAmount)

		this:SystemMessage("Healed "..target:GetName().." for " .. healAmount,"event")
		this:SystemMessage("Health is now "..tostring(GetCurHealth(target)))
	end
)

function DoSlay(target)	
    if( target:IsValid() ) then		
		target:SendMessage("ProcessTrueDamage", this, GetCurHealth(target), true)
		target:PlayEffect("LightningCloudEffect")
	end
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "slayTarget", 
	function(target,user)
		if( target == nil ) then
			return
		end

		DoSlay(target)
	end
)

function DoFreeze(target)	
	if( target:IsValid() ) then
		if ( HasMobileEffect(target, "GodFreeze") ) then
			target:SendMessage("EndGodFreezeEffect")
		else
			target:SendMessage("StartMobileEffect", "GodFreeze")
		end
	end
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "freezeTarget", 
	function(target,user)
		if( target == nil ) then
			return
		end

		DoFreeze(target)
	end
)

nameToSet = nil

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "setname",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SetName(nameToSet)
		target:SendMessage("UpdateName")
	end
)

local destroyTargetObj = nil
function DoDestroy(target)
	if(target:IsPlayer()) then
		this:SystemMessage("You cannot destroy players")
	elseif(target:HasObjVar("NoReset")) then
		destroyTargetObj = target
		ClientDialog.Show{
			TargetUser = this,
		    DialogId = "DestroyConfirm",
		    TitleStr = "Warning",
		    DescStr = "[$2456]",
		    Button1Str = "Yes",
		    Button2Str = "No",
		    ResponseFunc = function ( user, buttonId )
				buttonId = tonumber(buttonId)
				if( buttonId == 0 and destroyTargetObj ~= nil) then
					if(destroyTargetObj:HasEventHandler(EventType.Message,"Destroy")) then
						destroyTargetObj:SendMessage("Destroy")
					else
						destroyTargetObj:Destroy()
					end					
				end
			end
		}
	else
		this:SystemMessage("Destroying object "..tostring(target))
		if(target:HasEventHandler(EventType.Message,"Destroy")) then
			target:SendMessage("Destroy")
		else
			target:Destroy()
		end		
	end
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "destroyTarget",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		DoDestroy(target)
	end
)

function DoKick(arg)
	if( #arg >= 1) then
		local reason = ""
		if( #arg >= 2 ) then	
			-- DAB TODO: Only supports one word		
			reason = arg[2]
		end

		local playerObj = GetPlayerByNameOrId(arg[1])
		if( playerObj ~= nil ) then
			playerObj:KickUser(reason)
			
			this:SystemMessage(playerObj:GetName().." kicked from server.")
			
		end
	end	
end

function DoUserBan(arg)
	if( #arg >= 1) then
		local hours = "0"
		if( #arg >= 2 ) then	
			hours = arg[2]
		end

		local userid = arg[1]

		if( userid ~= nil and userid ~= "") then
			BanUser(userid, hours)
		end
	end	
end

function UnBanUser(userid)
	UnbanUser(userid)
end

function DoIPBan(arg)
	local ip = arg[1]

	if( ip ~= nil and ip ~= "") then
		BanIP(ip)
	end
end

function UnBanIP(ip)
	UnbanIP(ip)
end

RegisterEventHandler(EventType.GetBanListResult,"BanListResults",function(data)
		this:SystemMessage(DumpTable(data))
	end)

RegisterEventHandler(EventType.ClientTargetLocResponse, "jump", 
	function(success,targetLoc)
		local commandInfo = GetCommandInfo("jump")

		if not(LuaCheckAccessLevel(this,commandInfo.AccessLevel)) then return end	

		if( success ) then
			this:RequestClientTargetLoc(this, "jump")
			if( IsPassable(targetLoc) ) then
				this:SetWorldPosition(targetLoc)
				this:PlayEffect("TeleportToEffect")
			end
		end	
	end)

prefabCreate = nil
RegisterEventHandler(EventType.ClientTargetLocResponse, "prefab", 
	function(success,targetLoc)
		local commandInfo = GetCommandInfo("createprefab")

		if not(LuaCheckAccessLevel(this,commandInfo.AccessLevel)) then return end	

		if( success and prefabCreate) then
			CreatePrefab(prefabCreate,targetLoc,Loc(0,0,0))
			for i,point in pairs(GetRelativePrefabExtents(prefabCreate,targetLoc).Points) do
				CreateObj("house_plot_marker",Loc(point))
			end
			
		end	
	end)

campCreate = nil
RegisterEventHandler(EventType.ClientTargetLocResponse, "camp", 
	function(success,targetLoc)
		local commandInfo = GetCommandInfo("createcamp")

		if not(LuaCheckAccessLevel(this,commandInfo.AccessLevel)) then return end	

		if( success and campCreate) then
        	CreateObj("prefab_camp_controller",targetLoc,"controller_spawned", campCreate)
		end	
	end)



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

RegisterEventHandler(EventType.Timer,"Clock",
	function()
		local clockWindow = DynamicWindow("ClockWindow","Clock",100,100)
		clockWindow:AddLabel(100,30,GetGameTimeOfDayString())

		local label = "Broken"
		local isDaytime = not IsNightTime()
		if (isDaytime) then
			label = "Day"
		else
			label = "Night"
		end

		clockWindow:AddLabel(100,50,label)
		this:OpenDynamicWindow(clockWindow)

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"Clock")
	end)

RegisterEventHandler(EventType.DynamicWindowResponse,"ClockWindow",
	function()
		this:RemoveTimer("Clock")
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

RegisterEventHandler(EventType.CreatedObject,"controller_spawned",
    function(success,objRef,callbackData)        
        --spawn the object and save it
        if success then
            objRef:SetObjVar("PrefabName",callbackData)
            objRef:SendMessage("Reset")
        end
    end)

UserListPage = 1

function ShowUserList(selectedUser)
	if (selectedUser == nil) then selectedUser = this end
	local newWindow = DynamicWindow("UserList","Player List",450,530) 
	local allPlayers = FindPlayersInRegion()
	
	if(#allPlayers == 0) then
		table.insert(allPlayers,{Name="Center",Loc=Loc(0,0,0)})
	end

	local scrollWindow = ScrollWindow(20,40,380,375,25)
	for i,player in pairs(allPlayers) do
		local scrollElement = ScrollElement()	

		if((i-1) % 2 == 1) then
            scrollElement:AddImage(0,0,"Blank",360,25,"Sliced","1A1C2B")
        end
		
		scrollElement:AddLabel(5, 3, player:GetName(),0,0,18)

		local selState = ""
		if(player.Id == selectedUser.Id) then
			selState = "pressed"
		end
		scrollElement:AddButton(340, 3, "select|"..player.Id, "", 0, 18, "", "", false, "Selection",selState)
		scrollWindow:Add(scrollElement)
	end
	newWindow:AddScrollWindow(scrollWindow)

	-- Goto
	newWindow:AddButton(15, 420, "teleport|"..selectedUser.Id, "Tele To", 100, 23, "", "", false,"",buttonState)
	newWindow:AddButton(115, 420, "teleportToMe|"..selectedUser.Id, "Tele Here", 100, 23, "", "", false,"",buttonState)
	newWindow:AddButton(215, 420, "heal|"..selectedUser.Id, "Heal", 100, 23, "", "", false,"",buttonState)
	newWindow:AddButton(315, 420, "resurrect|"..selectedUser.Id, "Resurrect", 100, 23, "", "", false,"",buttonState)
	
	this:OpenDynamicWindow(newWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"UserList",
	function (user,returnId)
		if(returnId ~= nil) then
			action = StringSplit(returnId,"|")[1]
			playerId = StringSplit(returnId,"|")[2]
			--DebugMessage("action is "..tostring(action)) 
			--DebugMessage("playerId is "..tostring(playerId))
			if (playerId ~= nil) then
				local playerObj = GetPlayerByNameOrId(playerId)
				if(action== "teleport") then
					if( playerObj ~= nil ) then
						this:SetWorldPosition(playerObj:GetLoc())
						this:PlayEffect("TeleportToEffect")
					end
				elseif(action== "teleportToMe") then
					if( playerObj ~= nil ) then
						playerObj:PlayEffect("TeleportFromEffect")
						playerObj:SetWorldPosition(this:GetLoc())
						playerObj:PlayEffect("TeleportToEffect")
					end
				elseif(action== "select") then
					local playerObj = GetPlayerByNameOrId(playerId)
					ShowUserList(playerObj)
				elseif(action=="heal") then
					local curHealth = math.floor(GetCurHealth(playerObj))
					local healAmount = GetMaxHealth(playerObj) - curHealth
					SetCurHealth(playerObj,curHealth + healAmount)
					playerObj:PlayEffect("HealEffect")
					this:SystemMessage("Healed "..playerObj:GetName().." for " .. healAmount,"event")
				elseif(action== "resurrect") then
					if( playerObj ~= nil ) then
						playerObj:SendMessage("Resurrect",1.0)
					end
				end
			end
		end	
	end)

function DoToggleInvuln(targetObj)
	if(targetObj == nil or not(targetObj:IsValid())) then return end

	if(targetObj:IsPlayer() and not IsImmortal(targetObj)) then
		this:SystemMessage("You cannot set a mortal player to invulnerable.")
	elseif(targetObj:HasObjVar("Invulnerable")) then
		targetObj:DelObjVar("Invulnerable")
		this:SystemMessage(targetObj:GetName().."("..tostring(targetObj.Id)..") Invulnerable Off")
	else
		targetObj:SetObjVar("Invulnerable",true)
		this:SystemMessage(targetObj:GetName().."("..tostring(targetObj.Id)..") Invulnerable On")
	end
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse,"invuln",
	function(target,user)
		DoToggleInvuln(target)
	end)

function StartPush(pushObj)
	if not(IsDemiGod(this)) then return end

	this:SendClientMessage("EditObjectTransform",{pushObj,this,"push_edit"})
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse,"setpushtarget",
	function(targetObj,user)
		if(targetObj ~= nil) then			
			StartPush(targetObj)
		end
	end)

RegisterEventHandler(EventType.Message,"PushObject",
	function (target)
		StartPush(target)
	end)

RegisterEventHandler(EventType.ClientObjectCommand, "transform",
	function (user,targetId,identifier,command,...)
		if(IsDemiGod(user) and identifier == "push_edit") then
			if(command == "confirm") then
				local targetObj = GameObj(tonumber(targetId))
				if(targetObj:IsValid()) then
					local commandArgs = table.pack(...)

					local newPos = Loc(tonumber(commandArgs[1]),tonumber(commandArgs[2]),tonumber(commandArgs[3]))
					local newRot = Loc(tonumber(commandArgs[4]),tonumber(commandArgs[5]),tonumber(commandArgs[6]))
					local newScale = Loc(tonumber(commandArgs[7]),tonumber(commandArgs[8]),tonumber(commandArgs[9]))

					targetObj:SetWorldPosition(newPos)
					targetObj:SetRotation(newRot)
					targetObj:SetScale(newScale)
				end
			end
		end		
	end)

RegisterEventHandler(EventType.Message,"transfer",
	function (targetRegion)
		DebugMessage("GOING to ".. targetRegion .. "! "..this:GetName())	
		this:TransferRegionRequest(targetRegion,Loc(0,0,0))
	end)

RegisterEventHandler(EventType.DestroyAllComplete,"WorldReset",
	function ()
		DebugMessage("--- (WorldReset) OBJECTS DESTROYED --- LOADING SEEDS ---")
		LoadSeeds()
		ResetPermanentObjectStates()

		local allHouses = FindObjects(SearchModule("house_control"))
		for i,houseObj in pairs(allHouses) do
			houseObj:SendMessage("OnWorldReset")
		end
	end)

function ShowCreateCoins()		
	local width = (#Denominations * 80) + 160
	local curX = 20

	local newWindow = DynamicWindow("CreateCoins","Create Coins",width,100,-50,-50,"","Center")

	local i = #Denominations
	while(i > 0) do
		local denomInfo = Denominations[i]
		newWindow:AddTextField(curX,20,50,20,denomInfo.Name,"0")
		newWindow:AddLabel(curX+52,25,denomInfo.Abbrev,60,0,18)
		curX = curX + 80
		i = i - 1
	end

	newWindow:AddButton(curX+10,15,"Create","Create",0,0,"","",true)

	this:OpenDynamicWindow(newWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"CreateCoins",
	function (user,buttonId,fieldData)
		if(buttonId == "Create") then
			amounts = {}
			for denomName,denomValStr in pairs(fieldData) do
				local denomVal = tonumber(denomValStr)
				if(denomVal ~= nil and denomVal > 0) then
					amounts[denomName] = denomVal
				end
			end
			if(CountTable(amounts) > 0) then
				CreateObjInBackpack(user,"coin_purse","coins_created",amounts)
			end
		end
	end)

RegisterEventHandler(EventType.CreatedObject,"coins_created",
	function(success,objref,amounts)
		if(success) then
			objref:SendMessage("SetCoins",amounts)
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

isFollowing = false
RegisterEventHandler(EventType.ClientTargetGameObjResponse,"follow",
	function (target,user)
		if(target ~= nil) then
			if(IsImmortal(user) or ShareGroup(target,user) ) then
				local runspeed = ServerSettings.Stats.RunSpeedModifier
				if ( IsMounted(this) ) then
					runspeed = ServerSettings.Stats.MountSpeedModifier
				end
				user:PathToTarget(target,1,runspeed)			
				isFollowing = true	
			end
		end
	end)

function DoCreateFromFile(filename)
	io.open(filename,"r")
	local count = 1
	local depth = 1
	local parent, curItem	
	local lines = {}
	for line in io.lines(filename) do table.insert(lines,line) end
	local args = StringSplit(lines[1]," ")
	table.remove(lines,1,1)
    CreateObj(args[1],this:GetLoc(),"fromfile",lines,args[2])
end

RegisterEventHandler(EventType.CreatedObject,"fromfile",
	function (success,objRef,entries,count)
		if(count ~= nil and tonumber(count) > 1) then
			RequestSetStackCount(objRef,tonumber(count))
		end

		if(#entries > 0) then
			local line = entries[1]
			local depth = entries.depth or 1
			local _, newDepth = string.gsub(line, "%\t", "")
			
			local args = StringSplit(StringTrim(line)," ")
			table.remove(entries,1,1)

			if(newDepth <= depth) then
				if(newDepth < depth) then
					entries.depth = newDepth
					entries.parent = entries.superParent
				end

				if(entries.parent) then
					DebugMessage("Creating ",args[1]," inside ",entries.parent:GetCreationTemplateId())
					local randomLoc = GetRandomDropPosition(entries.parent)
					CreateObjInContainer(args[1], entries.parent, randomLoc, "fromfile", entries, args[2])
				else
					DebugMessage("Creating ",args[1]," inside ","Ground")
					CreateObj(args[1],this:GetLoc(),"fromfile",entries,args[2])
				end
			elseif(newDepth > depth) then
				local randomLoc = GetRandomDropPosition(objRef)
				if(entries.parent ~= nil) then
					entries.superParent = entries.parent
				end
				entries.parent = objRef
				entries.depth = newDepth
				DebugMessage("Creating ",args[1]," inside ",objRef:GetCreationTemplateId())
				CreateObjInContainer(args[1], objRef, randomLoc, "fromfile", entries, args[2])		
			end
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

-- Default command functions are stored in this table for readability
-- If you override one of these functions, it must be reregistered using RegisterCommand
-- or the command will still reference the old version of the function
DefaultCommandFuncs= 
{
	-- Mortal Commands

	Help = function(commandName)
		if( commandName ~= nil ) then
			if(commandName == "actions") then
				local emotesStr = ""
				for commandName, animName in pairs(Emotes) do 
					emotesStr = emotesStr .. "/" .. commandName .. ", "
				end
				emotesStr = StripTrailingComma(emotesStr)
				this:SystemMessage("Emotes: "..emotesStr)
			else
				local commandInfo = GetCommandInfo(commandName)
				if( commandInfo == nil ) then
					this:SystemMessage("Invalid command")
				elseif( not( LuaCheckAccessLevel(this,commandInfo.AccessLevel) or this:HasObjVar("IsGod")) ) then
					this:SystemMessage("You do not have the power to use that command.")
				else
					local usageStr = "Usage: /"..commandName
					if( commandInfo.Usage ~= nil ) then
						usageStr = usageStr.." "..commandInfo.Usage
					end
					this:SystemMessage(usageStr)
					if(commandInfo.Desc ~= nil ) then
						this:SystemMessage(commandInfo.Desc)
					end
				end
			end
		else
			local outStr = "Available Commands: "
			for i,commandInfo in pairs(CommandList) do
				if( LuaCheckAccessLevel(this,commandInfo.AccessLevel) or this:HasObjVar("IsGod") ) then
					outStr = outStr .. commandInfo.Command .. ", "
				end
			end
			this:SystemMessage(outStr)
			this:SystemMessage("Type /help <command> to get more info.")
			this:SystemMessage("For a list of emotes type /help actions")			
		end
	end,

	Title = function()
		ToggleTitleWindow(this)
		--local titleIndex = this:GetObjVar("titleIndex") or 0
		--local allTitles = PlayerTitles.GetAll()
		--	
		--local newTitleIndex = titleIndex + 1
		--if( newTitleIndex > #allTitles ) then newTitleIndex = 0 end
		--
		--if( newTitleIndex ~= titleIndex ) then
		--	this:SetObjVar("titleIndex",newTitleIndex)
		--
		--	this:SendMessage("UpdateTitle");
		--end
	end,

	Quest = function()
		if not(this:HasObjVar("OverrideQuestWindow")) then
			ToggleQuestWindow(this)
		end
		--local titleIndex = this:GetObjVar("titleIndex") or 0
		--local allTitles = PlayerTitles.GetAll()
		--	
		--local newTitleIndex = titleIndex + 1
		--if( newTitleIndex > #allTitles ) then newTitleIndex = 0 end
		--
		--if( newTitleIndex ~= titleIndex ) then
		--	this:SetObjVar("titleIndex",newTitleIndex)
		--
		--	this:SendMessage("UpdateTitle");
		--end
	end,

	Autoharvesting = function ()
		if (this:HasObjVar("NoQueueHarvest")) then
			this:SystemMessage("Autoharvesting of resources enabled.")
			this:DelObjVar("NoQueueHarvest")
		else
			this:SystemMessage("Autoharvesting of resources disabled.")
			this:SetObjVar("NoQueueHarvest",true)
		end
	end,

	Say = function(...)
		local line = CombineArgs(...)
		this:LogChat("[Say] "..line)
		this:PlayerSpeech(line,30)
	end,

	Roll = function(...)
		if ( this:HasTimer("AntiSpamTimer") ) then return end
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500), "AntiSpamTimer")

		local args = table.pack(...)
		local lower = math.max(1, tonumber(args[1]) or 1)
		local upper = math.min(1000, tonumber(args[2]) or 100)
		if ( lower > upper ) then
			local temp = upper
			upper = lower
			lower = temp
		end
		local name = StripColorFromString(this:GetName())
		local roll = math.random(lower,upper)
		local message = string.format("%s rolls %d (%d-%d)", name, roll, lower, upper)
		this:SystemMessage(message)
		local nearbyPlayers = FindObjects(SearchPlayerInRange(30))
		for i=1,#nearbyPlayers do
			nearbyPlayers[i]:SystemMessage(message)
		end
	end,

	--[[Region = function(...)
		local line = CombineArgs(...)
		if ( line == nil ) then return end
		line = StringTrim(line)
		if ( line == "" ) then return end
		
		local name = StripColorFromString(this:GetName())
		local fullMessage = "[FF8000][Region] " .. name .. ": " .. line .. "[-]"
		for i,userObj in pairs(FindPlayersInRegion()) do
			userObj:SystemMessage(fullMessage,"custom")
		end
	end,]]

	ReplyTell = function(...)
		DefaultCommandFuncs.Tell(mLastTeller,...)
	end,

	Tell = function(userNameOrId,...)
		if( userNameOrId == nil ) then Usage("tell") return end

		local line = CombineArgs(...)
		if ( line ~= nil) then
			local player = GetPlayerByNameOrIdGlobal(userNameOrId)
			if( player ~= nil ) then
				local name = "Unknown"
				if ( player:IsValid() ) then
					name = StripColorFromString(player:GetName())
				else
					name = GlobalVarReadKey("User.Name", player)
				end
				this:LogChat("[Tell]["..name.."] "..line)
				player:SendMessageGlobal("PrivateMessage",this:GetName(),line,this.Id)
				this:SystemMessage("[E352EA]To "..name..":[-] "..line,"custom")
			end
		end		
	end,

	Who = function(keyword)
		if(not(IsImmortal(this))) then
			this:SystemMessage("Who command has been temporarily disabled.")
			return
		end
		local max = 64
		local total = 0
		local isGod = IsGod(this)

		local online = GlobalVarRead("User.Online")
		for user,y in pairs(online) do
			local name = GlobalVarReadKey("User.Name", user)
			if ( total < max and (keyword == nil or name:match(keyword)) ) then
				if ( isGod ) then
					local address = GlobalVarReadKey("User.Address", user)
					this:SystemMessage(string.format("[FFBF00]%s (%s)(%s)[-]", name, address, user.Id))
				else
					this:SystemMessage(string.format("[FFBF00]%s (%s)[-]", name, user.Id))
				end
			end
			total = total + 1
		end

		local suffix = ""
		if ( total > max ) then
			suffix = " (List Truncated)"
		end
		if ( isGod ) then
			this:SystemMessage(string.format("[FFBF00]%d players online.%s[-]", total, suffix))
		end
	end,

	Stats = function()
		this:SystemMessage("Str:" ..GetStr(this) .. ",  Agi:" .. GetAgi(this) .. ",  Int:" ..GetInt(this))
		this:SystemMessage("Health:".. GetCurHealth(this).. "/".. GetMaxHealth(this).. " Regen:".. math.floor(GetHealthRegen(this) * 10)/10)
		this:SystemMessage("Stam:".. GetCurStamina(this).. "/".. GetMaxStamina(this).. " Regen:".. math.floor(GetStaminaRegen(this) * 10)/10)
		this:SystemMessage("Mana:".. GetCurMana(this).. "/".. GetMaxMana(this).. " Regen:".. math.floor(GetManaRegen(this) * 10) /10)
	end,

	Where = function()
		local loc = this:GetLoc()
		local locX = string.format("%.2f", loc.X)
		local locY = string.format("%.2f", loc.Y)
		local locZ = string.format("%.2f", loc.Z)
		local facing = string.format("%.0f", this:GetFacing())
		local regions = GetRegionsAtLoc(loc)
		local regionStr = ""
		for i,regionName in pairs(regions) do
			regionStr = regionStr .. regionName .. ", "
		end

		local regionAddress = GetRegionAddress()
		if(regionAddress ~= nil and regionAddress ~= "") then
			this:SystemMessage("Region Address: "..regionAddress)
		end

		if(IsGod(this)) then
			this:SystemMessage("World: "..GetWorldName())
			this:SystemMessage("Subregions: "..regionStr)
		end
		
		this:SystemMessage("Loc: "..locX..", "..locY..", "..locZ..", Facing: "..tostring(facing))
	end,

	GroupLeave = function(...)
		local groupId = GetGroupId(this)

		if ( groupId == nil ) then
			this:SystemMessage("You are not in a group.", "info")
			return
		end

		ClientDialog.Show{
			TargetUser = this,
			DialogId = uuid(),
			TitleStr = "Leave Group",
			DescStr = "Are you sure you wish to leave your group?",
			Button1Str = "Confirm",
			Button2Str = "Cancel",
			ResponseFunc=function(user,buttonId)
				if ( user == nil or buttonId ~= 0 ) then return end

				GroupRemoveMember(groupId, this)
			end,
		}		
	end,

	GroupMessage = function(...)
		GroupSendChat(this,...)
	end,

	GroupInvite = function(userNameOrId)
		if( userNameOrId == nil ) then Usage("invite") return end

		local player = GetPlayerByNameOrIdGlobal(userNameOrId)
		if ( player == nil ) then
			this:SystemMessage(string.format("Player '%s' not found.", userNameOrId), "info")
		else
			GroupInvite(this, player)
		end
	end,

	GuildInvite = function(...)

		Guild.InviteTarget(this)
	end,

	GuildMessage = function(...)
		Guild.SendMessage(...)
	end,

	AllegianceMessage = function(...)
		--DebugMessage("Whaddafqu")
		Guild.SendAllegianceMessage(...)
	end,

	GuildMenu = function()
		GuildInfo()
	end,

	Time = function()
		this:SystemMessage("It is "..GetGameTimeOfDayString())
	end,

	Clock = function()
		this:FireTimer("Clock")
	end,

	FrameTime = function ()
		this:FireTimer("FrameTimeTimer")
	end,

	Hunger = function()
		if ( this:HasTimer("CheckedHunger") ) then return end
		local hunger = this:GetObjVar("Hunger") or 0
		if ( hunger < ServerSettings.Hunger.Threshold ) then
			local tillHungry = TimeSpan.FromSeconds(((ServerSettings.Hunger.Threshold - hunger) / ServerSettings.Hunger.Rate) * 60)
			
			this:SystemMessage("You will be hungry in "..TimeSpanToWords(tillHungry))
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(60), "CheckedHunger")
		else
			this:SystemMessage("You are hungry.")
		end
	end,

	ResetFaction = function(factionName)
		if( factionName == nil ) then Usage("resetfaction") return end

		SetFactionToAmount(this,0,factionName)
		this:SystemMessage("Your "..factionName.." faction has been reset")
	end,


	Resethotbar = function()
		WipeHotbarData()
		this:SystemMessage("Your hotbars have been reset, please log out and then back in.")
	end,

	--TriggerWolfEvent = function()
	--	local controller = FindObject(SearchModule("great_tree_event_controller"))
	--	controller:SendMessage("StartEvent")
	--	this:SystemMessage("Wolf Event Triggered")
	--end,

	CheckFaction = function(factionName)
		if( factionName == nil ) then Usage("checkfaction") return end

		local factionAmount = GetFaction(this,factionName)
		this:SystemMessage("The "..factionName.." considers you "..GetFactionTitle(this,factionAmount,factionName).." ("..factionAmount..")")
	end,

	ChangeFaction = function(factionName,amount)
		if( factionName == nil or amount == nil) then Usage("changefaction") return end

		local factionAmount = GetFaction(this,factionName)
		local amount = tonumber(amount)
		this:SystemMessage("Your "..factionName.." faction will be changed by "..amount)

		ChangeFactionByAmount(this,amount,factionName)
	end,

	-- Immortal Commands

	WhoDialog =	function()
		ShowUserList(this)
	end,

	SearchDialog =	function(arg)
		ShowNewSearch(arg)
	end,

	Cloak = function(nameOrId)	
		local targetObj = this	
		if( nameOrId ~= nil) then		
			targetObj = GetPlayerByNameOrId(nameOrId)
		end
			
		if( targetObj ~= nil ) then
			local isCloaked = targetObj:IsCloaked()
			targetObj:SetCloak(not(isCloaked))
		end
	end,

	TeleportTo = function(nameOrId)
		if( nameOrId ~= nil) then	
			if(nameOrId:sub(1,1) == "$" or nameOrId:sub(1,1) == "$") then
				local permObj = PermanentObj(tonumber(nameOrId:sub(2)))
				if( permObj ~= nil ) then
					this:SetWorldPosition(permObj:GetLoc())
					this:PlayEffect("TeleportToEffect")
				end
			else
				local playerObj = GetPlayerByNameOrId(nameOrId)
				if( playerObj ~= nil ) then
					playerObj = playerObj:TopmostContainer() or playerObj
					this:SetWorldPosition(playerObj:GetLoc())
					this:PlayEffect("TeleportToEffect")
				end
			end
		else
			Usage("teleportto")
		end
	end,

	ToogleInvuln = function(targetId)
		if(targetId ~= nil) then
			local targetObj = nil
			if(targetId == 'self') then
				targetObj = this
			else
				targetObj = GameObj(tonumber(targetId))
			end

			DoToggleInvuln(targetObj)
		else
			this:RequestClientTargetGameObj(this,"invuln")
		end
	end,

	Jump = function()		
		this:RequestClientTargetLoc(this, "jump")			
	end,

	Goto = function(...)	
		local args = table.pack(...)
		if( #args < 1 ) then
			ShowGoToList()
			return
		end

		local x, y, z = 0, 0, 0
		if( #args == 2 ) then
			x = tonumber(args[1])
			z = tonumber(args[2])
		else
			x = tonumber(args[1])
			y = tonumber(args[2])
			z = tonumber(args[3])
		end
		if (type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number") then return end
		this:SetWorldPosition(Loc(x,y,z))
	end,

	Portal = function(...)
		local args = table.pack(...)
		if( #args < 1 ) then
			Usage("portal")
			return
		end

		local x, y, z = 0, 0, 0
		if( #args == 2 ) then
			x = tonumber(args[1])
			z = tonumber(args[2])
		else
			x = tonumber(args[1])
			y = tonumber(args[2])
			z = tonumber(args[3])
		end

		OpenTwoWayPortal(this:GetLoc(),Loc(x,y,z),20)
	end,


	-- DemiGod Commands

	AddTitle = function(userNameOrId,...)
		local lineData = table.pack(...)
		if( userNameOrId ~= nil and #lineData > 0 ) then
			local playerObj = GetPlayerByNameOrId(userNameOrId)
			if( playerObj ~= nil ) then				
				local line = ""
				for i = 1,#lineData do line = line .. tostring(lineData[i]) .. " " end
				if( line ~= "" ) then
					local newTitleIndex = PlayerTitles.Entitle(playerObj,line,true,"User Title","")

					if( newTitleIndex ~= nil ) then
						playerObj:SystemMessage("You have been granted the title: " .. line,"event")
					end
				end
			end
		else
			Usage("addtitle")
		end
	end,

	JoinGuild = function(guildId,guildName)
		if(Guild.Get(this)) then
			this:SystemMessage("You must leave your guild first")
			return
		end

		if(guildId == nil) then 
			guildId = NEW_PLAYER_GUILD_ID 
			guildName = ServerSettings.Misc.NewPlayerGuildName
		end

		if not(Guild.GetGuildRecord(guildId)) then
			if(guildName == nil) then
				this:SystemMessage("Guild does not exist, specify a guild name!")
				return
			end
			npGuildRecord = Guild.Create(nil,guildName,guildId)
		end

		CallFunctionDelayed(TimeSpan.FromSeconds(1),function ( ... )
			Guild.AddToGuild(guildId)
		end)
		
		CallFunctionDelayed(TimeSpan.FromSeconds(2),function ( ... )
			local guildRecord = Guild.GetGuildRecord(guildId)
			Guild.PromoteMember(this,guildRecord,"Officer",true)
		end)	
	end,

	Create = function(templateName,amount)		
		if( templateName ~= nil ) then
			templateId = GetTemplateMatch(templateName)
			if( templateId ~= nil ) then
				amount = tonumber(amount) or 0
				if( amount > 1 ) then
					if( GetTemplateObjVar(templateId,"ResourceType") ~= nil ) then
						createAmount = amount
						CreateObj(templateId, this:GetLoc(), "createamount")
						PlayEffectAtLoc("TeleportFromEffect",this:GetLoc())
						return
					end
				end

				CreateObj(templateId, this:GetLoc(), "CreateCommand")
				PlayEffectAtLoc("TeleportFromEffect",this:GetLoc())
			else
				templateListCategory = "All"
				templateListCategoryIndex = 1
				templateListFilter = templateName
				ShowPlacableTemplates()
			end
		else
			templateListFilter = ""
			ShowPlacableTemplates()
		end
	end,

	CreateEquippedObject = function(templateName, targetId)
		local target = this
		if ( targetId ~= nil ) then
			target = GameObj(tonumber(targetId))
			if ( target == nil or not target:IsValid() ) then
				target = this
			end
		end
		if ( target ~= nil and templateName ~= nil and target:IsValid() ) then
			templateId = GetTemplateMatch(templateName)
			if ( templateId ~= nil ) then
				CreateEquippedObj(templateId, target, "CreateCommand")
			end
		end
	end,

	CreatePrefab = function (prefabname)		
		if( prefabname ~= nil ) then
			prefabCreate = prefabname
			this:RequestClientTargetLoc(this, "prefab")
		end
	end,

	CreateCamp = function (campname)		
		if( campname ~= nil ) then
			campCreate = campname
			this:RequestClientTargetLoc(this, "camp")
		end
	end,

	Body = function(templateName)
		if( templateName == nil ) then
			Usage("setbody")
			return
		end

		bodyTemplateId = GetTemplateMatch(templateName)

		if( bodyTemplateId ~= nil ) then
			this:RequestClientTargetGameObj(this, "body")
		end
	end,

	ChangeForm = function(templateName)
		if(templateName ~= nil) then
			bodyTemplateId = GetTemplateMatch(templateName)

			if( bodyTemplateId ~= nil ) then
				this:RequestClientTargetGameObj(this, "form")
			end
		else
			this:AddModule("change_form_window")
		end
	end,

	CopyForm = function()
		this:SystemMessage("Which mob do you wish to copy?")
		this:RequestClientTargetGameObj(this, "copyformselect")
	end,

	Possess = function (targetObj)
		if(targetObj == nil) then			
			this:RequestClientTargetGameObj(this, "possess")
		else
			DoPossession(this,GameObj(tonumber(targetObj)))
		end
	end,

	EndPossess = function ()
		-- passing no argument returns you back to the player
		DoPossession(this)
	end,

	Tame = function(targetObj)
		if(targetObj == nil) then			
			this:RequestClientTargetGameObj(this, "tamecmd")
		else
			SetCreatureAsPet(GameObj(tonumber(targetObj)), this)
		end
	end,

	EditChar = function(targetObj)
		if(targetObj == nil) then			
			this:RequestClientTargetGameObj(this, "editchar")
		else
			OpenCharEditWindow(targetObj)
		end
	end,

	Scale = function(scaleValue)
		if( scaleValue == nil ) then
			Usage("setscale")
			return
		end

		newScale = tonumber(scaleValue)

		if( newScale ~= nil ) then
			this:RequestClientTargetGameObj(this, "scale")
		end
	end,

	Color = function(colorcode)
		if( colorcode == nil ) then
			Usage("SetColor")
			return
		end

		newColor = colorcode

		this:RequestClientTargetGameObj(this, "color")
	end,

	Hue = function(hueindex)
		if( hueindex == nil ) then
			Usage("SetHue")
			return
		end

		newHue = tonumber(hueindex)

		this:RequestClientTargetGameObj(this, "hue")
	end,

	Info = function(targetObjId)
		if(targetObjId ~= nil) then
			gameObj = GameObj(tonumber(targetObjId))
			if(gameObj:IsValid()) then
				DoInfo(gameObj)
				return
			else
				this:SystemMessage(tostring(targetObjId).." is not a valid id. Object does not exist.")
			end
		end
		this:RequestClientTargetGameObj(this, "info")		
	end,

	GlobalVar = function(recordPath)
		local results = GlobalVarListRecords(recordPath)
		if(#results == 1) then
			ShowGlobalVar(results[1])
		else
			ListGlobalVars(results)
		end
	end,

	DeleteGlobalVar = function (recordPath)
		recordPath = recordPath or ""
		local results = GlobalVarListRecords(recordPath)
		if(#results > 0) then
			local varStr = ""
			for i, varName in pairs(results) do 
				varStr = varStr .. varName .. "\n"
			end

			ClientDialog.Show{
				    TargetUser = this,
				    DialogId = "DeleteVarsDialog",
				    TitleStr = "Are you sure?",
				    DescStr = "[$2460]"..varStr,
				    Button1Str = "Yes",
				    Button2Str = "No",
				    ResponseFunc = function ( user, buttonId )
						buttonId = tonumber(buttonId)
						if( buttonId == 0) then				
							for i, varName in pairs(results) do 
								GlobalVarDelete(varName,nil)
							end
							this:SystemMessage("Deleted "..#results.." records.")
						else
							this:SystemMessage("Cancelled")
						end
					end
				}
		else
			this:SystemMessage("No matching records")
		end
	end,

	Debug = function(targetObjId)
		if(args ~= nil) then
			gameObj = GameObj(tonumber(targetObjId))
			if(gameObj:IsValid()) then
				gameObj:SetObjVar("Debug",true)
				DebugMessage(gameObj:GetName().."-----------------------------------")
				return
			end
		end
		this:RequestClientTargetGameObj(this, "debug")		
	end,
	AIState = function(targetObjId)
		if(args ~= nil) then
			gameObj = GameObj(tonumber(targetObjId))
			if(gameObj:IsValid()) then
				DebugMessage("State is "..gameObj:GetObjVar("CurrentState"))
				this:SystemMessage("State is "..gameObj:GetObjVar("CurrentState"))
				return
			end
		end
		this:RequestClientTargetGameObj(this, "aistate")		
	end,

	Resurrect = function(forceOrTargetId, targetObjId)
		local force = false
		local targetId = forceOrTargetId
		if ( forceOrTargetId == "force" ) then
			force = true
			targetId = targetObjId
		end

		if ( targetId == nil ) then
			if ( force ) then
				this:RequestClientTargetGameObj(this, "resTargetForce")
			else
				this:RequestClientTargetGameObj(this, "resTarget")
			end
			return
		end

		local gameObj = this
		if( targetId ~= "self" ) then
			gameObj = GameObj(tonumber(targetId))
		end

		if( gameObj == nil or not(gameObj:IsValid()) ) then
			return
		end

		gameObj:SendMessage("Resurrect",1.0,this,force)
	end,

	ResurrectAll = function (force)
		for i,playerObj in pairs(FindObjects(SearchPlayerInRange(25))) do
			playerObj:SendMessage("Resurrect",1.0,this,force=="force")
		end
	end,

	Heal = function()				
		this:RequestClientTargetGameObj(this, "healTarget")
	end,

	Slay = function(targetObjId)
		if(targetObjId == nil) then
			this:RequestClientTargetGameObj(this, "slayTarget")
			return
		end

		local gameObj = this
		if( targetObjId ~= "self" ) then
			gameObj = GameObj(tonumber(targetObjId))
		end

		DoSlay(gameObj)
	end,

	Nuke = function(targets,userRadius)		
		local includePlayers = false
		local radius = 10
		
		if( targets == "all" ) then
			includePlayers = true
		end
					
		if( userRadius ~= nil ) then
			radius = tonumber(userRadius)
		end				

		local killObjects = FindObjects(SearchMobileInRange(radius))
		if( killObjects ~= nil ) then			
			for index, obj in pairs(killObjects) do
				if( not(obj:IsPlayer() or obj:GetCreationTemplateId() == "wave_target" or (obj:GetObjVar("controller") ~= nil and obj:GetObjVar("controller"):IsPlayer())) or includePlayers) then										
					obj:SendMessage("ProcessTrueDamage", this, 5000, true)
					obj:PlayEffect("LightningCloudEffect")
				end
			end
		end
	end,

	Freeze = function()
		if(targetObjId == nil) then
			this:RequestClientTargetGameObj(this, "freezeTarget")
			return
		end

		local gameObj = this
		if( targetObjId ~= "self" ) then
			gameObj = GameObj(tonumber(targetObjId))
		end

		DoFreeze(gameObj)
	end,

	-- DAB COMBAT CHANGES: We should fix this function (use templates)
	Template = function(classType,level)		
		if(classType == nil or level == nil) then
			Usage("template")
			return
		end
		
		local statValues = {
			["beginner"] = {
				mainStat = 50,
				secStat = 30,
				terStat = 10,
				mainSkill = 40,
				secSkill = 20,
				otherSkill = 10
			},
			["veteran"] = {
				mainStat = 70,
				secStat = 50,
				terStat = 10,
				mainSkill = 70,
				secSkill = 60,
				otherSkill = 40,
			},
			["expert"] = {
				mainStat = 80,
				secStat = 60,
				terStat = 10,
				mainSkill = 100,
				secSkill = 70,
				otherSkill = 70
			}
		}

		local statMod = statValues[level]

		if(statMod == nil) then
			Usage("template")
			return
		end
		
		if( classType == "warrior") then
			SetStr(this,statMod.mainStat)
			SetAgi(this,statMod.secStat)
			SetInt(this,statMod.terStat)
			SetSkillLevel(this, "MeleeSkill", statMod.mainSkill, false)
			SetSkillLevel(this, "BashingSkill", 0, false)
			SetSkillLevel(this, "PiercingSkill", 0, false)
			SetSkillLevel(this, "SlashingSkill", statMod.mainSkill, false)
			SetSkillLevel(this, "MagicAffinitySkill", 0, false)
			SetSkillLevel(this, "BlockingSkill", statMod.mainSkill, false)
			SetSkillLevel(this, "DodgeSkill", 0, false)
			SetSkillLevel(this, "ManifestationSkill", 0, false)
			SetSkillLevel(this, "ChannelingSkill", 0, false)
			this:SystemMessage("[$2461]")
		elseif( classType == "rogue") then
			SetStr(this,statMod.secStat)
			SetAgi(this,statMod.mainStat)
			SetInt(this,statMod.terStat)
			SetSkillLevel(this, "MeleeSkill", statMod.mainSkill, false)
			SetSkillLevel(this, "BashingSkill", 0, false)
			SetSkillLevel(this, "PiercingSkill", statMod.mainSkill, false)
			SetSkillLevel(this, "SlashingSkill", 0, false)
			SetSkillLevel(this, "MagicAffinitySkill", 0, false)
			SetSkillLevel(this, "BlockingSkill", 0, false)
			SetSkillLevel(this, "DodgeSkill", statMod.mainSkill, false)
			SetSkillLevel(this, "ManifestationSkill", 0, false)
			SetSkillLevel(this, "ChannelingSkill", 0, false)
			this:SystemMessage("[$2462]")
		elseif( classType == "mage") then
			SetStr(this,statMod.secStat)
			SetAgi(this,statMod.terStat)
			SetInt(this,statMod.mainStat)
			SetSkillLevel(this, "MeleeSkill", 0, false)
			SetSkillLevel(this, "BashingSkill", 0, false)
			SetSkillLevel(this, "PiercingSkill", 0, false)
			SetSkillLevel(this, "SlashingSkill", 0, false)
			SetSkillLevel(this, "MagicAffinitySkill", statMod.mainSkill, false)
			SetSkillLevel(this, "BlockingSkill", 0, false)
			SetSkillLevel(this, "DodgeSkill", statMod.mainSkill, false)
			SetSkillLevel(this, "ManifestationSkill", statMod.mainSkill, false)
			SetSkillLevel(this, "ChannelingSkill", statMod.mainSkill, false)
			this:SystemMessage("[$2463]")
		elseif( classType == "hybrid") then
			local balancedStat = 20
			if( level == "veteran" ) then
				balancedStat = 40
			elseif( level == "expert" ) then
				balancedStat = 50
			end

			SetStr(this,balancedStat)
			SetAgi(this,balancedStat)
			SetInt(this,balancedStat)

			SetSkillLevel(this, "MeleeSkill", statMod.mainSkill, false)
			SetSkillLevel(this, "BashingSkill", 0, false)
			SetSkillLevel(this, "PiercingSkill", 0, false)
			SetSkillLevel(this, "SlashingSkill", statMod.secSkill, false)
			SetSkillLevel(this, "MagicAffinitySkill", statMod.secSkill, false)
			SetSkillLevel(this, "BlockingSkill", 0, false)
			SetSkillLevel(this, "DodgeSkill", statMod.secSkill, false)
			SetSkillLevel(this, "ManifestationSkill", statMod.secSkill, false)
			SetSkillLevel(this, "ChannelingSkill", statMod.mainSkill, false)
			this:SystemMessage("[$2464]")
		else
			Usage("template")
			return
		end		

		this:SystemMessage("You are now a "..level.." "..classType)
	end,

	SetStat = function(...)
		local arg = table.pack(...)
		if(#arg < 2) then 
			Usage("setstat")
			return
		end
		local myStat = arg[1]
		local myVal = tonumber(arg[2])
		local myTarg = this
		if not (arg[3] == nil) then
			local objId = arg[3]
			local targObj = GameObj(tonumber(objId))
			if(targObj == nil) or not(targObj:IsValid()) then
				this:SystemMessage("[F7CC0A] Invalid Set Target")
				return
			end
			myTarg = targObj
		end
		
		if( string.lower(myStat) == "hp" ) then
			--DebugMessage("SETTING TO "..myVal)
			SetCurHealth(myTarg,myVal)
		elseif(string.lower(myStat) == "mana" ) then
			SetCurMana(myTarg,myVal)
		elseif( string.lower(myStat) == "sta") then
			SetCurStamina(myTarg,myVal)
		elseif( string.lower(myStat) == "vit" ) then
			SetCurVitality(myTarg,myVal)
		-- else its a base stat
		else
			local mySname =string.sub(myStat,2)
			local mySstart = string.sub(myStat,1,1)
			myStat = string.upper(mySstart) .. string.lower(mySname)

			if(myVal <= ServerSettings.Stats.IndividualPlayerStatCap) and (myVal >= ServerSettings.Stats.IndividualStatMin) then
				local myMaxVal = GetStatCap(myTarg) - (GetTotalStats(myTarg) - myTarg:GetStatValue(myStat))
				DebugMessage(myStat,myVal,myMaxVal)
				SetStatByName(myTarg,myStat, math.min(myVal,myMaxVal))
				if (myVal > myMaxVal) then
					this:SystemMessage("[FA0C0C]Entered value exceeds maximum stat cap.[-]")
				end
				this:SystemMessage("[F7CC0A] Set " ..myTarg:GetName() .. " "..myStat.. " to " ..math.min(myVal,myMaxVal))
			else
				this:SystemMessage("Stat Range Must be between "..ServerSettings.Stats.IndividualStatMin.." and "..ServerSettings.Stats.IndividualPlayerStatCap)
			end
		end
	end,

	SetSkill = function(...)		
		local arg = table.pack(...)
		if(#arg < 2) then 
			Usage("setskill")
			return
		end
		local mySkill = arg[1]
		local myVal = tonumber(arg[2])
		local myTarg = this

		if not (arg[3] == nil) then
			local objId = tonumber(arg[3])
			if (type(objId) ~= "number") then return end
			local targObj = GameObj(objId)
			if(targObj == nil) or not(targObj:IsValid()) then
				this:SystemMessage("[F7CC0A]Invalid Set Target[-]")
				return
			end
			myTarg = targObj
		end
		local mySname =string.sub(mySkill,2)
		local mySstart = string.sub(mySkill,1,1)
		skillName = string.upper(mySstart) .. mySname .. "Skill"
		if(IsValidSkill(skillName)) then
			if(tostring(myVal) == "?") then
				local myLev = GetSkillLevel(myTarg,skillName)
				this:SystemMessage(myTarg:GetName() .. " " .. skillName .. " : " .. myLev.."[-]")
				return
			end
			SetSkillLevel(myTarg, skillName, myVal, false)
			if not (myTarg == nil) then
				this:SystemMessage("[F7CC0A]Set ".. myTarg:GetName().. " " .. skillName .. " to " .. myVal.."[-]")
			end
		else
			this:SystemMessage("[F7CC0A]Invalid Skill Set Request : (" .. skillName .. ")[-]")
		end
	end,

	SetAllSkills = function(...)		
		local arg = table.pack(...)
		if(#arg < 1) then 
			Usage("setallskills")
			return
		end
		local myVal = tonumber(arg[1])
		local myTarg = this
		if ( arg[2] ) then
			local objId = tonumber(arg[2])
			if (type(objId) ~= "number") then return end
			local targObj = GameObj(objId)
			if(targObj == nil) or not(targObj:IsValid()) then
				this:SystemMessage("[F7CC0A]Invalid Set Target[-]")
				return
			end
			myTarg = targObj
		end
		local skillDictionary = {}
		for name,data in pairs(SkillData.AllSkills) do
			skillDictionary[name] = {
				SkillLevel = myVal
			}
		end
		SetSkillDictionary(myTarg, skillDictionary)
		myTarg:SystemMessage("All skills set to "..myVal, "event")
	end,

	CreateCoins = function(...)
		local arg = table.pack(...)

		if(#arg > 0) then
			local coinAmount = tonumber(arg[1])
			if (coinAmount == nil) then return end
			if(coinAmount <= 0 ) then return end			

			CreateStackInBackpack(this,"coin_purse",coinAmount)
		else
			ShowCreateCoins()
		end
	end,

	SetName = function(...)
		local arg = table.pack(...)
		if( #arg == 0 ) then
			Usage("setname")
			return
		end

		local name = ""
		for i = 1,#arg do name = name .. tostring(arg[i]) .. " " end
		nameToSet = name

		if( nameToSet ~= nil ) then
			this:RequestClientTargetGameObj(this, "setname")
		end
	end,

	Destroy = function(objId)
		if( objId ~= nil ) then
			local target = GameObj(tonumber(objId))
			DoDestroy(target)
		else
			this:RequestClientTargetGameObj(this, "destroyTarget")
		end
	end,

	KickUser = function(...)
		local arg = table.pack(...)
		if( #arg == 0 ) then Usage("kickuser") return end

		DoKick(arg)		
	end,

	LuaBanUser = function(...)
		local arg = table.pack(...)
		if( #arg == 0 ) then Usage("banuser") return end

		DoUserBan(arg)		
	end,

	LuaUnbanUser = function(userId)
		if(userId ~= nil and userId ~= "") then
			UnBanUser(userId)
		else
			Usage("unbanuser")	
		end
	end,

	LuaBanIP = function(...)
		local arg = table.pack(...)
		if( #arg == 0 ) then Usage("banip") return end

		DoIPBan(arg)		
	end,

	LuaUnbanIP = function(ip)
		if(ip ~= nil and ip ~= "") then
			UnBanIP(ip)
		else
			Usage("unbanip")	
		end
	end,

	LuaClearBans = function()
		ClearBans();
	end,

	LuaGetBans = function()
		GetBans("BanListResults");
	end,


	Broadcast = function(...)
		local line = CombineArgs(...)
		if(line ~= nil) then
			ServerBroadcast(line,true)
		else
			Usage("broadcast")
		end
	end,

	LocalBroadcast = function(...)
		local line = CombineArgs(...)
		if(line ~= nil) then
			local loggedOnUsers = FindPlayersInRegion()
			for index,object in pairs(loggedOnUsers) do
				object:SystemMessage(line,"event")
				object:SystemMessage(line)
			end
		else
			Usage("localbroadcast")
		end
	end,

	PushObject = function(id)
		if(id ~= nil) then
			local pushObj = GameObj(tonumber(id))
			StartPush(pushObj)
		end
		this:RequestClientTargetGameObj(this, "setpushtarget")
	end,

	TeleportPlayer = function(nameOrId)
		if( nameOrId ~= nil) then		
			local playerObj = GetPlayerByNameOrId(nameOrId)
			if( playerObj ~= nil ) then
				playerObj:SetWorldPosition(this:GetLoc())
				playerObj:PlayEffect("TeleportToEffect")
			end
		else
			Usage("teleportplayer")
		end
	end,

	OpenContainer = function(nameOrId,equipSlot)
		if( nameOrId ~= nil) then
			if( equipSlot == nil ) then equipSlot = "Backpack" end

			local objRef = GetPlayerByNameOrId(nameOrId)
			if( objRef ~= nil ) then
				if(equipSlot == "Self" or equipSlot == "self") then
					objRef:SendOpenContainer(this)
				elseif( objRef:IsPlayer() ) then
					local contObj = objRef:GetEquippedObject(equipSlot)
					if( contObj ~= nil and contObj:IsContainer() ) then
						contObj:SendOpenContainer(this)
					end
				elseif( objRef:IsContainer() ) then
					objRef:SendOpenContainer(this)
				end
			end
		else
			this:RequestClientTargetGameObj(this, "container")	
		end
	end,

	ContainerInfo = function (id,arg)
		if(id == "all") then
			local containerSizes = {}
			for i,containerObj in pairs(FindObjects(SearchSharedObjectProperty("Capacity",nil))) do
				local count = GetItemCountRecursive(containerObj)
				table.insert(containerSizes,{Obj=containerObj,Count = count})
			end

			table.sort(containerSizes,function(a,b)
					return a.Count > b.Count
				end)

			for i=1,50 do
				if(#containerSizes >= i) then
					local objRef = containerSizes[i].Obj
					this:SystemMessage("Container "..objRef:GetName().." ("..objRef.Id..") contains "..containerSizes[i].Count.." items.")
				end
			end
			this:SystemMessage("Total World Containers: "..#containerSizes)
		else
			local objRef = GameObj(tonumber(id))
			if(objRef ~= nil and objRef:IsValid()) then
				local count = GetItemCountRecursive(objRef)
				this:SystemMessage("Container "..objRef:GetName().." contains "..count.." items.")
			else
				this:SystemMessage("Container not found. Must pass id!")
			end
		end
	end,

	FindHouse = function(idOrUserId)
		if(idOrUserId == nil) then
			Usage("findhouse")
			return
		end

		local houseObj
		if(idOrUserId:match("[a-z0-9][a-z0-9]-[a-z0-9][a-z0-9][a-z0-9][a-z0-9]")) then
			houseObj = FindObject(SearchMulti{
											SearchObjVar("OwnerUserId",idOrUserId),
											SearchModule("house_control")})

			if(houseObj == nil) then
				this:SystemMessage("House not found for user id "..idOrUserId)
				return
			end
		else
			houseObj = FindObject(SearchMulti{
											SearchObjVar("Owner",GameObj(tonumber(idOrUserId))),
											SearchModule("house_control")})

			if(houseObj == nil) then
				this:SystemMessage("House not found for object id "..idOrUserId)
				return
			end
		end

		DoInfo(houseObj)
	end,

		HouseInfo = function (id)
		if(id == "all") then
			local houseItemCounts = {}
			local houseTotalCount = 0
			for i, houseControlObj in pairs(FindObjects(SearchModule("house_control"))) do
				local count = 0
				local housePlot = GetHouseControlPlot(houseControlObj)
				local houseWorldObjs = FindObjects(SearchRect(housePlot))
				for i, houseWorldObj in pairs(houseWorldObjs) do
					if(houseWorldObj:IsContainer()) then
						count = count + GetItemCountRecursive(houseWorldObj) + 1
					else
						count = count + 1
					end
				end

				table.insert(houseItemCounts,{Obj=houseControlObj,Count = count})
				houseTotalCount = houseTotalCount + count
			end

			table.sort(houseItemCounts,function(a,b)
					return a.Count > b.Count
				end)

			for i=1,50 do
				if(#houseItemCounts >= i) then
					local objRef = houseItemCounts[i].Obj
					this:SystemMessage("House "..objRef:GetName().." ("..objRef.Id..") contains "..houseItemCounts[i].Count.." items.")
					DebugMessage("House "..objRef:GetName().." ("..objRef.Id..") contains "..houseItemCounts[i].Count.." items.")
				end
			end
			this:SystemMessage("Total World Houses: "..#houseItemCounts.." Total Items: "..houseTotalCount)
			DebugMessage("Total World Houses: "..#houseItemCounts.." Total Items: "..houseTotalCount)
		else
			local objRef = GameObj(tonumber(id))
			if(objRef ~= nil and objRef:IsValid() and objRef:HasModule("house_control")) then
				local itemsFile = io.open("houseInfo.items","w")
				io.output(itemsFile)
				local count = 0
				local housePlot = GetHouseControlPlot(objRef)
				local houseWorldObjs = FindObjects(SearchRect(housePlot))
				for i, houseWorldObj in pairs(houseWorldObjs) do
					if not(houseWorldObj:HasObjVar("IsHouse") or houseWorldObj:HasObjVar("HouseObject")) then
						io.write(houseWorldObj:GetCreationTemplateId().."\n")
						count = count + 1
						if(houseWorldObj:IsContainer()) then						
							ForEachItemInContainerRecursive(houseWorldObj,function (contObj,depth)
								io.write(string.rep("\t",depth)..contObj:GetCreationTemplateId().." ")
								local stackCount = GetStackCount(contObj) or 1
								io.write(tostring(stackCount).."\n")
								count = count + 1
								return true
							end)
						end
					end
				end
				io.close()

				this:SystemMessage("House "..objRef:GetName().." contains "..count.." items.")
			else
				this:SystemMessage("House not found. Must pass id!")
			end
		end
	end,

	CreateFromFile = function(filename)
		DoCreateFromFile(filename)
	end,

	SetTime = function(newTime)
		local timeController = GetTimeController()
		if( timeController == nil ) then return end
		--DebugMessage("Time Controller is not nil")
		if( newTime == nil or not timeController:IsValid() ) then 
			DebugMessage("[SetTime] ERROR: NEW TIME IS NIL")
			return 
		end

		local colonLoc = newTime:find(":")
		if(colonLoc ~= nil ) then
			--DebugMessage("Sending time update message")
			local hours = newTime:sub(1,colonLoc-1)
			local minutes = newTime:sub(colonLoc+1,#newTime)
			timeController:SendMessage("SetTime",hours,minutes)
		end
	end,

	-- God Commands

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

	KickAll = function(...)
		local arg = table.pack(...)
		local reason = ""
		if( #arg >= 1 ) then
			-- DAB TODO: Only supports one word
			reason = arg[1]
		end

		local loggedOnUsers =  FindPlayersInRegion()
		for index,object in pairs(loggedOnUsers) do
			if not( IsImmortal(object) ) then
				this:SystemMessage(object:GetName().." kicked from server.")
				object:KickUser(reason)
			end
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

	CreateCustom = function()
		OpenCreateCustomWindow()
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

	SendMessage = function (targetId,messageName,...)
		--DFB TODO DOESN'T WORK
		local arg = table.pack(...)

		for i,j in pairs(arg) do
			if (tonumber(j) ~= nil) then
				arg[i] = tonumber(j)
			elseif (j:match("#")) then
				arg[i] = GameObj(tonumber(j:sub(2)))
			end
		end

		local gameObj = GameObj(tonumber(targetId))
		gameObj:SendMessage("StartQuest",table.unpack(arg))
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
			this:PlayEffectWithArgs(effectName,0.0,effectArgs)
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

	Nearby = function()
		local nearbyObjects = FindObjects(SearchObjectInRange(20))
		for i,nearbyObject in pairs(nearbyObjects) do
			this:SystemMessage(nearbyObject:GetCreationTemplateId() .. ": " .. nearbyObject.Id)
		end
	end,

	CustomCommand = function()
		ShowCustomCommandWindow()
	end,

	DeleteChar = function ()
        local createdAt = this:GetObjVar("CreationDate")
        if ( createdAt ) then
            local totalTime = DateTime.UtcNow - createdAt
            local overrideExists = (this:GetObjVar("AllowCharDelete") ~= nil)
            if ( totalTime.TotalDays < ServerSettings.NewPlayer.MinimumDeleteDays and overrideExists == false) then
                --this:SystemMessage("Your character must be at least "..ServerSettings.NewPlayer.MinimumDeleteDays.." days old before it can be deleted. This character has existed for "..TimeSpanToWords(totalTime)..".")
                --return
            end
        end
        TextFieldDialog.Show{
            TargetUser = this,
            Title = "Delete Character",
            Description = "[$2467]",
            ResponseFunc = function(user,newValue)
                if(newValue == "DELETE") then
                    -- remove from guild (function does nothing if not in a guild)
                    Guild.Remove(this)

                    local houseObj = GetUserHouse(this)
                    if(houseObj) then
                        houseObj:SendMessageGlobal("OnCharDelete",this)
                    end

                    local clusterController = GetClusterController()
                    clusterController:SendMessage("UserLogout", this, true);

                    this:DeleteCharacter()
                    
                else
                    this:SystemMessage("Delete character cancelled")
                end
            end
        }
    end,

	PlayTime = function()
		this:SystemMessage("You have played for a total of "..TimeSpanToWords(TimeSpan.FromMinutes(this:GetObjVar("PlayMinutes") or 1)))
	end,

	Karma = function()
		local karma = GetKarma(this) or 0
		local karmaLevel = GetKarmaLevel(karma)
		this:SystemMessage("Total of "..karma.." karma. Your Karma level is "..karmaLevel.Name..".")
	end,

	Follow = function ()
		if(isFollowing) then
			this:ClearPathTarget()
			isFollowing = false
		else
			this:SystemMessage("Select the group member you wish to follow.","info")
			this:RequestClientTargetGameObj(this,"follow")
		end
	end,

	BugReport = function()
		OpenBugReportDialog(this)
		--local dynWindow = DynamicWindow("BugReportWindow","BugReport",400,300)
		--dynWindow:AddLabel(30-13,30-18,"[$2468]",360,100,18)
		--dynWindow:AddButton( 7, 140, "OpenForumTopic", "Get key from the forum post", 400-26-7, 50,"","",false,"")
		--dynWindow:AddButton( 7, 190, "OpenBugSite", "Open GameLoop", 400-26-7, 50,"","",false,"")
		--this:OpenDynamicWindow(dynWindow,this)
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

	RelativePos = function()
		this:SystemMessage("[$2469]")
		this:RequestClientTargetAnyObj(this,"relpos1")
	end,

	ResetWindowPos = function ()
		this:SendClientMessage("ClearCachedPanelPositions")
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

	PatchGlobalGuildTagTable = function()
		local startTime = ServerTimeMs()
		local uniqueTags = 0
		local duplicate_tags = {}
		local duplicate_count = 0
		local results = GlobalVarListRecords("Guild.")

		for i = 1, #results do
			local guildID = results[i]
			if(guildID == "Guild.Tag") then
				DebugMessage("Skipping Guild.Tag GlobalVar, warning Global Guild Table already exists!")
			else
				local record = GlobalVarRead(guildID)

				if(record ~= nil) then
					local g = record.Data;
					--gw doesn't exist in the Guild.Tag table already
					if(Guild.IsTagUnique(g.Tag)) then
						uniqueTags = uniqueTags + 1
						Guild.AddTagToGlobalList(g.Tag, g.Id, nil)
					else
						duplicate_tags[g.Tag] = g.Id;
						duplicate_count = duplicate_count + 1
					end
				end
			end
		end

		DebugMessage("PatchGlobalGuildTagTable created: " .. uniqueTags .. " unique guild tags, found: ".. duplicate_count .. " duplicate tags and took:" .. (ServerTimeMs() - startTime) .. "ms")
		DebugMessage("Dumping duplicate_tags".. DumpTable(duplicate_tags))
	end,
}

RegisterEventHandler(EventType.DynamicWindowResponse,"BugReportWindow",function(user,buttonId)
		if (buttonId == "OpenBugSite") then
			this:SendClientMessage("OpenURL","https://gameloop.io/g/shards-online/")
		end
		if (buttonId == "OpenForumTopic") then
			this:SendClientMessage("OpenURL","[$2470]")
		end
	end)



RegisterCommand{ Command="help", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Help, Usage="<command_name>", Desc="[$2471]" }
RegisterCommand{ Command="title", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Title, Desc="Show title window" }
RegisterCommand{ Command="quest", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Quest, Desc="Show questing window" }
RegisterCommand{ Command="bugreport", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.BugReport, Desc="Send a bug report" }
RegisterCommand{ Command="say", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Say, Desc="Say something."}
RegisterCommand{ Command="roll", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Roll, Desc="Roll between 0.0 and 100.0"}
RegisterCommand{ Command="re", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Region, Desc="Say something to the entire region."}	
RegisterCommand{ Command="who", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Who, Desc="Lists players on the server" }
RegisterCommand{ Command="stats", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Stats, Desc="Prints out your stats" }
RegisterCommand{ Command="where", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Where, Desc="Prints location on the map" }
RegisterCommand{ Command="g", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.GuildMessage, Desc="Sends a guild message" }
RegisterCommand{ Command="r", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.ReplyTell, Desc="Reply's the the last person to direct message you." }
--RegisterCommand{ Command="allegiance", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.AllegianceMessage, Desc="[$2472]" }
RegisterCommand{ Command="guild", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.GuildMenu, Desc="Opens the guild menu" }
--RegisterCommand{ Command="invite", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.GroupInvite, Desc="Invite someone, by name, to your group." }

RegisterCommand{ Command="group", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.GroupMessage, Desc="Sends a group message", Aliases={"gr", "party", "p"} }
RegisterCommand{ Command="leavegroup", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.GroupLeave, Desc="Leaves your group." }
--RegisterCommand{ Command="groupinvite", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.GroupInvite, Desc="Invite someone, by name, to your group." }

RegisterCommand{ Command="time", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Time, Desc="Gets the current game time" }
RegisterCommand{ Command="clock", AccessLevel = AccessLevel.Immortal, Func=DefaultCommandFuncs.Clock, Desc="Opens a window that shows the time" }
RegisterCommand{ Command="hunger", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Hunger, Desc="Displays your current hunger status" }
RegisterCommand{ Command="autoharvest", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Autoharvesting, Desc="Toggles autoharvesting on and off." }
--RegisterCommand{ Command="wolfevent", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.TriggerWolfEvent, Desc="Triggers the wolf event" }
RegisterCommand{ Command="resetfaction", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.ResetFaction, Usage="<faction internal name>", Desc="Resets your faction for a given team" }
RegisterCommand{ Command="checkfaction", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.CheckFaction, Usage="<faction internal name>", Desc="Gets all your faction level for a given faction" }
RegisterCommand{ Command="changefaction", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.ChangeFaction, Usage="<faction internal name> <amount>", Desc="Changes your faction by the amount specified"}
RegisterCommand{ Command="custom", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.CustomCommand, Desc="[$2474]" }
RegisterCommand{ Command="deletechar", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.DeleteChar, Desc="Permanently deletes your player character.", Aliases={"delchar", "deletecharacter", "delcharacter"}}
RegisterCommand{ Command="playtime", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.PlayTime, Desc="Tells you your total ingame time.", Aliases={"timeplayed", "totaltime"}}
RegisterCommand{ Command="karma", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Karma, Desc="Give you details on your Karma."}
RegisterCommand{ Command="resethotbar", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Resethotbar, Usage="<command_name>", Desc="Resets your hotbars removing all items." }

RegisterCommand{ Command="pets", AccessLevel = AccessLevel.Mortal, Func=DefaultCommandFuncs.Pet, Usage="<command_name>", Desc="Opens your pet window." }
RegisterCommand{ Command="tell", AccessLevel = AccessLevel.Immortal, Func=DefaultCommandFuncs.Tell, Usage="<name|id>", Desc="Send a private message to another player." }
RegisterCommand{ Command="follow", AccessLevel = AccessLevel.Immortal, Func=DefaultCommandFuncs.Follow, Desc="Automatically follow a mob."}
RegisterCommand{ Command="cloak", Category = "God Power", AccessLevel = AccessLevel.Immortal, Func=DefaultCommandFuncs.Cloak, Usage="[<name|id>]", Desc="[$2476]" }
RegisterCommand{ Command="reveal", Category = "God Power", AccessLevel = AccessLevel.Immortal, Func=function() DoReveal(this) end, Desc="Reveal yourself in a cool cool way." }
RegisterCommand{ Command="jump", Category = "God Power", AccessLevel = AccessLevel.Immortal, Func=DefaultCommandFuncs.Jump, Desc="Get a cursor for a location to jump to" }
RegisterCommand{ Command="gotolocation", Category = "God Power", AccessLevel = AccessLevel.Immortal, Func=DefaultCommandFuncs.Goto, Usage="[<x>] [<y>] [<z>]", Desc="[$2477]", Aliases={"goto"}}
RegisterCommand{ Command="teleportto", Category = "God Power", AccessLevel = AccessLevel.Immortal, Func=DefaultCommandFuncs.TeleportTo, Usage="<name|id>", Desc="Teleport to a person by name or an object by id", Aliases={"tpto"}}
RegisterCommand{ Command="invuln", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.ToogleInvuln, Usage="[<target_id|self>]", Desc="Toggle invulnerability", Aliases={"inv"} }
RegisterCommand{ Command="create", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Create, Usage="[<template>]", Desc="[$2478]" }
RegisterCommand{ Command="createequippedobject", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.CreateEquippedObject, Usage="<template> [<targetid]", Desc="Created the object as an equipped object on the target." }
RegisterCommand{ Command="createprefab", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.CreatePrefab, Usage="<prefabname>", Desc="Create a prefab object of the specified name", Aliases={"createp"}}
RegisterCommand{ Command="createcamp", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.CreateCamp, Usage="<campname>", Desc="Create a camp prefab of the specified name", Aliases={"createc"}}
RegisterCommand{ Command="destroy", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Destroy, Usage="[<target_id>]", Desc="[$2479]" }
RegisterCommand{ Command="resurrect", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Resurrect, Desc="[$2480]", Aliases={"res"} }
RegisterCommand{ Command="resall", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.ResurrectAll, Usage="[force]", Desc="[$2481]" }
RegisterCommand{ Command="heal", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Heal, Desc="Completely heal an object. Gives cursor" }
RegisterCommand{ Command="slay", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Slay, Desc="Instantly kill any mobile. Gives cursor" }	
RegisterCommand{ Command="nuke", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Nuke, Usage="[<all|npc>] [<radius>]", Desc="Instantly kill all mobiles in a radius around you." }
RegisterCommand{ Command="freeze", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Freeze, Desc="Freeze/Unfreeze a mobile in place."}
RegisterCommand{ Command="createcoins", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.CreateCoins, Usage="<amount>", Desc="Create a bag of coins in your backpack" }
RegisterCommand{ Command="teleportplayer", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.TeleportPlayer, Usage="<name|id>", Desc="Teleport a player to your location", Aliases={"tp"}}	
RegisterCommand{ Command="portal", Category = "God Power", AccessLevel = AccessLevel.Immortal, Func=DefaultCommandFuncs.Portal, Usage="[<x>] [<y>] [<z>]", Desc="Open a two way portal to a location on the map" }
RegisterCommand{ Command="broadcast", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Broadcast, Usage="<message>", Desc="Send a message to every player on the server", Aliases={"bcast"}}	
RegisterCommand{ Command="localbroadcast", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.LocalBroadcast, Usage="<message>", Desc="Send a message to every player on this server region", Aliases={"localbcast"}}	
RegisterCommand{ Command="push", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.PushObject, Desc="[$2482]"}	

RegisterCommand{ Command="settime", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.SetTime, Usage="<newtime>", Desc="Sets the current game time (24 hour format)" }
RegisterCommand{ Command="whod", Category = "God Power", AccessLevel = AccessLevel.Immortal, Func=DefaultCommandFuncs.WhoDialog, Desc="List players on server in a dialog window" }		
RegisterCommand{ Command="addtitle", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.AddTitle, Usage="<name|id> <title>", Desc="Grant a title to a player" }
	
RegisterCommand{ Command="joinguild", Category = "God Power", AccessLevel = AccessLevel.Immortal, Func=DefaultCommandFuncs.JoinGuild, Usage="[<guild_id>]", Desc="[$2483]" }

RegisterCommand{ Command="teleportall", Category = "God Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.TeleportAll, Desc="[$2484]" }			

RegisterCommand{ Command="kickuser", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.KickUser, Usage="<name|id> [<reason>]", Desc="Kick the user off the shard" }
RegisterCommand{ Command="kickall", Category = "God Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.KickAll, Usage="[<reason>]", Desc="Kick every user off the shard" }
RegisterCommand{ Command="banuser", Category = "God Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.LuaBanUser, Usage="<userid> [<hours>]", Desc="Bans the user off the shard. Specify hours for temporary bans." }
RegisterCommand{ Command="unbanuser", Category = "God Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.LuaUnbanUser, Usage="<userid>", Desc="Unbans a user from the shard" }
RegisterCommand{ Command="banip", Category = "God Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.LuaBanIP, Usage="<ip address> [<hours>]", Desc="Bans an ip address from the shard, support * wildcards. Specify hours for temporary bans" }
RegisterCommand{ Command="unbanip", Category = "God Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.LuaUnbanIP, Usage="<ip address>", Desc="Unbans an ip address from the shard, must match exactly a previously banned ip address" }
RegisterCommand{ Command="clearbans", Category = "God Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.LuaClearBans, Desc="Clears all bans from the server." }
RegisterCommand{ Command="getbans", Category = "God Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.LuaGetBans, Desc="Returns a list of all active server bans, and their durations." }

	
RegisterCommand{ Command="info", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Info, Desc="Get information about an object. Gives cursor" }	
RegisterCommand{ Command="globalvar", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.GlobalVar, Usage = "<globalvarpath>", Desc="[$2485]" }	
RegisterCommand{ Command="deleteglobalvar", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.DeleteGlobalVar, Usage = "<globalvarpath>", Desc="Deletes any global variable that matches the path." }	
RegisterCommand{ Command="search", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.SearchDialog, Usage = "<name>", Desc="[$2486]" }		
RegisterCommand{ Command="debug", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Debug, Desc="Sets an object to debug. Gives cursor" }	
RegisterCommand{ Command="aistate", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.AIState, Desc="Gets the current state of an object. Gives cursor" }	
RegisterCommand{ Command="copyform", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.CopyForm, Usage="", Desc="[$2487]" }
RegisterCommand{ Command="possess", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Possess, Desc="Possess a target mobile." }
RegisterCommand{ Command="endpossess", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.EndPossess, Desc="Possess a target mobile." }
RegisterCommand{ Command="tame", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Tame, Desc="Tame a mobile." }
RegisterCommand{ Command="editchar", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.EditChar, "Opens a window that allows you to alter skill/stat values" }

RegisterCommand{ Command="setname", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.SetName, Usage="<name>", Desc="[$2488]" }
RegisterCommand{ Command="setbody", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Body, Usage="<template>", Desc="[$2489]" }
RegisterCommand{ Command="changeform", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.ChangeForm, Usage="<template>", Desc="[$2490]" }
RegisterCommand{ Command="setscale", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Scale, Usage="<scale_multiplier>", Desc="Set the scale of a mobile. Gives you a cursor" }
RegisterCommand{ Command="setcolor", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Color, Usage="<colorcode>", Desc="[$2491]" }	
RegisterCommand{ Command="sethue", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Hue, Usage="<hueindex>", Desc="Set an object's hue via color replacement from the client hue table." }	
RegisterCommand{ Command="setstat", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.SetStat, Usage="<hp|mana|sta|str|agi|int> <value> [<target_id>]", Desc="[$2492]" }
RegisterCommand{ Command="setskill", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.SetSkill, Usage="<skill_name> <value> [<target_id>]", "[$2494]" }
RegisterCommand{ Command="setallskills", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.SetAllSkills, Usage="<value> [<target_id>]", "Set all skills to a level." }

RegisterCommand{ Command="opencontainer", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.OpenContainer, Usage="<name|id> [<equipslot>]", Desc="[$2495]", Aliases={"opencont"}}	
RegisterCommand{ Command="containerinfo", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.ContainerInfo, Usage="<id> [detailed]", Desc="[$2496]"}	
RegisterCommand{ Command="findhouse", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.FindHouse, Usage="<char_id|user_id>", Desc="[$2497]"}	
RegisterCommand{ Command="houseinfo", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.HouseInfo, Usage="<id> [detailed]", Desc="[$2498]"}	
RegisterCommand{ Command="createfromfile", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.CreateFromFile, Usage="filenamee", Desc="[$2499]"}	
	
RegisterCommand{ Command="template", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Template, Usage="[$2500]", Desc="Sets your skills and stats to match the specified template and level" }
	
RegisterCommand{ Command="props", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.ShowProps, Usage="<target_id|self>", Desc="List all object properties on an object." }
RegisterCommand{ Command="setobjprop", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.SetObjProp, Usage="[$2501]", Desc="Set an object property (see TagDefinitions.xml) for the specified object. Can use 'self' in place of id. If no type specified, defaults to number or one word string." }

RegisterCommand{ Command="setfacing", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.SetFacing, Usage="<id> [<direction>]", Desc="[$2502]" }
RegisterCommand{ Command="playeffect", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.PlayEffect, Usage="<effect_name>", Desc="Play a particle effect at your location." }
RegisterCommand{ Command="playsound", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.PlaySound, Usage="<sound_name>", Desc="Play a sound at your location" }
RegisterCommand{ Command="playmusic", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.PlayMusic, Usage="<sound_name>", Desc="Play music (only yourself)" }
RegisterCommand{ Command="playanim", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.PlayAnim, Usage="[<target_id>] <anim_name>", Desc="Play an animation on your character" }	
RegisterCommand{ Command="nearby", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.Nearby, Desc="[$2503]" }

RegisterCommand{ Command="shutdown", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.Shutdown, Usage="<delay_seconds> [<reason>]", Desc="[$2504]" }	
RegisterCommand{ Command="restart", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.Restart, Usage="<delay_seconds> [<reason>]", Desc="[$2505]" }	

RegisterCommand{ Command="savehotbar", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.SaveHotbar, Usage="<filename>", Desc="[DEBUG COMMAND] Save hotbar to xml file." }
RegisterCommand{ Command="loadhotbar", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.LoadHotbar, Usage="<filename>", Desc="[DEBUG COMMAND] Load hotbar from xml file." }

RegisterCommand{ Command="setvisualstate", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.SetVisualState, Desc="[DEBUG COMMAND] Manually set the visual state of a permanent object. For development only!" }
RegisterCommand{ Command="luadebug", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.LuaDebug, Usage="<Off|Error|Warning|Information|Verbose>", Desc="[$2506]" }
RegisterCommand{ Command="luagc", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.LuaGC, Usage="<collect|count|memusage|mb|me|write>", Desc="Various lua memory debugging commands." }
RegisterCommand{ Command="toggleluaprofile", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.ToggleLuaProfile, Desc="[DEBUG COMMAND] Toggles lua profiling on and off" }
RegisterCommand{ Command="backup", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.Backup, Desc="[DEBUG COMMAND] Force a backup to take place." } 
RegisterCommand{ Command="resetworld", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.ResetWorld, Desc="[$2508]" } 
RegisterCommand{ Command="destroyall", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.DestroyAll, Desc="[$2509]" } 
RegisterCommand{ Command="updaterange", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.UpdateRange, Usage="<range>", Desc="[$2510]" } 
RegisterCommand{ Command="reloadbehavior", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.ReloadBehavior, Usage="<behavior>", Desc="[DEBUG COMMAND] Reload the behavior in memory.", Aliases={"reload"}}
RegisterCommand{ Command="reloadtemplates", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.ReloadTemplates, Desc="[DEBUG COMMAND] Reload all templates in memory." }
RegisterCommand{ Command="log", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.Log, Usage="<log string>", Desc="[DEBUG COMMAND] Write a line to the lua log" }
RegisterCommand{ Command="createcustom", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DefaultCommandFuncs.CreateCustom, Desc="[DEBUG COMMAND] Create a custom object by it's art asset ID (Note: this should not be use to create game items since the game relies on the template name)" }
RegisterCommand{ Command="ispassable", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.IsPassable, Desc="[$2511]"}
RegisterCommand{ Command="hastimer", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.HasTimer, Usage="<target_id> <timer_name>", Desc="[$2512]" }	
RegisterCommand{ Command="transferall", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.TransferAll, Usage="<transferregion>", Desc="[$2513]"}
RegisterCommand{ Command="dostring", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.DoString, Usage="<lua code>", Desc="[$2514]"}
RegisterCommand{ Command="relativepos", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.RelativePos, Desc="[$2515]"}
RegisterCommand{ Command="frametime", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.FrameTime, Desc="Opens a window that shows the average frame time" }
RegisterCommand{ Command="resetwindowpos", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.ResetWindowPos, Desc="Resets the saved window positions on the client. For dynamic window debugging." }
RegisterCommand{ Command="debugframetime", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.DebugFrameTime, Usage="<begin,end>", Desc="Record average frame time statistics. end writes report to a file" }
RegisterCommand{ Command="listmobs", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.ListMobs, Desc="List all mobs on the server region." }
RegisterCommand{ Command="createallitems", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.CreateAllItems, Usage="<unique>", Desc="Create every carryable item inside containers. If passed 'unique' then only one of each client id is created" }
RegisterCommand{ Command="setspeed", AccessLevel = AccessLevel.God, Func=function(speed) SetMobileMod(this, "MoveSpeedPlus", "GodCommand", tonumber(speed))  end, Desc="Add the number given to your movement speed. If no speed is provided, it will remove the modifer." }
RegisterCommand{ Command="makebook", AccessLevel = AccessLevel.God, Func=function(a,b) PrestigeCommandMakeBook(this,a,b) end, Desc="Make a prestige book.", Usage="<PrestigeAbility> <AbilityLevel>" }
RegisterCommand{ Command="prestige", AccessLevel = AccessLevel.God, Func=function(a,b,c,d) PrestigeAbilityWindow(this,a,b,c,d) end, Desc="Handy dandy prestige window." }
RegisterCommand{ Command="patchglobalguildtagtable", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.PatchGlobalGuildTagTable, Desc="Run once to create globalvar guild tag table" }
RegisterCommand{ Command="reloadglobals", AccessLevel = AccessLevel.God, Func=function()ChangeWorld(true) end, Desc="Reload current server instance, only works on Standalone servers." }
RegisterCommand{ Command="forcedisconnect", AccessLevel = AccessLevel.God, Func=function(objectId)ForceDisconnect(objectId) end, Desc="Forces a player character to be immediately disconnected and logged out of the server, not waiting for a character save." }
RegisterCommand{ Command="learnrecipes", AccessLevel = AccessLevel.God, Func=function(user)LearnAllRecipes(this) end, Desc="Learn all crafting recipes." }


RegisterEventHandler(EventType.ClientTargetGameObjResponse, "container",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SendOpenContainer(user)
	end)

RegisterEventHandler(EventType.Message,"DeleteCharacter",function ( ... )
	DefaultCommandFuncs.DeleteChar(...)
end)

--[[

RegisterEventHandler(EventType.ClientUserCommand,"take",
	function(targetId)
		if (not IsImmortal(this)) then return end
		local targetObj = GameObj(tonumber(targetId))
		if(targetObj:ContainedBy() ~= nil) then
			targetObj:SetWorldPosition(this:GetLoc())
		else
			local backpackObj = this:GetEquippedObject("Backpack")
			local randomLoc = GetRandomDropPosition(backpackObj)
			targetObj:MoveToContainer(backpackObj,randomLoc)
		end
	end)

RegisterEventHandler(EventType.ClientUserCommand,"hideperm",
	function(targetId,show)
		local targetObj = PermanentObj(tonumber(targetId))
		if(show) then
			targetObj:SetVisualState("Default")
		else
			targetObj:SetVisualState("Hidden")
		end
	end)

RegisterEventHandler(EventType.ClientUserCommand,"perminfo",
	function(targetId,show)
		local targetObj = PermanentObj(tonumber(targetId))
		this:SystemMessage("Perm "..targetId.." - Loc: "..tostring(targetObj:GetLoc()))
	end)

RegisterEventHandler(EventType.ClientUserCommand,"gotoperm",
	function(targetId,show)
		if (not IsImmortal(this)) then return end
		local targetObj = PermanentObj(tonumber(targetId))
		this:SetWorldPosition(targetObj:GetLoc())
	end)--]]

userTeam = nil
RegisterEventHandler(EventType.ClientTargetGameObjResponse,"team",
	function (target,user)
		if(target ~= nil) then
			local nameColor = COLORS[userTeam]
			target:SetObjVar("NameColorOverride",nameColor)
			target:SendMessage("UpdateName")
			target:SystemMessage("You have joined the "..userTeam.." team.")
		end
	end)

-- CUSTOM TWOTOWERS Code
RegisterEventHandler(EventType.ClientUserCommand,"team",
	function (team)
		--DebugMessage("team",tostring(team))
		if not(team or team == "") then
			teamColorStr = ""
			for colorName,color in pairs(COLORS) do 
				teamColorStr = teamColorStr .. colorName .. ","
			end
			teamColorStr = StripTrailingComma(teamColorStr)
			this:SystemMessage("Team Colors: "..teamColorStr)
			return
		end

		userTeam = team
		this:RequestClientTargetGameObj(this, "team")
	end)