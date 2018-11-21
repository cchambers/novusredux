

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
            CallFunctionDelayed(TimeSpan.FromSeconds(i * 0.1), function()
                local angle = 0.4
                if ( cache.isCloaked ) then
                    angle = angle * ( i + 3 )
                else
                    angle = angle * ( ( SpecialEffects.RevealKade[1].Iterations - i ) + 3 )
                end
                local x = (0.001+angle)*math.cos(angle)
                local z = (0.001+angle)*math.sin(angle)
                PlayEffectAtLoc("VoidPillar", Loc(cache.loc.X+x, cache.loc.Y, cache.loc.Z+z-1.55), 3)
                if ( ( cache.isCloaked and i == 15 ) or ( not cache.isCloaked and i == 18 ) ) then
                    if not( cache.isCloaked ) then
                        CallFunctionDelayed(TimeSpan.FromSeconds(1), function()
                            obj:SetCloak(not cache.isCloaked)
                        end)
                    else
                        obj:SetCloak(not cache.isCloaked)
                    end
                end
            end)
        end
    }
}