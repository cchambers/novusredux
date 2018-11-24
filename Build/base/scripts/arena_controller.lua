
RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function ()
        SetTooltipEntry(this,"arena_controller", "Manage Teams")
        AddUseCase(this,"Manage",true,IsImmortal)
    end)

function GetArenaPlayers()
	local teamData = this:GetObjVar("teams")
	local players = {}
	for i,teamInfo in pairs(teamData) do
		for member in pairs(teamInfo.Members) do			
			if(member:IsValid()) then
				table.insert(players,member)
			end
		end
	end

	return players
end

function GetPlayersNearArena()
	local searcher = SearchPlayerInRange(30,true)
    return FindObjects(searcher)
end

function ShowControlPanel(user)
	if(IsDemiGod(user)) then
		local dynWindow = DynamicWindow("ArenaControl","Arena Control",300,500)
		local curY = 10
		local teamData = this:GetObjVar("teams")
		if(teamData ~= nil) then
			for teamIndex,teamInfo in pairs(teamData) do
				dynWindow:AddLabel(20,curY,teamColors[teamIndex].."Team: "..teamInfo.Name.."[-]",0,0,18,"left",false,false)				
				dynWindow:AddButton(240,curY,"AddMember|"..teamIndex,"",0,0,"","",false,"Plus")
				curY = curY + 25

				for member in pairs(teamInfo.Members) do
					if(member:IsValid()) then						
						dynWindow:AddLabel(40,curY,member:GetName() .. " (" .. member.Id .. ")",0,0,18,"left",false,true)
					else
						dynWindow:AddLabel(40,curY,"[Offline]",0,0,18,"left",false,true)
					end
					
					dynWindow:AddButton(240,curY,"RemoveMember|"..tostring(member.Id),"",18,18,"","",false,"Minus")
					curY = curY + 25
				end				
			end			
		end

		if(teamData == nil or #teamData < 3) then
			dynWindow:AddButton(20,curY+10,"AddTeam","Add Team",0,0,"","",false,"")
		end
		dynWindow:AddButton(20,400,"Reset","Reset",240,0,"","",false,"")

		user:OpenDynamicWindow(dynWindow,this)
	end
end

local arenaCommandHandlers = {
	suddendeath = function(user,stage)		
		local arenaPlayers = GetArenaPlayers()
		if(#arenaPlayers == 0) then
			user:SystemMessage("No arena players found. Sudden death cancelled")
			return
		end

		local allPlayers = GetPlayersNearArena()
		if(stage == nil or stage == "begin") then
			for i,player in pairs(allPlayers) do
				player:SystemMessage("[$1608]","event")
			end

			for i,arenaPlayer in pairs(arenaPlayers) do
				SetMobileMod(arenaPlayer, "HealingReceivedPlus", "ArenaSuddenDeath", -1000)
				AddBuffIcon(arenaPlayer,"ArenaSuddenDeath","Arena Sudden Death","drivingstrike","Healing disabled!",true)
				arenaPlayer:SystemMessage("[$1609]","event")
			end
		elseif(stage == "second") then
			for i,player in pairs(allPlayers) do
				player:SystemMessage("[$1610]","event")
			end
			for i,arenaPlayer in pairs(arenaPlayers) do
				SetMobileMod(arenaPlayer, "HealthRegenPlus", "ArenaSuddenDeath", -1000)
				AddBuffIcon(arenaPlayer,"ArenaSuddenDeath2","Second Arena Sudden Death","drivingstrike","Health regen disabled!",true)
				arenaPlayer:SystemMessage("You feel you are no longer regenerating health!","event")
			end
		end

		this:SetObjVar("SuddenDeathPlayers",arenaPlayers)
	end,

	suddendeathend = function(user,...)
		local suddenDeathPlayers = this:GetObjVar("SuddenDeathPlayers")
		for i,suddenDeathPlayer in pairs(suddenDeathPlayers) do
			if(suddenDeathPlayer:IsValid()) then
				SetMobileMod(arenaPlayer, "HealingReceivedPlus", "ArenaSuddenDeath", nil)
				SetMobileMod(arenaPlayer, "HealthRegenPlus", "ArenaSuddenDeath", nil)
				RemoveBuffIcon(suddenDeathPlayer,"ArenaSuddenDeath")
				RemoveBuffIcon(suddenDeathPlayer,"ArenaSuddenDeath2")
				suddenDeathPlayer:SystemMessage("[$1611]","event")
			end
		end
		this:DelObjVar("SuddenDeathPlayers")

		user:SystemMessage("Sudden death stat mods cleared.")
	end,

	bcast = function(user,...)
		--DebugMessage("bcast command execute")
		local line = CombineArgs(...)
		if(line ~= nil) then
			local allPlayers = GetPlayersNearArena()
			--DebugMessage("Found "..#allPlayers.." players")
			for i,player in pairs(allPlayers) do
				player:SystemMessage(line,"event")
			end
		end
	end,

	control = function(user)
		ShowControlPanel(user)
	end,
}

RegisterEventHandler(EventType.ClientObjectCommand,"arena",
	function (user,commandName,...)		
		--DebugMessage("arena command processing",user,commandName,(commandArgs ~= nil and DumpTable(commandArgs)) or "[No args]")

		if(commandName ~= nil and arenaCommandHandlers[commandName] ~= nil) then			
			--DebugMessage("command found")
			arenaCommandHandlers[commandName](user,...)
		end
	end)

teamColors = 
{
	"[F04646]",
	"[4646F0]",
	"[46F046]",
}

RegisterEventHandler(EventType.Timer,"UpdateStatusUI",
	function()
		local teamData = this:GetObjVar("teams")
		local players = GetPlayersNearArena()
		if(teamData == nil) then
			for i,player in pairs(players) do
				player:CloseDynamicWindow("ArenaStatus")
			end
		else
			local dynWindow = DynamicWindow("ArenaStatus","",200,180,-420,20,"Transparent","TopRight")
			local curY = 0
			
			for teamIndex,teamInfo in pairs(teamData) do 
				dynWindow:AddLabel(180,curY,teamColors[teamIndex].."Team: "..teamInfo.Name.."[-]",0,0,26,"right",false,true)
				curY = curY + 33
				for teamMember in pairs(teamInfo.Members) do 
					if(teamMember:IsValid()) then
						if(IsDead(teamMember)) then
							dynWindow:AddLabel(180,curY,teamMember:GetName() .. " ([FF0000]DEAD[-])",0,0,20,"right",false,true)
						else
							local healthPct = math.floor(GetCurHealth(teamMember) / GetMaxHealth(teamMember) * 100)
							dynWindow:AddLabel(180,curY,teamMember:GetName() .. " (" .. healthPct .. "%)",0,0,18,"right",false,true)
						end
					else
						dynWindow:AddLabel(180,curY,"[Offline]",0,0,18,"right",false,true)
					end
					curY = curY + 27
				end				
				teamIndex = teamIndex + 1
			end

			for i,player in pairs(players) do
				player:OpenDynamicWindow(dynWindow)
			end

			this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"UpdateStatusUI")
		end
	end)

RegisterEventHandler(EventType.Message,"UseObject",
	function (user,usedType)
		ShowControlPanel(user)
	end)

RegisterEventHandler(EventType.DynamicWindowResponse,"ArenaControl",
	function (user,buttonId)
		if(buttonId == "AddTeam") then
			TextFieldDialog.Show{
		        TargetUser = user,
		        ResponseObj = this,
		        Title = "Add Team",
		        Description = "",
		        ResponseFunc = function(user,newName)
		        	if(newName ~= nil and newName ~= "") then
			        	local teamData = this:GetObjVar("teams") or {}
						table.insert(teamData,{Name=newName,Members={}})
						this:SetObjVar("teams",teamData)
						user:SystemMessage("Teams added.")
						this:FireTimer("UpdateStatusUI")
			        	ShowControlPanel(user)
			        end
		        end
		    }
		elseif(buttonId:match("AddMember")) then
			local id, teamIndex = string.match(buttonId, "(%a+)|(%d+)")
			teamIndex = tonumber(teamIndex)
			user:RequestClientTargetGameObj(this, "addMember")
			RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse,"addMember",
				function (target,user)
					local teamData = this:GetObjVar("teams") or {}
					if(teamData[teamIndex] ~= nil) then
						if(target == nil or not(target:IsValid())) then
							user:SystemMessage("Member not found.")
						else
							user:SystemMessage("Member added.")
							teamData[teamIndex].Members[target] = true
							this:SetObjVar("teams",teamData)
						end
					end
					this:FireTimer("UpdateStatusUI")
					ShowControlPanel(user)
				end)
		elseif(buttonId:match("RemoveMember")) then
			local id, memberId = string.match(buttonId, "(%a+)|(%d+)")
			local member = GameObj(tonumber(memberId))
			local teamData = this:GetObjVar("teams") or {}
			for i,teamInfo in pairs(teamData) do 
				teamInfo.Members[member] = nil
			end
			this:SetObjVar("teams",teamData)
			this:FireTimer("UpdateStatusUI")
			ShowControlPanel(user)
		elseif(buttonId == "Reset") then
			ClientDialog.Show{
			    TargetUser = user,
			    TitleStr = "Confirm Reset",
			    DescStr = "Are you sure you wish to reset teams?",
			    Button1Str = "Confirm",
			    Button2Str = "Cancel",
			    ResponseObj = this,
			    ResponseFunc = function (user,buttonId)
						this:DelObjVar("teams")
						user:SystemMessage("Teams cleared.")
						this:FireTimer("UpdateStatusUI")
						ShowControlPanel(user)
					end,
			}
		end
	end)

AddView("arenaView", SearchPlayerInRange(30,true),1.0)
RegisterEventHandler(EventType.LeaveView,"arenaView",
	function (target)
		local teamData = this:GetObjVar("teams")
		-- only send this if we actually have team information
		if(teamData ~= nil) then
			target:CloseDynamicWindow("ArenaStatus")
		end
	end)