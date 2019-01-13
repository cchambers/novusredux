
SpecialEffects = {}

--- Start a Special Effect (Particle Effects and stuff in a sequence)
-- @param obj gameObj - The game obj to anchor the effect
-- @param effectName string - The Name of the effect
function StartSpecialEffect(obj, effectName)
    local cache = {}
    for ii=1,#SpecialEffects[effectName] do
        if ( SpecialEffects[effectName][ii].Iterations and SpecialEffects[effectName][ii].OnIter ) then
            if ( SpecialEffects[effectName][ii].Cache ) then
                -- update the cache
                cache = SpecialEffects[effectName][ii].Cache(obj, cache)
            end
            for i=1,SpecialEffects[effectName][ii].Iterations do
                SpecialEffects[effectName][ii].OnIter(i, obj, cache)
            end
        end
    end
end

function DoReveal(mobile)
    local effectName = string.format("Reveal%s", StripColorFromString(mobile:GetName()))
    if ( SpecialEffects[effectName] == nil ) then effectName = "RevealDefault" end
    StartSpecialEffect(mobile, effectName)
end

require 'globals.special_effects.reveals.main'