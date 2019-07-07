require 'ai_void_worshiper'

AI.Settings.SpeechTable = "Berserker"   

RegisterEventHandler(EventType.Message, "DamageInflicted",
    function (damager)
        if AI.IsValidTarget(damager) then
        if (IsFriend(attacker) and AI.Anger < 100) then return end
            local myTeamType = this:GetObjVar("MobileTeamType")
            local nearbyTeamMembers = FindObjects(SearchMulti(
            {
                SearchMobileInRange(20), --in 10 units
                SearchObjVar("MobileTeamType",myTeamType), --find others with my team type
            }))
            for i,j in pairs (nearbyTeamMembers) do
                j:SendMessage("AttackEnemy",damager) --defend me
            end
        end
    end)
--Don't give them the devil horns helm
RegisterEventHandler(EventType.Message, "HasDiedMessage",
    function(killer)
    	--this:GetEquippedObject("Head"):Destroy()
    	--this:DelObjVar("noloot")
    end)

