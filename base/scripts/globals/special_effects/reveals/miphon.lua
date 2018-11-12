

SpecialEffects.RevealMiphon = {
    {
        Iterations = 1,
        --- Cache is overwritten as you add more effects
        Cache = function(obj, lastCache)
            local cache = {
                loc = obj:GetLoc(),
                isCloaked = obj:IsCloaked()
            }
            return cache
        end,
        OnIter = function(i, obj, cache)
            PlayEffectAtLoc("DarkEnergySpawnEffect", cache.loc)
            this:SetCloak(not cache.isCloaked)
        end
    },
}