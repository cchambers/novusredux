require 'base_idol_player_script'

AddView("FindAnimals",SearchMobileInRange(20))

function AttachDebuff(holder)
end

function DetachDebuff(holder)
    DelView("FindAnimals")
end

--makes animals attack anything that get near it

RegisterEventHandler(EventType.EnterView,"FindAnimals",
	function (objRef)
	local holder = this:TopmostContainer() 
	if (holder ~= nil) then
        if (not AI.IsValidTarget(mobileObj)) then 
            return 
        end

        if (IsDead(objRef) or IsAsleep(objRef)) then
            return
        end

        if (objRef:GetMobileType() == "Animal") then
        	objRef:SendMessage("AttackEnemy",holder)
        end
    end
end)
AttachDebuff()