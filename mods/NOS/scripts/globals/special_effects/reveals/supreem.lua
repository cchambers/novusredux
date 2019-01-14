

SpecialEffects.RevealSupreem = {
    {
        Iterations = 8,
        --- Cache is overwritten as you add more effects
        Cache = function(obj, lastCache)
            local cache = {
                loc = obj:GetLoc(),
                isCloaked = obj:IsCloaked()
            }
            return cache
        end,
        OnIter = function(i, obj, cache)
            if ( i == 1 ) then
                PlayEffectAtLoc("TurbulentWindEffect", cache.loc, 10)
            end
            CallFunctionDelayed(TimeSpan.FromSeconds(i * 0.25), function()
                local x = 0
                local z = 0
                if ( cache.isCloaked ) then
                    x = ( i * 1 ) - 8
                    z = ( i * 1 ) - 8
                else
                    x = ( i * -1 )
                    z = ( i * -1 )
                end
                --x
                PlayEffectAtLoc("FirePillarEffect", Loc(cache.loc.X+x, cache.loc.Y, cache.loc.Z), 3)
                PlayEffectAtLoc("FirePillarEffect", Loc(cache.loc.X-x, cache.loc.Y, cache.loc.Z), 3)

                --z
                PlayEffectAtLoc("FirePillarEffect", Loc(cache.loc.X, cache.loc.Y, cache.loc.Z+z), 3)
                PlayEffectAtLoc("FirePillarEffect", Loc(cache.loc.X, cache.loc.Y, cache.loc.Z-z), 3)
                
                PlayEffectAtLoc("FirePillarEffect", Loc(cache.loc.X+x, cache.loc.Y, cache.loc.Z+z), 3)
                PlayEffectAtLoc("FirePillarEffect", Loc(cache.loc.X-x, cache.loc.Y, cache.loc.Z-z), 3)
                PlayEffectAtLoc("FirePillarEffect", Loc(cache.loc.X+x, cache.loc.Y, cache.loc.Z-z), 3)
                PlayEffectAtLoc("FirePillarEffect", Loc(cache.loc.X-x, cache.loc.Y, cache.loc.Z+z), 3)

                if ( (cache.isCloaked and i == 8) or (not cache.isCloaked and i == 1) ) then
                    CallFunctionDelayed(TimeSpan.FromSeconds(2), function()
                        if not( cache.isCloaked ) then
                            obj:PlayObjectSound("event:/magic/fire/magic_fire_wall_of_fire", false, 3)
                        end
                        obj:SetCloak(not cache.isCloaked)
                        PlayEffectAtLoc("CastFire2", cache.loc, 10)
                        if ( cache.isCloaked ) then
                            obj:PlayObjectSound("event:/magic/fire/magic_fire_wall_of_fire", false, 3)
                        end
                    end)
                end
            end)
        end
    },
}