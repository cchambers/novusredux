

SpecialEffects.RevealSupreem = {
    {
        Iterations = 11,
        --- Cache is overwritten as you add more effects
        Cache = function(obj, lastCache)
            local cache = {
                loc = obj:GetLoc(),
                isCloaked = obj:IsCloaked()
            }
            return cache
        end,
        OnIter = function(i, obj, cache)
            CallFunctionDelayed(TimeSpan.FromSeconds(i * 0.25), function()
                local x = 0
                if ( cache.isCloaked ) then
                    x = ( i * -1 ) + 6
                else
                    x = ( i * 1 ) - 6
                end
                PlayEffectAtLoc("FirePillarEffect", Loc(cache.loc.X+x, cache.loc.Y, cache.loc.Z), 3)
                if ( i == 7 ) then
                    obj:SetCloak(not cache.isCloaked)
                end
            end)
        end
    },
    {
        Iterations = 11,
        OnIter = function(i, obj, cache)
            CallFunctionDelayed(TimeSpan.FromSeconds(i * 0.25), function()
                local z = 0
                if ( cache.isCloaked ) then
                    z = ( i * 1 ) - 6
                else
                    z = ( i * -1 ) + 6
                end
                PlayEffectAtLoc("FirePillarEffect", Loc(cache.loc.X, cache.loc.Y, cache.loc.Z+z), 3)
            end)
        end
    }
}