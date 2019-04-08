

SpecialEffects.RevealMuska = {
    {
        Iterations = 2,
        --- Cache is overwritten as you add more effects
        Cache = function(obj, lastCache)
            local cache = {
                loc = obj:GetLoc(),
                isCloaked = obj:IsCloaked()
            }
            cache.loc.Y = cache.loc.Y + 1
            return cache
        end,
        OnIter = function(i, obj, cache)
            if ( i == 1 ) then
                PlayEffectAtLoc("CastEarth2", cache.loc, 10)
                PlayEffectAtLoc("TurbulentWindEffect", cache.loc, 7)
            end
            CallFunctionDelayed(TimeSpan.FromSeconds((i-1)*0.5), function()
                PlayEffectAtLoc("DarkEnergySpawnEffect", cache.loc)
                if ( i == 2 ) then
                    if not( cache.isCloaked ) then
                        obj:PlayObjectSound("event:/magic/void/magic_void_grim_aura")
                    end
                    obj:SetCloak(not cache.isCloaked)
                    if ( cache.isCloaked ) then
                        obj:PlayObjectSound("event:/magic/void/magic_void_grim_aura")
                    end
                end
            end)
        end
    },
}