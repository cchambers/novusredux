MobileEffectLibrary = {}
MobileEffectQTargets = {}

MobileEffectTimer = TimeSpan.FromMilliseconds(10)

function EndMobileEffect(effectTable)
	Verbose("MobileEffect", "EndMobileEffect", effectTable)
	if not( effectTable ) then
		LuaDebugCallStack("[EndMobileEffect] effectTable not provided.")
		return
	end

	-- this signals the effect was ended before it finished starting.
	effectTable.Ended = true
	
	local mobileEffects = effectTable.ParentObj:GetObjVar("MobileEffects") or {}
	if ( mobileEffects[effectTable.EffectName] ~= nil ) then
		mobileEffects[effectTable.EffectName] = nil
		effectTable.ParentObj:SetObjVar("MobileEffects",mobileEffects)
	end

	if ( MobileEffectLibrary[effectTable.EffectName].QTarget and MobileEffectQTargets[effectTable.ParentObj] ) then
		for i=1,#MobileEffectQTargets[effectTable.ParentObj] do
			if ( MobileEffectQTargets[effectTable.ParentObj][i] == effectTable.EffectName ) then
				MobileEffectQTargets[effectTable.ParentObj][i] = nil
				break
			end
		end
	end

	StateMachine.Unregister(effectTable)
end

--- This function MUST be called from the context of a module that is attached on mobileObj,
---- for example, inside player.lua you could call StartMobileEffect(this,...)
---- but on a module attached to a different player or an NPC you'd have to do player:SendMessage("StartMobileEffect",...) to start the effect on player in first example.

function StartMobileEffect(mobileObj,effectName,target,args)
	local timerName = effectName .. "Starting"
	if ( mobileObj:HasTimer(timerName) ) then return false end
	mobileObj:ScheduleTimerDelay(MobileEffectTimer, timerName)

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

	if ( HasMobileEffect(mobileObj, effectName) ) then
		-- existing effects applied multiple times (stacking)
		if ( MobileEffectLibrary[effectName].OnStack ~= nil ) then
			mobileObj:SendMessage(effectName.."Stack", target, args)
			return true
		end
		-- non-stackable effects fail here
		return false
	end

	local data = false
	if ( MobileEffectLibrary[effectName].PersistSession == true ) then
		local duration = args.Duration or MobileEffectLibrary[effectName].Duration
		if ( duration == nil ) then
			LuaDebugCallStack("[StartMobileEffect] Tried to persist mobile effect '"..effectName.."' through sessions without a Duration, if this is intentional; insert logic here, otherwise this effect will not work AT ALL.")
			return false
		end
		data = {
			target,
			args,
			DateTime.UtcNow + duration -- when the effect should end
		}
	end
	
	-- new effect (not stacked)
	local effectTable = deepcopy(MobileEffectLibrary[effectName])
	effectTable.UniqueId = uuid()
	effectTable.EffectName = effectName

	if ( MobileEffectLibrary[effectName].QTarget ) then
		if ( MobileEffectQTargets[mobileObj] ) then
			-- end every effect that is running that is expecting a target response.
			for i=1,#MobileEffectQTargets[mobileObj] do
				mobileObj:SendMessage(string.format("End%sEffect", MobileEffectQTargets[mobileObj][i]))
			end
		else
			MobileEffectQTargets[mobileObj] = {}
		end
		MobileEffectQTargets[mobileObj][#MobileEffectQTargets[mobileObj]+1] = effectName
	end

	local result = StateMachine.Register(effectTable,mobileObj,target,args)
	if ( effectTable.Ended ~= true ) then
		-- need to read and set here since some effects can start/stop other effects while registering
		local mobileEffects = mobileObj:GetObjVar("MobileEffects") or {}
		mobileEffects[effectName] = data
		mobileObj:SetObjVar("MobileEffects", mobileEffects)
	end
	return result
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
	if ( mobileObj:HasObjVar("IsChaotic") ) then
		-- this will be re-applied if the mobile is still infact chaotic
		mobileObj:DelObjVar("IsChaotic")
		SetStatusIconOverride(mobileObj,"")
	end
	if ( MobileEffectQTargets[mobileObj] ) then
		MobileEffectQTargets[mobileObj] = {}
	end
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
	local mobileEffects = mobileObj:GetObjVar("MobileEffects") or {}
	for name,data in pairs(mobileEffects) do
		if ( MobileEffectLibrary[name].Debuff == true ) then
			mobileObj:SendMessage(string.format("End%sEffect", name))
		end
	end
end

require 'NOS:globals.mobile_effects.general.main'
require 'NOS:globals.mobile_effects.buffs.main'
require 'NOS:globals.mobile_effects.debuffs.main'
require 'NOS:globals.mobile_effects.skills.main'
require 'NOS:globals.mobile_effects.npc.main'
require 'NOS:globals.mobile_effects.shields.main'
require 'NOS:globals.mobile_effects.bows.main'
require 'NOS:globals.mobile_effects.weapons.main'
require 'NOS:globals.mobile_effects.potions.main'
require 'NOS:globals.mobile_effects.items.main'
require 'NOS:globals.mobile_effects.objects.main'
require 'NOS:globals.mobile_effects.god.main'
require 'NOS:globals.mobile_effects.mounts.main'
require 'NOS:globals.mobile_effects.spells.main'
require 'NOS:globals.mobile_effects.rares.main'

-- NOS EDITS


require 'NOS:globals.mobile_effects.nos.main'
require 'NOS:globals.mobile_effects.potions.main'