require 'base_ai_npc'

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = true
AI.Settings.EnableBuy = true
AI.Settings.SetIntroObjVar = false
AI.Settings.StationedLeash = true
AI.Settings.EnableRepair = false

--AI.QuestList = {"BlacksmithIntroQuest_V2"}
--AI.Settings.KnowName = false
--AI.Settings.HasQuest = false
--AI.QuestMessages = {"Great. Now I have to teach him metalsmithing too.","He would make a fine blacksmith."}

fixPrice = 20
--[[
function GetWeaponTaskPouch(user)
    local backpackObj = user:GetEquippedObject("Backpack")
    local pouchItem = FindItemInContainerRecursive(backpackObj,
            function(item)            
                return item:HasObjVar("WeaponPouch")
            end)

    return pouchItem
end
]]--

--[[
function CreateWeaponTaskPouch(user)
    local createId = uuid()
    CreateObjInBackpack(user,"pouch",createId)  
    RegisterSingleEventHandler(EventType.CreatedObject,createId,
            function (success,objRef)
                objRef:SetObjVar("WeaponPouch",true)
                objRef:SetObjVar("Worthless",true)
                objRef:SetName("Samogh's Weapon Pouch")
            end)

    user:SystemMessage("You have received Samogh's Weapon Pouch","event")
end
--]]

--[[NPCTasks = {
    CobaltBlacksmithTask = {
        TaskName = "CobaltBlacksmithTask",
        TaskDisplayName = "Cobalt Ingots",
        Description = "Collect 4 Cobalt Ingots",
        FinishDescription = "Go back and talk to Samogh",
        RewardType = "recipe",
        RecipeMinSkill = 35,
        RecipeMaxSkill = 59,
        RecipeSkill = "MetalsmithSkill",
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$361]",
        TaskAcceptSpeech = "[$362]",
        TaskCurrentSpeech = "Any luck so far on aquiring Cobalt?",
        TaskContinueSpeech = "[$363]",
        TaskCancelSpeech = "[$364]",
        TaskHelpSpeech = "[$365]",
        TaskPreCompleteSpeech = "[$366]",
        TaskFinishedMessage = "[$367]",
        TaskIncompleteMessage = "[$368]",
        TaskAssists = {
                      {Template = "cel_quarry_head_miner",Text = "[$369]"},
                      {Template = "cel_village_beatrix",Text = "[$370]"},
                     },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {{"resource_cobalt_ingots",4}},
        Faction = "Villagers",
        FactionOnFinish = 1,
    },
    GleamingBlacksmithTask = {
        TaskName = "GleamingBlacksmithTask",
        TaskDisplayName = "Gleaming Ingots",
        Description = "Collect 4 Gleaming Iron Ingots",
        FinishDescription = "Go back and talk to Samogh",
        RewardType = "recipe",
        RecipeMaxSkill = 35,
        RecipeSkill = "MetalsmithSkill",
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$371]",
        TaskAcceptSpeech = "[$372]",
        TaskCurrentSpeech = "[$373]",
        TaskContinueSpeech = "[$374]",
        TaskCancelSpeech = "[$375]",
        TaskHelpSpeech = "[$376]",
        TaskPreCompleteSpeech = "[$377]",
        TaskFinishedMessage = "[$378]",
        TaskIncompleteMessage = "[$379]",
        TaskAssists = {
                      {Template = "cel_quarry_head_miner",Text = "[$380]"},
                      {Template = "cel_village_beatrix",Text = "[$381]"},
                     },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {{"resource_iron_ingots_gleaming",4}},
        Faction = "Villagers",
        FactionOnFinish = 1,
    },
    RecoverWeaponsTask = {
        TaskName = "RecoverWeaponsTask",
        TaskDisplayName = "Recovering Weaponry",
        RewardType = "recipe",
        Description = "Obtain 5 weapons of at flimsy or better quality",

        FinishDescription = "Go back and talk to Samogh",
        RewardType = "recipe",
        RecipeMinSkill = 60,
        RecipeMaxSkill = 100,        
        RecipeSkill = "MetalsmithSkill",
        TaskMinimumFaction = 10,
        Repeatable = true, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$382]",
        TaskAcceptSpeech = "[$383]",
        TaskCurrentSpeech = "[$384]",
        TaskContinueSpeech = "[$385]",
        TaskCancelSpeech = "[$386]",
        TaskHelpSpeech = "[$387]",
        TaskPreCompleteSpeech = "[$388]",
        TaskFinishedMessage = "[$389]",
        TaskIncompleteMessage = "[$390]",
        TaskAssists = {
                      {Template = "cel_village_beatrix",Text = "[$391]"},
                      },
        AcceptTaskCallback = function(user,task)
            -- if you already have one, dont give him another one
            if(GetWeaponTaskPouch(user)) then return end

            CreateWeaponTaskPouch(user)
        end,
        CheckCompletionCallback = function (user,task,openedDialog)            
            local pouchObj = GetWeaponTaskPouch(user)
            if not(pouchObj) and openedDialog then 
                if (openedDialog) then 
                    CreateWeaponTaskPouch(user)
                end
                return false
            end

            local weaponItems = FindItemsInContainerRecursive(pouchObj,
                    function(item)            
                        return item:HasObjVar("WeaponType") and (item:GetObjVar("MaxDurability") or 0) >= 20
                    end)

            return #weaponItems >= 5
        end,
        CompletionCallback = function (user,task)
            local pouchObj = GetWeaponTaskPouch(user)
            if not(pouchObj) then 
                return false
            end

            local weaponItems = FindItemsInContainerRecursive(pouchObj,
                    function(item)            
                        return item:HasObjVar("WeaponType") and (item:GetObjVar("MaxDurability") or 0) >= 20
                    end)

            if(#weaponItems >= 5) then
                pouchObj:Destroy()
                DoTaskFinish(user,task)
                return true
            end
            return false
        end,
        Faction = "Villagers",
        FactionOnFinish = 1,
    },   
}--]]


AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"Well well well, look what we have here."
	.."[$392]"
	.."[$393]"
	.."[$394]"
	.."[$395]",
} 

AI.TradeMessages = 
{
	"[$396]",
	"[$397]",
	"[$398]",
	"[$399]",
}

AI.GreetingMessages = 
{
	"[$400]",
	"[$401]",
	"[$402]",
}

AI.HowToPurchaseMessages = {
	"[$403]"
}

AI.NotInterestedMessage = 
{
	"I'm not interested in that.",
	"That's worthless that is. I don't want that.",
	"[$404]",
	"I don't want that.",
}

AI.NotYoursMessage = {
	"That is not yours to sell!",
	"Sure, I'd buy it, if it were yours.",
	"I don't think you own that, right?",
}

AI.CantAffordPurchaseMessages = {
	"[$405]",
	"I don't think you have enough for that.",
	"You don't have enough money to buy that.",
}

AI.CantAffordTrainPurchaseMessages = {
    "I don't think you have enough for that. I require a donation of "
}

AI.AskHelpMessages =
{
	"[$406]",
	"It depends on what you need.",
	"[$407]",
	"[$408]",
}

AI.FixMessage = {
	"[$409]"..fixPrice.." Coins[-], but it won't last as long the next time. You sure?",
}

AI.RefuseTrainMessage = {
	"Whatever. I got better things to do with my time.",
	"I got better things to do anway.",
}

AI.WellTrainedMessage = {
	"[$410]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$411]",
	"[$412]",
	"[$413]",
}

AI.NevermindMessages = 
{
    "Anything else you want?",
    "Anything else?",
    "What else do you need?",
}

AI.TalkMessages = 
{
	"What's your question. Speak up I can't hear you!",
	"[$414]",
	"[$415]",
	"What do you want to know.",
}

AI.WhoMessages = {
	"[$416]",
	"[$417]",
}

AI.PersonalQuestion = {
	"Sure. What is it.",
}

AI.HowMessages = {
	"[$418]",
}

AI.FamilyMessage = {
	"I dont want to talk about it.",
	"That's none of your business.",
	"It's none of your damn business.",
	"I'm not discussing that with you.",
	"[$419]",
}

AI.SpareTimeMessages= {
	"[$420]",
}

AI.WhatMessages = {
	"...About what? Speak up, I can't hear you!",
	"...About...?",
	"...What about?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$421]"
}

function Dialog.OpenHelpDialog(user)	

	text = AI.AskHelpMessages[math.random(1,#AI.AskHelpMessages)]
	
	response = {}

	response[1] = {}
	response[1].text = "I want to learn blacksmithing."
	response[1].handle = "Train" 


	response[4] = {}
	response[4].text = "Nevermind."
	response[4].handle = "Nevermind" 

	NPCInteraction(text,this,user,"Responses",response)

end

function Dialog.OpenFixDialog(user)
	text = AI.FixMessage[math.random(1,#AI.FixMessage)]
	response = {}

	response[3] = {}
	response[3].text = "Sure, fix it."
	response[3].handle = "FixIt" 

	response[4] = {}
	response[4].text = "Nevermind."
	response[4].handle = "Nevermind" 

	NPCInteraction(text,this,user,"Responses",response)

	GetAttention(user)
end

function Dialog.OpenTalkDialog(user)

    text = AI.TalkMessages[math.random(1,#AI.TalkMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What do you know about..."
    response[1].handle = "What" 

    response[2] = {}
    response[2].text = "Who are you anyway?"
    response[2].handle = "Who" 

    response[3] = {}
    response[3].text = "What is this place?"
    response[3].handle = "Where"

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...The so called 'Dead Gate'?"
    response[1].handle = "DeadGate" 

    if (IsLocInRegion(this:GetLoc(), "EldeirVillage"))then
    response[2] = {}
    response[2].text = "...The giant force field behind you?"
    response[2].handle = "Petra" 
    end

    response[3] = {}
    response[3].text = "...The people here?"
    response[3].handle = "People"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What's your story?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "Why are you a blacksmith?"
    response[2].handle = "How" 

    response[3] = {}
    response[3].text = "I have a personal question..."
    response[3].handle = "PersonalQuestion"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)

end

function Dialog.OpenPersonalQuestionDialog(user)

    text = AI.PersonalQuestion[math.random(1,#AI.PersonalQuestion)]

    response = {}

    response[1] = {}
    response[1].text = "Do you have a family?"
    response[1].handle = "Family" 

    response[2] = {}
    response[2].text = "What's your last name?"
    response[2].handle = "LastName" 

    response[3] = {}
    response[3].text = "What do you do in your spare time?"
    response[3].handle = "SpareTime"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)

end

--[[function Dialog.OpenBlacksmithIntroQuest_V2CraftIronIngotsDialog(user)
    --DFB TODO: Change this to $425
    QuickDialogMessage(this,user,"Good. Now you're going to take this [ECD905]Iron Ore[-], and forge it to [ECD905]Iron Ingots[-].\n\nIt's simple, just heat the stones up and pour it into slabs. Use my forge over there. Don't burn yourself now!")

end
function Dialog.OpenBlacksmithIntroQuest_V2TalkToSamogh2Dialog(user)
    --DFB TODO: Change this to $426
    QuickDialogMessage(this,user,"Good. Now you're going to take this [ECD905]Iron Ore[-], and forge it to [ECD905]Iron Ingots[-].\n\nIt's simple, just heat the stones up and pour it into slabs. Use my forge over there. Don't burn yourself now!")
end

function Dialog.OpenBlacksmithIntroQuest_V2CraftDaggerDialog(user)
    --DFB TODO Change this to $427
    QuickDialogMessage(this,user,"Well, you seem to be a natural! Now here's the trickey part, you'll be making a dagger.\n\n You want to take the [ECD905]Iron Ingots[-] and heat them to where you can shape them. Then you take the hammer, and bend them into shape. You'll need the forge for that, obviously.")
end]]

function Dialog.OpenCantDialog(user)
    --DFB TODO: Make this dialog disappear and implement it based on a per-task basis!
    DialogReturnMessage(this,user,"[$428]","Right.")
end
function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$429]","Right.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog
function Dialog.OpenDeadGateDialog(user)
	DialogReturnMessage(this,user,"[$430]","Right.")
end
function Dialog.OpenPetraDialog(user)
	DialogReturnMessage(this,user,"[$431]","OK.")
end
function Dialog.OpenPeopleDialog(user)
	DialogReturnMessage(this,user,"[$432]","Oh.")
end
function Dialog.OpenFamilyDialog(user)
	DialogEndMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)],"Oh... Sorry.")
end
function Dialog.OpenSpareTimeDialog(user)
	DialogReturnMessage(this,user,AI.SpareTimeMessages[math.random(1,#AI.SpareTimeMessages)],"Interesting.")
end
function Dialog.OpenHowDialog(user)
	DialogReturnMessage(this,user,AI.HowMessages[math.random(1,#AI.HowMessages)],"Oh.")
end
function Dialog.OpenStoryDialog(user)
	DialogReturnMessage(this,user,AI.StoryMessages[math.random(1,#AI.StoryMessages)],"Oh.")
end
function Dialog.OpenLastNameDialog(user)
	DialogReturnMessage(this,user,"Horchester. It's Horchester. Samogh Horchester","Oh.")
end


RegisterEventHandler(EventType.ClientTargetGameObjResponse, "blacksmith_fix", 
	function (target,buyer)
		amount = fixPrice
		if( CountCoins(buyer) < amount ) then
			Merchant.DoCantAfford(buyer)
			activeTransactions[transactionId] = nil
			return
		else
			-- everything checks out lets take the coins
			transactionData.State = "TakeCoins"			
			buyer:SetObjVar("ItemToFix",target)
			RequestConsumeResource(buyer,"coins",amount,"fix_item",this)
		end
	end)

function HandleConsumeResourceResponse(success,transactionId,buyer)	

	if( not(ValidateTransaction("TakeCoins",transactionId))) then
		activeTransactions[transactionId] = nil
		return
	end

	-- something went wrong taking the coins
	if( not(success) ) then
		Merchant.DoCantAfford(buyer)		
	-- we have taken the coins complete the transaction
	else
		FixItem(buyer:GetObjVar("ItemToFix"),buyer)		
		buyer:DelObjVar("ItemToFix")
	end

	activeTransactions[transactionId] = nil
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)