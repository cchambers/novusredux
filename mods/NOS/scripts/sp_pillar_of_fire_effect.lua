RegisterEventHandler(EventType.Message,"SpellHitUserEffectsp_pillar_of_fire_effect",
    function (target)
        DebugMessage("One")
        target:PlayEffect("FireTornadoEffect")
        
        CallFunctionDelayed(TimeSpan.FromSeconds(1.5), function() 
            EndEffect(target)
        end);

    end)


function EndEffect(target)
    target:StopEffect("FireTornadoEffect")
    this:DelModule("sp_pillar_of_fire_effect")
end