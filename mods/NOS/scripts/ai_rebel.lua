require 'base_ai_mob'
require 'base_ai_casting'
require 'base_ai_intelligent'
require 'base_ai_conversation'
require 'incl_faction'

AI.Settings.Debug = false
AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 15.0
AI.Settings.LeashDistance = 20
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.Leash = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2
AI.Settings.SpeechTable = "Rebel"
AI.Settings.ShouldFlee = true

if (this:GetObjVar("controller") ~= nil) then
    AI.Settings.CanWander = true
end
