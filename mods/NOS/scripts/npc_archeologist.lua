require 'NOS:base_ai_mob'
require 'NOS:base_ai_intelligent'
--require 'NOS:base_ai_sleeping'
require "NOS:incl_dialogwindow"
require 'NOS:base_npc_extensions'

AI.Settings.Leash = true
AI.Settings.StationedLeash = true

--DFB TODO: NPC's use a base_ai_npc script now, these NPC systems are way out of date.
--Really just here until we upgrade these npc's to use the NPC system.
function CloseDialogWindows(user)
	user:CloseDynamicWindow("Question")
	user:CloseDynamicWindow("Actions")
	user:CloseDynamicWindow("Responses")
end

this:SetObjVar("AlwaysFriendly",true)

--npc's should all have this
function IsFriend(target)
    --My only enemy is the enemy
    if (AI.InAggroList(target)) then
        return false
    else
        return true
    end
end

function HasExplorationQuestNote(user)
	local backpack = user:GetEquippedObject("Backpack")
	if (backpack == nil) then return false end
	local NoteObject = FindItemInContainerRecursive(backpack,function (item)
		return item:HasObjVar("ThomasContactNote")
	end)
	if (NoteObject ~= nil) then return true end
end


AI.StateMachine.AllStates.Idle = { 
        GetPulseFrequencyMS = function() return math.random(3000,15000) end,
        AiPulse = function() 
            --aiRoll = math.random(4)
            --if(aiRoll == 1) then
            --    AI.StateMachine.ChangeState("GoLocation")            
            --else
            --    AI.StateMachine.ChangeState("Wander")
            --end
            DecideIdleState()
        end,        
    }

function GetAttention(user)
    if (IsAsleep(this)) then
        return 
    end
    this:StopMoving()
    this:SetFacing(this:GetLoc():YAngleTo(user:GetLoc()))
    AI.StateMachine.ChangeState("Idle")
end

AI.StateMachine.AllStates.Wander = {
		RepeatState = true,
        OnEnterState = function()
			local regions = GetRegionsAtLoc(this:GetLoc())
			if (regions ~= nil and #regions > 0) then
				--DebugMessage(tostring(#regions) )
				curRegion = regions[math.random(1,#regions)]
			end
            WanderInRegion(curRegion,"Wander")
        end,

        OnArrived = function (success)
        	if (AI.MainTarget ~= nil) then return end
        	--DebugMessage("OnArrived executed")
            if (AI.StateMachine.CurState ~= "Wander") then
            	if (AI.StateMachine.CurState ~= "Idle") then
            		DecideIdleState()
            	end
            end
            if( math.random(2) == 1) then
                this:PlayAnimation("fidget")
            end
            DecideIdleState()
        end,
    }

--has the variable Visible to All set to true so he isn't really cloaked, it just appears like that.
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		if (not CanUseNPC(user)) then return end
		CloseDialogWindows(user)
		local hasNote = HasExplorationQuestNote(user)
		user:SendMessage("StartQuest","RuinsQuest")
		GetAttention(user)
		favorability = user:GetObjVar("ThomasFavorability")
		local introState = user:GetObjVar("ThomasFavorability")
		if (introState == nil) then

			text = "[$1952]"

			response = {}

			response[1] = {}
			response[1].text = "Actually, yes."
			response[1].handle = "Who" 

			response[2] = {}
			response[2].text = "Nope."
			response[2].handle = "" 

			user:SetObjVar("ThomasFavorability",0)

			NPCInteraction(text,this,user,"Question",response)

		elseif (introState == 0) then

			user:SendMessage("AdvanceQuest","RuinsQuest","GainAccessToTheRuins","TalkToThomas")
			text = "[$1953]"

			response = {}
--[[
			response[1] = {}
			response[1].text = "How can I help?"
			response[1].handle = "CanIHelp" 
]]--
			if (not hasNote) then
				response[2] = {}
				response[2].text = "I have a question."
				response[2].handle = "Question" 
			--[[else
				response[2] = {}
				response[2].text = "I have a letter for you."
				response[2].handle = "Letter" ]]--
			end
--[[
			response[3] = {}
			response[3].text = "I need your help."
			response[3].handle = "NeedHelp" 
]]--
			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)

		elseif (introState >= 3) then		

			local roll = math.random(1,3)
			if roll == 1 then text = "Hello there again. Got anything fancy to show me?" end
			if roll == 2 then text = "Hello there. What can I interest you in?" end
			if roll == 2 then text = "Hello now, anything new to show me?" end

			response = {}

			if (favorability > 0) then
				response[1] = {}
				response[1].text = "I have items for you."
				response[1].handle = "Sell" 
			end

			if (not hasNote) then
				response[2] = {}
				response[2].text = "I have a question."
				response[2].handle = "Question" 
			else
				response[2] = {}
				response[2].text = "I have a letter for you."
				response[2].handle = "Letter" 
			end

			response[3] = {}
			response[3].text = "I need your help."
			response[3].handle = "NeedHelp" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		elseif (introState >= 10) then		

			local roll = math.random(1,3)
			if roll == 1 then text = "[$1954]" end
			if roll == 2 then text = "[$1955]" end
			if roll == 3 then text = "[$1956]" end


			response = {}

			if (favorability > 0) then
				response[1] = {}
				response[1].text = "I have items for you."
				response[1].handle = "Sell" 
			end

			if (not hasNote) then
				response[2] = {}
				response[2].text = "I have a question."
				response[2].handle = "Question" 
			else
				response[2] = {}
				response[2].text = "I have a letter for you."
				response[2].handle = "Letter" 
			end

			response[3] = {}
			response[3].text = "I need your help."
			response[3].handle = "NeedHelp" 


			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		elseif (introState ~= nil) then		

			local roll = math.random(1,3)
			if roll == 1 then text = "Hello there. Anything interesting today?" end
			if roll == 2 then text = "What can I do for you, good man?" end
			if roll == 3 then text = "What's the business today, sir?" end

			response = {}

			if (favorability > 0) then
				response[1] = {}
				response[1].text = "I have items for you."
				response[1].handle = "Sell" 
			end

			if (not hasNote) then
				response[2] = {}
				response[2].text = "I have a question."
				response[2].handle = "Question" 
			else
				response[2] = {}
				response[2].text = "I have a letter for you."
				response[2].handle = "Letter" 
			end

			response[3] = {}
			response[3].text = "I need your help."
			response[3].handle = "NeedHelp" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)

		end
	end)


RegisterEventHandler(EventType.CreatedObject,"ContactNote",
    function(success,objRef,objVarName,noteContents)
        if (success) then
            objRef:SetObjVar(objVarName,true)
            objRef:SendMessage("WriteNote",noteContents)
        end
    end)


RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		if (not CanUseNPC(user)) then return end
		GetAttention(user)
		CloseDialogWindows(user)
		local hasNote = HasExplorationQuestNote(user)
		user:SendMessage("StartQuest")
		favorability = user:GetObjVar("ThomasFavorability")
		if (favorability == nil) then favorability = 0 end
		if(buttonId == "Who") then
			GetAttention(user)
			user:SendMessage("AdvanceQuest","RuinsQuest","GainAccessToTheRuins","TalkToThomas")
			text = "[$1957]"
			.."[$1958]"
			.."[$1959]"
			.."[$1960]"
			response = {}

			response[1] = {}
			response[1].text = "They won't let you in?"
			response[1].handle = "NoEntry" 
--[[
			response[2] = {}
			response[2].text = "What can I do to help?"
			response[2].handle = "CanIHelp" 
--]]
			response[3] = {}
			response[3].text = "What are the Ruins?"
			response[3].handle = "WhatAreRuins" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)

		end
		if (buttonId == "Letter") then
			local backpackObj = user:GetEquippedObject("Backpack") 
			QuickDialogMessage(this,user,"[$1961]")
		    noteContents = "[$1962]"
		    local NoteObject = FindItemInContainerRecursive(backpackObj,function (item)
		    	if (item:HasObjVar("ThomasContactNote")) then
		    		return true
		    	end
		    end)
			if (NoteObject ~= nil) then NoteObject:Destroy() end
		    CreateObjInBackpack(user,"scroll_readable","ContactNote","ThomasNote",noteContents) 
		    user:SetObjVar("ThomasFinished",true)
		end
		if(buttonId == "CanIHelp") then

			if (favorability > 0) then

				text="[$1963]"

				response = {}

				response[3] = {}
				response[3].text = "Ah."
				response[3].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)		

			else
				text = "[$1964]"
				.."[$1965]"
				.."[$1966]"
				.."[$1967]"
				
				response = {}

				response[1] = {}
				response[1].text = "Sure."
				response[1].handle = "Accept" 

				response[2] = {}
				response[2].text = "I'll think about it."
				response[2].handle = "Nevermind"

				NPCInteraction(text,this,user,"Question",response)
			end
		end
		if(buttonId == "Question") then

			text = "[$1968]"

			response = {}
			if (user:HasObjVar("CouncilmanThomas")) then
				response[1] = {}
				response[1].text = "Are you Councilman Thomas?"
				response[1].handle = "Council" 
			else
				response[1] = {}
				response[1].text = "Who are you?"
				response[1].handle = "Who" 
			end

			response[2] = {}
			response[2].text = "Why are you here?"
			response[2].handle = "Why"

			response[3] = {}
			response[3].text = "What are the Ruins?"
			response[3].handle = "WhatAreRuins" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind"

			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "NoEntry") then

			text = "[$1969]"
			.."[$1970]"
			.."[$1971]"
			.."[$1972]"

			response = {}
--[[
			response[2] = {}
			response[2].text = "What can I do to help?"
			response[2].handle = "CanIHelp" 
]]--
			response[4] = {}
			response[4].text = "Ok."
			response[4].handle = "Nevermind"

			NPCInteraction(text,this,user,"Question",response)
		elseif (buttonId == "Nevermind") then

			text="Anything else we can discuss?"

			response = {}

			if (favorability > 0) then
				response[1] = {}
				response[1].text = "I have items for you."
				response[1].handle = "Sell" 
			end

			if (not hasNote) then
				response[2] = {}
				response[2].text = "I have a question."
				response[2].handle = "Question" 
			--[[else
				response[2] = {}
				response[2].text = "I have a letter for you."
				response[2].handle = "Letter" ]]--
			end
--[[
			response[3] = {}
			response[3].text = "I need your help."
			response[3].handle = "NeedHelp" 
]]--
			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "WhatAreRuins") then

			text = "[$1973]"
			.."[$1974]"
			.."[$1975]"
			.."[$1976]"
			.."[$1977]"
			.."[$1978]"

			response = {}

			response[1] = {}
			response[1].text = "Why are the cultists here?"
			response[1].handle = "Cultists" 

			response[2] = {}
			response[2].text = "What else do you know?"
			response[2].handle = "More"

			response[3] = {}
			response[3].text = "Why do you care?"
			response[3].handle = "WhyCare" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind"

			NPCInteraction(text,this,user,"Question",response,nil,600)

		end
		if(buttonId == "Council") then

			user:SetObjVar("CouncilmanThomasTalkedTo",true)

			text="[$1979]"

			response = {}

			response[1] = {}
			response[1].text = "What what?"
			response[1].handle = "WaitWhat" 

			response[2] = {}
			response[2].text = "What do you mean?"
			response[2].handle = "WhatMean" 

			response[3] = {}
			response[3].text = "What ARE you doing then?"
			response[3].handle = "TheTruth" 

			response[4] = {}
			response[4].text = "Uh... Nevermind."
			response[4].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)			
		end
		if(buttonId == "TheTruth") then

			text="[$1980]"
			.."[$1981]" 
			.."[$1982]"
			.."[$1983]"
			.."[$1984]"
			.."[$1985]"

			response = {}

			response[1] = {}
			response[1].text = "You're paranoid."
			response[1].handle = "Paranoid" 

			response[2] = {}
			response[2].text = "Why gather artifacts?"
			response[2].handle = "GatherArtifacts" 

			response[3] = {}
			response[3].text = "Who is behind this?"
			response[3].handle = "WhoBehindThis" 

			response[4] = {}
			response[4].text = "Uh... Nevermind."
			response[4].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response,nil,600)			
		end
		if(buttonId == "WaitWhat" or buttonId  == "WhatMean") then

			text="[$1986]"

			response = {}

			response[1] = {}
			response[1].text = "No, what do you mean?"
			response[1].handle = "WaitWhat2" 

			response[2] = {}
			response[2].text = "What ARE you doing here then?"
			response[2].handle = "TheTruth" 

			response[3] = {}
			response[3].text = "Right."
			response[3].handle = "Nevermind" 

			response[4] = {}
			response[4].text = "I won't ask questions. Got it."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)			
		end
		if (buttonId == "Paranoid" ) then
			QuickDialogMessage(this,user,"[$1987]")
		end
		if (buttonId == "GatherArtifacts") then
			QuickDialogMessage(this,user,"[$1988]")
		end
		if (buttonId == "WhoBehindThis") then
			QuickDialogMessage(this,user,"[$1989]")
		end
		if(buttonId == "WaitWhat2") then

			text="[$1990]"

			response = {}

			response[3] = {}
			response[3].text = "Ah."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)			
		end
		if(buttonId == "WhyCare") then

			text="[$1991]"

			response = {}

			response[3] = {}
			response[3].text = "Ah."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)			
		end
		if(buttonId == "Cultists") then

			text="[$1992]"
			response = {}

			response[1] = {}
			response[1].text = "Thanks."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	

		end
		if(buttonId == "Accept") then

			text="[$1993]"
			response = {}

			response[1] = {}
			response[1].text = "Ok."
			response[1].handle = "Nevermind" 

			user:SendMessage("StartQuest","ArcheologistQuest","FindAnArtifact")
			user:SetObjVar("ThomasFavorability",1)

			NPCInteraction(text,this,user,"Question",response)	

		end
		if(buttonId == "More") then

			text="[$1994]"

			response = {}

			response[1] = {}
			response[1].text = "Interesting."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	
					
		end
		if(buttonId == "Why") then

			text="[$1995]"

			response = {}

			response[3] = {}
			response[3].text = "Ok."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	

		end
		if(buttonId == "NeedHelp") then

			if (favorability > 0) then

				text="[$1996]"
			
				response = {}

				if (favorability > 3) then
					response[1] = {}
					response[1].text = "I need to deciper something."
					response[1].handle = "Decipher" 
				end

				if (favorability > 5) then
					response[2] = {}
					response[2].text = "I need to identify this item."
					response[2].handle = "Identify" 
				end

				response[3] = {}
				response[3].text = "I need assistance."
				response[3].handle = "Assistance" 

				response[4] = {}
				response[4].text = "Nevermind."
				response[4].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Actions",response)	

			else
				text="[$1997]"
				
				response = {}
--[[
				response[2] = {}
				response[2].text = "What can I do for you?"
				response[2].handle = "CanIHelp" 
--]]
				response[4] = {}
				response[4].text = "Gee thanks."
				response[4].handle = "Nevermind" 

				NPCInteraction(text,this,user,"Question",response)
			end
		end
		if(buttonId == "Sell") then

			text="You have an artifact? Excellent! Let me see."

			user:SystemMessage("What do you wish to sell?","info")
			user:RequestClientTargetGameObj(this, "sell")

			response = {}

			response[3] = {}
			response[3].text = "Nevermind."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	

		end
	end)

function GetPrice(target)
	if (target == nil) then return 0 end
	local id = target:GetCreationTemplateId()
	if (id == nil) then return 0 end
	if (id == "artifact_small_statue") then return 400 end
	if (id == "artifact_pendant") then return 600 end
	if (id == "artifact_ornate_pottery") then return 400 end
	if (id == "artifact_ornate_goblet") then return 400 end
	if (id == "artifact_mask") then return 500 end
	if (id == "artifact_gold_bracelet") then return 600 end
	if (id == "artifact_flute") then return 400 end
	if (id == "idol_demon") then return 750 end
	if (id == "idol_debuff") then return 700 end
	if (id == "idol_flimsy") then return 700 end
	if (id == "idol_hunger") then return 700 end
	if (id == "idol_animal") then return 700 end
	if (id == "stone_tablet_a") then return 300 end
	if (id == "stone_tablet_b") then return 300 end
	if (id == "stone_tablet_c") then return 300 end
	if (id == "stone_tablet_d") then return 300 end
	if (id == "stone_tablet_e") then return 300 end
	if (id == "idol_clumsyness") then return 750 end
	if (id == "furniture_pot_ceramic_1") then return 10 end
	if (id == "furniture_pot_ceramic_2") then return 10 end
	if (id == "furniture_pot_ceramic_3") then return 10 end
	return 0
end

RegisterEventHandler(EventType.DynamicWindowResponse, "Actions",
	function (user,buttonId)
		if (not CanUseNPC(user)) then return end
		GetAttention(user)
		CloseDialogWindows(user)
		user:CloseDynamicWindow("Question")
		local hasNote = HasExplorationQuestNote(user)
		--DebugMessage("actions")
		favorability = user:GetObjVar("ThomasFavorability")

		if(buttonId == "Decipher") then

			text="[$1998]"--You have a table scroll or some other writing in the Vorenni tongue that you wish to read? Let me see. \n\nIt will cost some coin though, 20 gold pieces."

			--user:SystemMessage("What do you wish to decipher?")
			--user:RequestClientTargetGameObj(this, "decipher")

			response = {}

			response[2] = {}
			response[2].text = "I'll take one. [F7F700]Pay 20 gold[-]"
			response[2].handle = "BuyDecipher" 

			response[3] = {}
			response[3].text = "Nevermind."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Actions",response)	

		end
		if(buttonId == "Identify") then

			text="[$1999]"

			user:SystemMessage("What do you wish to identify?","info")
			user:RequestClientTargetGameObj(this, "identify")

			response = {}

			response[3] = {}
			response[3].text = "Nevermind."
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	

		end
		if(buttonId == "Assistance") then

			text="[$2000]"

            this:StopMoving()
            this:SendMessage("CastSpellMessage","Heal",this,user)

			response = {}

			response[3] = {}
			response[3].text = "Thanks!"
			response[3].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	

		end
		if (buttonId == "Nevermind") then

			text="Anything I can do for you?"

			response = {}

			if (favorability > 0) then
				response[1] = {}
				response[1].text = "I have items for you."
				response[1].handle = "Sell" 
			end

			if (not hasNote) then
				response[2] = {}
				response[2].text = "I have a question."
				response[2].handle = "Question" 
			else
				response[2] = {}
				response[2].text = "I have a letter for you."
				response[2].handle = "Letter" 
			end

			response[3] = {}
			response[3].text = "I need your help."
			response[3].handle = "NeedHelp" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)

		end
		if(buttonId == "SellArtifact") then
			if (favorability == nil) then favorability = 0 end

			user:SetObjVar("ThomasFavorability",favorability + 1)
			if (not GetPlayerQuestState(user,"ArcheologistQuest")) then
				user:SendMessage("FinishQuest","ArcheologistQuest")
			end
			
			local backpackObj = user:GetEquippedObject("Backpack") 

			CreateObjInContainer("coin_purse", backpackObj, GetRandomDropPosition(backpackObj), "LootCoinPurse", GetPrice(sellTarget))
			
			sellTarget:Destroy()

			text="Glad we could reach an agreement, anything else?"

			response = {}

			if (favorability > 0) then
				response[1] = {}
				response[1].text = "I have items for you."
				response[1].handle = "Sell" 
			end

			if (not hasNote) then
				response[2] = {}
				response[2].text = "I have a question."
				response[2].handle = "Question" 
			else
				response[2] = {}
				response[2].text = "I have a letter for you."
				response[2].handle = "Letter" 
			end

			response[3] = {}
			response[3].text = "I need your help."
			response[3].handle = "NeedHelp" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "BuyDecipher") then
			--DebugMessage("BuyDecipher")
			RequestConsumeResource(user,"coins",20,"BuyDecipher",this)
			this:PlayAnimation("transaction")
			--give some favorability
			if (favorability == nil) then favorability = 0 end
			user:SetObjVar("ThomasFavorability",favorability + 1)
		    
	    end

	end)

RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
	function (success,transactionId,user)
		if (not CanUseNPC(user)) then return end

	local hasNote = HasExplorationQuestNote(user)
	--DebugMessage(DumpTable(args))
	--DebugMessage("Attempting "..tostring(transactionId))
	CloseDialogWindows(user)
	if (transactionId ~= "BuyDecipher" or not success) then
			text = "[$2001]"
				
			response = {}

			response[2] = {}
			response[2].text = "Whatever."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)
			return
	else
			--give him the item
			local backpackObj = user:GetEquippedObject("Backpack")  
			local dropPos = GetRandomDropPosition(backpackObj)
	    	CreateObjInContainer("scroll_decipher", backpackObj, dropPos, nil)
	        user:SystemMessage("You have received a Decipher Scroll!","info")

			text="Here you are, good tidings now, anything else?"

			response = {}

			if (favorability > 0) then
				response[1] = {}
				response[1].text = "I have items for you."
				response[1].handle = "Sell" 
			end

			if (not hasNote) then
				response[2] = {}
				response[2].text = "I have a question."
				response[2].handle = "Question" 
			else
				response[2] = {}
				response[2].text = "I have a letter for you."
				response[2].handle = "Letter" 
			end

			response[3] = {}
			response[3].text = "I need your help."
			response[3].handle = "NeedHelp" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
	end
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "sell", 
	function(target,user)
		CloseDialogWindows(user)
		local price = GetPrice(target)
		if price > 0 then

			sellTarget = target
			response = {}
			--if he/she's sellable, pop up dialog asking if he wants to sell it.
			text="[$2002]"..price.."[-] gold!"
				
			response[1] = {}
			response[1].text = "It's all yours.[F7F700](Receive "..price.." gold)[-]"
			response[1].handle = "SellArtifact" 

			response[2] = {}
			response[2].text = "No, thank you."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Actions",response)

		else
			text="[$2003]"

			response = {}

			response[2] = {}
			response[2].text = "Oh."
			response[2].handle = "" 

			NPCInteraction(text,this,user,"Actions",response)
		end
	end)

function GetIdentity(target)
	if (target == nil) then return 0 end
	local id = target:GetCreationTemplateId()
	if (id == nil) then return 0 end
	if (id == "artifact_small_statue") then return "[$2004]" end
	if (id == "artifact_pendant") then return "[$2005]" end
	if (id == "artifact_ornate_pottery") then return "[$2006]" end
	if (id == "artifact_ornate_goblet") then return "[$2007]" end
	if (id == "artifact_mask") then return "[$2008]" end
	if (id == "artifact_gold_bracelet") then return "[$2009]" end
	if (id == "artifact_flute") then return "[$2010]" end
	if (id == "idol_demon") then return "[$2011]" end
	if (id == "idol_debuff") then return "[$2012]" end
	if (id == "idol_flimsy") then return "[$2013]" end
	if (id == "idol_hunger") then return "[$2014]" end
	if (id == "idol_animal") then return "[$2015]" end
	if (id == "stone_tablet_a") then return "[$2016]" end
	if (id == "stone_tablet_b") then return "[$2017]" end
	if (id == "stone_tablet_c") then return "[$2018]" end
	if (id == "stone_tablet_d") then return "[$2019]" end
	if (id == "stone_tablet_e") then return "[$2020]" end
	if (id == "idol_clumsyness") then return "[$2021]" end
	if (id == "furniture_pot_ceramic_1") then return "[$2022]" end
	if (id == "furniture_pot_ceramic_2") then return "[$2023]" end
	if (id == "furniture_pot_ceramic_3") then return "[$2024]" end
	return "[$2025]"
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "identify", 
	function(target,user)
		if (not CanUseNPC(user)) then return end
		if (target == nil or not target:IsValid()) then return end
			text = GetIdentity(target)

			if (GetPrice ~= 0) then
				sellTarget = target
				text = text .. "\n\nI'll buy it for [F7F700]"..GetPrice(target).." gold.[-]"
				response[1] = {}
				response[1].text = "It's all yours.[F7F700](Receive "..GetPrice(target).." gold)[-]"
				response[1].handle = "SellArtifact" 
			end
			response[2] = {}
			response[2].text = "Thank you."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Actions",response)
	end)

--RegisterEventHandler(EventType.ClientTargetGameObjResponse, "decipher", 
--	function(target,user)
--	end)

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function( ... )
        AddUseCase(this,"Interact",true)
    end)