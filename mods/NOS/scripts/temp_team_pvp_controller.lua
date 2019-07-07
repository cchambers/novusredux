
gameStarted = false
teamYellow = { ["kills"] = 0 }
teamGreen = { ["kills"] = 0 }

HUEGREEN = "FF00FF00"
HUEYELLOW = "FFFFFF00"

function OnSpeech(speaker,speech)
	local words = BuildArray(speech:gmatch("%S+"))
	if(#words == 2 and words[1]:lower() == "MobileTeamType") then
		if( words[2]:lower() == "yellow") then
			teamYellow[speaker] = true
			teamGreen[speaker] = nil
			speaker:SetColor(HUEYELLOW)
			speaker:SetObjVar("MobileTeamType","Yellow")
			this:NpcSpeech(speaker:GetName().." is now on team yellow.")
		elseif( words[2]:lower() == "green") then
			teamGreen[speaker] = true
			teamYellow[speaker] = nil
			speaker:SetColor(HUEGREEN)
			speaker:SetObjVar("MobileTeamType","Green")
			this:NpcSpeech(speaker:GetName().." is now on team green.")
		end
		speaker:SetObjVar("pvpController",this)
		speaker:AddModule("temp_team_pvp_player")
	elseif( words[1]:lower() == "reset" ) then
		this:NpcSpeech("Resetting score")
		teamGreen.kills = 0
		teamYellow.kills = 0
	end
end

function HandlePlayerDeath(player)
	if( teamGreen[player] ~= nil ) then
		teamYellow.kills = teamYellow.kills + 1
		this:NpcSpeech("Yellow team scores!")
	elseif( teamYellow[player] ~= nil ) then
		teamGreen.kills = teamYellow.kills + 1
		this:NpcSpeech("Green team scores!")
	end
end

function HandleScoreTimer()
	this:NpcSpeech("Yellow Kills: "..teamYellow.kills)
	this:NpcSpeech("Green Kills: "..teamGreen.kills)

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "Score")
end

this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "Score")

RegisterEventHandler(EventType.PlayerSpeech,"",OnSpeech)
RegisterEventHandler(EventType.Message, "PlayerDied", HandlePlayerDeath)
RegisterEventHandler(EventType.Timer, "Score", HandleScoreTimer)