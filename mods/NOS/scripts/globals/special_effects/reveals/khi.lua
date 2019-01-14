

SpecialEffects.RevealKade = {
    {
        Iterations = 18,
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
                PlayEffectAtLoc("CastVoid2", cache.loc, 10)
                PlayEffectAtLoc("TurbulentWindEffect", cache.loc, 10)
            end
            CallFunctionDelayed(TimeSpan.FromSeconds(i * 0.1), function()
                local angle = 0.4
                if ( cache.isCloaked ) then
                    angle = angle * ( i + 3 )
                else
                    angle = angle * ( ( SpecialEffects.RevealKade[1].Iterations - i ) + 3 )
                end
                local x = (0.001+angle)*math.cos(angle)
                local z = (0.001+angle)*math.sin(angle)
                local loc = Loc(cache.loc.X+x, cache.loc.Y, cache.loc.Z+z-1.55)
                PlayEffectAtLoc("VoidPillar", loc, 3)
                if ( ( cache.isCloaked and i == 15 ) or ( not cache.isCloaked and i == 18 ) ) then
                    if not( cache.isCloaked ) then
                        CallFunctionDelayed(TimeSpan.FromSeconds(1), function()
                            obj:PlayObjectSound("event:/magic/void/magic_void_cast_void")
                            obj:SetCloak(not cache.isCloaked)
                        end)
                    else
                        obj:SetCloak(not cache.isCloaked)
                        obj:PlayObjectSound("event:/magic/void/magic_void_cast_void")
                    end
                end
            end)
        end
    }
}
--SpecialEffects.RevealKade = SpecialEffects.RevealDefault