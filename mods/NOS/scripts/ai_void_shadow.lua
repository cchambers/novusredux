require 'base_ai_mob'
require 'base_ai_intelligent'
require 'base_ai_casting'

AI.Settings.CanUseCombatAbilities = false
AI.Settings.CanCast = true

RegisterEventHandler(EventType.Message,"CopyOtherMobile",function ( ... )
	AI.Settings.CanUseCombatAbilities = true
	AI.Settings.CanConverse = true
	this:SendMessage("UpdateName")
end)

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
    	this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5),"DestroyWraith")
    	PlayEffectAtLoc("VoidTeleportToEffect",this:GetLoc(),2)
    end)


RegisterEventHandler(EventType.Timer,"DestroyWraith",function ( ... )
	this:Destroy()
end) 