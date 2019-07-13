require 'NOS:ai_villager'

MemorialSpeech = {
        "I could take you and then just like you in my day!",
        "You call yourself a fencer? Not with that stance!",
        "Hush everyone! There are thieves about...",
        "I do not envy you the headache you will have when you awake. But for now, rest well and dream of pirate women.",
}

AI.Settings.SpeechTable = "Villager"
AI.Settings.FallbackSpeechTable = "Villager"

for i,j in pairs(AI.IdleStateTable) do
    if j.StateName == "GoLocation" then
        table.remove(AI.IdleStateTable,i)
    end
end

function HandleInteract(user,usedType)
    --DebugMessage("1")
    if(usedType ~= "Interact") then return end

    if(AI.GetSetting("NoSpeakOnInteract")) then return end
    FaceObject(this,user)
    --TalkNeutral(user)
    this:NpcSpeech(MemorialSpeech[math.random(1,#MemorialSpeech)])
end

this:SetObjVar("DoesNotNeedPath",true)
OverrideEventHandler("NOS:base_ai_conversation",EventType.Message, "UseObject", HandleInteract)