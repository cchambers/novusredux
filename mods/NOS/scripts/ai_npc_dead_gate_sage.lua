require 'NOS:base_ai_npc'

NPCTasks = {
}

function HasExplorationQuestNote(user)
    local backpack = user:GetEquippedObject("Backpack")
    if (backpack == nil) then return false end
    local NoteObject = FindItemInContainerRecursive(backpack,function (item)
        if item:HasObjVar("AegisContactNote") then
            return true
        end
    end)
    if (NoteObject ~= nil) then return true end
end

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = false
AI.Settings.StationedLeash = true
fixPrice = 20

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$790]"

} 

AI.TradeMessages = 
{
	"I have little to trade with, neophyte.",
}

AI.GreetingMessages = 
{
	"[$791]",
	"Praise the gods. How are you, neophyte?",
	"[$792]",
}

AI.NotInterestedMessage = 
{
	"I'm not interested in that.",
	"I have no need for such things, neophyte.",
}

AI.NotYoursMessage = {
	"Do not covet, neophyte. That is not yours to sell.",
	"[$793]",
	"[$794]",
}

AI.CantAffordPurchaseMessages = {
	"[$795]",
}

AI.AskHelpMessages =
{
	"What can I help you with, undevoted one?",
	"[$796]",
	"I think I can help you out. What do you need?",
	"Well sure, what can I assist you with?",
}

AI.RefuseTrainMessage = {
	"If you do not desire such, then I shall abstain.",
	"That's quite alright, I'm not going anywhere soon.",
}

AI.WellTrainedMessage = {
	"[$797]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"I can teach you a few things.",
	"[$798]",
	"[$799]",
}

AI.NevermindMessages = 
{
    "Is there anything else, neophyte?",
    "Anything else I can help you with?",
    "[$800]",
}

AI.TalkMessages = 
{
	"I have answers to your questions, neophyte.",
	"[$801]",
	"I am open to all forms of discussion, neophyte.",
	"What is your question, strange one?",
}

AI.WhoMessages = {
	"[$802]",
	"[$803]",
}

AI.PersonalQuestion = {
	"You may ask, but I have little to share.",
    "[$804]",
    "[$805]"
}

AI.HowMessages = {
	"[$806]",
}

AI.FamilyMessage = {
	"[$807]",
}

AI.SpareTimeMessages= {
	"[$808]",
}

AI.WhatMessages = {
	"...With what regard, neophyte...?",
	"...In what sense...?",
	"...Regarding?",
	"...Regarding...?",
}

AI.StoryMessages = {
	"[$809]"
}

function Dialog.OpenDeadGateIntroQuestTalkToAegisDialog(user)

    text = "[$810]"
    
    response = {}

    if (GetPlayerQuestState(user,"DeadGateIntroQuest") == "TalkToAegis") then
        response[1] = {}
        response[1].text = "I have a letter for you."
        response[1].handle = "Letter" 
    end

    response[2] = {}
    response[2].text = "...Yes."
    response[2].handle = "ActivateDeadGate" 

    response[3] = {}
    response[3].text = "...Knowledge of the gate?"
    response[3].handle = "ActivateDeadGate" 

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)

end

function Dialog.OpenHelpDialog(user)	

	text = AI.AskHelpMessages[math.random(1,#AI.AskHelpMessages)]
	
	response = {}

	response[1] = {}
	response[1].text = "I want to activate this gate."
	response[1].handle = "ActivateDeadGate" 

    response[2] = {}
    response[2].text = "I want to free Tethys."
    response[2].handle = "Tethys" 

    response[1] = {}
    response[1].text = "I need to know water magic."
    response[1].handle = "WaterMagic" 

	response[4] = {}
	response[4].text = "Nevermind."
	response[4].handle = "Nevermind" 

	NPCInteraction(text,this,user,"Responses",response)

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
    response[1].text = "...The Dead Gate?"
    response[1].handle = "ActivateDeadGate" 

    response[2] = {}
    response[2].text = "...The Imprisoning?"
    response[2].handle = "Imprisoning" 

    response[3] = {}
    response[3].text = "...The Goddess?"
    response[3].handle = "Goddess"

    response[4] = {}
    response[4].text = "...The Strangers?"
    response[4].handle = "Strangers"

    response[5] = {}
    response[5].text = "...Why are you here?"
    response[5].handle = "WhyAmIHere"

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
    response[2].text = "Why are you a priest?"
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

old_NevermindDialog = NevermindDialog
function NevermindDialog(user)

    if (GetPlayerQuestState(user,"DeadGateIntroQuest") == "TalkToAegis") then
        text = AI.NevermindMessages[math.random(1,#AI.NevermindMessages)]

        response[1] = {}
        response[1].text = "I have a letter for you."
        response[1].handle = "Letter" 

        NPCInteractionLongButton(text,this,user,"Responses",response)
    else
        old_NevermindDialog(user)
    end
end

function Dialog.OpenLetterDialog(user)
    local backpackObj = user:GetEquippedObject("Backpack")  
    QuickDialogMessage(this,user,"[$811]")
    noteContents = "[$812]"
    local NoteObject = FindItemInContainerRecursive(backpackObj,function (item)
        return item:HasObjVar("ThomasContactNote")
    end)
    if (NoteObject ~= nil) then NoteObject:Destroy() end
    CreateObjInBackpack(user,"scroll_readable","ContactNote",{"AegisNote",noteContents}) 
    user:SetObjVar("AgeisFinished",true)
end

RegisterEventHandler(EventType.CreatedObject,"ContactNote",
    function(success,objRef,args)
        local objVarName,noteContents = table.unpack(args)
        if (success) then
            objRef:SetObjVar(objVarName,true)
            objRef:SendMessage("WriteNote",noteContents)
            objRef:SetObjVar("Worthless",true)
        end
    end)

function Dialog.OpenCantDialog(user)
    --DFB TODO: Make this dialog disappear and implement it based on a per-task basis!
    DialogReturnMessage(this,user,"I am unable to do that, neophyte.","Right.")
end
function Dialog.OpenCeladorDialog(user)
	DialogReturnMessage(this,user,"[$813]","Right.")
end
function Dialog.OpenActivateDeadGateDialog(user)
    text = "[$814]"

    response = {}

    if (GetPlayerQuestState(user,"DeadGateIntroQuest") == "TalkToAegis") then
        response[1] = {}
        response[1].text = "I have a letter for you."
        response[1].handle = "Letter" 
    end

    response[2] = {}
    response[2].text = "Who created the Dead Gate?"
    response[2].handle = "CreatedDeadGate" 
    
    response[3] = {}
    response[3].text = "Why does nobody know this?"
    response[3].handle = "KnowDeadGate" 

    response[4] = {}
    response[4].text = "Oh wow, alright. Thanks."
    response[4].handle = "Nevermind." 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end
function Dialog.OpenCreatedDeadGateDialog(user)
    text = "[$815]"

    response = {}

    response[1] = {}
    response[1].text = "...Wow. OK."
    response[1].handle = "Nevermind" 

    response[2] = {}
    response[2].text = "...What are the Elder Gods."
    response[2].handle = "WhatAreElderGods" 

    response[3] = {}
    response[3].text = "Why does nobody know this?"
    response[3].handle = "KnowDeadGate" 

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)

end
function Dialog.OpenWhatAreElderGodsDialog(user)
    DialogReturnMessage(this,user,"[$816]","...Wow. Right. Thanks!")
end
function Dialog.OpenKnowDeadGateDialog(user)
    DialogReturnMessage(this,user,"[$817]","That's interesting.")
end
function Dialog.OpenImprisoningDialog(user)
    DialogReturnMessage(this,user,"[$818]","Yeah... that's messed up.")
end
function Dialog.OpenTethysDialog(user)
    DialogReturnMessage(this,user,"[$819]","Right.")
end
function Dialog.OpenGoddessDialog(user)
    DialogReturnMessage(this,user,"[$820]","Right.")
end
function Dialog.OpenStoryDialog(user)
    DialogReturnMessage(this,user,"[$821]","Thanks.")
end
function Dialog.OpenStrangersDialog(user)
    DialogReturnMessage(this,user,"[$822]","Huh. Interesting...")
end
Dialog.OpenWhereDialog = Dialog.OpenCeladorDialog

function Dialog.OpenFamilyDialog(user)
	DialogReturnMessage(this,user,AI.FamilyMessage[math.random(1,#AI.FamilyMessage)],"Oh... Sorry.")
end
function Dialog.OpenSpareTimeDialog(user)
	DialogReturnMessage(this,user,AI.SpareTimeMessages[math.random(1,#AI.SpareTimeMessages)],"Interesting.")
end
function Dialog.OpenHowDialog(user)
	DialogReturnMessage(this,user,AI.HowMessages[math.random(1,#AI.HowMessages)],"Oh.")
end
function Dialog.OpenWhyAmIHereDialog(user)
	DialogReturnMessage(this,user,AI.StoryMessages[math.random(1,#AI.StoryMessages)],"Oh.")
end
function Dialog.OpenLastNameDialog(user)
	DialogReturnMessage(this,user,"[$823]","Oh.")
end