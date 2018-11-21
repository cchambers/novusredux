require 'base_mobile_advanced'
require 'incl_player_titles'

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"SetColor")

RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		
		FaceObject(this,user)
		local startingState = user:GetObjVar("HeroQuestState")
		if(startingState == nil) then

			user:SendMessage("StartQuest","SlayDemonQuest")

			text = "[$2061]"
			.."[$2062]"
			.."[$2063]"
			.."[$2064]"

			response = {}

--[[
			response[1] = {}
			response[1].text = "How can I help?"
			response[1].handle = "Accept" 
--]]
			response[2] = {}
			response[2].text = "Goodbye."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"More",response)	

		elseif(startingState == "QuestStart") then	

			text="[$2065]"
			
			response = {}

			response[1] = {}
			response[1].text = "Right."
			response[1].handle = "" 

			NPCInteraction(text,this,user,"InfoWindow",response)	

		elseif(startingState == "ImbuedWeapon") then			

			text="[$2066]"
			
			response = {}

			response[1] = {}
			response[1].text = "Right."
			response[1].handle = "" 

			NPCInteraction(text,this,user,"InfoWindow",response)	

		elseif(startingState == "KilledDemon") then			

			text="[$2067]"
			
			response = {}

			response[1] = {}
			response[1].text = "No, thank you!"
			response[1].handle = "" 

			NPCInteraction(text,this,user,"InfoWindow",response)	

			local backpackObj = user:GetEquippedObject("Backpack")  
			local dropPos = GetRandomDropPosition(backpackObj)	
			PlayerTitles.CheckTitleGain(user,AllTitles.ActivityTitles.Relic5,1,"relic_of_the_void")
    		CreateObjInContainer("relic_of_the_void", backpackObj, dropPos, nil)
            user:SystemMessage("You have received a Relic of the Void.")
			user:DelObjVar("HeroQuestState")
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "More",
	function (user,buttonId)
		if(buttonId == "Accept") then

			text= "I beg of you, please avenge me!"
				.."[$2068]"
				.."[$2069]"
				.."[$2070]"
			
			response = {}

			response[1] = {}
			response[1].text = "Sounds good."
			response[1].handle = "Accept" 

			response[2] = {}
			response[2].text = "Not interested."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"BeginQuest",response)	
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "BeginQuest",
	function (user,buttonId)
		if(buttonId == "Accept") then
			text="[$2071]"
			
			response = {}
--[[
			response[1] = {}
			response[1].text = "I will avenge you!."
			response[1].handle = "Accept" 
--]]
			response[2] = {}
			response[2].text = "Not interested."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"AcceptQuest",response)	
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "AcceptQuest",
	function (user,buttonId)
		if (buttonId == "Accept") then
			user:SetObjVar("HeroQuestState","QuestStart")
			user:SendMessage("AdvanceQuest","SlayDemonQuest","DipSword","TalkToGhostHero")
			user:SystemMessage("You now can use the reflection pool.")
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