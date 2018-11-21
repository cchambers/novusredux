-- Create a namespace for combat ai
require 'base_ai_settings'


aggroList = {}

AI.MeleeTarget = nil

-- when we change combat targets, we need to start attacking the new target
-- and also begin pathing to him
function HandleNewTarget()
	--DebugMessageA(this,"HandleNewTarget".. "from " .. this:GetName())
	if( AI.MeleeTarget ~= nil ) then
		DebugMessageA(this,"[AI][HandleNewTarget] New melee target "..tostring(AI.MeleeTarget:GetName()))
		-- enter combat mode
     	this:SendMessage("AttackTarget",AI.MeleeTarget)
    else
    	DebugMessageA(this,"[AI][HandleNewTarget] Clearing melee target")
    	this:SendMessage("HandleEndCombat")
    end    
end

function AI.IsValidTarget(target)
	return target ~= nil and not target:HasObjVar("Invulnerable") and ValidCombatTarget(this, target, true)
end

-- Threat determines who should be our primary target
function AI.AddThreat(target,additionalThreat)
	--DebugMessage(1)
	if( not(AI.IsValidTarget(target)) ) then
		return
	end
	--DebugMessage(2)
	if (not target:IsMobile()) then return end
	--DebugMessage(3)
	--LuaDebugCallStack("target is "..tostring(target:GetName()))
    if( aggroList[target] == nil ) then
    	--
    	AI.AddToAggroList(target,additionalThreat)
    	--DebugMessage("Adding to aggro list")
    else
    	--DebugMessage("Adding threat")
    	DebugMessageA(this,"[AI][AddThreat] Adding "..additionalThreat.." to "..target:GetName().." Threat: " .. (aggroList[target] + additionalThreat))
    	aggroList[target] = aggroList[target] + additionalThreat
    end
end

-- This will add a mob to the aggro list if he is not already there
function AI.AddToAggroList(target,initialThreat)
	--DebugMessageA(this,"AddToAggroList".. "from " .. this:GetName())
	if( aggroList[target] == nil ) then
		DebugMessageA(this,"[AI][AddThreat] Adding to aggro list: "..target:GetName().. " initialThread: "..tostring(initialThreat))
    	aggroList[target] = initialThreat
    	this:SendMessage("AddVictim",target)
    end
end

function AI.InAggroList(target)
	--DebugMessage(DumpTable(aggroList))
	--DebugMessage(target)
	for i,j in pairs(aggroList) do
		if (target == i) then
			return true
		end
	end
	return false
end

-- This gets called when a mob leaves chase range
function AI.RemoveFromAggroList(target)
	DebugMessageA(this,"RemoveFromAggroList".. "from " .. this:GetName())
	if( aggroList[target] ~= nil ) then
	    aggroList[target] = nil
	    DebugMessageA(this,"Removing target: ".. tostring(target) ..", threat: "..tostring(aggroList[target]))	
		this:SendMessage("HandleEndCombat",target)
    end

    if( AI.MeleeTarget == target ) then
    	AI.ClearMeleeTarget()
    end
end

function AI.ClearAggroList()
	DebugMessageA(this,"ClearAggroList".. "from " .. this:GetName())
	aggroList = {}

	if( AI.MeleeTarget ~= nil ) then
    	AI.ClearMeleeTarget()
    end
    DebugMessageA(this,"Clear Target")
    this:SendMessage("EndCombatMessage")
end

-- this forces a mob to attack a specific target
function AI.SetMeleeTarget(newTarget)
	--DebugMessageA(this,"SetCombatTarget".. "from " .. this:GetName())
	-- you cant attack something if you are dead
	if( IsDead(this) ) then
		DebugMessageA(this,"[SetMeleeTarget] I am dead")
		return
	end

	--DebugMessageA(this,"[incl_combatai::SetCombatTarget] " .. this:GetName() .. ": " .. tostring(newTarget))

	-- check target valid
	if( newTarget == nil or not(newTarget:IsValid()) ) then
		return
	end
	--DebugMessageA(this,"My current melee target is"..tostring(AI.MeleeTarget))
	if(AI.MeleeTarget == nil or newTarget ~= AI.MeleeTarget) then
		AI.MeleeTarget = newTarget
		HandleNewTarget()
	end
end

-- choose a new target based on threat level
function AI.GetNewTarget(maxRange)
	--DebugMessageA(this,"GetNewTarget" .. "from " .. this:GetName())
	--DebugMessageA(this,"[incl_combatai::GetNewTarget]")
	--DebugMessage(DumpTable(aggroList))
    -- find the list of targets with the highest threat
	local highestAggro = 0
	local highestAggroTargets = {}
	for target,threat in pairs(aggroList) do			
		-- clean up aggro list as we go
		--DebugMessageA(this,"[incl_combatai::GetNewTarget] Evaluating target: "..target:GetName().." threat: "..tostring(threat))
		--DebugMessage("EVALULATION",not(maxRange),target:DistanceFrom(this) <= maxRange,not AI.MainTarget == target )
		if( not(AI.IsValidTarget(target)) ) then
			--DebugMessageA(this,"Setting target to nil")
			aggroList[target] = nil
		elseif(not(maxRange) or target:DistanceFrom(this) <= maxRange or AI.MainTarget == target) then
			-- if this is higher than the highest we have seen reset the list
			if( threat > highestAggro ) then
				highestAggroTargets = { target }
				highestAggro = threat
			-- if this target has current highest threat add him to the list
			elseif( threat == highestAggro ) then
				highestAggroTargets[#highestAggroTargets + 1] = target
			end
		end
	end

	if( #highestAggroTargets == 0 ) then
		DebugMessageA(this,"[AI][GetNewTarget] No aggro target")
		return nil
	elseif( #highestAggroTargets == 1 ) then
		DebugMessageA(this,"[AI][GetNewTarget] Aggro target (1) " .. tostring(highestAggroTargets[1]:GetName()))
		return highestAggroTargets[1]
	end

	-- we have more than one target with the same threat level, pick the closest one
	closestDist = nil
	newTarget = nil
	for i=1,#highestAggroTargets do
		local dist = this:DistanceFrom(highestAggroTargets[i])
		if(closestDist == nil or dist < closestDist ) then
			newTarget = highestAggroTargets[i]
			closestDist = dist
		end
	end
	DebugMessageA(this,"[AI][GetNewTarget] Aggro target (2) " .. tostring(newTarget:GetName()))
	return newTarget
end

-- remove our combat target and message other scripts
-- NOTE: If you are using the default AI, do not call this directly, send a "ClearTarget" message.
function AI.ClearMeleeTarget()
	--DebugMessageA(this,"ClearTarget".. "from " .. this:GetName())
	if( AI.MeleeTarget ~= nil ) then
		DebugMessageA(this,"[ClearMeleeTarget]")
		AI.MeleeTarget = nil
    	HandleNewTarget()
    end
end