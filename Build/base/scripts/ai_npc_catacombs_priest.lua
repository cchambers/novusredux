require 'base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = false
AI.Settings.EnableBuy = false
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = false

fixPrice = 20

NPCTasks = {
}

AI.QuestList = {}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = false
AI.QuestMessages = {}

Sermons = {
    {
    "[$679]",
    "[$680]",
    "[$681]",
    "[$682]",
    "Never fear though, my brethren",
    "For in time, we will triumph!",
    "We will succeed, and victory will be ours!",
    "For this is not but a test of faith!",
    "[$683]",
    "[$684]",
    "And victory will be all the sweeter.",
    "For in due time, all things will be revealed.",
    "And in due time all will know the Way.",
    "Let us pray now, in the name of the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "THE WAY OF THE WAYUN!!!",
    },
    {
    "[$685]",
    "[$686]",
    "[$687]",
    "[$688]",
    "[$689]",
    "And the Way was known to ALL.",
    "But in the time when the star fell,",
    "And the evil powers came to our world,",
    "[$690]",
    "The Gods of the Good Portal came to our help.",
    "When we cried in NEED, the Wayun came to our help.",
    "All should be known that this is the truth",
    "That the only purpose they serve, is to serve man.",
    "Let us pray now, in the name of the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "THE WAY OF THE WAYUN!!!",
    },
    {
    "[$691]",
    "[$692]",
    "And that they seek out all life to change.",
    "For the more one knows, the better we will become,",
    "For the Way is KNOWLEDGE, the Way is LIFE.",
    "[$693]",
    "The Will of the Wayun!",
    "It is said this is a dark time for our clan...",
    "A punishment for our sins.",
    "[$694]",
    "But our faith in the Wayun,",
    "That they will show the Wayward their will,",
    "...their will in keeping us here",
    "For that is all we desire, is it not?",
    "The Way of the Wayun.",
    "Let us pray now, in the name of the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "Observe the Way! Observe the Way!",
    "THE WAY OF THE WAYUN!!!",
    },
}

AI.IntroMessages =
{ --note that this is a single string on multiple lines
	"[$695]"
} 

AI.GreetingMessages = 
{
	"Ah beautiful, kind one, what can I do for you?",
    "Blessings of the Wayward to you my child.",
    "What can I do for you my son?"
}

AI.CantAffordPurchaseMessages = {
	"[$696]",
}

AI.AskHelpMessages =
{
	"Anything for you, dear son.",
    "Yes my child, whatever you need."
}

AI.RefuseTrainMessage = {
	"[$697]",
}

AI.WellTrainedMessage = {
	"[$698]",
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
	"[$699]",
}

AI.NevermindMessages = 
{
    "...Anything else dear child?",
    "...Anything I can do for you now?",
}

AI.TalkMessages = 
{
	"What can I teach you, my son?",
}

AI.WhoMessages = {
	"[$700]" ,
}

AI.PersonalQuestion = {
	"Anything for you, kind one.",
}

AI.HowMessages = {
    "[$701]"
}

AI.FamilyMessage = {
    "[$702]"
}

AI.SpareTimeMessages= {
	"[$703]",
}

AI.WhatMessages = {
	"Well, what would you like to know?",
}

AI.StoryMessages = {
	"[$704]",
}  
BEGIN_SERMON_TIME = 10
PULSE_TIME = 4200
AI.StateMachine.AllStates.Preach = {
        GetPulseFrequencyMS = function() return PULSE_TIME end,

        OnEnterState = function()
           local sermonLoc = this:GetObjVar("PreachLocation")
           mSermonChoice = math.random(1,#Sermons)
           this:PathTo(sermonLoc:GetLoc(),1.0,"PathToSermonLoc")
           this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(PULSE_TIME*BEGIN_SERMON_TIME + PULSE_TIME*#Sermons[mSermonChoice]),"EndSermon")
           RegisterSingleEventHandler(EventType.Timer,"EndSermon",function ( ... )
               if (mSermonDelayCount == nil or mSermonDelayCount == 0) then return end
               AI.StateMachine.ChangeState("GoHome")
           end)
        end,

        OnArrived = function (success)
            mBeginSermon = true --should start the sermon
            mSermonDelayCount = 0
            if not (success) then
                --something went wrong, tele him there
                local sermonLoc = this:GetObjVar("PreachLocation")
                if (sermonLoc ~= nil) then
                    --if it doesn't get here he'll start the sermon where he's standing
                    this:SetWorldPosition(sermonLoc:GetLoc())
                end
            end
        end,

        OnExitState = function()
            --end the sermon
            mBeginSermon = nil
            mSermonChoice = nil
            mSermonDelayCount = nil
            local sermonAttendies = FindObjects(SearchMulti({SearchModule("ai_catacombs_stranger_worshiper"),SearchMobileInRange(20)}))
            --DebugMessage("Exiting prayer, number of sermon attendies is "..tostring(#sermonAttendies))
            for i,j in pairs(sermonAttendies) do
                j:DelObjVar("Ritual")
                j:SendMessage("EndPrayMessage")
                --DebugMessage("Sending end prayer message to "..j:GetName())
            end
        end,

       AiPulse = function()
            if (mSermonChoice == nil) then mSermonChoice = math.random(1,#Sermons) end
            if (mSermonDelayCount == nil) then mSermonDelayCount = 0 end
            local sermonAttendies = FindObjects(SearchMulti({SearchModule("ai_catacombs_stranger_worshiper"),SearchMobileInRange(20)}))
            --DebugMessage("-------------------------------")
            --DebugMessage("Pulsing")
            --search for attendies, if I have enough and I have arrived start the sermon
            --DebugMessage(mSermonDelayCount .. "is sermon count")
            --DebugMessage(mSermonChoice .. "is sermon choice")
            --DebugMessage(#sermonAttendies .. "is sermon attendies")
            --DebugMessage("Sermon delay count is "..tostring(mSermonDelayCount))
            if mSermonDelayCount > BEGIN_SERMON_TIME then
                this:NpcSpeech(Sermons[mSermonChoice][mSermonDelayCount-BEGIN_SERMON_TIME] or "") --preach to the masses
                local nearbyPlayers = FindObjects(SearchPlayerInRange(25))
                for i,j in pairs(nearbyPlayers) do
                     j:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToPriest","ObserveSermon")
                end
                if (mSermonDelayCount > 15 + BEGIN_SERMON_TIME) then
                    --DFB TODO: play effects here
                    this:PlayAnimation("cast_heal")
                    --DebugMessage("Sending pray message to "..#sermonAttendies)
                    for i,j in pairs(sermonAttendies) do
                        j:SetObjVar("Ritual",true)
                    end
                end
            end
            mSermonDelayCount = mSermonDelayCount + 1 --increase the sermon speech index
        end,    
    }

RegisterEventHandler(EventType.Arrived,"PathToSermonLoc",AI.StateMachine.AllStates.Preach.OnArrived)

RegisterEventHandler(EventType.Message,"StartSermon",
function (sender)
    this:SetObjVar("PreachLocation",sender)
    AI.StateMachine.ChangeState("DecidingCombat")
    AI.StateMachine.ChangeState("Preach")
end)

function Dialog.OpenCatacombsStartQuestObserveSermonDialog(user)
    local sermonObj = FindObject(SearchTemplate("worship_location"))
    local delay = sermonObj:GetTimerDelay("StartSermon")
    if (delay ~= nil and not(AI.StateMachine.CurState == "Preach")) then
        --nextSpeechTime = delay.Minutes
        --if (nextSpeechTime <= 0) then
        this:NpcSpeech("I'll start the sermon soon. Do not worry.")
        sermonObj:SendMessage("StartSermon")
        --else
        --    this:NpcSpeech("My child, the next sermon is in "..tostring(nextSpeechTime).. " minutes, wait here...")
        --end
    else
        this:NpcSpeech("My child, the sermon is in progress.")
    end
end

function Dialog.OpenCatacombsStartQuestTalkToPriestDialog(user)
    if (AI.StateMachine.CurState == "Preach") then
        this:NpcSpeech("...Just a minute!")
        return
    end

    text = "[$705]"

    response = {}

    response[1] = {}
    response[1].text = "Because I'm here?"
    response[1].handle = "GuessAgain"

    response[2] = {}
    response[2].text = "It is what the Wayun will...?"
    response[2].handle = "YesButNo"

    response[3] = {}
    response[3].text = "I'm help from the Wayun"
    response[3].handle = "Bingo"

    response[4] = {}
    response[4].text = "I walked through a portal"
    response[4].handle = "GuessAgain" 

    response[5] = {}
    response[5].text = "Erm... I don't know."
    response[5].handle = "GuessAgain" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end
Dialog.OpenCatacombsStartQuestAnswerRiddleDialog = Dialog.OpenCatacombsStartQuestTalkToPriestDialog

function Dialog.OpenSlayVoidGuardianQuestTalkToPriestDialog(user)
    user:SendMessage("FinishQuest","SlayVoidGuardianQuest")
    user:SendMessage("StartQuest","SlayTheGeneralQuest")
    user:SystemMessage("[00D700]You have recieved a Book of Summon Portal!","info")
    CreateObjInBackpack(user,"bindportal_teleporter",createId)  
    local sourceLoc = Loc(12.16, 0.6783409, 33.23)
    local destLoc = Loc(-27.32, 0.168584, -170.80)
    OpenTwoWayPortal(sourceLoc,destLoc,300)
    text = "[$706]"

    response = {}

    response[1] = {}
    response[1].text = "What's beyond the Guardian?"
    response[1].handle = "BeyondGuardian"

    response[2] = {}
    response[2].text = "Goodbye."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end
function Dialog.OpenBeyondGuardianDialog(user)
    text = "[$707]"

    response = {}

    response[1] = {}
    response[1].text = "What can I do?"
    response[1].handle = "SlayDeath"

    response[2] = {}
    response[2].text = "Goodbye."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenSlayDeathDialog(user)
    text = "[$708]"

    response = {}

    response[1] = {}
    response[1].text = "I will stop Death."
    response[1].handle = "StopDeath"

    response[2] = {}
    response[2].text = "Goodbye."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenStopDeathDialog(user)
    --user:SendMessage("AdvanceQuest","SlayTheGeneralQuest","FindGeneral")
    QuickDialogMessage(this,user,"[$709]")
end

function Dialog.OpenYesButNoDialog(user)
    text = "[$710]"

    response = {}

    response[1] = {}
    response[1].text = "Because I'm here?"
    response[1].handle = "GuessAgain"

    response[2] = {}
    response[2].text = "It is what the Wayun will...?"
    response[2].handle = "YesButNo"

    response[3] = {}
    response[3].text = "I'm help from the Wayun"
    response[3].handle = "Bingo"

    response[4] = {}
    response[4].text = "I walked through a portal"
    response[4].handle = "GuessAgain" 

    response[5] = {}
    response[5].text = "Erm... I don't know."
    response[5].handle = "GuessAgain" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenGuessAgainDialog(user)
    text = "No, not quite."

    response = {}

    response[1] = {}
    response[1].text = "Because I'm here?"
    response[1].handle = "GuessAgain"

    response[2] = {}
    response[2].text = "It is what the Wayun will...?"
    response[2].handle = "YesButNo"

    response[3] = {}
    response[3].text = "I'm help from the Wayun"
    response[3].handle = "Bingo"

    response[4] = {}
    response[4].text = "I walked through a portal"
    response[4].handle = "GuessAgain" 

    response[5] = {}
    response[5].text = "Erm... I don't know."
    response[5].handle = "GuessAgain" 


    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenBingoDialog(user)

    text = "[$711]"

    response = {}

    response[1] = {}
    response[1].text = "What is going on"
    response[1].handle = "GoingOn"

    --response[2] = {}
   -- response[2].text = "What do you need ME for?"
    --response[2].handle = "Ready"

    response[3] = {}
    response[3].text = "I'm ready to help you"
    response[3].handle = "Ready"

    response[4] = {}
    response[4].text = "Goodbye"
    response[4].handle = "" 

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenGoingOnDialog(user)
    text = "[$712]"

    response = {}

    response[1] = {}
    response[1].text = "Yes I am from the Wayun."
    response[1].handle = "Ready"

    response[2] = {}
    response[2].text = "No not me."
    response[2].handle = ""

    response[3] = {}
    response[3].text = "Goodbye..."
    response[3].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end

function Dialog.OpenReadyDialog(user)
    ChangeFactionByAmount(user,10,"Wayun")
    user:SendMessage("FinishQuest","CatacombsStartQuest")
    user:SendMessage("StartQuest","SaveGuardQuest")
    QuickDialogMessage(this,user,"[$713]")
end

function Dialog.OpenCatacombsRearrangeQuestInvestigateDialog(user)
    CheckAchievementStatus(user, "Other", "SurvivorOfTheChanging", nil, {Description = "", CustomAchievement = "Survivor Of The Changing", Reward = {Title = "Survivor Of The Changing"}})
    QuickDialogMessage(this,user,"[$714]")
end

function CanBuyItem(buyer,item)
    if (not HasFinishedQuest(buyer,"CatacombsStartQuest")) then
        this:NpcSpeech("...")
        return false
    else
        return true
    end
end

function IntroDialog(user)
    --[[user:SendMessage("AdvanceQuest","CatacombsStartQuest","TalkToSomeone","Investigate")
    if (not HasFinishedQuest(user,"CatacombsStartQuest") or user:HasObjVar("SkipQuest")) then
        if (GetPlayerQuestState(user,"CatacombsStartQuest") == "TalkToThePriest" and not AI.StateMachine.CurState == "Preach") then
            local sermonObj = FindObject(SearchTemplate("worship_location"))
            if (sermonObj ~= nil) then
            else
                DebugMessage("[ai_npc_catacombs_priest] ERROR: Could not start sermon, worship location not found.")
            end
            return
        end
        this:NpcSpeech("[$715]")
        return
    else]]--
        text = AI.IntroMessages[math.random(1,#AI.IntroMessages)]
    --end
    user:SetObjVar("Intro|Perthaus the Priest",true)

    response = {}

    response[1] = {}
    response[1].text = "What is this place?"
    response[1].handle = "Where"

    response[2] = {}
    response[2].text = "Why didn't you talk to me?"
    response[2].handle = "TalkToPlayer"

    response[2] = {}
    response[2].text = "The pleasure is mine."
    response[2].handle = "Nevermind" 


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

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1,#AI.WhatMessages)]

    response = {}

    response[1] = {}
    response[1].text = "...The evil that dwells here?"
    response[1].handle = "Monsters" 

    response[2] = {}
    response[2].text = "...Your role?"
    response[2].handle = "Role" 

    response[3] = {}
    response[3].text = "...Kho?"
    response[3].handle = "Kho"

    response[4] = {}
    response[4].text = "...The Wayun?"
    response[4].handle = "Wayun" 

    response[5] = {}
    response[5].text = "...Your people?"
    response[5].handle = "Wayward"

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenWhoDialog(user)

    text = AI.WhoMessages[math.random(1,#AI.WhoMessages)]

    response = {}

    response[1] = {}
    response[1].text = "What is your story?"
    response[1].handle = "Story" 

    response[2] = {}
    response[2].text = "How did you end up a priest?"
    response[2].handle = "How" 

    response[3] = {}
    response[3].text = "Might I ask you a personal question?"
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
    response[2].text = "What is your last name?"
    response[2].handle = "LastName" 

    response[3] = {}
    response[3].text = "What do you do in your spare time?"
    response[3].handle = "SpareTime"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)

end
function Dialog.OpenSlayTheGeneralQuestTalkToPriest2Dialog(user)
    text = "[$716]"

    response = {}

    response[1] = {}
    response[1].text = "I slayed Death, and met a Wayun."
    response[1].handle = "YouAreWinner"

    response[2] = {}
    response[2].text = "Not sure what your talking about."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end
function Dialog.OpenYouAreWinnerDialog(user)
    text = "[$717]"

    response = {}

    response[1] = {}
    response[1].text = "The Wayun have a message for you!"
    response[1].handle = "YouAreWinnerTwo"

    response[2] = {}
    response[2].text = "Nevermind. Goodbye."
    response[2].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end
function Dialog.OpenYouAreWinnerTwoDialog(user)
    user:SendMessage("FinishQuest","SlayTheGeneralQuest")
    this:PlayAnimation("dance")
    user:SystemMessage("[00D700]You have recieved a Map of Catacombs!","info")
    -- DAB TODO: Dead quest just disabling dead code
    --local currentConfig = GetCurrentCatacombsConfiguration() 
    --CreateObjInBackpack(user,"catacombs_config"..currentConfig.."_map_scroll")  
    text = "[$718]"

    response = {}

    response[1] = {}
    response[1].text = "Thanks."
    response[1].handle = ""

    response[2] = {}
    response[2].text = "There is something you need to know."
    response[2].handle = "SomethingToKnow"

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end
function Dialog.OpenSomethingToKnowDialog(user)
    text = "[$719]"

    response = {}

    response[1] = {}
    response[1].text = "Kamus said the temple cannot be saved."
    response[1].handle = "CannotBeSaved"

    response[2] = {}
    response[2].text = "Your gods aren't gods."
    response[2].handle = "NotGods"

    response[3] = {}
    response[3].text = "This isn't a temple to the Wayun."
    response[3].handle = "NotATempleToWayun"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end
function Dialog.OpenCannotBeSavedDialog(user)
    text = "[$720]"

    response = {}

    response[1] = {}
    response[1].text = "This isn't a temple to the Wayun either."
    response[1].handle = "NotATempleToWayun"

    response[2] = {}
    response[2].text = "Your gods aren't gods either."
    response[2].handle = "NotGods"

    response[3] = {}
    response[3].text = "Everything you know is a lie."
    response[3].handle = "EverythingIsLies"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end
function Dialog.OpenNotGodsDialog(user)
    text = "[$721]"

    response = {}

    response[1] = {}
    response[1].text = "They're humans from another universe."
    response[1].handle = "EverythingIsLies"

    response[3] = {}
    response[3].text = "Everything you know is a lie."
    response[3].handle = "EverythingIsLies"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end
function Dialog.OpenNotATempleToWayunDialog(user)
    text = "[$722]"

    response = {}

    response[3] = {}
    response[3].text = "Everything you know is a lie."
    response[3].handle = "EverythingIsLies"

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = ""

    NPCInteraction(text,this,user,"Responses",response)

    GetAttention(user)
end
function Dialog.OpenEverythingIsLiesDialog(user)
    user:SendMessage("CheckAchievement", "Other", "FaithBreaker", nil, {Description = "", CustomAchievement = "Faith Breaker", Reward = {Title = "Faith Breaker"}})
    DialogReturnMessage(this,user,"[$723]")
end
function Dialog.OpenTalkToPlayerDialog(user)
    DialogReturnMessage(this,user,"[$724]","Right.")
end
function Dialog.OpenWhereDialog(user)
    DialogReturnMessage(this,user,"[$725]","Right.")
end
function Dialog.OpenMonstersDialog(user)
	DialogReturnMessage(this,user,"[$726]","Right.")
end
function Dialog.OpenRoleDialog(user)
    DialogReturnMessage(this,user,"[$727]","Right.")
end
function Dialog.OpenKhoDialog(user)
    DialogReturnMessage(this,user,"[$728]","Right.")
end
function Dialog.OpenWayunDialog(user)
    DialogReturnMessage(this,user,"[$729]","Right.")
end
function Dialog.OpenWaywardDialog(user)
    DialogReturnMessage(this,user,"[$730]","Interesting.")
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
    DialogReturnMessage(this,user,"[$731]","Oh, alright.")
end

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",ResponsesDialog)

