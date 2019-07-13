require "NOS:base_ai_npc"

AI.Settings.MerchantEnabled = true
AI.Settings.EnableTrain = true
AI.Settings.EnableBuy = true
AI.Settings.SetIntroObjVar = false
fixPrice = 20

--AI.QuestList = {"MageIntroQuest"}
--AI.Settings.HasQuest = true
--AI.QuestMessages = {", do you seek knowledge of magic?",", I know things that might be of interest to you."}

NPCTasks = {}

AI.IntroMessages = {
    --note that this is a single string on multiple lines
    "What can I do ya for?"
}

AI.TradeMessages = {
    "Okay, talk to me.",
}

AI.GreetingMessages = {
    "Welcome, welcome. Can I interest you in something?"
}

AI.HowToPurchaseMessages = {
    "[$121]"
}

AI.NotInterestedMessage = {
    "I'm not interested in that sort of thing, sorry.",
    "I don't want that, thank you.",
    "I'm definitely not interested in that.",
    "I'm not looking to buy that, sorry."
}

AI.NotYoursMessage = {
    "I'm not about to buy something that isn't yours.",
    "That's not yours, are you playing games with me?.",
    "Even if that was yours I wouldn't buy it."
}

AI.CantAffordPurchaseMessages = {
    "That's not enough to cover costs I'm afraid.",
}

AI.AskHelpMessages = {
    "I can assist you with that, what would you need?",
    "[$124]",
    "What would you need then?"
}

AI.RefuseTrainMessage = {
    "Not today.",
}

AI.WellTrainedMessage = {
    "You know just about everything I can teach you."
}

AI.CannotAffordMessages = AI.CantAffordPurchaseMessages

AI.TrainScopeMessages = {
    "Sure, I can do that.",
}

AI.NevermindMessages = {
    "Anything else I can assist you with...?",
    "Anything else this mage can help you with...?",
    "What else would you desire?"
}

AI.WhoMessages = {
    "Me? I'm just a dude playing a dude dressed as another dude! What can I do for ya?"
}

AI.WhatMessages = {
    "...Regarding...?",
    "...Regarding what?",
    "...Regarding...?"
}

AI.StoryMessages = {
    "[$137]"
}

function Dialog.OpenWhatDialog(user)
    --DebugMessage("WhatDialog")
    text = AI.WhatMessages[math.random(1, #AI.WhatMessages)]

    response = {}

    response[6] = {}
    response[6].text = "Nevermind."
    response[6].handle = "Nevermind"

    NPCInteractionLongButton(text, this, user, "Responses", response)
end

function Dialog.OpenWhoDialog(user)
    text = AI.WhoMessages[math.random(1, #AI.WhoMessages)]

    response = {}

    response[4] = {}
    response[4].text = "Nevermind."
    response[4].handle = "Nevermind"

    NPCInteraction(text, this, user, "Responses", response)
end


OverrideEventHandler("NOS:base_ai_npc", EventType.DynamicWindowResponse, "Responses", ResponsesDialog)
