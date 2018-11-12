Emotes = {	
	sword_in_ground = "sword_in_ground",
	wave = "wave",
	point = "point",
	stretch = "stretch",
	angry = "angry",
	bashful = "bashful",
	cheer = "cheer",
	clapping = "clapping",
	point = "point",
	dismiss_one = "dismiss_one",
	dismiss_two = "dismiss_two",
	excited_one = "excited_one",
	excited_two = "excited_two",
	fistpump = "fistpump",
	happy = "happy",
	bow = "bow",
	buttslap = "buttslap",
	embarassed = "embarassed",
	flipthebird = "flipthebird",
	loser = "loser",
	no_one = "no_one",
	no_two = "no_two",
	really = "really",
	sad = "sad",
	salute = "salute",
	shakefist = "shakefist",
	showingoff = "showingoff",
	thinking = "thinking",
	throatslash = "throatslash",
	throatslash_two = "throatslash_two",
	tired = "tired",
	wave = "wave",
	whatever = "whatever",
	yes_one = "yes_one",
	yes_two = "yes_two",
	dance = "dance_wave",
	dance_gangamstyle = "dance_gangamstyle",	
	dance_bellydance = "dance_bellydance",
	dance_cabbagepatch = "dance_cabbagepatch",
	dance_chickendance = "dance_chickendance",
	dance_guitarsolo = "dance_guitarsolo",
	dance_headbang = "dance_headbang",
	dance_hiphop = "dance_hiphop",
	dance_macarena = "dance_macarena",
	dance_raisetheroof = "dance_raisetheroof",
	dance_robot = "dance_robot",
	dance_runningman = "dance_runningman",
	dance_twist = "dance_twist",
}

for command,animName in pairs(Emotes) do
	RegisterEventHandler(
		EventType.ClientUserCommand, command,
		function()		
			this:PlayAnimation(animName)
		end
	)
end

emoteIndex = 1

RegisterEventHandler(
		EventType.ClientUserCommand, "allemotes",
		function()		
			emoteIndex = 1
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"allemotes")
		end
	)

RegisterEventHandler(
		EventType.Timer, "allemotes",
		function()		
			local curIndex = 1
			for command,animName in pairs(Emotes) do
				if(curIndex == emoteIndex) then
					this:PlayAnimation(animName)
					this:NpcSpeech(animName)
					this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"allemotes")
				end
				curIndex = curIndex + 1
			end			
			
			emoteIndex = emoteIndex + 1
		end
	)

this:RemoveTimer("allemotes")