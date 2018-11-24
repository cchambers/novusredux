require 'base_ai_mob'
require 'base_ai_casting'
require 'base_ai_intelligent'

quotes = {
	 "I got lots of bone-cold stuff for you",
	 "Feel that? It's the chill of my bones!",
	 "Let's fight, flesh boy!",
	 "Eat some fireball flesh man!",
}

AI.Settings.ChaseRange = 15.0
AI.Settings.LeashDistance = 25

AI.StateMachine.AllStates.DecidingCombat = {
        OnEnterState = function()	
       		if (math.random(1,300) == 1) then
       			this:StopMoving()
       			this:PlayAnimation("rend")
       			this:NpcSpeech(quotes[math.random(1,#quotes)])
       		end
        end,
    }
