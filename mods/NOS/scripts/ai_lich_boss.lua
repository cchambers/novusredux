require 'base_ai_intelligent'

quotes = {
	 "There's a sight for sore bones",
   "You'll be just as dead soon enough!",
   "Look at the bones on that one!",
   "I'll rip his bones out!",
   "I'll swallow your soul!",
	 "I got a bone to pick with you!",
	 "I'll cut off your gizzard!",
	 --"Oh look, it's little goodie two shoes!",
   "You'll be bone-cold when I'm done with you!",
   "I got a bone for you!",
   "Put your backbones into it!",
   "Let's fight, meat boy!",
   "I'll rip your bones out!",
   "Come on you bags of bones!",
}

AI.Settings.ChaseRange = 25.0
AI.Settings.LeashDistance = 35

AI.StateMachine.AllStates.DecidingCombat = {
        OnEnterState = function()	
       		if (math.random(1,300) == 1) then
       			this:StopMoving()
       			this:PlayAnimation("rend")
       			this:NpcSpeech(quotes[math.random(1,#quotes)])
       		end
        end,
    }

RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
        if (IsGuard(killer)) then return end

        CreateObj("treasurechest_lich",this:GetLoc(),"created_chest")

    end)

RegisterEventHandler(EventType.CreatedObject,"created_chest",function (success,objRef)
    if (success) then
        Decay(objRef, 800)
        objRef:SetFacing(270)
    end
end)