require 'base_mobile_advanced'
require "incl_dialogwindow"
require 'incl_gametime'

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"SetColor")

RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		
		FaceObject(this,user)
		local introState = user:GetObjVar("DruidIntro")
		if(introState == nil) then
			text="[$2085]"

			response = {}

			response[1] = {}
			response[1].text = "What? Who are you?"
			response[1].handle = "Who"

			response[2] = {}
			response[2].text = "I need your advice"
			response[2].handle = "Advice" 

			response[3] = {}
			response[3].text = "Why did you just appear?"
			response[3].handle = "Why" 

			response[4] = {}
			response[4].text = "Er, nevermind."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)	
			user:SetObjVar("DruidIntro",true)			

		elseif(introState == true) then		

			text="You again, outsider. What can I guide you towards?"

			response = {}

			response[1] = {}
			response[1].text = "I need your advice"
			response[1].handle = "Advice" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who"

			response[3] = {}
			response[3].text = "What are you doing here?"
			response[3].handle = "Why" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		if(buttonId == "Question") then

			text="Anything else I can do for you...?"

			response = {}

			response[1] = {}
			response[1].text = "I need your advice"
			response[1].handle = "Advice" 

			response[2] = {}
			response[2].text = "Who are you?"
			response[2].handle = "Who"

			response[3] = {}
			response[3].text = "What are you doing here?"
			response[3].handle = "What" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Who") then

			text="[$2086]"
			response = {}

			response[1] = {}
			response[1].text = "Tell me more about your people."
			response[1].handle = "YourPeople"

			response[2] = {}
			response[2].text = "What do you know about..."
			response[2].handle = "What" 

			response[3] = {}
			response[3].text = "I need your guidance."
			response[3].handle = "Advice" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)	
		end
		if (buttonId == "Advice") then

			text = "[$2087]"

			response = {}

			response[2] = {}
			response[2].text = "I seek knowledge of your time."
			response[2].handle = "Knowledge" 

			response[2] = {}
			response[2].text = "I need assistance with something else."
			response[2].handle = "Assistance" 

			response[2] = {}
			response[2].text = "I seek a relic of the Gods."
			response[2].handle = "Relic" 

			response[1] = {}
			response[1].text = "Nevermind."
			response[1].handle = "Nevermind" 

			NPCInteractionLongButton(text,this,user,"Question",response)
		end
		if (buttonId == "Knowledge") then
			QuickDialogMessage(this,user,"[$2088]")
		end
		if (buttonId == "YourPeople") then
			QuickDialogMessage(this,user,"[$2089]")
		end
		if (buttonId == "Assistance") then
			QuickDialogMessage(this,user,"[$2090]")
		end
		if (buttonId == "Relic") then
			QuickDialogMessage(this,user,"[$2091]")
	        CreateObjInBackpack(user,"holy_water","handle_holy_water")  
	        user:SystemMessage("You have received [D7D700]Holy Water[-]!","info")
		end
		if (buttonId == "What") then
			QuickDialogMessage(this,user,"[$2092]")
		end
		if (buttonId == "Why") then
			QuickDialogMessage(this,user,"[$2093]")
		end
	end)

RegisterEventHandler(EventType.Timer,"SetColor",
function()
	this:SetObjVar("IsGhost",true)
	this:SetCloak(true)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(60),"CheckTimeOfDay")
end)

RegisterEventHandler(EventType.Timer,"CheckTimeOfDay",
function()
    local nearbyPlayers = FindObjects(SearchPlayerInRange(15))
	if (not (#nearbyPlayers > 0)) then
		this:Destroy()
	end
end)