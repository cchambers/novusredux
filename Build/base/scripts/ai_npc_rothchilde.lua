require 'base_ai_npc'

AI.Settings.EnableTrain = false
AI.Settings.EnableMerchant = false
AI.Settings.StationedLeash = true
fixPrice = 20

AI.QuestList = {"RepublicOfPetraQuest"}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = true
--AI.QuestMessages = {"Welcome to the Republic of Petra.","You would make a fine Citizen.","Come hither, newcomer."}

--[[NPCTasks = {
    BreadRetrevialTask = {
        TaskName = "BreadRetrevialTask",
        TaskDisplayName = "Feeding the Poor",
        Description = "Find 10 food items.",
        FinishDescription = "Bring them back to the Rothchilde.",
        RewardType = "ancient_map",
        RewardAmount = 1,
        Repeatable = true, --if you can redo the task
        Importance = 2, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1242]",
        TaskAcceptSpeech = "[$1243]",
        TaskCurrentSpeech = "Have you found the food I seek?",
        TaskContinueSpeech = "[$1244]",
        TaskCancelSpeech = "[$1245]",
        TaskHelpSpeech = "[$1246]",
        TaskPreCompleteSpeech = "[$1247]",
        TaskFinishedMessage = "[$1248]",
        TaskIncompleteMessage = "[$1249]",
        TaskAssists = {
                      {Template = "cel_merchant_general_store",Text = "[$1250]"},
                      {Template = "cel_mayor",Text = "[$1251]"},
                      {Template = "cel_blacksmith",Text = "[$1252]"},
                      {Template = "cel_merchant_bartender",Text = "[$1253]"},
                    },
        CheckCompletionCallback = function (user,task)
            if (user:GetEquippedObject("Backpack") == nil) then
                DebugMessage("ERROR: "..user:GetName().."'s backpack was gone!")
                return false
            end
            local items = FindItemsInContainerRecursive(user:GetEquippedObject("Backpack"),
            function (item)
                return item:HasModule("food")
            end)
            if (#items > 9) then
                return true
            end
            return false
        end,
        CompletionCallback = function (user,task)
            if (user:GetEquippedObject("Backpack") == nil) then
                DebugMessage("ERROR: "..user:GetName().."'s backpack was gone!")
                return 
            end
            local items = FindItemsInContainerRecursive(user:GetEquippedObject("Backpack"),
            function (item)
                return item:HasModule("food")
            end)
            local n = 0
            for i,j in pairs(items) do
                if (n < 10) then
                    j:Destroy()
                    n = n + 1
                end
            end
            DoTaskFinish(user,task)
        end,
        Faction = "Villagers",
        FactionOnFinish = 6,
        FactionOnAccept = 1,
    },
    --[[WormExtractTask = {
        TaskName = "WormExtractTask",
        TaskDisplayName = "Worms of Kho",
        RewardType = "recipe_painting5",
        Description = "Get 5 bottles of Worm Extract.",
        FinishDescription = "Bring them back to the Rothchilde.",
        RewardAmount = 1,
        Repeatable = false, --if you can redo the task
        Importance = 4, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1254]",
        TaskAcceptSpeech = "[$1255]",
        TaskCurrentSpeech = "Did you manage to harvest the worm extract?",
        TaskContinueSpeech = "Well keep searching. The Extract must flow.",
        TaskCancelSpeech = "[$1256]",
        TaskHelpSpeech = "[$1257]",
        TaskPreCompleteSpeech = "[$1258]",
        TaskFinishedMessage = "[$1259]",
        TaskIncompleteMessage = "[$1260]",
        TaskAssists = {
                      {Template = "cel_guard_rufus",Text = "[$1261]"},
                      {Template = "cel_mayor",Text = "[$1262]"},
                      {Template = "cel_blacksmith",Text = "[$1263]"},
                      {Template = "cel_merchant_general_store",Text = "[$1264]"},
                    },
        CompletionCallback = "Items",
        CheckCompletionCallback = "Items",
        TaskItemList = {
        {"animalparts_worm_extract",5}
        },
        Faction = "Villagers",
        FactionOnFinish = 5,
        FactionOnAccept = 1,
    },
    AncientBearClawTask = {
        TaskName = "AncientBearClawTask",
        TaskDisplayName = "The Ancient Bear",
        RewardType = "shield_large_silver",
        Description = "Slay an Ancient Bear and take his claws.",
        FinishDescription = "Bring the claw back to Rothchilde.",
        RewardAmount = 1,
        TaskMinimumFaction = 15,
        Description = "Take a claw from an Ancient Bear",
        CompletionDescription = "Bring the claw to Rothchilde",
        Repeatable = false, --if you can redo the task
        Importance = 4, --these are sorted from the player on asking, the tasks with the top five highest importance are displayed on interaction with an NPC
        TaskDescriptionSpeech = "[$1265]",
        TaskAcceptSpeech = "[$1266]",
        TaskCurrentSpeech = "Did you manage to slay the Ancient Bear?",
        TaskContinueSpeech = "[$1267]",
        TaskCancelSpeech = "[$1268]",
        TaskHelpSpeech = "[$1269]",
        TaskPreCompleteSpeech = "[$1270]",
        TaskFinishedMessage = "[$1271]",
        TaskIncompleteMessage = "[$1272]",
        TaskAssists = {
                      {Template = "cel_guard_rufus",Text = "[$1273]"},
                      {Template = "cel_mayor",Text = "[$1274]"},
                      {Template = "cel_blacksmith",Text = "[$1275]"},
                      {Template = "cel_merchant_general_store",Text = "[$1276]"},
                      {Template = "cel_village_beatrix",Text = "[$1277]"},
                    },
        CompletionCallback = "Items",
        CheckCompletionCallback = "Items",
        TaskItemList = {
        {"animalparts_ancient_bear_claw",1}
        },
        Faction = "Villagers",
        FactionOnFinish = 6,
        FactionOnAccept = 1,
    },
}--]]

AI.IntroMessages =
{ 
    "[$1278]"--note that this is a single string on multiple lines
} 

AI.TradeMessages = 
{
	"[$1279]",
	"[$1280]",
	"[$1281]",
	"Anything for a such a wonderful person.",
}

AI.GreetingMessages = 
{
	"[$1282]",
	"Good day, newcomer! I'm so happy to see you.",
	"Greetings and good tidings!",
}

AI.NotInterestedMessage = 
{
	"I'm not interested that sort of thing, sorry.",
	"I don't want that, thank you.",
    "I'm definitely not interested in that.",
	"I'm not looking to buy that, sorry.",
}

AI.NotYoursMessage = {
	"I'm not about to buy something you can't sell.",
	"[$1283]",
	"[$1284]",
}

AI.CantAffordPurchaseMessages = {
	"[$1285]",
	"I'll be needing coin..sorry, training isn't free..",
	"[$1286]",
}

AI.AskHelpMessages =
{
	"Certainly, what do you need?",
	"[$1287]",
	"[$1288]",
}

AI.RefuseTrainMessage = {
	"[$1289]",
	"[$1290]",
}

AI.WellTrainedMessage = {
	"[$1291]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$1292]",
	"[$1293]",
	"[$1294]",
}

AI.NevermindMessages = 
{
    "Anything else I can assist you with?",
    "Is there anything else I can help you with?",
    "Anything else, my dear friend?",
}

AI.TalkMessages = 
{
	"[$1295]",
	"I'm always open to talking to the newcomers.",
}

AI.WhoMessages = {
	"[$1296]",
}

AI.PersonalQuestion = {
	"[$1297]",
    "[$1298]",
    "[$1299]"
}

AI.HowMessages = {
	"[$1300]",
}

AI.FamilyMessage = {
	"[$1301]",
	}

AI.SpareTimeMessages= {
	"[$1302]",
}

AI.WhatMessages = {
	"...In what regard...?",
	"...Dealing with...?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$1303]"
}
--CHANGE THIS NOW

function IntroDialog(user)

    if (user:HasObjVar("OpenedDialog|Rothchilde the Councilman")) then
        text = "You again. Are you ready to fufill your purpose?"
    else
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    end
    user:SetObjVar("OpenedDialog|Rothchilde the Councilman",true)

    response = {}

    response[1] = {}
    response[1].text = "Why did the \"Strangers\" send me?"
    response[1].handle = "StrangersQuest" 
--[[
    response[2] = {}
    response[2].text = "I want to become a Citizen."
    response[2].handle = "CitizenshipQuest"
--]]
    response[3] = {}
    response[3].text = "Don't care. Goodbye."
    response[3].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenQuestsDialog(user)
    text = "[$1304]"

    response = {}
    --[[
    if (GetPlayerQuestState(user,"RelicQuest") == nil) then
        response[1] = {}
        response[1].text = "...Erm, why am in Celador again?"
        response[1].handle = "StrangersQuest" 
    end
        if (GetPlayerQuestState(user,"RepublicOfPetraQuest") == nil) then
        response[2] = {}
        response[2].text = "Tell me about Citizenship."
        response[2].handle = "CitizenshipQuest" 
    end
    --]]

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "" 
    
    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenStrangersQuestDialog(user)

    text = "[$1305]"

    response = {}

    response[1] = {}
    response[1].text = "I'm interested."
    response[1].handle = "AcceptRelicQuest" 

    response[2] = {}
    response[2].text = "Who are the Strangers?"
    response[2].handle = "Strangers"

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenAcceptRelicQuestDialog(user)
    user:SendMessage("StartQuest","RelicQuest")
    QuickDialogMessage(this,user,"[$1306]")
    user:SendMessage("ShowHint","[$1307]")
end

function Dialog.OpenAcceptCitizenshipQuestDialog(user)
    user:SendMessage("StartQuest","RepublicOfPetraQuest")
    QuickDialogMessage(this,user,"[$1308]")
    user:SendMessage("ShowHint","[$1309]")
end

function Dialog.OpenCitizenshipQuestDialog(user)
    
    text = "[$1310]"
    
    response = {}

    response[1] = {}
    response[1].text = "I'm interested."
    response[1].handle = "AcceptCitizenshipQuest" 

    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenGreetingDialog(user)
    if ( GetPlayerQuestState(user,"RelicQuest") == nil or
         GetPlayerQuestState(user,"RepublicOfPetraQuest") == nil ) then
        Dialog.OpenQuestsDialog(user)
        return
    end

    text = AI.GreetingMessages[math.random(1,#AI.GreetingMessages)]

    response = {}

    response[1] = {}
    response[1].text = "I want to know something..."
    response[1].handle = "Talk" 

    if (AI.GetSetting("MerchantEnabled") ~= nil and AI.GetSetting("MerchantEnabled") == true) then
        response[2] = {}
        response[2].text = "I want to trade..."
        response[2].handle = "Trade" 
    else
        response[2] = {}
        response[2].text = "Who are you?"
        response[2].handle = "Who" 
    end

    response[3] = {}
    response[3].text = "It's regarding work..."
    response[3].handle = "Work" 

    if (AI.GetSetting("EnableTrain") ~= nil and AI.GetSetting("EnableTrain") == true and CanTrain()) then
        response[5] = {}
        response[5].text = "Train me in a skill..."
        response[5].handle = "Train" 
    end

    response[6] = {}
    response[6].text = "Goodbye."
    response[6].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenStrangersDialog(user)
    text = "[$1311]"

    response = {}

    response[1] = {}
    response[1].text = "Fine."
    response[1].handle = "StrangersQuest" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenRelicQuestFindSourceOfPowerDialog(user)
    QuickDialogMessage(this,user,"[$1312]")
end

function Dialog.OpenRelicQuestTalkToRothchilde2Dialog(user)

    text = "[$1313]"

    response = {}

    response[1] = {}
    response[1].text = "Thank you."
    response[1].handle = "" 

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
    response[2].text = "Why am I here again?"
    response[2].handle = "DeadGate" 

    response[3] = {}
    response[3].text = "Who are you anyway?"
    response[3].handle = "Who" 

    response[4] = {}
    response[4].text = "What is this place?"
    response[4].handle = "Where"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...The Imprisoning?"
    response[1].handle = "Imprisoning" 

    response[2] = {}
    response[2].text = "...What is the Council?"
    response[2].handle = "Council" 

    response[3] = {}
    response[3].text = "...Where I came from?"
    response[3].handle = "CameFrom"

    response[4] = {}
    response[4].text = "...The Gods?"
    response[4].handle = "Gods" 

    response[5] = {}
    response[5].text = "...Magic involving death?"
    response[5].handle = "Death" 

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
    response[2].text = "Why are you a councilman?"
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

function Dialog.OpenCouncilmanQuestConfrontCouncilDialog(user)
    DialogReturnMessage (user,"[$1314]","Alright... sure...")
    user:SetObjVar("RotchildeRegardingThomas",true)
end

function Dialog.OpenDeathDialog(user)
    DialogReturnMessage(this,user,"[$1315]","Right.")
    this:PlayAnimation("cast_heal")
    user:SendMessage("BindToLocation",user:GetLoc())            
end

function Dialog.OpenOutlandsRebelQuestBringMessageToRothchildeDialog(user)
    text = "Do you value your life, "..user:GetName().."?"

    response = {}

    response[1] = {}
    response[1].text = "...Yes."
    response[1].handle = "ValueYourLife" 

    response[2] = {}
    response[2].text = "...No."
    response[2].handle = "ClearyYouDoNotValueYourLife" 

    response[3] = {}
    response[3].text = "...I have a message for you."
    response[3].handle = "ClearyYouDoNotValueYourLife" 

    response[4] = {}
    response[4].text = "Erm, goodbye..."
    response[4].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenCultistRelicQuestTalkToRothchildeDialog(user)
    text = "[$1316]"

    response = {}

    response[1] = {}
    response[1].text = "...I serve only the Elder Gods."
    response[1].handle = "WithTheXor" 

    response[2] = {}
    response[2].text = "...I follow only the strong."
    response[2].handle = "OnlyTheStrong" 

    response[3] = {}
    response[3].text = "...I don't care either way."
    response[3].handle = "DontCareAboutXor" 

    response[4] = {}
    response[4].text = "...How dare you manipulate them!"
    response[4].handle = "MixedLoyalties" 

    response[5] = {}
    response[5].text = "...Screw you."
    response[5].handle = "YouMadeATerribleMistake" 

    response[6] = {}
    response[6].text = "Uh, Bye!"
    response[6].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)
end

function Dialog.OpenWithTheXorDialog(user)
    QuickDialogMessage(this,user,"[$1317]")
    SetFactionToAmount(user,50,"Cultists")
    CreateObjInBackpack(user,"coin_purse","coins",500)
    PlayerTitles.EntitleFromTable(user,AllTitles.ActivityTitles.XorServant)
    user:SystemMessage("You have recieved 500 Copper!")
end

function Dialog.OpenOnlyTheStrongDialog(user)
    QuickDialogMessage(this,user,"[$1318]")
    CreateObjInBackpack(user,"coin_purse","coins",250)
    user:SystemMessage("You have recieved 250 Copper!")
end

function Dialog.OpenDontCareAboutXorDialog(user)
    QuickDialogMessage(this,user,"[$1319]")
end

function Dialog.OpenMixedLoyaltiesDialog(user)
    QuickDialogMessage(this,user,"[$1320]")
end

function Dialog.OpenYouMadeATerribleMistakeDialog(user)
    SetFactionToAmount(user,-45,"Villagers")
    --SetFactionToAmount(user,-45,"Cultists")
    PlayerTitles.EntitleFromTable(user,AllTitles.ActivityTitles.Stupid)
    ChangeFactionByAmount(user,35,"Rebels")
    QuickDialogMessage(this,user,"[$1321]")
end

function Dialog.OpenValueYourLifeDialog(user)
    user:SendMessage("AdvanceQuest","OutlandsRebelQuest","SpeakToBeauregard")
    user:SystemMessage("[D70000]You have recieved Head of a Rebel Spy!")
    CreateObjInBackpack(user,"head_of_spy","head_created") 
    DialogReturnMessage(this,user,"[$1322]","Fine.")
end

function Dialog.OpenClearyYouDoNotValueYourLifeDialog(user)
    user:SendMessage("AdvanceQuest","OutlandsRebelQuest","SpeakToBeauregard")
    user:SystemMessage("[D70000]You have recieved Head of a Rebel Spy!")
    CreateObjInBackpack(user,"head_of_spy","head_created") 
    DialogReturnMessage(this,user,"[$1323]","Fine.")
end

function Dialog.OpenCantDialog(user)
    --DFB TODO: Make this dialog disappear and implement it based on a per-task basis!
    DialogReturnMessage(this,user,"[$1324]","Right.")
end
function Dialog.OpenWhereDialog(user)
	DialogReturnMessage(this,user,"[$1325]","Right.")
end

function Dialog.OpenCouncilDialog(user)
    DialogReturnMessage(this,user,"[$1326]","Right.")
end
function Dialog.OpenImprisoningDialog(user)
	DialogReturnMessage(this,user,"[$1327]","Right.")
end
function Dialog.OpenCameFromDialog(user)
    DialogReturnMessage(this,user,"[$1328]","Gee, thanks...")
end
function Dialog.OpenGodsDialog(user)
    DialogReturnMessage(this,user,"[$1329]","Right.")
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
	DialogReturnMessage(this,user,"[$1330]","That's great...")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)
