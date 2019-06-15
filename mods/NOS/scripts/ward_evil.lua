
--[[

    This is the Lua Module that controlls the ward in the world.

]]

local effectPulse = TimeSpan.FromSeconds(10)

function CleanUp()
    this:Destroy()
end

local Owner
if ( initializer ) then
    Owner = initializer.Owner
    if (Owner ~= nil) then
        Owner:PlayObjectSound("event:/magic/void/magic_void_cast_void", false, 0.0, false, false)
    end
end

if not( Owner ) then
    CleanUp()
    return
end

local loc = this:GetLoc()

RegisterEventHandler(EventType.EnterView, "NearbyOutcasts", function(player)
    -- prevent detecting self or ghosts or GMs/etc
    if ( player == Owner or IsDead(player) or IsImmortal(player) ) then return end
    if ( GetKarmaLevel(GetKarma(player)).Evil == true ) then
        Owner:SendMessageGlobal("WardUpdate", "Evil")
        CleanUp()
    end
    PlayEffectAtLoc("MagicRingExplosionEffect", loc, 4.0)
    this:PlayObjectSound("event:/magic/air/magic_air_cloack", false, 0.0, true, true)
end)

RegisterEventHandler(EventType.Message, "RemoveWard", CleanUp)

-- handle the effect pulsing
RegisterEventHandler(EventType.Timer, "WardEffectPulse", function()
    Owner:PlayLocalEffect(this,"MagicRingEffect", effectPulse.TotalSeconds)
    this:ScheduleTimerDelay(effectPulse, "WardEffectPulse")
end)
this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5), "WardEffectPulse")

-- start searching
AddView("NearbyOutcasts", SearchPlayerInRange(9), 2)

-- eventually fade
CallFunctionDelayed(TimeSpan.FromMinutes(10), function()
    Owner:SendMessageGlobal("WardUpdate", "Fade")
    CleanUp()
end)