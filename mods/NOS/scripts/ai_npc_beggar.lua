require 'ai_villager'

AI.CustomSpeech.BeggarSpeech = {
    IdleSpeech = { 
        "I wish I could earn an income...", 
        "[$360]", 
        "I miss my home in Petra... don't you?",
        "It's a shame we've fallen on hard times...",
        "I wish that I had more money.",
        "We're lucky the dead don't make us join them.",
        "I hear the dead are stirring in their graves." ,
        "At least the weather's nice, right?",
        "I'm so bored.",
        "I wish I had a job.",
        "Busy today?",
    },
}

AI.Settings.SpeechTable = "BeggarSpeech"
AI.Settings.FallbackSpeechTable = "Villager"

for i,j in pairs(AI.IdleStateTable) do
    if j.StateName == "GoLocation" then
        table.remove(AI.IdleStateTable,i)
    end
end

this:SetObjVar("DoesNotNeedPath",true)