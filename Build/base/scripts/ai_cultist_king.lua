require 'ai_cultist'
AI.Settings.Debug = false
AI.Settings.AggroRange = 15.0
AI.Settings.ChaseRange = 20.0
AI.Settings.LeashDistance = 35
AI.Settings.StationedLeash = true
AI.Settings.CanWander = false
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.CanFlee = false

AI.CustomSpeech.KingSpeech = {
    CombatSpeech = {
        "Feel the wrath of the GODS!",
        "It is time for you to be SACRIFIED!",
        "Feel the wrath for your HERESY!",
        "Your soul must be purged!",
        "By the Exaulted Ones, you will be CLEANSED!",
        "The Old Ones know of your lack of faith!",
        "I smell the fear in your blood",
        "The Gods laugh at you, scum!",
        "Where's your pride? Fight me!",
        "By the Elder Gods, you will not see mercy!",
        "You'll be begging for mercy soon enough!",
        "You will be slain and your flesh eaten!",
        "Time for you to be put down!",
        "Wretched creature!",
        "You insignificant wretch!",
        "I'm going to destroy you!",
    }
}
AI.Settings.SpeechTable = "KingSpeech"
AI.Settings.FallbackSpeechTable = "Cultist"

if( initializer ~= nil and initializer.CultistNamed ~= nil and initializer.Title ~= nil and initializer.Suffix) then    
    local name = initializer.CultistNamed[math.random(#initializer.CultistNamed)]
    local title = initializer.Title[math.random(#initializer.Title)]
    local suffix = initializer.Suffix[math.random(#initializer.Suffix)]
    this:SetName(title.." "..name.." "..suffix)
end

AI.GreetingsMessages = {
    "[$29]",
    "[$30]",
    "[$31]"
}


RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        if (IsGuard(killer)) then return end

        CreateObj("treasurechest_king",this:GetLoc(),"created_chest")

    end)

RegisterEventHandler(EventType.CreatedObject,"created_chest",function (success,objRef)
    if (success) then
		Decay(objRef, 800)
        objRef:SetFacing(270)
    end
end)


--[[function HandleInteract(user,usedType)
    if(usedType ~= "Interact") then return end
    --if (not ShouldRespond()) then return end
    FaceObject(this,user)
    local choice = math.random(1,4)
    local choices = {0,1,4,7}
    if IsFriend(user) then
        user:SendMessage("NPCInteraction",this)
        if (GetPlayerQuestState(user,"JoinCultQuest") == "TalkToCultistKing") then

            text = "[$33]"

            response = {}

            response[1] = {}
            response[1].text = "I have questions for you."
            response[1].handle = "Questions" 

            --response[2] = {}
            --response[2].text = "My Lord, I desire a relic..."
            --response[2].handle = "Question6" 

            --response[3] = {}
            --response[3].text = "I wish to raid the heretics."
            --response[3].handle = "Question5" 

            response[4] = {}
            response[4].text = "Thanks!"
            response[4].handle = "" 

            NPCInteraction(text,this,user,"Question",response)
        --QuickDialogMessage(this,user,"[$34]")
        --user:SendMessage("ShowHint","[$35]")
        elseif (GetPlayerQuestState(user,"CultistRelicRepeatableQuest") == "TalkToCultistKing") then
            QuickDialogMessage(this,user,"[$36]")
        elseif (GetPlayerQuestState(user,"CultistRelicQuest") == "TalkToCultistKing") then
            QuickDialogMessage(this,user,"[$37]")
        else
            text = AI.GreetingsMessages[math.random(#(AI.GreetingsMessages))]

            response = {}

            response[1] = {}
            response[1].text = "I have questions for you."
            response[1].handle = "Questions" 

            --response[2] = {}
            --response[2].text = "My Lord, I desire a relic..."
            --response[2].handle = "Question6" 

            --response[3] = {}
            --response[3].text = "I wish to raid the heretics."
            --response[3].handle = "Question5" 

            response[2] = {}
            response[2].text = "Thanks!"
            response[2].handle = "" 

            NPCInteraction(text,this,user,"Question",response)
        end
    else
        if (choice >= 3) then
            InsultTarget(user)
        else
            ThreatenTarget(user)
        end
    end
end
OverrideEventHandler("base_ai_conversation",EventType.Message, "UseObject", HandleInteract)

RegisterEventHandler(EventType.DynamicWindowResponse, "Question",
    function (user,buttonId)
        if (buttonId == "Questions") then
                text = "[$38]"

                response = {}

                response[1] = {}
                response[1].text = "Tell me the story of the cult."
                response[1].handle = "Question1" 

                response[2] = {}
                response[2].text = "What do I do as a cultist lord?"
                response[2].handle = "Question2"
                
                response[3] = {}
                response[3].text = "Who are our friends in the Village?"
                response[3].handle = "Question3"

                response[4] = {}
                response[4].text = "Is this all of the cult?"
                response[4].handle = "Question4"

                response[5] = {}
                response[5].text = "I have another question."
                response[5].handle = "Questions2"

                response[6] = {}
                response[6].text = "Nevermind"
                response[6].handle = "Nevermind" 

                NPCInteraction(text,this,user,"Question",response)

        elseif (buttonId == "Questions2") then

                text = "What is your other question, He of the Faith..."

                response = {}
                
                response[1] = {}
                response[1].text = "I need men to go on a raid."
                response[1].handle = "Question5"

                --response[2] = {}
                --response[2].text = "How can I get a relic?"
                --response[2].handle = "Question6"

                response[3] = {}
                response[3].text = "What are the Elder Gods?"
                response[3].handle = "Question7"

                response[5] = {}
                response[5].text = "Nevermind"
                response[5].handle = "" 

                NPCInteraction(text,this,user,"Question",response)

        elseif (buttonId == "QuestTask1") then
        elseif (buttonId == "QuestTask2") then
        elseif (buttonId == "QuestTask3") then
        elseif (buttonId == "Question1") then
            QuickDialogMessage(this,user,"[$39]")
        elseif (buttonId == "Question2") then
            QuickDialogMessage(this,user,"[$40]")
        elseif (buttonId == "Question3") then
            QuickDialogMessage(this,user,"[$41]")
        elseif (buttonId == "Question4") then
            QuickDialogMessage(this,user,"[$42]")
        elseif (buttonId == "Question5") then
            QuickDialogMessage(this,user,"[$43]")
        --elseif (buttonId == "Question6") then
        --    if (not (HasFinishedQuest(user,"CultistRelicQuest"))) then
        --        QuickDialogMessage(this,user,"[$44]")
        --        user:SendMessage("StartQuest","CultistRelicQuest")
        --    else
        --        QuickDialogMessage(this,user,"[$45]")
        --        user:SendMessage("StartQuest","CultistRelicRepeatableQuest")
        --    end
        elseif (buttonId == "Question7") then
            QuickDialogMessage(this,user,"[$46]")
            PlayerTitles.EntitleFromTable(user,AllTitles.ActivityTitles.XorFollower)
        end
    end)
]]
--Have them leash only if they have a home location
if (initializer ~= nil ) then

    AI.Settings.Leash = true
    --local facing = this:GetLoc():YAngleTo(campController:GetLoc())
    --this:SetObjVar("homeFacing", facing)
end

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        if (IsGuard(killer)) then return end

        if ( this:HasObjVar("lootable") ) then return end
        
        local nearbyCombatants = FindObjects(SearchMulti(
        {
            SearchPlayerInRange(20,true), --in 20 units
        }))

        DistributeBossRewards(nearbyCombatants, nil, "Cultist")
    end)