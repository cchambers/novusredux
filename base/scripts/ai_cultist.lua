require 'base_ai_mob'
require 'base_ai_casting'
require 'incl_regions'
require 'base_ai_intelligent'
require 'base_ai_conversation'
require 'incl_faction'
require 'incl_run_path'
--require 'base_ai_sleeping'

AI.Settings.Debug = false
-- set charge speed and attack range in combat ai

AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 10.0
AI.Settings.LeashDistance = 20
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = false
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2
AI.Settings.SpeechTable = "Cultist"
AI.Settings.ShouldFlee = true

if (this:GetObjVar("controller") ~= nil) then
    AI.Settings.CanWander = true
end
