require 'base_ai_npc'
require 'incl_ai_patrolling'
require 'incl_regions'
require 'incl_player_titles'

--table.insert(AI.IdleStateTable, {StateName = "GoLocation",Type = "pleasure"})

--[[QuestDialog = {
    {
        QuestID = "StartingQuest",
        TaskID = "FindMayor",
    }
}]]

AI.Settings.MaxChaseTime = 1

--[[NPCTasks = {
--[[    FragrentMushroomGathering = {
        TaskName = "FragrentMushroomGathering",
        TaskDisplayName = "The Fragrant Mushroom",
        Description = "Find a Fragrant Mushroom.",
        FinishDescription = "Bring it back to the Mayor.",
        RewardType = "coins",
        RewardAmount = 100,
        Repeatable = true, --if you can redo the task
        Importance = 2, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1105]",
        TaskAcceptSpeech = "[$1106]",
        TaskCurrentSpeech = "Any luck so far on finding that mushroom?",
        TaskContinueSpeech = "[$1107]",
        TaskCancelSpeech = "[$1108]",
        TaskHelpSpeech = "[$1109]",
        TaskPreCompleteSpeech = "[$1110]",
        TaskFinishedMessage = "[$1111]",
        TaskIncompleteMessage = "[$1112]",
        TaskAssists = {
                      {Template = "cel_blacksmith",Text = "[$1113]"},
                      {Template = "cel_merchant_bartenders_wife",Text = "[$1114]"},
                      {Template = "cel_village_beatrix",Text = "[$1115]"},
                      {Template = "cel_merchant_general_store",Text = "[$1116]"},
                      },
        CheckCompletionCallback = "Items",
        CompletionCallback = "Items",
        TaskItemList = {
            {"ingredient_fragrent_mushroom",1},
        },
        Faction = "Villagers",
        FactionOnFinish = 6,
    },

    IntelCultistsTask = {
        TaskName = "IntelCultistsTask",
        TaskDisplayName = "Intel on the Cult",
        Description = "Find 5 Cultist Notes.",
        FinishDescription = "Bring them back to the Mayor.",
        RewardType = "coins",
        RewardAmount = 850,
        TaskMinimumFaction = 25,
        Repeatable = false, --if you can redo the task
        Importance = 1, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1117]",
        TaskAcceptSpeech = "[$1118]",
        TaskCurrentSpeech = "[$1119]",
        TaskContinueSpeech = "[$1120]",
        TaskCancelSpeech = "[$1121]",
        TaskHelpSpeech = "[$1122]",
        TaskPreCompleteSpeech = "[$1123]",
        TaskFinishedMessage = "[$1124]",
        TaskIncompleteMessage = "[$1125]",
        TaskAssists = {
                      {Template = "cel_rothchilde",Text = "[$1126]"},
                      {Template = "cel_guard_rufus",Text = "[$1127]"},
                      {Template = "cel_village_beatrix",Text = "[$1128]"},
                      {Template = "cel_merchant_general_store",Text = "[$1129]"},
                      },                     
        CheckCompletionCallback = function (user,task)
            local backpackObj = user:GetEquippedObject("Backpack")
            local items = FindItemsInContainerRecursive(backpackObj,function (item)
                if (item:HasModule("note")) then return true end
            end)
            local count = 0
            for i, j in pairs(items) do
                if (string.match(j:GetCreationTemplateId(),"cultist_note_")) then
                    count = count + 1
                end
            end
            if (count >= 5) then return true end
            return false
        end,
        CompletionCallback = function (user,task)
            local backpackObj = user:GetEquippedObject("Backpack")
            local items = FindItemsInContainerRecursive(backpackObj,function (item)
                if (item:HasModule("note")) then return true end
            end)
            local count = 0
            for i, j in pairs(items) do
                if (string.match(j:GetCreationTemplateId(),"cultist_note_")) then
                    count = count + 1
                    if (count <= 5) then
                        j:Destroy()
                    end
                end
            end
            if (count >= 5) then 
                DoTaskFinish(user,task)
            end
            return false
        end,
        Faction = "Villagers",
        FactionOnFinish = 6,
    },

    CultistScriptureTask = {
        TaskName = "CultistScriptureTask",
        TaskDisplayName = "Sonus Apocolyptica",
        RewardType = "relic_of_the_firstborn",
        Description = "Find all 10 Cultist Scriptures.",
        FinishDescription = "Bring them back to the Mayor.",
        TaskMinimumFaction = 35,
        RewardAmount = 1,
        Repeatable = false, --if you can redo the task
        Importance = 5, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1130]",
        TaskAcceptSpeech = "[$1131]",
        TaskCurrentSpeech = "Do you have the scripture that we need?",
        TaskContinueSpeech = "[$1132]",
        TaskCancelSpeech = "[$1133]",
        TaskHelpSpeech = "[$1134]",
        TaskPreCompleteSpeech = "[$1135]",
        TaskFinishedMessage = "[$1136]",
        TaskIncompleteMessage = "[$1137]",
        TaskAssists = {
                      {Template = "cel_rothchilde",Text = "[$1138]"},
                      {Template = "cel_guard_rufus",Text = "[$1139]"},
                      {Template = "cel_village_beatrix",Text = "[$1140]"},
                      },                      
        CheckCompletionCallback = function (user,task)
            local backpackObj = user:GetEquippedObject("Backpack")
            local items = FindItemsInContainerRecursive(backpackObj,function (item)
                if (item:HasModule("note")) then return true end
            end)
            local count = {false,false,false,false,false,false,false,false,false,false}
            for i, j in pairs(items) do
                if (string.match(j:GetCreationTemplateId(),"cultist_scripture_")) then
                    if     (string.match(j:GetCreationTemplateId(),"cultist_scripture_a")) then
                        --DebugMessage(1)
                        count[1] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_b")) then
                        --DebugMessage(2)
                        count[2] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_c")) then
                        --DebugMessage(3)
                        count[3] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_d")) then
                        --DebugMessage(4)
                        count[4] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_e")) then
                        --DebugMessage(5)
                        count[5] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_f")) then
                        --DebugMessage(6)
                        count[6] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_g")) then
                        --DebugMessage(7)
                        count[7] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_h")) then
                        --DebugMessage(8)
                        count[8] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_i")) then
                        --DebugMessage(9)
                        count[9] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_j")) then
                        --DebugMessage(10)
                        count[10] = true
                    end
                end
            end
            for i,j in pairs(count) do
                if not j then return false end
            end
            return true
        end,
        CompletionCallback = function (user,task)
            local backpackObj = user:GetEquippedObject("Backpack")
            local items = FindItemsInContainerRecursive(backpackObj,function (item)
                if (item:HasModule("note")) then return true end
            end)
            local count = {false,false,false,false,false,false,false,false,false,false}
            for i, j in pairs(items) do
                if (string.match(j:GetCreationTemplateId(),"cultist_scripture_")) then
                    if     (string.match(j:GetCreationTemplateId(),"cultist_scripture_a")) then
                        count[1] = true
                        j:Destroy()
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_b")) then
                        j:Destroy()
                        count[2] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_c")) then
                        j:Destroy()
                        count[3] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_d")) then
                        j:Destroy()
                        count[4] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_e")) then
                        j:Destroy()
                        count[5] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_f")) then
                        j:Destroy()
                        count[6] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_g")) then
                        j:Destroy()
                        count[7] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_h")) then
                        j:Destroy()
                        count[8] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_i")) then
                        j:Destroy()
                        count[9] = true
                    elseif (string.match(j:GetCreationTemplateId(),"cultist_scripture_j")) then
                        j:Destroy()
                        count[10] = true
                    end
                end
            end
            for i,j in pairs(count) do
                if not j then return false end
            end
            PlayerTitles.CheckTitleGain(user,AllTitles.ActivityTitles.Relic3,1,"relic_of_the_firstborn")
            DoTaskFinish(user,task)
        end,
        Faction = "Villagers",
        FactionOnFinish = 6,
    },
]]--
--}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$1141]",
} 

AI.TradeMessages = 
{
	"[$1142]",
}

AI.GreetingMessages = 
{
	"[$1143]",
	"[$1144]",
	"[$1145]",
}

AI.AskHelpMessages =
{
	"[$1146]",
	"Well what do you need on this day?",
	"Anything for a friend! What troubles you this day?",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.NevermindMessages = 
{
    "Anything else I can assist you with, good sir?",
    "Any other questions or concerns?",
    "Anything else that concerns me my good man?",
}

AI.AskNeedMessages = 
{
    "Well what do you need my good man?"
}

AI.TalkMessages = 
{
	"[$1147]",
	"Certainly! Ask away my good man! Ask!",
    "[$1148]"
}

AI.WhoMessages = {
	"[$1149]",
}

AI.PersonalQuestion = {
	"[$1150]",
    "[$1151]",
    "[$1152]"
}

AI.HowMessages = {
	"[$1153]",
}

AI.FamilyMessage = {
	"[$1154]",
	}

AI.SpareTimeMessages= {
	"[$1155]",
}

AI.WhatMessages = {
	"...Why yes, good sir, what is it?",
	"...Regarding what my good man?",
	"Erhm ... Regarding...?",
}

AI.StoryMessages = {
	"[$1156]"
}

MayorLocations = CeladorData.MayorLocations

AI.StateMachine.AllStates.GoLocation = {
        OnEnterState = function()
            if(math.random(1,3)==1) then
                destination = MayorLocations[math.random(#MayorLocations)]
                this:PathTo(destination.Loc,1.0,"GoLocation")
            else
                destination = { Name="Wander", Loc=GetRandomPassableLocation("Market") }
                this:PathTo(destination.Loc,1.0,"GoLocation")
            end
        end,

        OnArrived = function (success)
            if(success) then
                if (AI.StateMachine.CurState ~= "GoLocation") then
                    return 
                end
                if (AI.StateMachine.CurState ~= "Converse") then
                    return 
                end
                if( destination ~= nil ) then 
                    if(destination.Facing ~= nil) then
                        this:SetFacing(destination.Facing)
                    end
                    if( destination.Name == "VillageWell" ) then
                        this:PlayAnimation("cast")
                    end
                    if (destination.Type == "Merchant") then
                        nearestMerchant = FindObject(SearchMulti({
                            SearchHasObjVar("IsMerchant"),
                            SearchObjectInRange(10)}))
                        if (nearestMerchant ~= nil) then
                            nearestMerchant:SendMessage("NPCAskPrice")
                            AI.IdleTarget = nearestMerchant
                            this:NpcSpeech(GetSpeechTable("MerchantBuyerSpeech")[math.random(1,#GetSpeechTable("MerchantBuyerSpeech"))])
                            AI.StateMachine.ChangeState("Converse")
                        end
                    end
                end
            end
            --DebugMessage("Go Location")
            if (AI.StateMachine.CurState == "GoLocation") then
                DecideIdleState()
            end
        end,
    }

function IntroDialog(user)
    Dialog.OpenGreetingDialog(user)
end

function Dialog.OpenTalkDialog(user)

    text = AI.TalkMessages[math.random(1,#AI.TalkMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What do you know about..."
    response[1].handle = "What" 

    response[2] = {}
    response[2].text = "I have a question regarding..."
    response[2].handle = "Regarding" 

    response[3] = {}
    response[3].text = "Who are you anyway?"
    response[3].handle = "Who" 

    response[4] = {}
    response[4].text = "What is this place?"
    response[4].handle = "Celador"

    response[5] = {}
    response[5].text = "Nevermind."
    response[5].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenRegardingDialog(user)
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...What happened to the city?"
    response[1].handle = "Imprisoning" 

    response[2] = {}
    response[2].text = "...The village?"
    response[2].handle = "Village" 

    response[3] = {}
    response[3].text = "...The people living in tents???"
    response[3].handle = "Tents"

    response[4] = {}
    response[4].text = "...The strict laws?"
    response[4].handle = "Laws" 

    response[5] = {}
    response[5].text = "...What happened to the council?"
    response[5].handle = "Council" 

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...The plight of the people?"
    response[1].handle = "People" 

    response[2] = {}
    response[2].text = "...The elections?"
    response[2].handle = "Elections" 

    response[3] = {}
    response[3].text = "...The next town meeting?"
    response[3].handle = "TownMeeting"

    response[4] = {}
    response[4].text = "...Taxes?"
    response[4].handle = "Taxes" 

    response[5] = {}
    response[5].text = "...The quarry?"
    response[5].handle = "Quarry" 

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 


    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What's your story?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "Why are you the mayor?"
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

function Dialog.OpenCantDialog(user)
    --DFB TODO: Make this dialog disappear and implement it based on a per-task basis!
    DialogReturnMessage(this,user,"[$1168]","Right.")
end
function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$1169]","Right, Thank you.")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog

function Dialog.OpenVillageDialog(user)
	DialogReturnMessage(this,user,"[$1170]","Right.")
end
function Dialog.OpenTentsDialog(user)
	DialogReturnMessage(this,user,"[$1171]","Right.")
end
function Dialog.OpenLawsDialog(user)
	DialogReturnMessage(this,user,"[$1172]","Well then.")
end
function Dialog.OpenTaxesDialog(user)
    DialogReturnMessage(this,user,"[$1173]","Oh... sorry.")
end
function Dialog.OpenCouncilDialog(user)
    DialogReturnMessage(this,user,"[$1174]","Oh... Wow.")
end
function Dialog.OpenPeopleDialog(user)
    DialogReturnMessage(this,user,"[$1175]","Whatever.")
end
function Dialog.OpenTownMeetingDialog(user)
    DialogReturnMessage(this,user,"[$1176]","Right.")
    user:SetObjVar("CouncilmanThomas",true)
    --user:SendMessage("StartQuest","CouncilmanQuest")
end
function Dialog.OpenElectionsDialog(user)
    DialogReturnMessage(this,user,"[$1177]","That's great.")
end
function Dialog.OpenQuarryDialog(user)
    DialogReturnMessage(this,user,"[$1178]","Oh... sorry.")
end
function Dialog.OpenFamilyDialog(user)
	DialogEndMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)],"Oh...")
end
function Dialog.OpenSpareTimeDialog(user)
	DialogReturnMessage(this,user,AI.SpareTimeMessages[math.random(1,#AI.SpareTimeMessages)],"Oh.")
end
function Dialog.OpenHowDialog(user)
	DialogReturnMessage(this,user,AI.HowMessages[math.random(1,#AI.HowMessages)],"Oh.")
end
function Dialog.OpenStoryDialog(user)
	DialogReturnMessage(this,user,AI.StoryMessages[math.random(1,#AI.StoryMessages)],"Oh.")
end
function Dialog.OpenLastNameDialog(user)
	DialogReturnMessage(this,user,"[$1179]","Ah.")
end

RegisterEventHandler(EventType.Arrived, "GoLocation",AI.StateMachine.AllStates.GoLocation.OnArrived)
