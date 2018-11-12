-- DISABLED!
do return end

require 'base_ai_state_machine'

DefaultSettings = {
	MatchTypes = {
		Deathmatch = { State = "Deathmatch", MinPlayers = 2, Duration = TimeSpan.FromMinutes(5) },
		--["Last Man Standing"] = { State="LastManStanding", MinPlayers = 3, Duration = TimeSpan.FromMinutes(5) }
	},
	PreGameDuration = TimeSpan.FromSeconds(5)
}


allPlayers = {}
CurMatchType = ""

function GetSettings()
	return this:GetObjVar("Settings")
end

function GetMatchSettings(matchType)
	matchType = matchType or CurMatchType
	return this:GetObjVar("Settings").MatchTypes[matchType]
end

function GetNextMatchType()
	allTypes = {}
	for matchName,info in pairs(GetSettings().MatchTypes) do
		table.insert(allTypes,matchName)
	end

	-- should we cycle
	return allTypes[math.random(#allTypes)]
end

function ChangeState(newState,isInit)
	this:SetObjVar("CurState",newState)
	if(isInit) then
		AI.StateMachine.Init(newState)
	else
		if(AI.StateMachine.CurState == newState) then
			AI.StateMachine.ChangeSubState("PreGame")
		else
			AI.StateMachine.ChangeState(newState)
		end
	end
end

function ChangeSubState(newSubState)
	this:SetObjVar("CurSubState",newSubState)
	AI.StateMachine.ChangeSubState(newSubState)
end

function AddPlayer(playerObj)
	if(allPlayers[playerObj]) then
		-- shouldnt happen
		DebugMessage("Player already in system "..tostring(playerObj))
	end

	allPlayers[playerObj] = { EnterTime=DateTime.UtcNow, IsBot=not(playerObj:IsPlayer()) }
	-- for viewing purposes
	this:SetObjVar("AllPlayers",allPlayers)

	if(not(playerObj:HasModule("twotowers_player"))) then
		playerObj:AddModule("twotowers_player")
	end
	
	local curState = AI.StateMachine.GetCurSubStateTable()
	if(curState and curState.OnPlayerEnter) then
		curState:OnPlayerEnter(playerObj)
	end
end

function RemovePlayer(playerObj)
	allPlayers[playerObj] = nil 
	this:SetObjVar("AllPlayers",allPlayers)

	local curState = AI.StateMachine.GetCurSubStateTable()
	if(curState and curState.OnPlayerExit) then
		curState:OnPlayerExit(playerObj)
	end
end

function ForEachPlayer(func,excludeBots)
	for playerObj,info in pairs(allPlayers) do		
		if(playerObj:IsValid() and (not(excludeBots) or not(info.IsBot))) then
			func(playerObj,info)
		end
	end
end

function BroadcastSystemMessage(message)
	ForEachPlayer(function (playerObj)
			playerObj:SystemMessage(message,"event")
			playerObj:SystemMessage(message)
		end,true)
end

function BroadcastMessage(message,...)
	-- cant pass ... through to an inline function
	for playerObj,info in pairs(allPlayers) do
		DebugMessage("SendMessage "..playerObj.Id.." - "..message)
		playerObj:SendMessage(message,...)
	end
end

function StartNextMatch(isInit,gameType)
	local matchSettings = nil
	if(gameType) then
		CurMatchType = gameType
		matchSettings = GetMatchSettings(gameType)
	end

	if not(matchSettings) then
		CurMatchType = GetNextMatchType()
		matchSettings = GetMatchSettings()
	end

	ChangeState(matchSettings.State,isInit)
end

function UpdatePregameWindow(startString)
	local windowWidth = 500
	local windowHeight = 60

	local pregameWindow = DynamicWindow(
		"PreGameWindow", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
		"", --(string) Title of the window for the client UI
		windowWidth, --(number) Width of the window
		windowHeight, --(number) Height of the window
		0, --(number) Starting X position of the window (chosen by client if not specified)
		20, --(number) Starting Y position of the window (chosen by client if not specified)
		"Transparent", --(string) Window type (optional)
		"Top"--windowAnchor --(string) Window anchor (default "TopLeft")
	)

	pregameWindow:AddImage(
		-windowWidth/2, --(number) x position in pixels on the window
		0, --(number) y position in pixels on the window
		"Category2SelectionBoxDefault", --(string) sprite name
		windowWidth, --(number) width of the image
		windowHeight, --(number) height of the image
		"Sliced" --(string) sprite type Simple, Sliced or Object (defaults to Simple)
		--spriteHue, --(string) sprite hue (defaults to white)
		--opacity --(number) (default 1.0)
	)

	pregameWindow:AddLabel(
		0, --(number) x position in pixels on the window
		5, --(number) y position in pixels on the window
		"Next Game Type: "..CurMatchType.."\n"..startString, --(string) text in the label
		0, --(number) width of the text for wrapping purposes (defaults to width of text)
		0, --(number) height of the label (defaults to unlimited, text is not clipped)
		0, --(number) font size (default specific to client)
		"center" --(string) alignment "left", "center", or "right" (default "left")
		--scrollable, --(boolean) scrollable (default false)
		--outline, --(boolean) outline (defaults to false)
		--font --(string) name of font on client (optional)
	)

	ForEachPlayer(function(playerObj) playerObj:OpenDynamicWindow(pregameWindow) end,true)			
end

AI.StateMachine.AllStates = {	
	Deathmatch = {
		InitialSubState = "PreGame",

		OnEnterState = function (self)
			DebugMessage("Deathmatch Start")

			RegisterStateEventHandler(EventType.Message,"ToggleScoreWindow",self.OnToggleScoreWindow)
		end,

		OnExitState = function (self)
			self.CurSubState = nil			
		end,

		OnToggleScoreWindow = function (self,player)
			if(allPlayers[player].ScoreWindowOpen) then
				player:CloseDynamicWindow("ScoreWindow")
				allPlayers[player].ScoreWindowOpen = nil
			else
				local dynWindow = DynamicWindow("ScoreWindow","Deathmatch",1000,700,-500,-350,"","Center")
				dynWindow:AddLabel(10,10,"Players "..tostring(CountTable(allPlayers)),0,0,16)
				player:OpenDynamicWindow(dynWindow)
				allPlayers[player].ScoreWindowOpen = true
			end
		end,

		ResetStats = function(self,player)
			allPlayers[player].DeathmatchStats = { Kills = 0, Deaths = 0 }
		end,

		SubStates = {
			PreGame = {
				GetPulseFrequencyMS = function() return 1000 end,

				OnEnterState = function (self)
					DebugMessage("Deathmatch PreGame OnEnterState")
					BroadcastMessage("twotowers_spectator")			
					
					ScheduleSubStateEventTimer(GetSettings().PreGameDuration,"PreGameTimer",self.OnPreGameTimer)					
				end,

				OnExitState = function (self)
					DebugMessage("Deathmatch PreGame OnExitState")

					this:RemoveTimer("PreGameTimer")
					UnregisterEventHandler("twotowers_controller",EventType.Timer,"PreGameTimer")
				end,

				AiPulse = function (self)
					DebugMessage("Deathmatch PreGame AiPulse")

					local activePlayers = CountTable(allPlayers)
					local startString = ""
					if this:HasTimer("PreGameTimer") then
						startString = "Match starts in "..math.ceil(this:GetTimerDelay("PreGameTimer").TotalSeconds).." seconds."
					else
						startString = "Waiting for more players ("..activePlayers.."/"..GetMatchSettings().MinPlayers..")"
					end
					UpdatePregameWindow(startString)
				end,

				OnPreGameTimer = function(self)
					DebugMessage("Deathmatch PreGame OnPreGameTimer")

					self:TryStartMatch()			
				end,				

				OnPlayerEnter = function(self,player)
					DebugMessage("Deathmatch PreGame OnPlayerEnter")

					player:SendMessage("twotowers_spectator")
					self:TryStartMatch()
				end,

				TryStartMatch = function(self)
					DebugMessage("Deathmatch PreGame TryStartMatch")

					local settings = GetMatchSettings()
					if not(this:HasTimer("PreGameTimer")) and CountTable(allPlayers) >= settings.MinPlayers then
						ForEachPlayer(function(playerObj) playerObj:CloseDynamicWindow("PreGameWindow") end,true)

						ChangeSubState("Game")
					end
				end,
			},

			Game = {
				OnEnterState = function(self)
					DebugMessage("Deathmatch Game Start")
					BroadcastSystemMessage("Deathmatch Start")

					BroadcastMessage("twotowers_player")

					local deathmatchState = AI.StateMachine.GetCurStateTable()
					ForEachPlayer(function (playerObj)
						deathmatchState:ResetStats(playerObj)
					end)		

					local settings = GetMatchSettings()
					ScheduleSubStateEventTimer(settings.Duration,"MatchTimer",self.OnMatchTimer)					
					RegisterSubStateEventHandler(EventType.Message,"PlayerKilled",self.OnPlayerKilled)					
				end,

				OnExitState = function (self)
					DebugMessage("Deathmatch Game OnExitState")

					this:RemoveTimer("MatchTimer")
					UnregisterEventHandler("twotowers_controller",EventType.Timer,"MatchTimer")
				end,

				OnPlayerEnter = function(self,player)
					DebugMessage("Deathmatch Game OnPlayerEnter")

					player:SendMessage("twotowers_player")
					AI.StateMachine.GetStateTable():ResetStats(player)
				end,

				OnMatchTimer = function(self)
					DebugMessage("Deathmatch Game OnMatchTimer")

					ForEachPlayer(function (playerObj)
						playerObj:CloseDynamicWindow("ScoreWindow")
					end)	

					StartNextMatch(false)
				end,

				OnPlayerKilled = function (self,victim,killer)
					BroadcastSystemMessage(killer:GetName().." has vanquished "..victim:GetName() .. "!")
					allPlayers[victim].DeathmatchStats.Deaths = allPlayers[victim].DeathmatchStats.Deaths + 1
					allPlayers[killer].DeathmatchStats.Kills = allPlayers[killer].DeathmatchStats.Kills + 1
				end,				
			}
		}
	},

	LastManStanding = {
		InitialSubState = "PreGame",

		OnEnterState = function (self)
			DebugMessage("LastManStanding Start")
		end,

		OnExitState = function (self)
			self.CurSubState = nil
		end,

		SubStates = {
			PreGame = {
				GetPulseFrequencyMS = function() return 1000 end,

				OnEnterState = function (self)
					DebugMessage("LastManStanding PreGame OnEnterState")
					BroadcastMessage("twotowers_spectator")			
					
					ScheduleSubStateEventTimer(GetSettings().PreGameDuration,"PreGameTimer",self.OnPreGameTimer)					
				end,

				OnExitState = function (self)
					DebugMessage("LastManStanding PreGame OnExitState")

					this:RemoveTimer("PreGameTimer")
					UnregisterEventHandler("twotowers_controller",EventType.Timer,"PreGameTimer")
				end,

				AiPulse = function (self)
					DebugMessage("LastManStanding PreGame AiPulse")

					local activePlayers = CountTable(allPlayers)
					local startString = ""
					if this:HasTimer("PreGameTimer") then
						startString = "Match starts in "..math.ceil(this:GetTimerDelay("PreGameTimer").TotalSeconds).." seconds."
					else
						startString = "Waiting for more players ("..activePlayers.."/"..GetMatchSettings().MinPlayers..")"
					end
					UpdatePregameWindow(startString)
				end,

				OnPreGameTimer = function(self)
					DebugMessage("LastManStanding PreGame OnPreGameTimer")

					self:TryStartMatch()			
				end,				

				OnPlayerEnter = function(self,player)
					DebugMessage("LastManStanding PreGame OnPlayerEnter")

					player:SendMessage("twotowers_spectator")
					self:TryStartMatch()
				end,

				TryStartMatch = function(self)
					DebugMessage("LastManStanding PreGame TryStartMatch")
					
					local settings = GetMatchSettings()
					if not(this:HasTimer("PreGameTimer")) and CountTable(allPlayers) >= settings.MinPlayers then
						ForEachPlayer(function(playerObj) playerObj:CloseDynamicWindow("PreGameWindow") end,true)

						ChangeSubState("Game")
					end
				end,
			},

			Game = {
				OnEnterState = function(self)
					DebugMessage("LastManStanding Game Start")
					BroadcastSystemMessage("LastManStanding Start")

					BroadcastMessage("twotowers_player")

					local settings = GetMatchSettings()
					ScheduleSubStateEventTimer(settings.Duration,"MatchTimer",self.OnMatchTimer)					
				end,

				OnExitState = function (self)
					DebugMessage("LastManStanding Game OnExitState")

					this:RemoveTimer("MatchTimer")
					UnregisterEventHandler("twotowers_controller",EventType.Timer,"MatchTimer")
				end,

				OnMatchTimer = function(self)
					DebugMessage("LastManStanding Game OnMatchTimer")
					StartNextMatch(false)
				end,
			}
		}
	}
}	

RegisterEventHandler(EventType.EnterView,"onlinePlayers",
	function(playerObj)
		DebugMessage("onlinePlayers EnterView "..tostring(playerObj.Id))
		AddPlayer(playerObj)
	end)

RegisterEventHandler(EventType.LeaveView,"onlinePlayers",
	function(playerObj)
		DebugMessage("onlinePlayers LeaveView "..tostring(playerObj.Id))
		RemovePlayer(playerObj)
	end)

RegisterEventHandler(EventType.Message,"StartMatch",
	function (gameType)
		StartNextMatch(false,gameType)
	end)

if(not(this:HasObjVar("Settings"))) then
	this:SetObjVar("Settings",DefaultSettings)
end

AddView("onlinePlayers", SearchMultiInclusive{SearchUser(),SearchModule("twotowers_bot")}, 1.0)

StartNextMatch(true)
