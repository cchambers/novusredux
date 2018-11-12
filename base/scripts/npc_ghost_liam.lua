require 'base_mobile_advanced'
require "incl_dialogwindow"

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"SetColor")

RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		
		FaceObject(this,user)
		local introState = user:GetObjVar("LiamIntro")
		if(introState == nil) then
			text="[$2129]"
			.."[$2130]"
			.."What do you seek, newcomer?"
			response = {}

			response[1] = {}
			response[1].text = "I have a question."
			response[1].handle = "Question2"

			response[2] = {}
			response[2].text = "Tell me about yourself."
			response[2].handle = "Question" 

			response[3] = {}
			response[3].text = "I need your help."
			response[3].handle = "Question3" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"LiamTalk",response)	
			user:SetObjVar("LiamIntro",true)				
		elseif(introState == true) then		

			text="[$2131]"

			response = {}

			response[1] = {}
			response[1].text = "I have a question."
			response[1].handle = "Question2"

			response[2] = {}
			response[2].text = "Tell me about yourself."
			response[2].handle = "Question" 

			response[3] = {}
			response[3].text = "I need your help."
			response[3].handle = "Question3" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"LiamTalk",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "LiamTalk",
	function (user,buttonId)
		if(buttonId == "Question") then

			text="[$2132]"

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

			text= "[$2133]"
			response = {}

			response[1] = {}
			response[1].text = "What is the meaning of life?"
			response[1].handle = "MeaningOfLife"

			response[2] = {}
			response[2].text = "Why are we here?"
			response[2].handle = "WhyAmIHere" 

			response[3] = {}
			response[3].text = "Nevermind."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	
		end
		if(buttonId == "Question3") then
			text="[$2134]"
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

			text="What else can I divulge to you, neophyte?"

			response = {}

			response[1] = {}
			response[1].text = "I have a question."
			response[1].handle = "Question2"

			response[2] = {}
			response[2].text = "Tell me about yourself."
			response[2].handle = "Question" 

			response[3] = {}
			response[3].text = "I need your help."
			response[3].handle = "Question3" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"LiamTalk",response)
		end
		if(buttonId == "Who") then

			text = "[$2135]"

			response = {}

			response[1] = {}
			response[1].text = "Tell me about The Imprisoning."
			response[1].handle = "Imprisoning" 

			response[2] = {}
			response[2].text = "Tell me about The Shattering."
			response[2].handle = "Shattering" 

			response[3] = {}
			response[3].text = "Interesting."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Why") then

			text="[$2136]"

			response = {}

			response[1] = {}
			response[1].text = "Oh."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "WhyAmIHere") then

			text="[$2137]"

			response = {}

			response[1] = {}
			response[1].text = "Oh."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Imprisoning") then

			local text="[$2138]"

			local responses = 
			{
				{ 
					text = "Thanks.",
					handle = "Nevermind" 
				}
			}

			NPCInteraction(text,this,user,"Question",responses)
		end
		if(buttonId == "MeaningOfLife") then

			local text="[$2139]"

			local responses = 
			{
				{ 
					text = "What?",
					handle = "Nevermind" 
				}
			}

			NPCInteraction(text,this,user,"Question",responses)
		end
		if(buttonId == "Shattering") then

			local text="[$2140]"
			.."[$2141]"
			.."[$2142]"

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

	local chest = this:GetEquippedObject("Chest")
	if(chest) then
		chest:SetColor("0xC100FFFF")
	end

	local legs = this:GetEquippedObject("Legs")
	if(legs) then
		legs:SetColor("0xC100FFFF")
	end
end)