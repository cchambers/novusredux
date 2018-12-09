local mCurJump = 0
local jumpSkill = GetSkillLevel(this,"MagerySkill")
local maxJumps =  math.floor(GetSkillPctPotency(jumpSkill) * 6) + 1
local hasHit = {}
local rangeSkill = GetSkillLevel(this,"ChannelingSkill")
local CHAIN_JUMP_RANGE = math.floor(GetSkillPctPotency(rangeSkill) * 5) + 3
local curPhase = 0
local lastPhase = 0
local targQueue = {}
local queuedTargets = {}
local mActive = true

this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "RemoveChainLightningTimer")
RegisterEventHandler(EventType.Message,"SpellHitUserEffectsp_chain_lightning_effect",
	function(target)
		hasHit[target] = true
		local potJumps = 0
		--DebugMessage("CL curjump: " .. mCurJump .. " Max: " ..maxJumps)
			if(mCurJump < maxJumps) then
				local mobiles = FindObjects(SearchMulti({
					SearchRange(target:GetLoc(),CHAIN_JUMP_RANGE),
					SearchMobile()}), GameObj(0))
				--DebugMessage("InRange:" .. #mobiles)
				if(#mobiles > 0) then
					curPhase = curPhase + 1
					targQueue[curPhase] = {}
					for i, v in pairs(mobiles) do
						----DebugMessage("V is "..v:GetName())
						---DebugMessage("Checking pvp flag", and v:IsPlayer()) )
						if ( hasHit[v] == nil and ValidCombatTarget(this, v, true) ) then
							
							if not(mCurJump < maxJumps) then 
								mActive = false
								--this:ScheduleTiemrDelay(TimeSpan.FromSeconds(1), "RemoveChainLightningTimer")
								break 
							end
							--DebugMessage(tostring(target) .. " queued " .. tostring(v))
							queuedTargets[v] = true
							potJumps = potJumps + 1
							--hasHit[v] = true
							target:PlayProjectileEffectTo("ChainLightningEffect",v,1,1)
							v:PlayEffect("ChainLightningExplosionEffect")
							
							mCurJump = mCurJump + 1
							targQueue[curPhase][v] = true
							else
								--DebugMessage("V ALREADY")
							
						end
					end
				end
				if(lastPhase < curPhase) then 
			
							ProcessPhase(curPhase)
				
				else
					this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "RemoveChainLightningTimer")
				end
				
			end

		end)

function EndEffect()
	this:DelObjVar("sp_chain_lightning_effectSource")
	this:FireTimer("sp_chain_lightning_effect_removemodule")
end

function ProcessPhase(phaseNum)
	if(lastPhase == phaseNum) then
		this:FireTimer("RemoveChainLightningTimer")
		return
	end
	lastPhase = phaseNum
	for i, v in pairs(targQueue[phaseNum]) do
		--i:NpcSpeech("CHAINING")
		if(hasHit[i] == nil) then this:SendMessage("RequestMagicalAttack", "Chainlightning", i, this, true) end
	end
	if(curPhase <= lastPhase) then this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "RemoveChainLightningTimer") end
end
function ModuleCleanUp()
	this:DelModule("sp_chain_lightning_effect")
end
RegisterEventHandler(EventType.Timer, "sp_chain_lightning_effect_removemodule", ModuleCleanUp)

RegisterEventHandler(EventType.Timer, "RemoveChainLightningTimer", EndEffect)
