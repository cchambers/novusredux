

SpecialEffects.RevealDefault = {
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
            obj:SetCloak(not cache.isCloaked)
            obj:PlayEffect("HolyEffect")
        end
    },
}