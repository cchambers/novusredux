require 'base_mobile_advanced'
require "incl_dialogwindow"

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"SetColor")

RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		
		FaceObject(this,user)
		local introState = user:GetObjVar("AlucardIntro")
		if(introState == nil) then
			text="[$2074]"

			response = {}

			response[1] = {}
			response[1].text = "What is this place?"
			response[1].handle = "Question2"

			response[2] = {}
			response[2].text = "Tell me about yourself."
			response[2].handle = "Question" 

			response[3] = {}
			response[3].text = "Can you help me?"
			response[3].handle = "Question3" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"AlucardTalk",response)	
			user:SetObjVar("AlucardIntro",true)				
		elseif(introState == true) then		

			text="Hello again, strange one. What can I do for you?"

			response = {}

			response[1] = {}
			response[1].text = "What is this place?"
			response[1].handle = "Question2"

			response[2] = {}
			response[2].text = "Tell me about yourself."
			response[2].handle = "Question" 

			response[3] = {}
			response[3].text = "Can you help me?"
			response[3].handle = "Question3" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"AlucardTalk",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "AlucardTalk",
	function (user,buttonId)
		if(buttonId == "Question") then

			text="[$2075]"

			response = {}

			response[1] = {}
			response[1].text = "Who are you?"
			response[1].handle = "Who"

			response[2] = {}
			response[2].text = "Why are you here?"
			response[2].handle = "Why" 

			response[3] = {}
			response[3].text = "Nevermind."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "Question2") then

			text="[$2076]"
			.."[$2077]"
			.."[$2078]"
			.."[$2079]"
			.."[$2080]"
			response = {}

			response[1] = {}
			response[1].text = "Interesting."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	
		end
		if(buttonId == "Question3") then
			text="[$2081]"
			response = {}

            this:StopMoving()
            this:SendMessage("CastSpellMessage","Heal",this,user)

			response[1] = {}
			response[1].text = "Thanks!"
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
	end)


RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		if(buttonId == "Nevermind") then

			text="Anything else strange one? "

			response = {}

			response[1] = {}
			response[1].text = "What is this place?"
			response[1].handle = "Question2"

			response[2] = {}
			response[2].text = "Tell me about yourself."
			response[2].handle = "Question" 

			response[3] = {}
			response[3].text = "Can you help me?"
			response[3].handle = "Question3" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"AlucardTalk",response)
		end
		if(buttonId == "Who") then

			text = "[$2082]"

			response = {}

			response[1] = {}
			response[1].text = "Death doesn't bother you?"
			response[1].handle = "NoWorries" 

			response[2] = {}
			response[2].text = "Interesting."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "What" or buttonId == "Why") then

			text="[$2083]"
			response = {}

			response[1] = {}
			response[1].text = "Right."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "NoWorries") then

			local text="[$2084]"

			local responses = 
			{
				{ 
					text = "Seems so.",
					handle = "Nevermind" 
				}
			}

			NPCInteraction(text,this,user,"Question",responses)
		end
	end)

RegisterEventHandler(EventType.Timer,"SetColor",
function()
	this:SetObjVar("IsGhost",true)
	this:SetCloak(true)
	if (this:GetEquippedObject("Chest") ~= nil) then
		this:GetEquippedObject("Chest"):SetColor("0xC100FFFF")
	end
	if (this:GetEquippedObject("Legs") ~= nil) then
		this:GetEquippedObject("Legs"):SetColor("0xC100FFFF")
	end
end)