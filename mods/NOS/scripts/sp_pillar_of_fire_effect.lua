local PILLAROFFIRE_DAMAGE_RANGE = 2
local mTargetLoc = nil
local mPillarActive = false
local function ValidatePillarOfFire(targetLoc)
    DebugMessage("TWO")

    if( not(IsPassable(targetLoc)) ) then
        this:SystemMessage("[$2616]","info")
        return false
    end

    if not(this:HasLineOfSightToLoc(targetLoc,ServerSettings.Combat.LOSEyeLevel)) then
        this:SystemMessage("[$2617]","info")
        return false
    end
    return true
end

RegisterEventHandler(EventType.Message,"SpellHitUserEffectsp_pillar_of_fire_effect",
    function (target)
        DebugMessage("One")
        target:PlayEffect("FireTornadoEffect")
        
        CallFunctionDelayed(TimeSpan.FromSeconds(1.5), function() 
            EndEffect(target)
        end);

    end)



function EndEffect(target)
    target:StopEffect("FireTornadoEffect")
    this:DelModule("sp_pillar_of_fire_effect")
end