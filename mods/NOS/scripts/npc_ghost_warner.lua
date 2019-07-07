require 'base_mobile_advanced'
require "incl_dialogwindow"

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"SetColor")

RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		
		FaceObject(this,user)
		local introState = user:GetObjVar("HeroQuestState")
		if(introState == nil) then
			text="[$2153]"

			response = {}

			response[1] = {}
			response[1].text = "What?"
			response[1].handle = "What"

			response[2] = {}
			response[2].text = "What are you doing?."
			response[2].handle = "Question" 

			response[3] = {}
			response[3].text = "Whatever."
			response[3].handle = "" 

			NPCInteraction(text,this,user,"WarnerTalk",response)			
		elseif(introState == "ImbuedWeapon") then		

			text="[$2154]"

			response = {}

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"WarnerTalk",response)
		elseif(introState == "KilledDemon") then		

			text="[$2155]"

			response = {}

			response[4] = {}
			response[4].text = "Yep."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"WarnerTalk",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "WarnerTalk",
	function (user,buttonId)
		if(buttonId == "What") then

			text="[$2156]"

			response = {}

			response[3] = {}
			response[3].text = "Right."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"",response)

		end
		if(buttonId == "Question") then

			text="[$2157]"
			response = {}

			response[1] = {}
			response[1].text = "What happened?"
			response[1].handle = "WhatHappened"

			response[2] = {}
			response[2].text = "What can be done to stop it?"
			response[2].handle = "HowToKillIt" 

			response[3] = {}
			response[3].text = "Right."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"WarnerTalk",response)	
		end
		if(buttonId == "WhatHappened") then

			text="[$2158]" 
			.."[$2159]"
			.."[$2160]"
			.."[$2161]"
			.."[$2162]"

			response = {}

			response[1] = {}
			response[1].text = "The demon existed long before?"
			response[1].handle = "DeadRising"

			response[2] = {}
			response[2].text = "What can be done to stop it?"
			response[2].handle = "HowToKillIt" 

			response[3] = {}
			response[3].text = "Oh."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"WarnerTalk",response,570,600)

		end
		if (buttonId == "DeadRising") then
			text = "[$2163]"

			response = {}

			response[1] = {}
			response[1].text = "Thanks."
			response[1].handle = ""

			NPCInteraction(text,this,user,"WarnerTalk",response)
		end
		if (buttonId == "HowToKillIt") then
			text = "[$2164]"

			response = {}

			response[1] = {}
			response[1].text = "Interesting."
			response[1].handle = ""

			NPCInteraction(text,this,user,"WarnerTalk",response)
		end
	end)

RegisterEventHandler(EventType.Timer,"SetColor",
function()
	this:SetObjVar("IsGhost",true)
	this:SetCloak(true)

	local chestObj = this:GetEquippedObject("Chest")
	if(chestObj ~= nil)	then chestObj:SetColor("0xC100FFFF") end
	
	local legsObj = this:GetEquippedObject("Legs")
	if(legsObj ~= nil) then legsObj:SetColor("0xC100FFFF") end
end)

AddView("warn", SearchMobileInRange(10))

RegisterEventHandler(EventType.EnterView,"warn",
	function(objRef)
		if (objRef ~= nil and objRef:IsValid() and objRef:IsPlayer()) then
			local questStatus = objRef:GetObjVar("HeroQuestState")
			if (questStatus ~= "ImbuedWeapon" and questStatus ~= "KilledDemon") then
				this:NpcSpeech("Turn back! Turn back I say!")
			end
		end
	end)