

SpecialEffects.RevealZenroth = {
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
            PlayEffectAtLoc("TurbulentWindEffect", cache.loc, 10)
            PlayEffectAtLoc("FlameAuraEffect", cache.loc, 10)
            CallFunctionDelayed(TimeSpan.FromSeconds(2), function()
                if not( cache.isCloaked ) then
                    obj:PlayObjectSound("event:/magic/fire/magic_fire_wall_of_fire", false, 3)
                end
                obj:SetCloak(not cache.isCloaked)
                if ( cache.isCloaked ) then
                    obj:PlayObjectSound("event:/magic/fire/magic_fire_wall_of_fire", false, 3)
                end
            end)
            for i=1,3 do
                PlayEffectAtLoc("VoidPillar", cache.loc, 5)
            end
            for i=1,6 do
                PlayEffectAtLoc("FirePillarEffect", cache.loc:Project(i*60, 3), 5)
            end
        end
    },
}