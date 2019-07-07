RegisterEventHandler(EventType.EnterView, "Transmorgifier", 
	function(user)
		user:AddModule("custom_char_window")
		--DebugMessage("StartingQuest is at "..tostring(GetPlayerQuestState(user,user,"StartingQuest")))
		if (GetPlayerQuestState(user,"StartingQuest") == "ChangeAppearance") then
			user:SetObjVar("ChoseAppearance",true)
		end
	end)

AddView("Transmorgifier", SearchPlayerInRange(1.0))

RegisterEventHandler(EventType.ModuleAttached,"limbo_transmorgifier",
	function()	
		AddUseCase(this,"Transmorgify",true)
		SetTooltipEntry(this,"[$1907]")
	end)

RegisterEventHandler(EventType.Message,"UseObject",
	function(user, usedType)
		if(usedType == "Use" or usedType == "Transmorgify") then
			user:PathTo(this:GetLoc(),ServerSettings.Stats.RunSpeedModifier)
		end
	end)