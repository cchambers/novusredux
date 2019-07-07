function GetVitalityDisplayString(vitality)
    local vitPct = vitality / ServerSettings.Stats.BaseVitality
    for i,vitDisplayInfo in pairs(ServerSettings.Vitality.DisplayStrings) do
        if(vitPct >= vitDisplayInfo[1]) then
            return vitDisplayInfo[2]
        end
    end

    return "Rested"
end

function VitalityCheck(player)
    local curVit = GetCurVitality(player)
    --player:NpcSpeech("Vit: "..tostring(curVit))
    -- set debuff for low vitality if they don't have it and their vitality is low
    if ( curVit <= ServerSettings.Vitality.Low ) then
        player:SystemMessage("You are exhausted! Return to an inn to rest.", "info")
        if not( HasMobileEffect(player, "LowVitality") ) then
            StartMobileEffect(player, "LowVitality", nil, nil)
        end
    elseif( ServerSettings.Vitality.Warn and curVit <= ServerSettings.Vitality.Warn) then
        player:SystemMessage("You are getting tired and should return to an inn to rest.", "info")
    end
end