require 'NOS:base_mobile_advanced'
require "NOS:incl_dialogwindow"
require 'NOS:incl_gametime'

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"SetColor")

RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		
		FaceObject(this,user)
		user:SendMessage("AdvanceQuest","SlayDemonQuest","TalkToTheHero","TalkToElivar")
		local introState = user:GetObjVar("ElivarIntro")
		if(introState == nil) then
			text="[$2094]"

			local backpackObj = user:GetEquippedObject("Backpack")  
			local dropPos = GetRandomDropPosition(backpackObj)
    		CreateObjInContainer("lscroll_lightning", backpackObj, dropPos, nil)
			response = {}

			response[1] = {}
			response[1].text = "The Demon is immortal?"
			response[1].handle = "ImmortalDemon"

			response[2] = {}
			response[2].text = "What happened?"
			response[2].handle = "Happened" 

			response[3] = {}
			response[3].text = "Why did you just appear?"
			response[3].handle = "Who" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)	
			user:SetObjVar("ElivarIntro",true)			

		elseif(introState == true) then		

			text="What else can I divluge to you..."

			response = {}

			response[1] = {}
			response[1].text = "What happened?"
			response[1].handle = "Happened"

			response[2] = {}
			response[2].text = "Tell me about yourself."
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "Can you help me?"
			response[3].handle = "HelpMe" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		if(buttonId == "Question") then

			text="What else can I divluge to you..."

			response = {}

			response[1] = {}
			response[1].text = "What happened?"
			response[1].handle = "Happened"

			response[2] = {}
			response[2].text = "Tell me about yourself."
			response[2].handle = "Who" 

			response[3] = {}
			response[3].text = "Can you help me?"
			response[3].handle = "HelpMe" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"GilsiaTalk",response)
		end
		if(buttonId == "Happened") then

			text="[$2095]"
			.."[$2096]"
			.."[$2097]"
			.."[$2098]"
			.."[$2099]"
			.."[$2100]"
			.."[$2101]"
			.."[$2102]"
			response = {}

			response[1] = {}
			response[1].text = "What do you know of Kho?"
			response[1].handle = "Kho"

			response[2] = {}
			response[2].text = "So... you are the demon?"
			response[2].handle = "YouAreDemon?" 

			response[3] = {}
			response[3].text = "I have so many questions..."
			response[3].handle = "Questionssssss" 

			response[4] = {}
			response[4].text = "Goodbye"
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response,nil,800)	
		end
		if (buttonId == "ImmortalDemon") then

			text = "[$2103]"

			response = {}

			response[2] = {}
			response[2].text = "So... you are the demon?"
			response[2].handle = "YouAreDemon?" 

			response[1] = {}
			response[1].text = "Right."
			response[1].handle = "Nevermind" 
			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "YouAreDemon?") then
			text="[$2104]"
			response = {}

			response[1] = {}
			response[1].text = "Can't you control yourself?"
			response[1].handle = "StopIt" 

			response[2] = {}
			response[2].text = "Stop it then!"
			response[2].handle = "StopIt" 

			response[3] = {}
			response[3].text = "Right."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Kho") then
			text="[$2105]"
			
			response = {}

			response[1] = {}
			response[1].text = "Can you talk to him?"
			response[1].handle = "TalkToKho" 

			response[2] = {}
			response[2].text = "Uh... Right."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "TalkToKho") then
			text="[$2106]"
			
			response = {}

			response[2] = {}
			response[2].text = "Right."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "StopIt") then
			text="[$2107]"
			
			response = {}

			response[1] = {}
			response[1].text = "Then you must be destroyed."
			response[1].handle = "Attack" 

			response[2] = {}
			response[2].text = "Right."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Questionssssss" or buttonId == "HelpMe") then

			text="[$2108]"
			
			response = {} 

			response[2] = {}
			response[2].text = "Right."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if (buttonId == "Attack") then
			this:PlayAnimation("cast_heal")
			this:NpcSpeech("Fool. You know nothing.")
			user:SendMessage("ProcessTrueDamage", this, 10000, true)
			user:PlayEffect("LightningCloudEffect")
			user:PlayEffect("LightningCloudEffect")
			user:PlayEffect("LightningCloudEffect")
		end
		if (buttonId == "Who") then
			text = "[$2109]"
	
			response = {} 

			response[1] = {}
			response[1].text = "What is your story?"
			response[1].handle = "Happened"

			response[2] = {}
			response[2].text = "Right."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
		end
	end)

RegisterEventHandler(EventType.Timer,"SetColor",
function()
	this:SetObjVar("IsGhost",true)
	this:SetCloak(true)
	this:GetEquippedObject("Chest"):SetColor("0xC100FFFF")
	--this:GetEquippedObject("Legs"):SetColor("0xC100FFFF")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(60),"CheckTimeOfDay")
end)

RegisterEventHandler(EventType.Timer,"CheckTimeOfDay",
function()
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(60),"CheckTimeOfDay")
    local nearbyPlayers = FindObjects(SearchPlayerInRange(15))
	if (not IsNightTime() and not (#nearbyPlayers > 0)) then
		this:Destroy()
	end
end)