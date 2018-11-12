MobileEffectLibrary = {}

function EndMobileEffect(effectTable)
    Verbose("MobileEffect", "EndMobileEffect", effectTable)
	local mobileEffects = effectTable.ParentObj:GetObjVar("MobileEffects") or {}
	mobileEffects[effectTable.EffectName] = nil
	effectTable.ParentObj:SetObjVar("MobileEffects",mobileEffects)

	StateMachine.Unregister(effectTable)
end

--- This function MUST be called from the context of a module that is attached on mobileObj,
---- for example, inside player.lua you could call StartMobileEffect(this,...)
---- but on a module attached to a different player or an NPC you'd have to do player:SendMessage("StartMobileEffect",...) to start the effect on player in first example.

function StartMobileEffect(mobileObj,effectName,target,args)
    Verbose("MobileEffect", "StartMobileEffect", mobileObj,effectName,target,args)
	if not( MobileEffectLibrary[effectName] ) then
		LuaDebugCallStack("[StartMobileEffect] '".. effectName.."' does not seem to exist.")
		return false
	end

	target = target or nil
	args = args or {}

	-- when immune debuffs cannot apply
	if ( MobileEffectLibrary[effectName].Debuff == true and IsMobileImmune(mobileObj) ) then
		return true -- true cause it was successful, it just got eaten.
	end

	-- some effects can be resisted by willpower
	if ( MobileEffectLibrary[effectName].Resistable == true and Resisted(mobileObj) ) then
		-- Effect could be resisted, and it was.
		return true
	end

	local mobileEffects = mobileObj:GetObjVar("MobileEffects") or {}
	if not( ContainsMobileEffect(mobileEffects, effectName) ) then
		if ( MobileEffectLibrary[effectName].PersistSession == true ) then
			local duration = args.Duration or MobileEffectLibrary[effectName].Duration
			if ( duration == nil ) then
				LuaDebugCallStack("[StartMobileEffect] Tried to persist mobile effect '"..effectName.."' through sessions without a Duration, if this is intentional; insert logic here, otherwise this effect will not work AT ALL.")
				return false
			end
			mobileEffects[effectName] = {
				target,
				args,
				DateTime.UtcNow + duration -- when the effect should end
			}
		else
			mobileEffects[effectName] = false
		end
		mobileObj:SetObjVar("MobileEffects", mobileEffects)
	else
		-- existing effects applied multiple times (stacking)
		if ( MobileEffectLibrary[effectName].OnStack ~= nil ) then
			mobileObj:SendMessage(effectName.."Stack", target, args)
			return true
		end
		-- non-stackable effects fail here
		return false
	end
	
	-- new effect (not stacked)
	local effectTable = deepcopy(MobileEffectLibrary[effectName])
	effectTable.UniqueId = uuid()
	effectTable.EffectName = effectName
	return StateMachine.Register(effectTable,mobileObj,target,args)
end

function HasMobileEffect(mobileObj, effectName)
    Verbose("MobileEffect", "HasMobileEffect", mobileObj, effectName)
	if ( mobileObj == nil ) then
		LuaDebugCallStack("nil mobileObj provided to HasMobileEffect")
	end
	return ContainsMobileEffect(mobileObj:GetObjVar("MobileEffects") or {}, effectName)
end

function HasAnyMobileEffect(mobileObj, effectNames, mobileEffects)
    Verbose("MobileEffect", "HasMobileEffect", mobileObj, effectNames, mobileEffects)
	if ( mobileObj == nil ) then
		LuaDebugCallStack("nil mobileObj provided to HasMobileEffects")
	end
	if ( mobileEffects == nil ) then
		mobileEffects = mobileObj:GetObjVar("MobileEffects")
	end
	if ( mobileEffects ) then
		for name,data in pairs(mobileEffects) do
			for i=1,#effectNames do
				if ( name == effectNames[i] ) then
					return true
				end
			end
		end
	end
	return false
end

function ContainsMobileEffect(effects, effectName)
    Verbose("MobileEffect", "ContainsMobileEffect", effects, effectName)
	for name,data in pairs(effects) do
		if ( name == effectName ) then
			return true
		end
	end
	return false
end

function ApplyPersistentMobileEffects(mobileObj)
    Verbose("MobileEffect", "ApplyPersistentMobileEffects", mobileObj)
	local mobileEffects = mobileObj:GetObjVar("MobileEffects") or {}
	mobileObj:DelObjVar("MobileEffects")
	-- need to clear this one too..
	mobileObj:DelObjVar("SpellChamberLevel")
	for effect,data in pairs(mobileEffects) do
		if ( data ~= false ) then
			-- calculate how much time is remaining in the effect, if any
			local timeRemaining = data[3] - DateTime.UtcNow
			if ( timeRemaining.TotalSeconds > 0 ) then
				-- update the effect's duration with the time remaining
				data[2].Duration = TimeSpan.FromSeconds(timeRemaining.TotalSeconds)
				StartMobileEffect(mobileObj, effect, data[1], data[2])
			end
		end
	end
end

function EndMobileEffectsOnDeath(mobileObj)
    Verbose("MobileEffect", "EndMobileEffectsOnDeath", mobileObj)
	local mobileEffects = mobileObj:GetObjVar("MobileEffects") or {}
	for effect,data in pairs(mobileEffects) do
		if ( MobileEffectLibrary[effect] ~= nil and MobileEffectLibrary[effect].PersistDeath ~= true ) then
			mobileObj:SendMessage(string.format("End%sEffect", effect))
		end
	end
end

function OnStackRefreshDuration(self,root,target,args)
	local timerId = string.format("%s-%s", root.PulseId, root.CurStateName)
	local timerDelay = self.ParentObj:GetTimerDelay(timerId)
	if ( timerDelay ~= nil ) then
		-- if the stack applied has a duration greater than the duration that's remaining in the current effect
		local duration = args.Duration or self.Duration
		if ( duration and duration.TotalSeconds > timerDelay.TotalSeconds ) then
			-- set timer to the duration of the stacked duration
			root.ParentObj:ScheduleTimerDelay(duration, timerId)
		end
	end
end

function ClearDebuffs(mobileObj)
	local mobileEffects = mobileObj:GetObjVar("MobileEffects")
	for name,data in pairs(mobileEffects) do
		if ( MobileEffectLibrary[name].Debuff == true ) then
			mobileObj:SendMessage(string.format("End%sEffect", name))
		end
	end
	if ( IsPoisoned(mobileObj) ) then
		mobileObj:SendMessage("CurePoison")
	end
end

require 'globals.mobile_effects.general.main'
require 'globals.mobile_effects.buffs.main'
require 'globals.mobile_effects.debuffs.main'
require 'globals.mobile_effects.skills.main'
require 'globals.mobile_effects.npc.main'
require 'globals.mobile_effects.shields.main'
require 'globals.mobile_effects.bows.main'
require 'globals.mobile_effects.weapons.main'
require 'globals.mobile_effects.potions.main'
require 'globals.mobile_effects.items.main'
require 'globals.mobile_effects.god.main'