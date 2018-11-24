require 'base_ai_mob'
require 'base_ai_intelligent'
--require 'base_ai_sleeping'
require "incl_dialogwindow"
require 'incl_faction'
require 'base_npc_extensions'

AI.Settings.Leash = true
AI.Settings.StationedLeash = true


--npc's should all have this
function IsFriend(target)
	if (target == nil or not target:IsValid()) then return false end
	local favorability = GetFaction(target) or 0
    --My only enemy is the enemy
    if (AI.InAggroList(target)) then
        return false
    else
		if (favorability == nil) then return false end
		if (favorability < 0) then return false end
        return true
    end
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
		
		local opinionOfUser = user:GetObjVar("DiagodasOpinion")
		local hasQuestForBook = user:GetObjVar("DiagodasYihosiglok")

		local favorability = GetFaction(user)
		if (favorability ~= 0 and favorability < 0) then return end

		GetAttention(user)
		--new person
		if (opinionOfUser == nil) then
			text = "[$2251]"

			response = {}

			response[1] = {}
			response[1].text = "Who are you, exactly?"
			response[1].handle = "Who" 

			response[2] = {}
			response[2].text = "Can you provide assistance?"
			response[2].handle = "Help" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			user:SetObjVar("DiagodasOpinion","Greetings")

			NPCInteraction(text,this,user,"Question",response)

		elseif (opinionOfUser == "Greetings" and hasQuestForBook == nil) then

			text = "[$2252]"

			response = {}

			response[1] = {}
			response[1].text = "Who are you, exactly?"
			response[1].handle = "Who" 

			response[2] = {}
			response[2].text = "Can you provide assistance?"
			response[2].handle = "Help" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)

		elseif (opinionOfUser == "Greetings" and hasQuestForBook == "Searching") then

			text = "Hau'kommen again, do you have the book I seek?"

			response = {}

			response[1] = {}
			response[1].text = "I do have the book."
			response[1].handle = "OfferYihosiglok" 

			response[3] = {}
			response[3].text = "I do not yet."
			response[3].handle = "Nevermind" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)

		elseif (opinionOfUser == "SpellScrolls" and hasQuestForBook == nil) then

			text = "Hau'kommen again, do you have the spell scrolls?"

			response = {}

			response[1] = {}
			response[1].text = "I do have scrolls."
			response[1].handle = "OfferScroll" 

			response[3] = {}
			response[3].text = "I do not yet."
			response[3].handle = "Nevermind" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)

		elseif (opinionOfUser == "SpellScrolls" and hasQuestForBook == "Searching") then

			text = "[$2253]"

			response = {}

			response[1] = {}
			response[1].text = "I do have scrolls."
			response[1].handle = "OfferScroll" 

			response[2] = {}
			response[2].text = "I do have the book."
			response[2].handle = "OfferYihosiglok"

			response[3] = {}
			response[3].text = "I do not yet."
			response[3].handle = "Nevermind" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
	function (user,buttonId)
		GetAttention(user)
		if (not CanUseNPC(user)) then return end

		local opinionOfUser = user:GetObjVar("DiagodasOpinion")

		local favorability = GetFaction(user)
		if (favorability ~= 0 and favorability < 0) then return end
		if (favorability == nil) then favorability = 0 end

		if (buttonId == "Nevermind") then
			
			text="What else can I do for you, outsider?"

			response = {}

			response[1] = {}
			response[1].text = "Who are you, exactly?"
			response[1].handle = "Who" 

			response[2] = {}
			response[2].text = "Can you provide assistance?"
			response[2].handle = "Help" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Who") then

			text = "[$2254]"

			response = {}

			response[1] = {}
			response[1].text = "So your specialty is magic?"
			response[1].handle = "Magic" 

			response[2] = {}
			response[2].text = "What about converts?"
			response[2].handle = "Converts" 

			response[3] = {}
			response[3].text = "You were born into the cult?"
			response[3].handle = "BornInto" 

			response[4] = {}
			response[4].text = "Right."
			response[4].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end


		if(buttonId == "Help") then

			text = "What can I do to assist you, outsider?"

			response = {}

			response[1] = {}
			response[1].text = "I need to learn magic."
			response[1].handle = "LearnMagic" 

			response[2] = {}
			response[2].text = "I want to gain favor."
			response[2].handle = "GainFavor" 

			response[3] = {}
			response[3].text = "I need items."
			response[3].handle = "Items" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end

		if(buttonId == "Question") then

			text = "[$2255]"

			response = {}
			response[1] = {}
			response[1].text = "Why is the cult so hostile?"
			response[1].handle = "Hostile" 

			response[2] = {}
			response[2].text = "What do you believe?"
			response[2].handle = "Believe" 

			response[3] = {}
			response[3].text = "Why is this area forbidden?"
			response[3].handle = "Forbidden" 

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Magic") then

			text = "[$2256]"

			response = {}

			response[1] = {}
			response[1].text = "What spells do you know?"
			response[1].handle = "Spells" 

			response[2] = {}
			response[2].text = "I can get you spell scrolls."
			response[2].handle = "Scrolls" 

			response[3] = {}
			response[3].text = "Can you teach me anything?"
			response[3].handle = "LearnMagic" 

			response[4] = {}
			response[4].text = "Right."
			response[4].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Converts") then

			text = "[$2257]"

			response = {}

			response[3] = {}
			response[3].text = "Right."
			response[3].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "BornInto") then

			text = "[$2258]"

			response = {}

			response[3] = {}
			response[3].text = "Right."
			response[3].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "LearnMagic") then

			text = "[$2259]"

			response = {}

			response[2] = {}
			response[2].text = "Sounds good to me."
			response[2].handle = "AcceptYihosiglok" 

			response[3] = {}
			response[3].text = "I'm not interested."
			response[3].handle = "Nevermind." 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "GainFavor") then

			text = "[$2260]"

			response = {}

			response[3] = {}
			response[3].text = "Alright."
			response[3].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Items") then

			text = "[$2261]"

			response = {}

			response[3] = {}
			response[3].text = "Alright."
			response[3].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Hostile") then

			text = "[$2262]"

			response = {}

			response[2] = {}
			response[2].text = "Isn't that heresy?"
			response[2].handle = "Believe" 

			response[3] = {}
			response[3].text = "I suppose so."
			response[3].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Believe") then

			text = "[$2263]"

			response = {}

			response[3] = {}
			response[3].text = "Yeah, I suppose so."
			response[3].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Forbidden") then

			text = "[$2264]"

			response = {}

			response[3] = {}
			response[3].text = "Right."
			response[3].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Spells") then

			text = "[$2265]"

			response = {}

			response[3] = {}
			response[3].text = "Alright then."
			response[3].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "Scrolls") then

			text = "[$2266]"

			response = {}

			response[2] = {}
			response[2].text = "We have a deal."
			response[2].handle = "AcceptScrolls"

			response[3] = {}
			response[3].text = "Nevermind."
			response[3].handle = "Nevermind" 

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "AcceptScrolls") then

			text = "[$2267]"

			response = {}

			response[2] = {}
			response[2].text = "I have some right now..."
			response[2].handle = "OfferScroll" 

			response[3] = {}
			response[3].text = "Alright then."
			response[3].handle = "Nevermind" 

			user:SetObjVar("DiagodasOpinion","SpellScrolls")

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "AcceptYihosiglok") then

			text = "Splended. Let me know when you find that book."

			response = {}

			response[2] = {}
			response[2].text = "I have it right now..."
			response[2].handle = "OfferYihosiglok" 

			response[3] = {}
			response[3].text = "Alright then."
			response[3].handle = "Nevermind" 

			user:SetObjVar("DiagodasYihosiglok","Searching")

			responses = {response}

			NPCInteraction(text,this,user,"Question",response)
		end
		if(buttonId == "OfferYihosiglok") then

			text="Well, let me see it then!"

			user:SystemMessage("Select the Book of Yihosiglok.","info")
			user:RequestClientTargetGameObj(this, "BookOfYihsiglok")

			response = {}

			response[1] = {}
			response[1].text = "Nevermind."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	

		end
		if(buttonId == "OfferScroll") then

			text="Let me see the scroll you have."

			user:SystemMessage("Select the spell scroll.","info")
			user:RequestClientTargetGameObj(this, "SpellScroll")

			response = {}

			response[1] = {}
			response[1].text = "Nevermind."
			response[1].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Question",response)	

		end
	end)

function IsSpellScroll(target)
	if (target == nil or not target:IsValid()) then return false end
	if (target:HasModule("spell_scroll")) then return true end
	return false
end

function IsBookOfYihosiglok(target)
	if (target == nil or not target:IsValid()) then return false end
	if (target:HasModule("note") and target:HasObjVar("BookOfYihosiglok")) then return true end
	return false
end

function GetPrice(target)
	if (target == nil) then return 0 end
	local spellType = target:GetObjVar("Spell")
	if (spellType == nil) then return 0 end
	if (spellType == "Fireball") then return 12 end
	if (spellType == "Teleport") then return 15 end
	if (spellType == "Lightning") then return 20 end
	if (spellType == "Heal") then return 14 end
	if (spellType == "Cloak") then return 22 end
	return 0
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "SpellScroll", 
	function(target,user)
		local price = GetPrice(target)
		local isScroll = IsSpellScroll(target)
		if (not CanUseNPC(user)) then return end
		if price > 0 and isScroll == true then

			sellTarget = target
			response = {}
			--if he/she's sellable, pop up dialog asking if he wants to sell it.
			text="[$2268]"..price.."[-] Copper!"
				
			response[1] = {}
			response[1].text = "Sounds good.[F7F700](Receive "..price.." Copper)[-]"
			response[1].handle = "Accept" 

			response[2] = {}
			response[2].text = "No, I don't think so."
			response[2].handle = "Nevermind" 
			
			user:SetObjVar("DiagodasOpinion","Greetings")

			NPCInteraction(text,this,user,"Actions",response)
		else
			text="[$2269]"

			response = {}

			response[2] = {}
			response[2].text = "Oh."
			response[2].handle = "" 

			NPCInteraction(text,this,user,"Actions",response)
		end
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "BookOfYihsiglok", 
	function(target,user)
		if (not CanUseNPC(user)) then return end
		local isBook = IsBookOfYihosiglok(target)
		if isBook == true then

			sellTarget = target
			response = {}
			--if he/she's sellable, pop up dialog asking if he wants to sell it.
			text="[$2270]"

			user:DelObjVar("DiagodasYihosiglok")

			local backpackObj = user:GetEquippedObject("Backpack")  
			local dropPos = GetRandomDropPosition(backpackObj)
	    	CreateObjInContainer("lscroll_teleport", backpackObj, dropPos, nil)
	        user:SystemMessage("You have received a Teleport Scroll!","info")

	        target:Destroy()

			response[2] = {}
			response[2].text = "Thanks!"
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Actions",response)

		else

			text="That is not the book I seek."

			response = {}

			response[2] = {}
			response[2].text = "Oh."
			response[2].handle = "Nevermind" 

			NPCInteraction(text,this,user,"Actions",response)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Actions",
	function (user,buttonId)
		if (not CanUseNPC(user)) then return end
		if (buttonId == "Nevermind") then
			
			text="What else can I do for you, outsider?"

			response = {}

			response[1] = {}
			response[1].text = "Who are you, exactly?"
			response[1].handle = "Who" 

			response[2] = {}
			response[2].text = "Can you provide assistance?"
			response[2].handle = "Help" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)
		end
		if (buttonId == "Accept" and sellTarget ~= nil) then

			local backpackObj = user:GetEquippedObject("Backpack")

			CreateObjInContainer("coin_purse", backpackObj, GetRandomDropPosition(backpackObj), "LootCoinPurse", GetPrice(sellTarget))
			
			sellTarget:Destroy()

			text="[$2271]"

			response = {}

			response[1] = {}
			response[1].text = "Who are you, exactly?"
			response[1].handle = "Who" 

			response[2] = {}
			response[2].text = "Can you provide assistance?"
			response[2].handle = "Help" 

			response[3] = {}
			response[3].text = "I have a question."
			response[3].handle = "Question" 

			response[4] = {}
			response[4].text = "Goodbye."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Question",response)

		end
	end)

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
    function( ... )
        AddUseCase(this,"Interact",true)
    end)