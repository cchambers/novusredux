require 'base_mobile_advanced'
require 'incl_combat_abilities'
require 'incl_magic_sys'

RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		if(not IsDead(user)) then return end
		FaceObject(this,user)

		local text = "[$1235]"
		local response = {
			{text="Yes! Can you help me?",handle="AnotherChance"},
			{text="Please! I want another chance.",handle="AnotherChance"},
			{text="Wait just a minute...",handle="Dialog"},
			{text="I don't need your help.",handle=""},
		}
		NPCInteraction(text,this,user,"InteractionWindow",response)							
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "InteractionWindow",
	function (user,buttonId)
		if (buttonId == "AnotherChance") then
			local text = "[$1236]"
			local response = {
					{text="Yes, please!",handle="RestoreCharacter"},
					{text="I'll find a way back.",handle=""},
				}
			NPCInteraction(text,this,user,"InteractionWindow",response)	
		end
		if (buttonId == "Dialog") then
			local text = "[$1237]"
			local response = {
				{text="I have so many questions",handle="Questions"},
				{text="Are you a Stranger?",handle="Stranger"},
				{text="Why are you helping us?",handle="HelpingUs"},
				{text="What do you need me to do?",handle="DoWhat"},
				{text="Right, bye.",handle=""},
			}
			NPCInteraction(text,this,user,"InteractionWindow",response)		
		end
		if (buttonId == "Questions") then
			QuickDialogMessage(this,user,"[$1238]")
		end
		if (buttonId == "Stranger") then
			QuickDialogMessage(this,user,"[$1239]")
		end
		if (buttonId == "DoWrong") then
			QuickDialogMessage(this,user,"[$1240]")
		end
		if (buttonId == "WhyDoThis") then
			QuickDialogMessage(this,user,"[$1241]")
		end
		if (buttonId == "RestoreCharacter") then
			user:SendMessage("Resurrect")
			this:Destroy()
		end
	end)

