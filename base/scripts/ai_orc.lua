require 'ai_default_human'

AI.Settings.SpeechTable = "OrcSpeech"

if (initializer ~= nil) then
    if( initializer.OrkNames ~= nil ) then    
        local name = initializer.OrkNames[math.random(#initializer.OrkNames)]
        this:SetName(name)
    end
end