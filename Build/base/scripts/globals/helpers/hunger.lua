
function HungerUpdate(player, amount)
	if ( IsImmortal(player) and not TEST_HUNGER ) then return end
    if ( IsDead(player) or amount == nil ) then return end

    -- if Hunger isn't set, we need to negate (-) amount since we are just going to add it to its self on the next line, to produce a 0 regardless of amount passed.
    local hunger = player:GetObjVar("Hunger") or -amount
    hunger = math.clamp(hunger + amount, 0, ServerSettings.Hunger.MaxHunger)

    -- apply hungry debuff if they are
    if ( hunger >= ServerSettings.Hunger.Threshold ) then
        player:SystemMessage("You are starving!", "info")
        if not( HasMobileEffect(player, "Hungry") ) then
            StartMobileEffect(player, "Hungry")
        end
    elseif( ServerSettings.Hunger.WarnThreshold and hunger >= ServerSettings.Hunger.WarnThreshold) then
        player:SystemMessage("You could use a bite to eat.", "info")
    else
        if ( HasMobileEffect(player, "Hungry") ) then
            player:SendMessage("EndHungryEffect")
        end

        if(hunger < 1) then
            player:SystemMessage("You feel sated.", "info")
        end

    end

    --player:NpcSpeech("Hunger: "..tostring(hunger))
    player:SetObjVar("Hunger", hunger)
end

function VitalityCheck(player)
    local curVit = GetCurVitality(player)
    --player:NpcSpeech("Vit: "..tostring(curVit))
    -- set debuff for low vitality if they don't have it and their vitality is low
    if ( curVit <= ServerSettings.Vitality.Low ) then
        player:SystemMessage("You are exhausted! You need to return to an inn to rest.", "info")
        if not( HasMobileEffect(player, "LowVitality") ) then
            StartMobileEffect(player, "LowVitality", nil, nil)
        end
    elseif( ServerSettings.Vitality.Warn and curVit <= ServerSettings.Vitality.Warn) then
        player:SystemMessage("You are getting tired and should return to an inn to rest.", "info")
    end
end