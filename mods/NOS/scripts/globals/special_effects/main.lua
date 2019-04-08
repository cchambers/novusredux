SpecialEffects = {}

function StartSpecialEffect(obj, effectName)
    local cache = {}
    for ii = 1, #SpecialEffects[effectName] do
        if (SpecialEffects[effectName][ii].Iterations and SpecialEffects[effectName][ii].OnIter) then
            if (SpecialEffects[effectName][ii].Cache) then
                -- update the cache
                cache = SpecialEffects[effectName][ii].Cache(obj, cache)
            end
            for i = 1, SpecialEffects[effectName][ii].Iterations do
                SpecialEffects[effectName][ii].OnIter(i, obj, cache)
            end
        end
    end
end

function DoReveal(mobile)
    name = StripColorFromString(mobile:GetName())
    name = name:gsub("%s+", "")
    effectName = tostring("Reveal" .. name)
    if (type(SpecialEffects[effectName]) ~= "table") then
        effectName = "RevealDefault"
    end
    
    StartSpecialEffect(mobile, effectName)
end

require "globals.special_effects.reveals.main"
