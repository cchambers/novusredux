require 'NOS:ai_follower'

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        this:PlayEffect("IgnitedEffect",7)
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(3.8),"PlayVanishEffect")
    end)

RegisterEventHandler(EventType.Timer, "PlayVanishEffect", 
	function()
		PlayEffectAtLoc("VoidTeleportToEffect",this:GetLoc(),4)
	end)

