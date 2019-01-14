

SpecialEffects.RevealGrim = {
    {
        Iterations = 7,
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
            CallFunctionDelayed(TimeSpan.FromSeconds(i-1), function()
                local percent = i / 20
                if not( cache.isCloaked ) then
                    percent = 1 - percent
                end
                local loc = cache.loc:Project(math.random(1,360), math.random(2,8))
                PlayEffectAtLoc("LightningCloudEffect", loc, math.random(2,4))
                if ( i == 4 ) then
                    for i=1,3 do
                        PlayEffectAtLoc("LightningEffect", cache.loc:Project(i*120, 0.5), 4)
                    end
                    PlayEffectAtLoc("CastAir2", cache.loc, 10)
                    CallFunctionDelayed(TimeSpan.FromSeconds(0.5), function()
                        if not( cache.isCloaked ) then
                            obj:PlayObjectSound("event:/magic/air/magic_air_lightning")
                        end
                        obj:SetCloak(not cache.isCloaked)
                        if ( cache.isCloaked ) then
                            obj:PlayObjectSound("event:/magic/air/magic_air_lightning")
                        end
                    end)
                end
            end)
        end
    },
}