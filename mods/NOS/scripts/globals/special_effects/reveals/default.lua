
SpecialEffects.RevealDefault = {
    {
        Iterations = 10,
        --- Cache is overwritten as you add more effects
        Cache = function(obj, lastCache)
            local cache = {
                loc = obj:GetLoc(),
                isCloaked = obj:IsCloaked()
            }
            cache.Y = cache.loc.Y
            if not( cache.isCloaked ) then
                cache.loc.Y = cache.loc.Y + 2
            end
            return cache
        end,
        OnIter = function(i, obj, cache)
            if ( i == 1 ) then 
                PlayEffectAtLoc("PrimedAir2", Loc(cache.loc.X, cache.Y, cache.loc.Z), 10)
            end
            CallFunctionDelayed(TimeSpan.FromSeconds(i * 0.25), function()
                PlayEffectAtLoc("ConjurePrimeBlueEffect", Loc(cache.loc.X, cache.loc.Y, cache.loc.Z - 0.5), 3)
                cache.loc.Y = cache.loc.Y + (cache.isCloaked and 0.2 or -0.2)

                if ( i == 10 ) then
                    CallFunctionDelayed(TimeSpan.FromSeconds(1), function()
                        if not( cache.isCloaked ) then
                            obj:PlayObjectSound("event:/magic/void/magic_void_spawn_imp")
                        end
                        obj:SetCloak(not cache.isCloaked)
                        if ( cache.isCloaked ) then
                            obj:PlayObjectSound("event:/magic/void/magic_void_spawn_imp")
                        end
                    end)
                end
            end)
        end
    }
}