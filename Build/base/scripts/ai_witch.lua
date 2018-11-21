require 'base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.SetIntroObjVar = true
AI.Settings.EnableBuy = false
AI.Settings.StationedLeash = true
AI.Settings.CanConverse = false

NPCTasks = {
}

AI.QuestList = {}
AI.Settings.KnowName = false 
AI.Settings.HasQuest = false
AI.QuestMessages = {}

AI.DialogMessages = {
    "Do you wish to know your fate and fortune?",
    "Do not fear my power... Do you wish to enterain your fate?",
    "You, do you wish to seek out you destiny?",
    "I have a blessing for you! Do you wish to face it?",
    "A greater power has something in store for you. Two of them. Do you wish to seek it?",
    "There is something that stirrs in the world unseen, do you wish to find it?",
    "Do you indeed seek the blessings of Lilith?",
    "Do you indeed seek the invocation of the Goddess Lilith?",
    "I have a power for you. Do you wish... for me to reveal it?",
    "Do you seek the truth and power of Lilith?",
}

Curses = {
    {
        Dialog = "Then you will be CURSED with misfortune!",
        Effect = "Curse",
    },
    {
        Dialog = "Then the insects will come, and they will bite, and you will perish!",
        Effect = "Insects",
    },
    {
        Dialog = "The Goddess Lilith desires for you great fortune!",
        Effect = "Money",
    },
    {
        Dialog = "Then you shall find eternal knowledge!",
        Effect = "SkillBuff",
    },
    {
        Dialog = "Then Lilith shall grant you trial by COMBAT!!!",
        Effect = "Spawns",
    },
    {
        Dialog = "Then you shall be restored to your fullest!",
        Effect = "FullRestore",
    },
    {
        Dialog = "Your future has no meaning to you. You have nothing to fear...",
        Effect = "None",
    },
}

function IntroDialog(user)
    text = AI.DialogMessages[math.random(1,#AI.DialogMessages)]
    
    response = {}

    response[4] = {}
    response[4].text = "...Yes."
    response[4].handle = "CurseThem" 

    response[4] = {}
    response[4].text = "...No."
    response[4].handle = "Nevermind" 

    NPCInteraction(text,this,user,"Responses",response)
end

--DFB TODO: Dialog options.
function Dialog.OpenNevermindDialog(user)
    QuickDialogMessage(this,user,"I am a witch!")
end

--DFB TODO: Dialog options
function Dialog.OpenGreetingDialog(user)
    QuickDialogMessage(this,user,"Hello again! I am a witch!")
end