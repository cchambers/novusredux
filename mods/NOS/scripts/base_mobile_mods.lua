
--- List of all possible Mobile Mods, 
-- using any of these options you can modify the status of a mobile, like buff them with strength, or debuff them with less wisdom, or freeze them in place, etc..
-- they are stored in the local memory space of base_mobile so when each mod is changed there is zero IO interaction, this also means they do not persist.

-- helpers/mobile.lua contains a list of what stat (if any) to recalculate when any of these change


-- incase you're wondering why there is a Plus and Times for each mod; it's very optimized to grab the specific static table by name in all the dozens of places
	-- we call GetMobileMod(), and it's one less parameter to SetMobileMod() so that's a plus.  - KH
MobileMod = {
	-- stats
	AccuracyPlus = { },
	AccuracyTimes = { },
	AgilityPlus = { },
	AgilityTimes = { },
	AttackPlus = { },
	AttackTimes = { },
	ConstitutionPlus = { },
	ConstitutionTimes = { },
	CritChancePlus = { },
	CritChanceTimes = { },
	DefensePlus = { },
	DefenseTimes = { },
	EvasionPlus = { },
	EvasionTimes = { },
	ForcePlus = { },
	ForceTimes = { },
	IntelligencePlus = { },
	IntelligenceTimes = { },
	PowerPlus = { },
	PowerTimes = { },
	StrengthPlus = { },
	StrengthTimes = { },
	WillPlus = { },
	WillTimes = { },
	WisdomPlus = { },
	WisdomTimes = { },

	-- regen stats
	MaxHealthPlus = { },
	MaxHealthTimes = { },
	MaxManaPlus = { },
	MaxManaTimes = { },
	MaxStaminaPlus = { },
	MaxStaminaTimes = { },
	MaxVitalityPlus = { },
	MaxVitalityTimes = { },

	-- regen stats rates
	HealthRegenPlus = { },
	HealthRegenTimes = { },
	ManaRegenPlus = { },
	ManaRegenTimes = { },
	StaminaRegenPlus = { },
	StaminaRegenTimes = { },
	VitalityRegenPlus = { },
	VitalityRegenTimes = { },

	-- other stats
	MoveSpeedPlus = { },
	MoveSpeedTimes = { },
	MountMoveSpeedPlus = { },
	MountMoveSpeedTimes = { },

	--- damage
	-- magic
	MagicDamageTakenPlus = { },
	MagicDamageTakenTimes = { },
	-- physical
	PhysicalDamageTakenPlus = { },
	PhysicalDamageTakenTimes = { },
	-- other damage types are added in the loop down lower

	--healing
	HealingReceivedPlus = { },
	HealingReceivedTimes = { },

	-- movement restriction
	Freeze = { }, -- stop movement, stop spin, allow items/combat
    Disable = { }, -- super slow movement, disallow items/combat
	Busy = { }, -- no change to movement, disallow items/combat 
	Root = { }, -- !!not implemented!! stop movement, allow spin, allow items/combat
}

-- add all the damage types to mobile mods list
for key,value in pairs(CombatDamageType) do
	MobileMod[string.format("%sDamageTakenPlus", key)] = { }
	MobileMod[string.format("%sDamageTakenTimes", key)] = { }
end

function HandleMobileMod(modName, modId, modValue)
	Verbose("MobileMod", "HandleMobileMod", modName, modId, modValue)
	if ( MobileMod[modName] == nil ) then
		LuaDebugCallStack("[Invalid MobileMod] Provided modName "..modName.." is invalid.")
		return
	end
	--DebugMessage("HandleMobileMod", modName, modId, tostring(modValue))

	-- adding or removing we clear any existing expires.
	ClearMobileModExpire(modName, modId)
	
	if ( MobileMod[modName] ~= nil ) then
		-- prevent unneccessary cpu cycles if nothing changed.
		if ( MobileMod[modName][modId] == modValue ) then
			return
		end

		-- save the data of this mobile mod (memory only)
		MobileMod[modName][modId] = modValue

		-- special case for movement, all negative movement effects mount speed as well.
		-- WARNING! Moving from a negative to a positive move mod with the SAME ID will cause the MountMoveSpeed to lock until a relog.
		-- This isn't going to be accounted for since each mobile mod should be unique, and a mobile mod id should never move from a negative to a positive.
		if ( 
			({MoveSpeedPlus=true,MoveSpeedTimes=true})[modName]
			and
			(modValue == nil or modValue < 0)
		) then
			if ( ({MoveSpeedPlus})[modName] ) then
				MobileMod.MountMoveSpeedPlus[modId] = modValue
			else
				MobileMod.MountMoveSpeedTimes[modId] = modValue
			end
		end

		if ( MobileModRecalculateStat[modName] ~= nil ) then
			MarkStatsDirty(MobileModRecalculateStat[modName])
		end

		if ( ({Freeze=true,Disable=true,Busy=true})[modName] ) then
			-- force value to be either true or false
			if ( modValue ~= true ) then modValue = false end
            ApplyModMoveLock(modName, modId, modValue)
		end
	end
end

-- Handles the 'stacking' of disable/freeze effects
function ApplyModMoveLock(name, id, val)
	Verbose("MobileMod", "ApplyModMoveLock", name, id, val)

	local disable,busy,freeze = ({Disable=true})[name],({Busy=true})[name],({Freeze=true})[name]
    local freezes,disables,slows = false,false,false

	if ( freeze ) then
		-- check all Freeze mods that only use SetMobileFrozen
		for i,v in pairs(MobileMod.Freeze) do
			if ( v == true and i ~= id ) then freezes = true break end
		end
	
		-- if the mod is Freeze, and there are no other freezes, do exactly as asked.
		if ( freezes == false ) then this:SetMobileFrozen(val, val) end

		return
	end
	
	if ( disable or busy ) then
		for i,v in pairs(MobileMod.Disable) do
			if ( v == true and i ~= id ) then
				disables = true
				slows = true
				break
			end
		end
	end
	
	if ( busy and disables == false ) then
		-- check all Busy mods that only use Disabled objVar
		for i,v in pairs(MobileMod.Busy) do
			if ( v == true and i ~= id ) then disables = true break end
		end
	end

	-- if the mod is Disable, and there are no other slows, do exactly as asked.
	if ( disable and slows == false ) then
		if ( id == "CastFreeze" ) then
			MobileMod.MoveSpeedTimes.ReservedIDCast = val and -0.7 or nil
			MobileMod.MountMoveSpeedTimes.ReservedIDCast = val and -0.7 or nil
		else
			MobileMod.MoveSpeedTimes.ReservedID = val and -1 or nil
			MobileMod.MountMoveSpeedTimes.ReservedID = val and -1 or nil
		end
	end

	-- if the mod is Disable or Busy and there are no other disables, do exactly as asked.
	if ( (disable or busy) and disables == false ) then
		if ( val ) then
			Verbose("MobileMod", "ApplyModMoveLock:Disabled", true)
			--LuaDebugCallStack("DISABLED")
			this:SetObjVar("Disabled", true)
		else
			Verbose("MobileMod", "ApplyModMoveLock:Disabled", false)
			this:DelObjVar("Disabled")
			--since being disabled causes weapon swing loop to halt, restart it here
			this:SendMessage("DelaySwingTimer") --by delaying all hands by 0
		end
	end
end

function ClearMobileModExpire(modName, modId)
	Verbose("MobileMod", "ClearMobileModExpire", modName, modId)
	local timer = modName..modId.."Expire"
	if ( this:HasTimer(timer) ) then
		UnregisterEventHandler("base_mobile_mods", EventType.Timer, timer)
		this:RemoveTimer(timer)
	end
end

RegisterEventHandler(EventType.Message, "MobileMod", HandleMobileMod)

RegisterEventHandler(EventType.Message, "MobileModExpire", function(modName, modId, modValue, modExpire)
	Verbose("MobileMod", "MobileModExpire", modName, modId, modValue, modExpire)
	-- apply the mod
	HandleMobileMod(modName, modId, modValue)
	local timer = modName..modId.."Expire"
	-- handle the expire
	RegisterSingleEventHandler(EventType.Timer, timer, function()
		HandleMobileMod(modName, modId, nil)
	end)
	-- make it expire eventually.
	this:ScheduleTimerDelay(modExpire, timer)
end)