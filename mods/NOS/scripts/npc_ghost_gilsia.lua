require 'base_mobile_advanced'
require "incl_dialogwindow"

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"SetColor")

RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		
		FaceObject(this,user)
		local introState = user:GetObjVar("GilsiaIntro")
		if(introState == nil) then
			text="[$2110]"
				.."[$2111]"
				.."[$2112]"

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

			NPCInteraction(text,this,user,"GilsiaTalk",response)	
			user:SetObjVar("GilsiaIntro",true)				
		elseif(introState == true) then		

			text="[$2113]"

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

			NPCInteraction(text,this,user,"GilsiaTalk",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "GilsiaTalk",
	function (user,buttonId)
		if(buttonId == "Question") then

			text="[$2114]"

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

			text="[$2115]"
			response = {}

			response[1] = {}
			response[1].text = "Oh."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	
		end
		if(buttonId == "Question3") then
			text="[$2116]"
			response = {}

			response[1] = {}
			response[1].text = "Nevermind."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
	end)


RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		if(buttonId == "Nevermind") then

			text="Alright then, what else can I do for you?"

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

			NPCInteraction(text,this,user,"GilsiaTalk",response)
		end
		if(buttonId == "Who") then

			text = "I'm Gilisa Glenwell ... Or at least I was. "
			.."[$2117]"
			.."[$2118]"
			.."[$2119]"
			.."[$2120]"
			.."[$2121]"

			response = {}

			response[1] = {}
			response[1].text = "Tell me about The Imprisoning."
			response[1].handle = "Imprisoning" 

			response[2] = {}
			response[2].text = "Why haven't you moved on?"
			response[2].handle = "Why" 

			response[3] = {}
			response[3].text = "Interesting."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response,570,600)
		end
		if(buttonId == "What" or buttonId == "Why") then

			text="[$2122]"
			.."[$2123]"
			.."[$2124]"
			response = {}

			response[1] = {}
			response[1].text = "Oh."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Imprisoning") then

			local text="[$2125]"
				.."[$2126]"
				.."[$2127]"
				.."[$2128]"

			local responses = 
			{
				{ 
					text = "Thanks.",
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