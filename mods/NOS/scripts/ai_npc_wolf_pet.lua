require 'NOS:base_ai_mob' 

AI.Settings.Leash = true
AI.Settings.StationedLeash = true

function IsFriend(target)
    --My only enemy is the enemy
    if (AI.MainTarget ~= target or target:IsPlayer()) then
        return true
    else
        return false
    end
end

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Interact") then return end
        if math.random(1,100) ~= 1 then
            this:NpcSpeech("Woof!")
        else
            this:NpcSpeech("Stop poking me you ape!")
        end
    end)

RegisterEventHandler(EventType.Message,"AttackedBySpell",
	function(attacker,abilityName)
		if (abilityName == "Heal") then
			--attacker:SendMessage("AdvanceQuest","MageIntroQuest","TalkToVivia","CastHealOnLegas")
		end
	end)

AI.Init()
