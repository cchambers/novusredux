require 'base_ai_mob'

AI.Settings.CanConverse = true
AI.ConversationCooldown = true --True if I should talk, false if not
AI.SetSetting("TalkRange",5)
AI.SetSetting("EndConversationChance",5)
AI.Settings.CanConverse = true
AI.Settings.SpeechTable = "Default"
AI.Settings.FallbackSpeechTable = "Default"
AI.CustomSpeech = {}

--Basic defines for NPC speech interpretation.
NPC_SPEECH_IDLE_SPEECH = 0
NPC_SPEECH_QUESTION = 1
NPC_SPEECH_CONCERN = 2
NPC_SPEECH_DEMAND = 3
NPC_SPEECH_STATEMENT = 4
NPC_SPEECH_BOAST = 5
NPC_SPEECH_THREAT = 6
NPC_SPEECH_JOKE = 7
NPC_SPEECH_INSULT_TARGET = 8
NPC_SPEECH_GREETING = 9
NPC_SPEECH_RESPOND_FAREWELL = 10
NPC_SPEECH_RESPOND_GREETING = 11
NPC_SPEECH_NEUTRAL_ERROR = 12
NPC_SPEECH_RESPOND_CONCERN_YES = 13
NPC_SPEECH_RESPOND_CONCERN_NO = 14
NPC_SPEECH_AGREE = 15
NPC_SPEECH_DISAGREE = 16
NPC_SPEECH_NEUTRAL = 17
NPC_SPEECH_CURSE_AT_TARGET = 18
--Add to potential combat states
--table.insert(AI.CombatStateTable,{StateName = "Taunt",Type = "offensivenoncombat",Range = AI.GetSetting("AggroRange"),})

-- All static speech has been moved to npc_speech. To add custom speech,
-- add a speech table in there and set the SpeechTable string
-- speechType is a string and is looked for in both StaticNPCSpeech (global) table and AI.CustomSpeech (module specific)
-- NOTE: Do not add entries to the global StaticNPCSpeech table in ai scripts, add them to AI.CustomSpeech
function GetSpeechTable(speechType)
    local speechTable = GetSpeechAndResponseTable(speechType)
    if (speechTable == nil) then 
        --DebugMessage("speechType is " ..speechType)
        return nil 
    end

    --For backwards compatability just their speech is returned from this function.
    local returnTable = {}
    
    for i,j in pairs(speechTable) do
        table.insert(returnTable,j[1])
    end
    return returnTable
end

function GetSpeechAndResponseTable(speechType)    
    local speechTable = nil  

    local primarySpeechTableName = AI.Settings.SpeechTable    
    local fallbackSpeechTableName = AI.Settings.FallbackSpeechTable
    
    -- first do our table lookups to get the primary and secondary master speech tables
    local primarySpeechTable = nil
    if(primarySpeechTableName ~= nil) then
        primarySpeechTable = AI.CustomSpeech[primarySpeechTableName] or StaticNPCSpeech[primarySpeechTableName]
        if(primarySpeechTable == nil) then
            DebugMessage("ERROR: Invalid primary speech table specified: "..primarySpeechTableName)
        end
    end
    
    local fallbackSpeechTable = nil
    if(fallbackSpeechTableName ~= nil) then
        fallbackSpeechTable = AI.CustomSpeech[fallbackSpeechTableName] or StaticNPCSpeech[fallbackSpeechTableName]
        if(fallbackSpeechTable == nil) then
            DebugMessage("ERROR: Invalid fallback speech table specified: "..fallbackSpeechTableName)
        end
    end

    -- now do a lookup for the specific speech type in each
    if(primarySpeechTable ~= nil and primarySpeechTable[speechType] ~= nil) then
        speechTable = primarySpeechTable[speechType]
    elseif(fallbackSpeechTable ~= nil and fallbackSpeechTable[speechType] ~= nil) then
        speechTable = fallbackSpeechTable[speechType]
    elseif(StaticNPCSpeech.Default[speechType] ~= nil) then
        speechTable = StaticNPCSpeech.Default[speechType]
    end

    return speechTable
end

function NpcTalk(words)
    result = words
    --[[if (NPCLanguages[AI.Settings.SpeechTable] ~= nil) then
        result = ""
        for i = 1, #words do
            local c = words:sub(i,i)
            local isUpperCase = false
            if (string.upper(c) == c) then
                isUpperCase = true
            end
            -- do something with c
            if (NPCLanguages[AI.Settings.SpeechTable][string.upper(c)]) then
                newc = NPCLanguages[AI.Settings.SpeechTable][c]
                if (isUpperCase and #NPCLanguages[AI.Settings.SpeechTable][string.upper(c)] > 1) then
                    upchar = ""
                    for n = 1, #newc do
                        --special case for punctuation
                        if (n == "'") then
                            upchar = upchar .. newc:sub(n,n)
                        else
                            --otherwise 
                            if (n == 1) then
                                upchar = upchar .. string.upper(newc:sub(n,n))
                            else
                                upchar = upchar .. newc:sub(n,n)
                            end
                        end
                    end
                    newc = upchar
                elseif (isUpperCase and string.match(newc,"%w")) then --upper case punctuation
                    newc = string.upper(newc)
                end
                c = newc
            end
            result = result .. c
        end
    end--]]
    this:NpcSpeech(result)
end

function GetAttention(user)
    this:StopMoving()
    this:SetFacing(this:GetLoc():YAngleTo(user:GetLoc()))
    AI.ConversationStateLength = 15000
    AI.StateMachine.ChangeState("Converse")
end

--say something to taunt target
function TauntTalk()
    if (not AI.GetSetting("CanConverse")) then
        return
    end

    if not(AI.IsActive()) then return end

    if (AI.ConversationCooldown == false) then
        return
    end

    local chance = math.random(1,#(GetSpeechTable("TauntSpeech")))
    for i,speech in pairs(GetSpeechTable("TauntSpeech")) do
        if (chance == i) then
            NpcTalk(speech)
        end
    end
end

function HandleInteract(user,usedType)
    --DebugMessage("1")
    if(usedType ~= "Interact") then return end

    if(AI.GetSetting("NoSpeakOnInteract")) then return end
    --DebugMessage("A")
    --if (not ShouldRespond()) then return end
    FaceObject(this,user)
    if IsFriend(user) then
        TalkNeutral(user)
    else
        local choice = math.random(1,3)
        if (choice >= 3) then
            InsultTarget(user)
        else
            ThreatenTarget(user)
        end
    end
end
RegisterEventHandler(EventType.Message, "UseObject", HandleInteract)

--say something while in combat
function CombatTalk()
    if (not AI.GetSetting("CanConverse")) then
        return
    end

    if not(AI.IsActive()) then return end

    if (AI.ConversationCooldown == false) then
        return
    end

    if  (AI.MainTarget ~= nil) then --I'm talking to an animal
        if (AI.MainTarget:GetMobileType() == "Animal" and GetSpeechTable("CombatSpeechAnimal") ~= nil) then
            if (GetSpeechTable("CombatSpeechAnimal") ~= nil) then
                local chance = math.random(1,math.max(2,#(GetSpeechTable("CombatSpeechAnimal"))))
                for i,speech in pairs(GetSpeechTable("CombatSpeechAnimal")) do
                    if (chance == i) then
                        NpcTalk(speech)
                    end
                end
            end
        elseif (GetSpeechTable("CombatSpeech") ~= nil) then --Not talking to animals
            if (GetSpeechTable("CombatSpeech") ~= nil) then
                local chance = math.random(1,math.max(2,#(GetSpeechTable("CombatSpeech"))))
                for i,speech in pairs(GetSpeechTable("CombatSpeech")) do
                    if (chance == i) then
                        NpcTalk(speech)
                    end
                end
            end
        end
    end
end
--say something while in combat
function FleeTalk()
    if (not AI.GetSetting("CanConverse")) then
        return
    end

    if not(AI.IsActive()) then return end

    if (AI.ConversationCooldown == false) then
        return
    end
    
    local chance = math.random(1,#(GetSpeechTable("FleeSpeech")))
    for i,speech in pairs(GetSpeechTable("FleeSpeech")) do
        if (chance == i) then
            NpcTalk(speech)
        end
    end
end
function IdleTalk()
    if (not AI.GetSetting("CanConverse")) then
        return
    end

    if not(AI.IsActive()) then return end

    if (AI.ConversationCooldown == false) then
        return
    end

    local chance = math.random(1,#(GetSpeechTable("IdleSpeech")))
    for i,speech in pairs(GetSpeechTable("IdleSpeech")) do
        if (chance == i) then
            NpcTalk(speech)
        end
    end
end

--State that taunts players and mobs who run
AI.StateMachine.AllStates.Taunt = {
        GetPulseFrequencyMS = function() return math.random(700,1400) end,

        OnEnterState = function() 
            this:PlayAnimation("alarmed")
            this:StopMoving()
            if(AI.GetSetting("CanConverse")) then
                this:PlayAnimation("Wave")
                TauntTalk()
            end
            AI.Anger = AI.Anger - 15
        end,

        AiPulse = function()
            DecideCombatState()
        end,
    }

AI.StateMachine.AllStates.Converse = {
        GetPulseFrequencyMS = function() return (AI.ConversationStateLength or 4000) end,

        OnEnterState = function() 
            this:StopMoving()
            if (AI.IdleTarget ~= nil) then
                FaceObject(this,AI.IdleTarget)
                local seed = math.random(1,2)
                if(seed == 1) then
                    this:PlayAnimation("yes_one")
                elseif (seed == 2) then
                    this:PlayAnimation("yes_two")
                end
            end
        end,

        AiPulse = function()--                                                         DFB TODO: Don't use this setting. \/
            if (this:HasTimer("TalkRespondTimer")) then
                return
            end
            local shouldEndConversation = AI.IdleTarget == nil 
                    or not(AI.IdleTarget:IsValid())
                    or AI.IdleTarget:DistanceFrom(this) > AI.GetSetting("TalkRange")

            -- if this is two npcs talking to each other, there are other things to consider
            if(not shouldEndConversation and not(AI.IdleTarget:IsPlayer())) then
                shouldEndConversation = math.random(1,AI.GetSetting("EndConversationChance")) == 1 
                        or AI.IdleTarget:GetObjVar("CurrentState") ~= "Converse"
            end

            if(shouldEndConversation) then                
                DecideIdleState()
                AI.ConversationStateLength = nil
            end
        end,

        OnExitState = function()
            this:PlayAnimation("idle")
        end,
    }

function SayWords(SpeechIndex,seed,subject)
    if not(AI.IsActive()) then return end

    if (AI.StateMachine.CurState ~= "Converse" and AI.MainTarget == nil) then
        AI.StateMachine.ChangeState("Converse")
    end
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(3.4),"TalkingTimer")
    --DFB TODO: Play animations when speaking.
    if  (SpeechIndex == -1 or SpeechIndex == nil) then
        DebugMessage("[SayWords] ERROR: nil conversation speech index for "..this:GetName())
        return
    elseif (SpeechIndex == NPC_SPEECH_IDLE_SPEECH) then --Idle speech, small talk
        for i,words in pairs(GetSpeechTable("IdleSpeech")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                seed = math.random(1,3)
                if(seed == 1) then
                this:PlayAnimation("yes_two")
                elseif (seed == 2) then
                this:PlayAnimation("dismiss_two")
                elseif (seed == 3) then
                this:PlayAnimation("yes_one")
                end
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_QUESTION) then --Questions
        for i,words in pairs(GetSpeechTable("IdleSpeechQuestion")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                seed = math.random(1,3)
                if(seed == 1) then
                this:PlayAnimation("yes_two")
                elseif (seed == 2) then
                this:PlayAnimation("no_one")
                elseif (seed == 3) then
                this:PlayAnimation("yes_one")
                end
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_CONCERN) then --Concern
        for i,words in pairs(GetSpeechTable("IdleSpeechConcern")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                this:PlayAnimation("wave")
                this:StopMoving()
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_DEMAND) then --Demand
        for i,words in pairs(GetSpeechTable("DemandSpeech")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                seed = math.random(1,2)
                if(seed == 1) then
                this:PlayAnimation("yes_two")
                elseif (seed == 2) then
                this:PlayAnimation("dismiss_two")
                end
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_STATEMENT) then --Statement
        for i,words in pairs(GetSpeechTable("StatementSpeech")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                seed = math.random(1,3)
                if(seed == 1) then
                this:PlayAnimation("yes_two")
                elseif (seed == 2) then
                this:PlayAnimation("dismiss_two")
                elseif (seed == 3) then
                this:PlayAnimation("yes_one")
                end
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_BOAST) then --Boast
        for i,words in pairs(GetSpeechTable("BoastSpeech")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                seed = math.random(1,2)
                if (seed == 1) then
                    this:PlayAnimation("showingoff")
                elseif (seed == 2) then
                    this:PlayAnimation("fistbump")
                end
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_THREAT) then --Threat. 
        for i,words in pairs(GetSpeechTable("ThreatSpeech")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                seed = math.random(1,3)
                if(seed == 1) then
                this:PlayAnimation("throatslash")
                elseif (seed == 2) then
                this:PlayAnimation("throatslash_two")
                elseif (seed == 3) then
                this:PlayAnimation("fistbump")
                elseif (seed == 4) then
                this:PlayAnimation("shakefist")
                end
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_JOKE) then --Joke. 
        for i,words in pairs(GetSpeechTable("JokeSpeech")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                 seed = math.random(1,3)
                if(seed == 1) then
                this:PlayAnimation("happy")
                elseif (seed == 2) then
                this:PlayAnimation("yes_one")
                elseif (seed == 3) then
                this:PlayAnimation("thinking")
                end
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_INSULT_TARGET) then --Insult. Respond with anger, insult, or a threat. Increase anger.
        for i,words in pairs(GetSpeechTable("InsultSpeech")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                seed = math.random(1,4)
                if(seed == 1) then
                this:PlayAnimation("flipthebird")
                elseif (seed == 2) then
                this:PlayAnimation("throatslash_one")
                elseif (seed == 3) then
                this:PlayAnimation("fistbump")
                elseif (seed == 4) then
                this:PlayAnimation("shakefist")
                end
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_GREETING) then --Greeting. Respond with greeting, or concern if other is injured.
        for i,words in pairs(GetSpeechTable("GreetingSpeech")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                this:PlayAnimation("wave")
                this:StopMoving()
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_RESPOND_FAREWELL) then --Farewell. Respond with farewell, or don't respond if angry.
        for i,words in pairs(GetSpeechTable("FarewellSpeech")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                this:PlayAnimation("wave")
                this:StopMoving()
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_RESPOND_GREETING) then --"Greeting 2" Respond to the other's greeting
        for i,words in pairs(GetSpeechTable("GreetingSpeech")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                this:PlayAnimation("wave")
                this:StopMoving()
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_NEUTRAL_ERROR) then--I either agreed, disagreed, or said a netural resposnse. This shouldn't be called.
        if (LastSpeaker ~= nil) then
            DebugMessage("[SayWords] Warning/Error: Trying to speak about a neutral response index! (Code NPC_SPEECH_NEUTRAL_ERROR) from "..this:GetName().." to " .. LastSpeaker:GetName()) 
        else
            DebugMessage("[SayWords] ERROR: Tried to speak about something labeled with a neutral response, with a nil LastSpeaker (Code NPC_SPEECH_NEUTRAL_ERROR)! From " .. this:GetName())
        end
        for i,words in pairs(GetSpeechTable("TalkNeutral")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                this:PlayAnimation("dance")
                this:StopMoving()
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_RESPOND_CONCERN_YES) then --I previously expressed concern and they said yes
        DebugMessage("[SayWords] ERROR: Tried to speak about a response to concern: "..this:GetName().." to " .. LastSpeaker:GetName() .." attempting to say yes (Code NPC_SPEECH_RESPOND_CONCERN_YES)")
    elseif (SpeechIndex == NPC_SPEECH_RESPOND_CONCERN_NO) then --I previously expressed concern and they said no
        DebugMessage("[SayWords] ERROR: Tried to speak about a response to concern: "..this:GetName().." to " .. LastSpeaker:GetName() .." attempting to say no (Code NPC_SPEECH_RESPOND_CONCERN_NO)")
    elseif (SpeechIndex == NPC_SPEECH_AGREE) then --Speak Agree.
        seed = seed or math.random(1,#GetSpeechTable("IdleResponsePositive"))
        for i,words in pairs(GetSpeechTable("IdleResponsePositive")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                seed = math.random(1,2)
                if(seed == 1) then
                this:PlayAnimation("yes_one")
                elseif (seed == 2) then
                this:PlayAnimation("yes_two")
                end
                this:StopMoving()
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_DISAGREE) then--I disagreed --DFBTODO: Make this more complex?
        seed = seed or math.random(1,#GetSpeechTable("IdleResponseNegative"))
        for i,words in pairs(GetSpeechTable("IdleResponseNegative")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                seed = math.random(1,4)
                if(seed == 1) then
                this:PlayAnimation("no_one")
                elseif (seed == 2) then
                this:PlayAnimation("no_two")
                elseif (seed == 3) then
                this:PlayAnimation("dismiss_one")
                elseif (seed == 4) then
                this:PlayAnimation("dismiss_two")
                end
                this:StopMoving()
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_NEUTRAL) then--I said a netural resposne
        seed = seed or math.random(1,#GetSpeechTable("IdleResponseNeutral"))
        for i,words in pairs(GetSpeechTable("IdleResponseNeutral")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                seed = math.random(1,3)
                if(seed == 1) then
                this:PlayAnimation("dismiss_one")
                elseif (seed == 2) then
                this:PlayAnimation("dismiss_two")
                elseif (seed == 3) then
                this:PlayAnimation("no_one")
                end
                this:StopMoving()
            end
        end
    elseif (SpeechIndex == NPC_SPEECH_CURSE_AT_TARGET) then--I said an angry response grrr
        seed = seed or math.random(1,#GetSpeechTable("IdleResponseAngry"))
        for i,words in pairs(GetSpeechTable("IdleResponseAngry")) do
            if i == seed then
                NpcTalk(words) --blah blah blah
                seed = math.random(1,6)
                if(seed == 1) then
                this:PlayAnimation("excited_one")
                elseif (seed == 2) then
                this:PlayAnimation("excited_two")
                elseif (seed == 3) then
                this:PlayAnimation("weapon_spin")
                elseif (seed == 6) then
                this:PlayAnimation("shakefist")
                end
                this:StopMoving()
            end
        end
    else
        DebugMessage("[SayWords] ERROR: Tried to speak something undefined: "..this:GetName().." to " .. LastSpeaker:GetName() .." , defined code is (Code "..SpeechIndex..")")
        NpcTalk("I'm sorry, I forgot what I was going to say...") --blah blah blah
    end
    return
end
--Respond with concern.
function RespondConcerned(target)  
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable("IdleSpeechConcern")
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    SayWords(NPC_SPEECH_CONCERN,seed,subject)
    AI.IdleTarget:SendMessage("ReceiveTalk",this,2,subject)
    this:StopMoving()
    FaceObject(this,target)
end
--Carry on the conversation
function TalkNeutral(target) 
    --Say something.
    local choice =  math.random(1,7)
    conversationPiece = nil
    local speechTable = GetSpeechAndResponseTable("IdleSpeech")
    if (choice == 1) then
        conversationPiece = NPC_SPEECH_IDLE_SPEECH --Just start talking with an idle speech
    elseif (choice == 2) then
        speechTable = GetSpeechAndResponseTable("IdleSpeechQuestion")
        conversationPiece = NPC_SPEECH_QUESTION --Ask a question
    elseif (choice == 3) then
        speechTable = GetSpeechAndResponseTable("StatementSpeech")
        conversationPiece = NPC_SPEECH_STATEMENT --Make a statement
    elseif (choice == 4) then
        speechTable = GetSpeechAndResponseTable("DemandSpeech")
        conversationPiece = NPC_SPEECH_DEMAND  --Make a demand
    elseif (choice == 5) then
        speechTable = GetSpeechAndResponseTable("BoastSpeech")
        conversationPiece = NPC_SPEECH_BOAST --boast.
    elseif (choice == 6) then 
        speechTable = GetSpeechAndResponseTable("JokeSpeech")
        conversationPiece = NPC_SPEECH_JOKE --Joke. 
    elseif choice == 7 then
        speechTable = GetSpeechAndResponseTable("IdleResponseNeutral")
        conversationPiece = NPC_SPEECH_NEUTRAL  --neutral response
    --else
    --    NpcTalk("I like it up the butt.") --what what
    end
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    --DebugMessage("conversationPiece is "..tostring(conversationPiece))
    SayWords(conversationPiece,seed,subject)    
    this:StopMoving()
    FaceObject(this,target)
    --DebugMessage(this:GetName().." and Sent is "..conversationPiece)
    target:SendMessage("ReceiveTalk",this,conversationPiece,subject)
end
--$#@#$% you!
function CurseAtTarget(target)
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable("IdleResponseAngry")
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    SayWords(NPC_SPEECH_CURSE_AT_TARGET,seed)--Have NPC's take cursing at them as an insult
    this:StopMoving()
    FaceObject(this,target)
    --DebugMessage(this:GetName().." and Sent is "..8)
    target:SendMessage("ReceiveTalk",this,NPC_SPEECH_CURSE_AT_TARGET,subject)
end
--Insult them
function InsultTarget(target)
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable("InsultSpeech")
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    SayWords(NPC_SPEECH_INSULT_TARGET,seed)
    this:StopMoving()
    FaceObject(this,target)
    --DebugMessage(this:GetName().." and Sent is "..8)
    target:SendMessage("ReceiveTalk",this,NPC_SPEECH_INSULT_TARGET,subject)
end
--do you has cheesburger
function AskQuestion(target)
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable("IdleSpeechQuestion")
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    SayWords(NPC_SPEECH_QUESTION,seed)
    this:StopMoving()
    FaceObject(this,target)
    --DebugMessage(this:GetName().." and Sent is "..1)
    target:SendMessage("ReceiveTalk",this,NPC_SPEECH_QUESTION,subject)
end
--no I do not has cheesburger
function RespondNegative(target)
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable("IdleResponseNegative")
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    SayWords(NPC_SPEECH_DISAGREE,seed)
    this:StopMoving()
    FaceObject(this,target)
   --DebugMessage(this:GetName().." and Sent is "..NPC_SPEECH_DISAGREE)
    target:SendMessage("ReceiveTalk",this,NPC_SPEECH_DISAGREE,subject)
end
function RespondConfused(target)
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable("Confused")
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    SayWords(NPC_SPEECH_DISAGREE,seed)
    this:StopMoving()
    FaceObject(this,target)
   --DebugMessage(this:GetName().." and Sent is "..NPC_SPEECH_DISAGREE)
    target:SendMessage("ReceiveTalk",this,NPC_SPEECH_DISAGREE,subject)
end
--meh
function RespondNeutral(target)
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable("IdleResponseNeutral")
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    SayWords(NPC_SPEECH_NEUTRAL,seed)
    this:StopMoving()
    FaceObject(this,target)
   --DebugMessage(this:GetName().." and Sent is "..NPC_SPEECH_NEUTRAL)
    target:SendMessage("ReceiveTalk",this,NPC_SPEECH_NEUTRAL,subject)
end
--do you has cheesburger
function RespondPositive(target)
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable("IdleResponsePositive")
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    SayWords(NPC_SPEECH_AGREE,seed)
    this:StopMoving()
    FaceObject(this,target)
   --DebugMessage(this:GetName().." and Sent is "..NPC_SPEECH_AGREE)
    target:SendMessage("ReceiveTalk",this,NPC_SPEECH_AGREE,subject)
end
--do you has cheesburger DFB TODO: MAKE LAUGHTER BETTER
function RespondLaughter(target)
    if (target == nil or not target:IsValid()) then return end
    NpcTalk("Hah hah hah!")
    this:StopMoving()
    FaceObject(this,target)
   --DebugMessage(this:GetName().." and Sent is "..NPC_SPEECH_AGREE)
    target:SendMessage("ReceiveTalk",this,NPC_SPEECH_AGREE)
end
--screw you
function ThreatenTarget(target)
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable("ThreatSpeech")
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    SayWords(NPC_SPEECH_THREAT)
    this:StopMoving()
    FaceObject(this,target)
   --DebugMessage(this:GetName().." and Sent is "..6)
    target:SendMessage("ReceiveTalk",this,NPC_SPEECH_THREAT,subject)
end
--I has cheesburger
function BoastAtTarget(target)
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable("BoastSpeech")
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    if (AI.GetSetting("DoNotBoast") ~= nil) then
        TalkNeutral(target)
        return
    end
    this:StopMoving()
    FaceObject(this,target)
    SayWords(NPC_SPEECH_BOAST,seed)
   --DebugMessage(this:GetName().." and Sent is "..5)
    target:SendMessage("ReceiveTalk",this,NPC_SPEECH_BOAST,subject)
end
--grrr
function RespondAngry(target)
    if (target == nil or not target:IsValid()) then return end
    CurseAtTarget(target)
    this:StopMoving()
   --DebugMessage(this:GetName().." and Sent is "..NPC_SPEECH_FAREWELL)
    FaceObject(this,target)
end
--respond greeting
function RespondGreeting(target)
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable("GreetingSpeech")
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    SayWords(NPC_SPEECH_RESPOND_GREETING,seed)
    this:StopMoving()
    FaceObject(this,target)
   --DebugMessage(this:GetName().." and Sent is "..NPC_SPEECH_RESPOND_GREETING)
    target:SendMessage("ReceiveTalk",this,NPC_SPEECH_RESPOND_GREETING,subject)
end
--bye
function RespondFarewell(target)
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable("FarewellSpeech")
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    SayWords(NPC_SPEECH_RESPOND_FAREWELL,seed)
    this:StopMoving()
    FaceObject(this,target)
   --DebugMessage(this:GetName().." and Sent is "..NPC_SPEECH_FAREWELL)
    target:SendMessage("ReceiveTalk",this,NPC_SPEECH_FAREWELL,subject)
end
--I have a subject but not a index
function RespondSubject(target,subject)
    if (target == nil or not target:IsValid()) then return end
    local speechTable = GetSpeechAndResponseTable(subject)
    local seed = math.random(1,#speechTable)
    local subject = speechTable[seed][2]
    NpcTalk(speechTable[seed][1])
    this:StopMoving()
    FaceObject(this,target)
    --DebugMessage(this:GetName().." and Sent is "..8)
    target:SendMessage("ReceiveTalk",this,GetSpeechIndex(subject),subject)
end

function GetSpeechIndex(subject)
    if (subject == "Insult") then
        return NPC_SPEECH_INSULT_TARGET
    elseif (subject == "Joke") then
        return NPC_SPEECH_JOKE
    elseif (subject == "") then
        return NPC_SPEECH_NEUTRAL
    elseif (subject == "Statement") then
        return NPC_SPEECH_DEMAND
    elseif (subject == "Demand") then
        return NPC_SPEECH_DEMAND
    elseif (subject == "Brag") then
        return NPC_SPEECH_BOAST
    elseif (subject == "Hello") then
        return NPC_SPEECH_GREETING
    end
    return nil
end

function ReactToDeath()
    --DFB TODO - React in horror, disgust, flee
end
--Start a conversation
function InitiateConversation(otherObj,noHello)
   --DebugMessage(1)
    if (this:HasTimer("TalkRespondTimer")) then
        return
    end
    if (AI.StateMachine.CurState == "Converse") then return end
    AI.IdleTarget = otherObj
    this:StopMoving()
    FaceObject(this,otherObj)
   --DebugMessage("Trying conversation")
    if (AI.IdleTarget == nil or not AI.IdleTarget:IsValid()) then
        NpcTalk("I.. um.. uh..")
        DebugMessage("[InitiateConversation] ERROR: Tried to talk to an invalid object!")
            --DebugMessage("DecideIdleState error conversation")
        AI.StateMachine.ChangeState("Idle")
    end
    if  (GetCurHealth(AI.IdleTarget) < GetMaxHealth(AI.IdleTarget)) then
        RespondConcerned(LastSpeaker)
        return
    end

    local conversationPiece = -1
    --Determine if I should make a statement, say hello, ask a question, show concern, or demand something (if I'm slightly angry)
    if (math.random(1,5) == 1 or noHello ~= nil) then
        --Don't say hello. Say something.
        local choice =  math.random(1,5)
        if (choice == 1) then
            speechTable = GetSpeechAndResponseTable("IdleSpeech")
            conversationPiece = 0 --Just start talking with an idle speech
        elseif (choice == 2) then
            speechTable = GetSpeechAndResponseTable("IdleSpeechQuestion")
            conversationPiece = 1 --Ask a question
        elseif (choice == 3) then
            speechTable = GetSpeechAndResponseTable("StatementSpeech")
            conversationPiece = 3--Make a statement
        elseif (choice == 4) then
            speechTable = GetSpeechAndResponseTable("DemandSpeech")
            conversationPiece = 4  --Make a demand
        elseif (choice==5) then-- 
            TalkNeutral(otherObj)
            return
        end
    else
        speechTable = GetSpeechAndResponseTable("GreetingSpeech")
        --Say hello.
        conversationPiece = 9 --Index for greeting.
    end
    seed = math.random(1,#speechTable)
    subject = speechTable[seed][2]
    --Speak damnit speak!
    --DebugMessage("conversationPiece is "..tostring(conversationPiece))
    SayWords(conversationPiece,seed) --Actually perform the npc speech
    AI.IdleTarget:SendMessage("ReceiveTalk",this,conversationPiece,subject)
end

--Handle NPC conversations
RegisterEventHandler(EventType.Timer,"TalkRespondTimer", function(LastSpeaker,ReceivedSpeech,Subject)
    --don't talk if we shouldn't.
   --DebugMessage("ReceivedSpeech",ReceivedSpeech)
    --AI.IdleTarget = LastSpeaker
    AI.Anger = AI.Anger - 1
    --DebugMessage(this:GetName().."  ReceivedSpeech is "..tostring(ReceivedSpeech))
    if (AI.IdleTarget == nil or not AI.IdleTarget:IsValid()) then
        --DebugMessage("DecideIdleState invalid")
        AI.StateMachine.ChangeState("Idle")
        return
    end
    --If I'm angry, begin in this order
        if (AI.Anger > 10) then                           
            if (AI.Anger > 20) then                         --Respond with anger if I'm angry
                if (AI.Anger > 100) then                         
                    AttackEnemy(LastSpeaker)                 --Attack if I'm angry enough (gone crazy)
                    return
                end
            CurseAtTarget(LastSpeaker) --I'm really angry, curse at enemy
            return
            end
        InsultTarget(LastSpeaker) --I'm irritable, insult them
        return
        end
    if (Subject ~= nil and Subject ~= "" and GetSpeechTable(Subject) ~= nil) then
        RespondSubject(LastSpeaker,Subject)
        return 
    end
    if  (ReceivedSpeech == -1 or ReceivedSpeech == nil)  then
        RespondConfused(LastSpeaker)
        --NpcTalk("Sorry, I didn't quite understand what you said.")
        --DebugMessageA(this,"[TalkRespondTimer]Warning: nil conversation speech for "..this:GetName())
        return
    elseif (ReceivedSpeech == 0) then --Idle speech, small talk, respond neutral, potentially respond with a question
        if(math.random(1,4) == 1) then
            AskQuestion(LastSpeaker)
        else
            RespondNegative(LastSpeaker)
        end
    elseif (ReceivedSpeech == 1) then --Questions, respond negative 
        RespondNeutral(LastSpeaker)
    elseif (ReceivedSpeech == 2) then --Concern, respond positive if high health, negative if low health
        if (GetCurHealth(this) > 0.5*GetMaxHealth(this)) then 
            RespondPositive(LastSpeaker)
        else
            RespondNegative(LastSpeaker)
        end
    elseif (ReceivedSpeech == 3) then --Demand, increase anger, respond negative, respond with threat if angry enough
        AI.Anger = AI.Anger + 3.5
        if AI.Anger > 10 then
            ThreatenTarget(LastSpeaker)
        else
            RespondNegative(LastSpeaker)
        end
    elseif (ReceivedSpeech == 4) then --Statements, respond neutral, or not at all
        if(math.random(1,5) == 1) then 
            AskQuestion(LastSpeaker)
        elseif(math.random(1,5) == 1) then
            --Say nothing
        else
            RespondNeutral(LastSpeaker)
        end
    elseif (ReceivedSpeech == 5) then --Boasts, respond with indifference or with another boast. Small chance to respond with an insult
        --if(math.random(1,NPC_SPEECH_DISAGREE) == 1)then 
            --InsultTarget(LastSpeaker)
        if (math.random(1,4) == 1)then 
            RespondNeutral(LastSpeaker)
        else
            BoastAtTarget(LastSpeaker)
        end
    elseif (ReceivedSpeech == 6) then --Threat. Respond angry and raise anger significantly. Respond with another threat possibily.
        AI.Anger = AI.Anger + 8
        if AI.Anger > 10 then
            ThreatenTarget(LastSpeaker)
        elseif math.random(1,2) == 1 then 
            RespondAngry(LastSpeaker)
        else
            InsultTarget(LastSpeaker)
        end
    elseif (ReceivedSpeech == 7) then --Joke. Respond with indifference, laughter, or a slight chance for negative. Reduce anger.
        AI.Anger = AI.Anger - 4
        if (math.random(1,4) == 1) then
            RespondNeutral(LastSpeaker)
        else
            RespondLaughter(LastSpeaker)
        end
    elseif (ReceivedSpeech == 8) then --Insult. Respond with anger, insult, or a threat. Increase anger.
        AI.Anger =AI.Anger + 6
        if AI.Anger > 12 then
            RespondAngry(LastSpeaker)
        elseif (math.random(1,3) == 1) then 
            ThreatenTarget(LastSpeaker)
        else
            InsultTarget(LastSpeaker)
        end
    elseif (ReceivedSpeech == 9) then --Greeting. Respond with greeting, or concern if other is injured.
        if (GetCurHealth(LastSpeaker) < GetMaxHealth(LastSpeaker)) then 
            RespondConcerned(LastSpeaker)
        else
            RespondGreeting(LastSpeaker)
        end 
    elseif (ReceivedSpeech == NPC_SPEECH_FAREWELL) then 
        if (AI.Anger < 7) then 
            RespondFarewell(LastSpeaker)
        end
    elseif (ReceivedSpeech == NPC_SPEECH_RESPOND_GREETING) then --"Greeting 2", if he responds with a greeting, chance to strike up a conversation.
        if (math.random(1,2) == 1) then 
            TalkNeutral(LastSpeaker)
        else 
            --conversation ends
        end
    elseif (ReceivedSpeech == NPC_SPEECH_NEUTRAL_ERROR) then --I either agreed, disagreed, or said a netural resposne
        TalkNeutral(LastSpeaker)
    elseif (ReceivedSpeech == NPC_SPEECH_RESPOND_CONCERN_YES) then --I previously expressed concern and they said yes
        RespondNeutral(LastSpeaker)
    elseif (ReceivedSpeech == NPC_SPEECH_RESPOND_CONCERN_NO) then --I previously expressed concern and they said no
        --DFB TODO: If I can heal the target, do so
        return
    elseif (ReceivedSpeech == NPC_SPEECH_AGREE) then --I agreed
        TalkNeutral(LastSpeaker)
    elseif (ReceivedSpeech == NPC_SPEECH_DISAGREE) then --I disagreed --DFBTODO: Make this more complex?
        TalkNeutral(LastSpeaker)
    elseif (ReceivedSpeech == NPC_SPEECH_NEUTRAL) then --I said a netural resposne
        TalkNeutral(LastSpeaker)
    elseif (ReceivedSpeech == NPC_SPEECH_CURSE_AT_TARGET) then
        InsultTarget(LastSpeaker)
    else
        NpcTalk("Sorry, I didn't quite understand what you said.")
        DebugMessage("[TalkRespondTimer]ERROR: unknown conversation speech for "..this:GetName().."With value "..ReceivedSpeech)
        return
    end
    --DebugMessage(this:GetName().." Reset speech!")
    ReceivedSpeech = nil
    return
end)

function ShouldRespond()
    --DebugMessage("Checking...")
   --DebugMessage(1)
    local determine = false

    if not(AI.IsActive()) then return false end
    if (this:HasTimer("TalkRespondTimer")) then
        return false
    end
   --DebugMessage(2)
    if IsInCombat(this) then
        return false
    end

    if (AI.GetSetting("StartConversations") == false) then return false end

   --DebugMessage(3)
    if (AI.GetSetting("CanConverse") == false) then return end    
    if (not AI.ConversationCooldown) then
        return false
    end
   --DebugMessage(4)
    if (AI.MainTarget == nil) then
        determine = true
    end
   --DebugMessage(5)
    return determine
end

--Receive talk and schedule a response. 
RegisterEventHandler(EventType.Message, "ReceiveTalk", 
function (LastSpeaker,ReceivedSpeech,Subject,force)
   --DebugMessage("ReceivedSpeech",ReceivedSpeech,Subject)
    AI.IdleTarget = LastSpeaker
   --DebugMessage("BAM+++++++++++++++++++++++++++++++++++++++++++++++++++++")
   --DebugMessage("ReceivedSpeech is "..tostring(ReceivedSpeech))
   --DebugMessage("Working")
    if (not ShouldRespond() and not force) then
        return
    end

    if (this:HasTimer("TalkingTimer") and not force) then
        return 
    end
    --DebugMessage(1)
    if not(AI.IsActive()) then return end
    --DebugMessage(2)
    if (LastSpeaker ~= nil and LastSpeaker:IsValid()) then
        if (LastSpeaker:DistanceFrom(this) > AI.GetSetting("AggroRange")) then return end
        FaceObject(this,LastSpeaker)
        this:StopMoving()
    else
        --DebugMessage("[Event Handler ReceiveTalk] ERROR: Received an invalid conversation speaker in object " .. this:GetName())
        return
    end
    --Type of speech received stored here for talk timer
    --DebugMessage(3)
    AI.StateMachine.ChangeState("Converse")
    --DebugMessage(this:GetName().."  ReceivedSpeech is "..tostring(ReceivedSpeech).."and anger is "..AI.Anger)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(3.5), "TalkRespondTimer",LastSpeaker,ReceivedSpeech,Subject)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(3.4), "resetcooldown")
    AI.ConversationCooldown = false
end)

--if (initializer ~= nil) then
--    AddView("talkRange", SearchMobileInRange(AI.GetSetting("TalkRange")))   
--end
function DecipherSpeech(speech)
    if (speech == nil) then return {4,"Confused"} end
    local response = 4
    local YesKeywords = {"Yes","yes","yeah","yep","Yep","sure","yea","ok","OK","Ok"}
    local NoKeywords = {"No","nope","no","ney"}
    local GreetingsKeywords = {"Hello","hello","hi","Hi","HI","HELLO","hey","Hey","HEY","Sup","SUP","sup"}
    local GoodbyeKeywords = {"Bye","bye","BYE","Goodbye","goodbye","later","Later","Cya","cya"}
    local QuestionKeywords = {"?","what","what is" ,"do you","question","can you", "what are","how" , "how to" , "how can" , "how", "do","why","where","when","who","should" , "would" ,"could","can I","What","What is" , "What are","How" , "How to" , "How can" , "How", "Do","Why","Where","When","Who","Should" , "Would" ,"Could","Can I"}
    local name = StringSplit(this:GetName()," ")
    local speechTable = StaticNPCSpeech[AI.Settings.SpeechTable] or StaticNPCSpeech.Default
    local subject = nil
    for i,word in pairs(badWords) do
        if (string.find(string.lower(speech),string.lower(word))) then
            response = 6
        end
    end
    for i,word in pairs(name) do
        if (string.find(string.lower(speech),string.lower(word))) then
            response = 9
        end
    end
    for i,word in pairs(YesKeywords) do
        if (string.find(string.lower(speech),string.lower(word))) then
            response = NPC_SPEECH_AGREE
            subject = "Yes"
        end
    end
    for i,word in pairs(NoKeywords) do
        if (string.find(string.lower(speech),string.lower(word))) then
            response = NPC_SPEECH_DISAGREE
            subject = "No"
        end
    end    
    for i,word in pairs(GreetingsKeywords) do
        if (string.find(string.lower(speech),string.lower(word))) then
            response = 9
        end
    end
    for i,word in pairs(GoodbyeKeywords) do
        if (string.find(string.lower(speech),string.lower(word))) then
            response = NPC_SPEECH_FAREWELL
        end
    end
    for i,word in pairs(QuestionKeywords) do
        if (string.find(string.lower(speech),string.lower(word))) then
            response = 1
            subject = "IDontKnow"
        end
    end
    for i,j in pairs(speechTable) do
       --DebugMessage(i)
        if (string.find(string.lower(speech),string.lower(i))) then
            subject = i
        end
    end
    if (subject == nil) then
        speechTable = StaticNPCSpeech.Default
        for i,j in pairs(speechTable) do
            --DebugMessage(i)
            if (string.find(string.lower(speech),string.lower(i))) then
                subject = i
            end
        end
    end
    return {response,subject}
end

--Receive player speech and have a conversation with a player
RegisterEventHandler(EventType.PlayerSpeech,"", 
    function(speaker,speech)

    if (not ShouldTalk()) then
        return
    end
    --DebugMessage(FacingAngleDiff(this,speaker))
    if (FacingAngleDiff(this,speaker) > 55) then
        return
    end
    
    LastSpeaker = speaker
    local speechResult = DecipherSpeech(speech)
       --DFB TODO: Eventually you'll be able to have conversations with npc's by examining key words such as yes, no, etc. 
    if (LastSpeaker ~= nil and LastSpeaker:IsValid()) then
        FaceObject(this,LastSpeaker)
        this:SendMessage("ReceiveTalk",LastSpeaker,speechResult[1],speechResult[2],true)
        --DebugMessage("LastSpeaker",LastSpeaker,"ReceivedSpeech",speechResult)
        this:StopMoving()
    else
        --DebugMessage("[Event Handler ReceiveTalk] ERROR: Received an invalid conversation speaker from a player in object " .. this:GetName())
        return
    end
end)

function IsTalkableTarget(target)
    --DebugMessage("I am "..this:GetName().." the other object is "..target:GetName() .. "and target:HasModule() is " .. tostring(target:HasModule("base_ai_conversation")))
    --return target:HasModule("base_ai_conversation")
    if not(AI.IsActive()) then return end

    if (not AI.ConversationCooldown) then
        return false
    end

    if (target:DistanceFrom(this) > AI.GetSetting("TalkRange")) then return end

    return (AI.GetSetting("CanConverse") == true and not IsDead(target))
end

function ShouldTalk()
    --DebugMessage(1)
    local determine = false

    if not(AI.IsActive()) then return end

    if IsInCombat(this) then
        return
    end
    if (AI.GetSetting("StartConversations") == false) then return end
    if (AI.GetSetting("CanConverse") == false) then return end    

    if (not AI.ConversationCooldown) then
        return false
    end

    if (AI.MainTarget == nil) then
        determine = true
    end
    if (math.random(1,3) == 1) then
        determine = false
    end
    --DebugMessage(2)
    return determine
end

RegisterEventHandler(EventType.Timer,"resetcooldown", function()
    AI.ConversationCooldown = true
    end)

RegisterEventHandler(EventType.LeaveView, "chaseRange", function(mob)
        if (mob == AI.MainTarget) then
            AI.StateMachine.ChangeState("Taunt")
        end
    end)

RegisterEventHandler(EventType.Message,"DamageInflicted",function ( ... )
    this:RemoveTimer("TalkRespondTimer")
end)

RegisterEventHandler(EventType.Message,"PlayerEquippedItemMessage",function(object)
    if IsDead(this) then return end
    NpcTalk(GetSpeechTable("AcceptItemSpeech")[math.random(1,#GetSpeechTable("AcceptItemSpeech"))])
end)

RegisterEventHandler(EventType.Message,"PlayerRejectEquippedItemMessage",function(object)
    if IsDead(this) then return end
    NpcTalk(GetSpeechTable("RejectItemSpeech")[math.random(1,#GetSpeechTable("RejectItemSpeech"))])
end)

RegisterEventHandler(EventType.EnterView,"chaseRange",
    function(otherObj)
        --DebugMessage("Mobile entered talkRange")

        if not(AI.IsActive()) then return end
        
        --check to see if valid
        if (otherObj == nil or not otherObj:IsValid()) then
            return
        end

        if (not AI.GetSetting("CanConverse")) then
            return 
        end

        if (this:HasTimer("TalkRespondTimer")) then
            return false
        end

        if IsInCombat(this) or IsInCombat(otherObj) then
            return
        end

        --If I just ran into a corpse
        if (IsDead(otherObj)) then
            ReactToDeath() --Oh my god I found a corpse.
        end
        --DFB TODO: Check to make sure that it's Mobiles only that you can talk to
        --If it's someone I might want to talk to, talk to them.
        if IsTalkableTarget(otherObj) then
            if IsFriend(otherObj) then
                if ShouldTalk() then
                    AI.IdleTarget = otherObj
                    --DebugMessage(this:GetName() .. "Started conversation with "..otherObj:GetName())
                    InitiateConversation(otherObj)
                    AI.StateMachine.ChangeState("Converse")
                    this:ScheduleTimerDelay(TimeSpan.FromSeconds(3.4), "resetcooldown")
                    AI.ConversationCooldown = false
                end
            else--if IsHostile(otherObj) then
                ThreatenTarget(otherObj) --DFB TODO: Potentially threaten them, or warn them.
                this:ScheduleTimerDelay(TimeSpan.FromSeconds(3.4), "resetcooldown")
                AI.ConversationCooldown = false
            end
        end
    end)