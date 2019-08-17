require "base_magic_sys"
require "weapon_cache"

mInCombatState = this:GetSharedObjectProperty("CombatMode")
mCurrentTarget = this:GetObjVar("CurrentTarget")

local mDualWielding = false
local mQueuedWeaponAbility = nil
local mIsMoving = this:IsMoving()

local mMovingArcher = false
local mOutOfArrows = false
local mBowDrawn = false
local mArrowDamageBonus = 0
local mArrowType = nil
-- a list of arrow types that gets re-ordered when preferred type is changed so that preferred is top of list
local mArrowTypes = {}

mSkipRangedStopMoving = not IsPlayerCharacter(this)

-- cache some stuff to check against to prevent re-adding views that already exist.
mPrimed = {
	RightHand = nil,
	LeftHand = nil
}

-- When the swing timer goes up, swing is ready.
mSwingReady = {
	RightHand = true,
	LeftHand = true
}

--- CombatMods are here to facilitate a 'hidden' Mod, for a single weapon swing for example, and does not update stats.
CombatMod = {
	-- copies from base_mobile (These are used in QueuedWeaponAbilites)
	AttackPlus = {},
	AttackTimes = {}
}

--[[
RegisterEventHandler(EventType.Message, "CombatDebug", function()
	DebugTable(mPrimed)
	DebugTable(mSwingReady)
	if(mIsMoving)then
		DebugMessage("mIsMoving True")
	else
		DebugMessage("mIsMoving False")
	end
	if(mBowDrawn)then
		DebugMessage("mBownDraw True")
	else
		DebugMessage("mBownDraw False")
	end
	if(mMovingArcher)then
		DebugMessage("mMovingArcher True")
	else
		DebugMessage("mMovingArcher False")
	end
end)
]]

RegisterEventHandler(EventType.Message, "CombatMod", function(modName, modId, modValue)
		ApplyCombatMod(modName, modId, modValue)
	end)

function ApplyCombatMod(modName, modId, modValue)
	if (CombatMod[modName] ~= nil) then
		CombatMod[modName][modId] = modValue
	end
end

--- Perform a weapon attack.
-- @param atTarget mobile
-- @param hand string - LeftHand or RightHand
function PerformWeaponAttack(atTarget, hand)
    Verbose("Combat", "PerformWeaponAttack", atTarget, hand)
	if not( hand ) then hand = "RightHand" end

	if (
		not mInCombatState
		or
		mWeaponSwapped -- waiting for the dirty stats to recalc
		or
		atTarget == nil
		or
		atTarget == this
		or
		not mSwingReady[hand]
		or
		IsDead(this)
		or
		IsMobileDisabled(this)
		or
		this:HasTimer("SpellPrimeTimer")
	) then return end

	if not( ValidCombatTarget(this, atTarget) )  then
		ClearTarget()
		ResetSwingTimer(0, hand)
		return
	end

	-- handle moving bow men
	if (_Weapon[hand].IsRanged) then
		-- dont let archers shoot when they are moving.
		-- if (mIsMoving) then
		-- 	return
		-- end
	end

	if not (WithinCombatRange(this, atTarget, _Weapon[hand].Range)) then
		-- the SetupViews will takecare of restarting this
		return
	end

	if not (this:HasLineOfSightToObj(atTarget, ServerSettings.Combat.LOSEyeLevel)) then
		if (this:IsPlayer()) then
			this:SystemMessage("Cannot See Target.", "info")
		end
		-- reset swing timer, can't really trigger on los gained back like we can with range
		ResetSwingTimer(0, hand)
		return
	end

	LookAt(this, atTarget)

	local setWasHidden = false
	if ( mQueuedWeaponAbility ~= nil and mQueuedWeaponAbility.AllowCloaked == true and this:IsCloaked() ) then
		this:SetObjVar("WasHidden", true)
		setWasHidden = true
	end
	-- reveal them
	this:SendMessage("BreakInvisEffect", "Swing")
	atTarget:SendMessage("BreakInvisEffect", "SwungAt")

	--- perform the actual swing/shoot/w.e.
	if ( _Weapon[hand].IsRanged ) then
		if (mIsMoving) then
			local chance = 0
			if not (this:HasTimer("OutOfArrows")) then
				chance = GetSkillLevel(this,"MarksmanshipSkill") / 10
				if (chance < 5) then chance = 5 end
				chance = math.random(0,chance) 
				chance = chance >= 5
				CheckSkill(this, "MarksmanshipSkill")
				ExecuteRangedWeaponAttack(atTarget, hand, chance)
			end
		else 
			ExecuteRangedWeaponAttack(atTarget, hand)
		end
	else
		ExecuteWeaponAttack(atTarget, hand)
	end

	if ( setWasHidden ) then this:DelObjVar("WasHidden") end
end

function ExecuteRangedWeaponAttack(atTarget, hand, hitSuccessOverride, isCritOverride)
	Verbose("Combat", "ExecuteRangedWeaponAttack", atTarget, hand, hitSuccessOverride, isCritOverride)
	-- if they were out of arrows before, prevent them dropping arrows in their back and fire off a shot without first pulling
	if ( mOutOfArrows ) then
		mOutOfArrows = false
		ResetSwingTimer(0, hand)
		return
	end
	if ( IsPlayerCharacter(this) and not(IsPossessed(this)) ) then
		-- consume the arrow before any further calculations.
		if ( ConsumeResourceBackpack(this, mArrowType, 1) ) then
			mOutOfArrows = false
			ExecuteWeaponAttack(atTarget, hand, true, hitSuccessOverride, isCritOverride)
		else
			EndDrawBow()
			FindArrowType(this)
			-- reset swing timer
			ResetSwingTimer(0, hand)
		end
	else
		-- non-players don't consume arrows on ranged attacks (That's loot!)
		ExecuteWeaponAttack(atTarget, hand, true, hitSuccessOverride, isCritOverride)
	end
end

RegisterEventHandler(EventType.Message, "ExecuteRangedWeaponAttack", ExecuteRangedWeaponAttack)

--- Performs the actual attack with a weapon, also consumes any queued weapon abilities
-- @param atTarget, mobileObj this weapon attack is being executed against
-- @param hand, string, weapon hand, LeftHand or RightHand
-- @param ranged, bool, (optional) is this a ranged attack?
-- @param hitSuccessOverride, bool, (optional) if supplied hit chance will be based on this value, nil or not provided will calculate the hit chance (or 100% hit chance for queued weapon abilities)
-- @param isCritOverride, bool, (optional) if supplied, this boolean will decide if it's a crit or not, nil will cause it to calculate a crit chance.
function ExecuteWeaponAttack(atTarget, hand, ranged, hitSuccessOverride, isCritOverride)
	Verbose("Combat", "ExecuteWeaponAttack", atTarget, hand, ranged, hitSuccessOverride, isCritOverride)

	if (ranged) then
		PerformClientArrowShot(this, atTarget, _Weapon.RightHand.Object)
		mBowDrawn = false
	else
		-- PerformClientArrowShot calls this internally
		PlayAttackAnimation(this)
	end

	-- grunting and stuff
	RandomAttackSoundChance(this)

	-- reset swing timer with a delay to drawing any bows ( to allow current attack animations to playout )
	ResetSwingTimer(0, hand, true)

	local hitSuccess = hitSuccessOverride
	if (hitSuccess == nil) then
		hitSuccess = CheckHitSuccess(atTarget, hand)
	end
	if (mQueuedWeaponAbility ~= nil) then
		if (PerformWeaponAbility(this, atTarget, mQueuedWeaponAbility, hitSuccess)) then
			if (mQueuedWeaponAbility == nil) then
				LuaDebugCallStack(
					"mQueueWeaponAbility is nil where it shouldn't be, ExecuteWeaponAttack is probably being called multiple times in quick succession."
				)
			end

			-- successfully took the stamina required, apply any mods
			if (mQueuedWeaponAbility.CombatMods ~= nil) then
				for k, v in pairs(mQueuedWeaponAbility.CombatMods) do
					ApplyCombatMod(k, "WeaponAbility", v)
				end
			end
		end
	end

	-- some queued abilities will bypass the normal execute hit action and call it manually, or do whatever is needed for the ability.
	if (mQueuedWeaponAbility == nil or mQueuedWeaponAbility.SkipHitAction ~= true) then
		if (hitSuccess) then
			if (ranged) then
				local targetArrowTable = atTarget:GetObjVar("ArrowCount") or { Arrows = 0, AshArrows = 0, BlightwoodArrows = 0, BroodwoodArrows = 0 }
				targetArrowTable[mArrowType] = targetArrowTable[mArrowType] + 1
				atTarget:SetObjVar("ArrowCount", targetArrowTable)
			end
			ExecuteHitAction(atTarget, hand)
		else
			ExecuteMissAction(atTarget, hand)
		end
	end

	if (mQueuedWeaponAbility ~= nil) then
		-- remove any mods applied from the weapon ability.
		if (mQueuedWeaponAbility.CombatMods ~= nil) then
			for k, v in pairs(mQueuedWeaponAbility.CombatMods) do
				ApplyCombatMod(k, "WeaponAbility", nil)
			end
		end
		-- interrupt the target if this ability allows
		if (mQueuedWeaponAbility.SpellInterrupt == true) then
			CheckSpellCastInterrupt(atTarget)
		end
		if ( hitSuccess ) then
			-- ability was used and we hit, let's clear it.
			ClearQueuedWeaponAbility()
		end
	end
end

function ClearQueuedWeaponAbility()
Verbose("Combat", "ClearQueuedWeaponAbility")
	local queuedAbility = mQueuedWeaponAbility
	mQueuedWeaponAbility = nil
	if ( queuedAbility and this:IsPlayer() ) then
		this:SendClientMessage("SetActionActivated",{"CombatAbility",queuedAbility.ActionId,false})
	end
end

RegisterEventHandler(EventType.Message, "ClearQueuedWeaponAbility", ClearQueuedWeaponAbility)

RegisterEventHandler(EventType.Message,"RegisterAbilitySelectTarget",function (primary,weaponAbility)
		if(weaponAbility.QueueTarget == "Any") then
			RegisterSingleEventHandler(EventType.ClientTargetAnyObjResponse,"AbilitySelectTarget",
				function (target,user)
					Verbose("Combat", "AbilitySelectTarget",target,user)
					weaponAbility.NoTarget = true
					weaponAbility.QueueTarget = nil
					weaponAbility.Target = target
					QueueWeaponAbility(this,primary,weaponAbility)
				end)
		elseif(weaponAbility.QueueTarget == "Loc") then
			RegisterSingleEventHandler(EventType.ClientTargetLocResponse,"AbilitySelectTarget",
				function (success,targetLoc,targetObj,user)
					Verbose("Combat", "AbilitySelectTarget",success,targetLoc,targetObj,user)
					weaponAbility.NoTarget = true
					weaponAbility.QueueTarget = nil
					weaponAbility.Target = targetObj
					-- if a target location is set, we need to pass it through the MobileEffectArgs
					if ( targetLoc ) then
						if ( weaponAbility.MobileEffect ) then
							if ( weaponAbility.MobileEffectArgs ) then
								weaponAbility.MobileEffectArgs.TargetLoc = targetLoc
							else
								weaponAbility.MobileEffectArgs = {
									TargetLoc = targetLoc
								}
							end
						end
						if ( weaponAbility.TargetMobileEffect ) then
							if ( weaponAbility.TargetMobileEffectArgs ) then
								weaponAbility.TargetMobileEffectArgs.TargetLoc = targetLoc
							else
								weaponAbility.TargetMobileEffectArgs = {
									TargetLoc = targetLoc
								}
							end
						end
					end
					QueueWeaponAbility(this,primary,weaponAbility)
				end)
		else
			RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse,"AbilitySelectTarget",
				function (target,user)
					weaponAbility.NoTarget = true
					weaponAbility.QueueTarget = nil
					weaponAbility.Target = target
					QueueWeaponAbility(this, primary, weaponAbility)
				end
			)
		end
	end
)

function PerformMagicalAttack(spellName, spTarget, spellSource, doNotRetarget)
	
	Verbose("Magic", "PerformMagicalAttack", spellName, spTarget, spellSource, doNotRetarget)
	if (doNotRetarget == nil) then
		doNotRetarget = false
	end
	if (not (doNotRetarget) and not (IsDead(spTarget))) then
		mCurrentTarget = spTarget
	end

	if not (ValidCombatTarget(this, spTarget)) then
	
		return
	end

	if (mInCombatState) then
		SetInCombat(true)
		BeginCombat()
	end

	if (doNotRetarget == false) then
		LookAt(this, spTarget)
	end

	if (HasMobileEffect(spTarget, "SpellMagicReflection")) then
		spTarget:PlayEffect("ForceField", 1)
		spTarget:SendMessage("StopReflecting")
		ExecuteSpellHitActions(spellSource, spellName, spellSource)
	else
		ExecuteSpellHitActions(spTarget, spellName, spellSource)
	end

	return "AttackHit"
end

function ExecuteSpellHitActions(atTarget, spellName, spellSource)
	Verbose("Magic", "ExecuteSpellHitActions", atTarget, spellName, spellSource)
	local damageAmount = 0

	-- local baseDam = GetSpellInformation(spellName, "SpellPower") or 0
	local baseDam = SpellData.AllSpells[spellName] and SpellData.AllSpells[spellName].SpellPower or 0
	-- hack to make ruin damage based on distance
	if (spellName == "Ruin" and atTarget:IsValid()) then
		local distance = this:DistanceFrom(atTarget)
		if (distance > 2) then
			-- alter the damage by the distance
			if (distance > 4) then
				baseDam = baseDam * 0.25
			else
				baseDam = baseDam * 0.50
			end
		end
	end
	local damageType = GetSpellDamageType(spellName)

	local damInfo = {}
	damInfo.Damage = baseDam
	damInfo.Type = SpellData.AllSpells[spellName] and SpellData.AllSpells[spellName].DamageType or "MAGIC"
	damInfo.Source = this
	damInfo.Attacker = this
	damInfo.Victim = atTarget
	damInfo.SpellCircle = SpellData.AllSpells[spellName] and SpellData.AllSpells[spellName].Circle or 1

	CheckDestructionMobileEffect(this, atTarget, baseDam, spellName)

	ApplyDamageToTarget(damInfo)
	ApplySpellEffects(spellName, atTarget, spellSource)
end

--- Delay the next swing by a TimeSpan
-- @param delay (optional) TimeSpan - The amount of time to delay next swing. If not provided, swing will execute immediately if swing timer does not exist.
-- @param hand (optional) string - The hand to delay, or All. Defaults to All
function DelaySwingTimer(delay, hand)
	if not( mInCombatState ) then return end
	Verbose("Combat", "DelaySwingTimer", delay, hand)

	local hands = {hand}
	if (hand == nil or hand == "All") then
		hands = {
			"RightHand",
			"LeftHand"
		}
	end

	for i = 1, #hands do
		hand = hands[i]
		-- hand should only work given a combat weapon equipped that's not a shield.
		if (_Weapon[hand].NoCombat ~= true and not _Weapon[hand].ShieldType) then
			local timerId = GetSwingTimerName(hand)
			local nextSwingIn = this:GetTimerDelay(timerId)
			if (delay) then
				if (nextSwingIn == nil) then
					ResetSwingTimer(delay.TotalSeconds, hand)
				else
					this:ScheduleTimerDelay(delay:Add(nextSwingIn), timerId)
				end
			else
				-- this is to allow passing no delay
				if (nextSwingIn == nil) then
					ResetSwingTimer(0, hand)
				end
			end
		end
	end
end

function GetSwingTimerName(weaponHand)
	return string.format("SWING_TIMER_%s", weaponHand or "RightHand")
end

function GetSwingSpeedSeconds()
	return math.max(this:GetStatValue("AttackSpeed"), ServerSettings.Combat.MinimumSwingSpeed)
end

function ResetSwingTimer(timeToDelayNextSwing, weaponHand, delayDrawBow)
	if not (mInCombatState) then
		return
	end
	Verbose("Combat", "ResetSwingTimer", timeToDelayNextSwing, weaponHand)
	weaponHand = weaponHand or "RightHand"
	if (timeToDelayNextSwing == nil) then
		timeToDelayNextSwing = 0
	end

	EndDrawBow()

	if (_Weapon.RightHand.IsRanged) then
		if (delayDrawBow) then
			-- this is a 'hack' to prevent animation from snapping directly to loading a new arrow after firing an arrow.
			-- I call it a hack because I think client should handle that.. But maybe that would be too restrictive for bow speed? -KH
			CallFunctionDelayed(TimeSpan.FromSeconds(1.45), DrawBow)
		else
			DrawBow()
		end
	end

	local timerList = {weaponHand}
	if (weaponHand == "All") then
		timerList = {
			"RightHand",
			"LeftHand"
		}
	end

	for i = 1, #timerList do
		weaponHand = timerList[i]
		-- mark swing as not ready anymore.
		mSwingReady[weaponHand] = false
		-- hand should only work given a combat weapon equipped that's not a shield.
		if (_Weapon[weaponHand].NoCombat ~= true and not _Weapon[weaponHand].ShieldType) then
			this:ScheduleTimerDelay(
				TimeSpan.FromSeconds(GetSwingSpeedSeconds() + timeToDelayNextSwing),
				GetSwingTimerName(weaponHand)
			)
		end
	end
end

------------------------------------------

-- Evalutators
function ValidateCurrentTarget()
	Verbose("Combat", "ValidateCurrentTarget")
	if (mCurrentTarget == nil) then
		return false
	end
	if not (mCurrentTarget:IsValid()) then
		return false
	end
	return true
end

function CheckHitSuccess(victim, hand)
	Verbose("Combat", "CheckHitSuccess", victim, hand)
	local isPlayer = IsPlayerCharacter(this)

	local accuracy = this:GetStatValue("Accuracy")
	local evasion = victim:GetStatValue("Evasion")
	local hitChance = ((accuracy) / ((evasion) * 2) * 100)

	-- INCREASE CHANCE OF HIT WITH 2H WEAPONS... 
	if (EquipmentStats.BaseWeaponClass[_Weapon[hand].Class].AccuracyBuff) then
		hitChance = hitChance * 1.35
	else
		local addSkill = (GetSkillLevel(this,"ArmsLoreSkill") or 0.1) / 10
		local mentor = this:GetObjVar("MentorPath")
		if (mentor ~= nil) then
			if (mentor == "CombatTypeSkill") then
				addSkill = addSkill + (GetSkillLevel(this,"MentoringSkill") or 0.1) / 10
			end
		end
		hitChance = hitChance + addSkill
	end

	local hitSuccess = false
	-- if player or tamed pet
	if (isPlayer or _MyOwner ~= nil) then
		if not (victim:IsPlayer()) then
			hitSuccess = Success(hitChance / 87.5)
		else
			hitSuccess = Success(hitChance / 100)
		end
		-- Ensure only gain off valid targets
		if (ValidCombatGainTarget(victim, _MyOwner or this)) then
			local victimWeaponSkillLevel = GetSkillLevel(victim, GetPrimaryWeaponSkill(victim))

			if (isPlayer) then
				-- only check melee on a hit success
				if (hitSuccess) then
					CheckSkill(this, "MeleeSkill", victimWeaponSkillLevel)
				end
				-- check weapon skill on hit/miss
				local weaponClassInfo = EquipmentStats.BaseWeaponClass[_Weapon[hand].Class]
				if (weaponClassInfo and weaponClassInfo.WeaponSkill and not (weaponClassInfo.WeaponSkillGainsDisabled)) then
					CheckSkill(this, weaponClassInfo.WeaponSkill, victimWeaponSkillLevel)
				end
			else
				-- owners can only gain if the pet didn't miss and they are within range of the pet.
				if (hitSuccess and _MyOwner:IsValid() and this:DistanceFrom(_MyOwner) <= ServerSettings.Pets.Command.Distance) then
					-- do a gain on owner's beastmastery
					CheckSkill(_MyOwner, "BeastmasterySkill", victimWeaponSkillLevel)
				end
			end
		end
	else
		-- mobs cannot have a hit chance lower than 50%.
		hitSuccess = Success(math.max(hitChance / 100, 0.75))
	end

	return hitSuccess
end

-- Get Combat Status
function InCombat(obj)
	Verbose("Combat", "InCombat", obj)
	if (obj == nil or obj == this) then
		return mInCombatState
	else
		return IsInCombat(obj)
	end
end

function ExecuteMissAction(atTarget, hand)
	if (hand ~= "LeftHand") then
		hand = "RightHand"
	end
	Verbose("Combat", "ExecuteMissAction", atTarget, hand)
	--LuaDebugCallStack("ExecuteMissAction")
	--atTarget:NpcSpeech("[08FFFF]*miss*[-]","combat")
	atTarget:SendMessage("SwungOn", this)
	PlayWeaponSound(this, "Miss", _Weapon[hand].Object)
end

--- This comes after a successful (hitchance) ExecuteWeaponAttack, and applies the weapon damage
-- @param atTarget, mobileObj, target to execute the hit action against
-- @param hand, string, hand of weapon, LeftHand or RightHand
function ExecuteHitAction(atTarget, hand)
	Verbose("Combat", "ExecuteHitAction", atTarget, hand)

	local damageInfo = {
		Attack = (this:GetStatValue("Attack") + GetCombatMod(CombatMod.AttackPlus) + mArrowDamageBonus) *
			GetCombatMod(CombatMod.AttackTimes, 1),
		Type = _Weapon[hand].DamageType,
		Source = _Weapon[hand].Object,
		Attacker = this,
		Victim = atTarget
	}

	if (_Weapon[hand].Object and _Weapon[hand].Object:HasObjVar("ImbuedWeapon")) then
		local level = _Weapon[hand].Object:GetObjVar("ExecutionerLevel") * -1
		AdjustDurability(_Weapon[hand].Object, level)
		_Weapon[hand].Object:SendMessage("Imbue.RemoveCharge")
	end

	-- damage the weapon that's being swung.
	if ( _Weapon[hand].Object and Success(ServerSettings.Durability.Chance.OnWeaponSwing) and IsPlayerCharacter(this) ) then
		AdjustDurability(_Weapon[hand].Object, -1)
	end

	ApplyDamageToTarget(damageInfo)
end

RegisterEventHandler(EventType.Message, "ExecuteHitAction", ExecuteHitAction)

function ApplyDamageToTarget(damageInfo)
	Verbose("Combat", "ApplyDamageToTarget", damageInfo)
	if damageInfo == nil then return end

	damageInfo.Attacker = damageInfo.Attacker or this

	if ( 
		damageInfo.Attacker ~= damageInfo.Victim
		and
		not ValidCombatTarget(damageInfo.Attacker, damageInfo.Victim)
	) then
		return
	end

	if ( damageInfo.Source ) then
		damageInfo.WeaponType = Weapon.GetType(damageInfo.Source)
		damageInfo.WeaponClass = Weapon.GetClass(damageInfo.WeaponType)
		if not( damageInfo.Type ) then
			damageInfo.Type = Weapon.GetDamageType(damageInfo.WeaponType)
		end
	end

	if not( damageInfo.Type ) then damageInfo.Type = "TrueDamage" end

	local typeData = CombatDamageType[damageInfo.Type]
	-- not a real combat damage type, stop here.
	if not( typeData ) then
		LuaDebugCallStack("[ApplyDamageToTarget] invalid type: "..tostring(damageInfo.Type))
		return
	end

	-- pass in some variables
	damageInfo.VictimIsPlayer = IsPlayerCharacter(damageInfo.Victim)
	damageInfo.Owner = _MyOwner

	-- alter the damageInfo table
	damageInfo = CalculateDamageInfo(damageInfo)
	
	damageInfo.Victim:SendMessage(
		"DamageInflicted",
		damageInfo.Attacker,
		damageInfo.Damage,
		damageInfo.Type,
		false,
		damageInfo.Blocked > 0,
		damageInfo.IsReflected,
		damageInfo.Source
	)
end

function SetCurrentTarget(newTarget, fromClient)
	Verbose("Combat", "SetCurrentTarget", newTarget, fromClient)

	if (mCurrentTarget ~= newTarget) then
		mCurrentTarget = newTarget

		if (mCurrentTarget) then
			this:SetObjVar("CurrentTarget", mCurrentTarget)
		else
			this:DelObjVar("CurrentTarget")
		end

		if (not fromClient and this:IsPlayer()) then
			this:SendClientMessage("ChangeTarget", mCurrentTarget)
		end
	end

	if (mInCombatState) then
		InitiateCombatSequence()
	end
end
RegisterEventHandler(EventType.Message, "SetCurrentTarget", SetCurrentTarget)

function ClearView()
	if (mPrimed.RightHand) then
		DelView("RightHandAttackRange")
		mPrimed.RightHand = nil
	end
	if (mPrimed.LeftHand) then
		DelView("LeftHandAttackRange")
		mPrimed.LeftHand = nil
	end
end

function EndCombat()
	Verbose("Combat", "EndCombat")
	ClearView()
	SetInCombat(false)
end

function SetupViews()
	if (mCurrentTarget ~= nil) then
		LookAt(this, mCurrentTarget)
		if (mInCombatState) then
			SetupView("RightHand")
			if (mDualWielding) then
				SetupView("LeftHand")
			end
		end
	end
end

function SetupView(hand)
	Verbose("Combat", "SetupView", hand)
	if (mCurrentTarget == nil or mCurrentTarget == this or not InCombat(this)) then
		return
	end
	if (not _Weapon[hand].Class or _Weapon[hand].ShieldType) then
		return
	end

	local range = GetCombatRange(this, mCurrentTarget, _Weapon[hand].Range)

	if (mPrimed[hand] == range) then
		-- this view already exists, don't need to add it again.
		return
	end

	mPrimed[hand] = range

	AddView(string.format("%sAttackRange", hand), SearchObjectInRange(range))
end

function BeginCombat()
	Verbose("Combat", "BeginCombat")
	-- if (IsDead(this)) then
	-- 	return
	-- end
	-- make sure we are in combat! (this function does nothing if you are already in combat)
	SetInCombat(true)
	InitiateCombatSequence()
end

function InitiateCombatSequence()
	Verbose("Combat", "InitiateCombatSequence")
	if (IsDead(this)) then
		return
	end

	if (mCurrentTarget ~= nil) then -- dead already
		local owner = mCurrentTarget:GetObjectOwner()
		if (owner and owner == this) then 
			this:SystemMessage("You almost attacked your pet! Close one.", "info")
			this:SendMessage("EndCombatMessage")
			return false
		end
	end

	local ready = mSwingReady
	if (ready.RightHand) then
		-- swing is ready, do it
		PerformWeaponAttack(mCurrentTarget, "RightHand")
	elseif not (this:HasTimer("SWING_TIMER_RightHand")) then
		-- start swing over
		ResetSwingTimer(0, "RightHand")
	end

	if (mDualWielding) then
		if (ready.LeftHand) then
			PerformWeaponAttack(mCurrentTarget, "LeftHand")
		elseif not (this:HasTimer("SWING_TIMER_LeftHand")) then
			ResetSwingTimer(0, "LeftHand")
		end
	end

	if (mCurrentTarget ~= nil) then
		SetupViews()
		if (IsPlayerCharacter(this)) then
			SendPetCommandToAll(GetActivePets(this, PetStance.Aggressive), "autoattack", mCurrentTarget)
		end
	end
end

--EVENT HANDLERS
function HandleAttackTarget(target)
	Verbose("Combat", "HandleAttackTarget", target)
	SetInCombat(true)
	if (target ~= nil) then
		SetCurrentTarget(target)
	end
end

function HandleScriptCommandToggleCombat()
	Verbose("Combat", "HandleScriptCommandToggleCombat")
	-- if (IsDead(this)) then
	-- 	return
	-- end

	if (CancelCastPrestigeAbility(this)) then
		return
	end

	-- Enter combat mode if not already
	if not (mInCombatState) then
		BeginCombat()
	else
		SetInCombat(false)
	end
end

function HandleScriptCommandTargetObject(targetObjId)
	Verbose("Combat", "HandleScriptCommandTargetObject", targetObjId)
	if (targetObjId == nil) then
		SetCurrentTarget(nil, true)
		return
	end

	local newTarget = GameObj(tonumber(targetObjId))
	if not (newTarget:IsValid()) then
		return
	end

	SetCurrentTarget(newTarget, true)
end

-- Stat Calculations
--Actors
mCombatMusicPlaying = false
function SetInCombat(inCombat, force)
	if (inCombat == false) then this:SendMessage("CombatToggled") end
	
	if (this:HasObjVar("NoGains")) then return end

	if (inCombat == true) then
		if (IsSitting(this)) then
			this:SendMessage("StopSitting")
			this:SetWorldPosition(this:GetObjVar("PositionBeforeUsing"))
			RemoveUseCase(this, "Stand")
		end

		if (IsAsleep(this)) then
			this:SendMessage("WakeUp")
			this:SetWorldPosition(this:GetObjVar("PositionBeforeUsing"))
			RemoveUseCase(this, "Wake Up")
		end
	end

	if (inCombat == true and this:GetObjVar("IsHarvesting") == true) then
		local harvestTool = this:GetObjVar("HarvestingTool")
		harvestTool:SendMessage("CancelHarvesting", this)
	end

	Verbose("Combat", "SetInCombat", inCombat, force)
	if inCombat ~= true then
		inCombat = false
	end
	-- we use a local variable to be able to see changes to the state immediately
	-- if (IsDead(this)) then
	-- 	inCombat = false
	-- end
	if (mInCombatState ~= inCombat or force) then
		mInCombatState = inCombat
		this:SendMessage("CombatStatusUpdate", inCombat)

		if (this:HasSharedObjectProperty('CombatMode')) then
			this:SetSharedObjectProperty("CombatMode", inCombat)
		end

		if (mInCombatState == true) then
			ArcherMinDelay()
			--if (this:IsPlayer() and IsCombatMap()) then
			--	this:PlayMusic("Combat")
			--	mCombatMusicPlaying = true
			--end
			this:SendMessage("BreakInvisEffect", "Combat")
			if (_Weapon.RightHand.Object ~= nil) then
				PlayWeaponSound(this, "Draw")
			end

			if (this:GetObjVar("IsHarvesting")) then
				-- this is a messy hack since the tool itself does the gathering right now
				if (_Weapon.RightHand.Class == "Tool") then
					_Weapon.RightHand.Object:SendMessage("CancelHarvesting", this)
				end
				this:SendMessage("CancelHarvesting", this)
			end
		else
			--if (mCombatMusicPlaying) then
			--	this:StopMusic()
			--	mCombatMusicPlaying = false
			--end

			if (_Weapon.RightHand.Object ~= nil) then
				PlayWeaponSound(this, "Sheathe")
			end
			EndDrawBow()
		end
	end
end

function EndDrawBow()
	if (mBowDrawn) then
		this:PlayAnimation("end_draw_bow")
		mBowDrawn = false
	end
end

function ClearSwingTimers()
	Verbose("Combat", "ClearSwingTimers")
	if (this:HasTimer("SWING_TIMER_RightHand")) then
		this:RemoveTimer("SWING_TIMER_RightHand")
	end
	if (this:HasTimer("SWING_TIMER_LeftHand")) then
		this:RemoveTimer("SWING_TIMER_LeftHand")
	end
	mSwingReady.RightHand = false
	mSwingReady.LeftHand = false
end

RegisterEventHandler(EventType.Message, "ClearSwingTimers", ClearSwingTimers)

--Enter attack range of right hand weapon
RegisterEventHandler(
	EventType.EnterView,
	"RightHandAttackRange",
	function(obj)
		Verbose("Combat", "RightHandAttackRange", obj)
		if (not mInCombatState or obj ~= mCurrentTarget) then
			return
		end
		PerformWeaponAttack(mCurrentTarget, "RightHand")
	end
)

--Enter attack range of left hand weapon
RegisterEventHandler(
	EventType.EnterView,
	"LeftHandAttackRange",
	function(obj)
		Verbose("Combat", "LeftHandAttackRange", obj)
		if (not mInCombatState or obj ~= mCurrentTarget) then
			return
		end
		PerformWeaponAttack(mCurrentTarget, "LeftHand")
	end
)

--Right Hand Swing Timer
RegisterEventHandler(
	EventType.Timer,
	"SWING_TIMER_RightHand",
	function()
		mSwingReady.RightHand = true
		PerformWeaponAttack(mCurrentTarget, "RightHand")
	end
)

--Left Hand Swing Timer for Dual wield support
RegisterEventHandler(
	EventType.Timer,
	"SWING_TIMER_LeftHand",
	function()
		mSwingReady.LeftHand = true
		PerformWeaponAttack(mCurrentTarget, "LeftHand")
	end
)

---------------------------
-----------------------
--LEGACY
function HandleMagicalAttackRequest(spellName, spTarg, spellSource, doNotRetarget, damagePvP)
	
	--DebugMessage(isNotAOE, " is AOE")
	if (spTarg == spellSource and not ServerSettings.Combat.NoSelfDamageOnAOE and (not isNotAOE) and not damagePvP) then
		return
	end
	--D*ebugMessage("[INFO]Spell Request: " ..tostring(spellName) .. " Target: " .. spTarg:GetName().. " Source:"..tostring(spellSource) .. " NoRetarget:" .. tostring(doNotRetarget))
	--DebugMessage("damagePvP is "..tostring(damagePvP))
	PerformMagicalAttack(spellName, spTarg, spellSource, doNotRetarget, damagePvP)
end

function HandleAutotargetToggleRequest(newState)
	Verbose("Combat", "HandleAutotargetToggleRequest", newState)
	if (newState == nil) then
		newState = not (this:GetObjVar("AutotargetEnabled"))
	end

	if (newState == "on" or newState == true) then
		this:SystemMessage("Autotargetting enabled.", "info")
		this:SetObjVar("AutotargetEnabled", true)
	else
		this:SystemMessage("Autotargetting disabled.", "info")
		this:DelObjVar("AutotargetEnabled")
	end
end

RegisterEventHandler(
	EventType.Message,
	"ResetSwingTimer",
	function(delay, hand)
		if not (InCombat(this)) then
			return
		end
		ResetSwingTimer(delay or 0, hand)
	end
)

RegisterEventHandler(
	EventType.Message,
	"DelaySwingTimer",
	function(delay, hand)
		if not (InCombat(this)) then
			return
		end
		DelaySwingTimer(delay, hand)
	end
)

function ClearTarget()
	Verbose("Combat", "ClearTarget")
	SetCurrentTarget(nil)
	if (this:IsPlayer()) then
		this:SendClientMessage("ChangeTarget", nil)
	end
end

function FindArrowType(mobile)
	local backpack = mobile:GetEquippedObject("Backpack")
	if (backpack) then
		for i = 1, #mArrowTypes do
			local type = mArrowTypes[i]
			if
				(FindItemInContainerRecursive(
					backpack,
					function(item)
						return item:GetObjVar("ResourceType") == type
					end
				))
			then
				mArrowType = type
				mArrowDamageBonus = ArrowTypeData[type].DamageBonus or 0
				return true
			end
		end
	end
	NotifyOutOfArrows(mobile)
	return false
end

function NotifyOutOfArrows(mobile)
	if not (mobile:HasTimer("OutOfArrows")) then
		mobile:SystemMessage("Out of arrows.", "info")
		mobile:ScheduleTimerDelay(TimeSpan.FromSeconds(4), "OutOfArrows")
	end
end

function DrawBow()
	Verbose("Combat", "DrawBow")
	if (not _Weapon.RightHand.IsRanged or mBowDrawn or mIsMoving or not mInCombatState and not IsMobileDisabled(this)) then
		return false
	end

	if (IsPlayerCharacter(this) and not(IsPossessed(this)) and not(FindArrowType(this))) then
		mOutOfArrows = true
		return false
	end

	-- have the client character pull and hold the bow
	this:PlayAnimation("draw_bow")
	mBowDrawn = true
	PlayWeaponSound(this, "Load", _Weapon.RightHand.Object)

	return true
end

--Movement Handler
RegisterEventHandler(
	EventType.StartMoving,
	"",
	function()
		if (mSkipRangedStopMoving) then
			return
		end
		Verbose("Combat", "StartMoving")
		mIsMoving = true

		EndDrawBow()
	end
)

RegisterEventHandler(
	EventType.StopMoving,
	"",
	function()
		if (mSkipRangedStopMoving) then
			return
		end
		Verbose("Combat", "StopMoving")
		mIsMoving = false
		-- throw a slight delay in here to account for server latency
		CallFunctionDelayed(
			TimeSpan.FromMilliseconds(250),
			function(...)
				if not (mIsMoving) then
					ArcherMinDelay()
				end
			end
		)
	end
)

function ArcherMinDelay()
	if (mInCombatState) then
		if (_Weapon.RightHand.IsRanged) then
			if (DrawBow()) then
				if (mSwingReady.RightHand) then
					-- swing is ready, fire in min delay
					mSwingReady.RightHand = false
					this:ScheduleTimerDelay(ServerSettings.Combat.BowStopMinDelay, "SWING_TIMER_RightHand")
				else
					-- swing is not ready, fire in time left (if greater than min) or min
					local delay = ServerSettings.Combat.BowStopMinDelay
					local timerDelay = this:GetTimerDelay("SWING_TIMER_RightHand")
					if (timerDelay ~= nil and timerDelay > ServerSettings.Combat.BowStopMinDelay) then
						delay = timerDelay
					end
					this:ScheduleTimerDelay(delay, "SWING_TIMER_RightHand")
				end
			else
				--failed to draw bow (out of arrows?) try again later.
				ResetSwingTimer(0, "RightHand")
			end
		end

		if (mCurrentTarget ~= nil) then
			LookAt(this, mCurrentTarget)
		end
	end
end

function UpdatePreferredArrowType(type)
	mArrowType = type
	-- set the preferred at first in list
	mArrowTypes = {type}
	-- add the remaining types
	for i = 1, #ArrowTypes do
		local t = ArrowTypes[i]
		-- skipping preferred
		if (t ~= type) then
			mArrowTypes[#mArrowTypes + 1] = t
		end
	end
end

RegisterEventHandler(
	EventType.Message,
	"PreferredArrowType",
	function(type)
		-- if it's a valid arrow type
		if (ArrowTypeData[type] ~= nil) then
			UpdatePreferredArrowType(type)
			this:SetObjVar("PreferredArrowType", type)
			this:SystemMessage(ArrowTypeData[type].Name .. " set as preferred arrow type.", "info")
		end
	end
)

RegisterEventHandler(
	EventType.Message,
	"EndCombatMessage",
	function(reason)
		--if(reason ~= nil) then DebugMessage(this:GetName() .. " Ended Combat: " .. reason) end
		SetInCombat(false)
	end
)

RegisterEventHandler(
	EventType.Message,
	"ForceCombat",
	function(target)
		if (mInCombatState ~= true) then
			if (target) then
				SetCurrentTarget(target)
			end
			SetInCombat(true)
			BeginCombat()
		end
	end
)

RegisterEventHandler(
	EventType.ItemEquipped,
	"",
	function(item)
		if ( item == nil ) then return end
		local slot = GetEquipSlot(item)
		if ( slot == "Mount" ) then return end
		if (item:HasObjVar("ColorWarItem")) then
			local user = this
			if (not(item:HasModule("colorwar_flag"))) then
				item:SetHue(user:GetHue())
			end
		end
		if ( IsPlayerCharacter(this) ) then
			CancelCastPrestigeAbility(this)

			if ( slot == "RightHand" or slot == "LeftHand" ) then
				UpdatePlayerWeaponAbilities(this)
			end

			UpdateEquipmentSkillBonuses(this,item)

			if (this:HasObjVar("IsHarvesting")) then	
				local harvestingTool = this:GetObjVar("HarvestingTool")
				harvestingTool:SendMessage("CancelHarvesting", this)
			end

			if ( this:HasTimer("SpellPrimeTimer") and GetEquipmentClass(item) == "WeaponClass" ) then
				CancelSpellCast(6)
				-- DoFizzle(this)
			end
		end
		if ( slot == "RightHand" or slot == "LeftHand" ) then
			-- weapon was equipped, clear queued abilities.
			ClearQueuedWeaponAbility()
			ClearSwingTimers()
			mWeaponSwapped = true
			-- update reference to our weapons
			UpdateWeaponCache(slot, item)
		end
	end
)

RegisterEventHandler(
	EventType.ItemUnequipped,
	"",
	function(item)
		if (item == nil) then
			return
		end
		local slot = GetEquipSlot(item)
		if (IsPlayerCharacter(this)) then
			CancelCastPrestigeAbility(this)

			UpdateEquipmentSkillBonuses(this, item)

			if (slot == "RightHand" or slot == "LeftHand") then
				-- weapon was unequipped, clear queued abilities.
				ClearQueuedWeaponAbility()
				UpdatePlayerWeaponAbilities(this)
				-- delete the view if it exists
				if (mPrimed[slot]) then
					DelView(string.format("%sAttackRange", hand))
					mPrimed[slot] = nil
				end
			end
		end
		if (slot == "RightHand" or slot == "LeftHand") then
			ClearSwingTimers()
			mWeaponSwapped = true
			-- update reference to our weapons
			UpdateWeaponCache(slot, false)
		end
	end
)

RegisterEventHandler(
	EventType.Timer,
	"DoRecalculateStats",
	function()
		if (mWeaponSwapped) then
			-- reset swing timer, minus the time it took for the timer to trigger this event.
			ResetSwingTimer(-0.1, slot)
			SetupViews()
			mWeaponSwapped = false
		end
	end
)

RegisterEventHandler(EventType.ClientUserCommand, "targetObject", HandleScriptCommandTargetObject)
RegisterEventHandler(EventType.ClientUserCommand, "toggleCombat", HandleScriptCommandToggleCombat)
RegisterEventHandler(EventType.ClientUserCommand, "autotarget", HandleAutotargetToggleRequest)
RegisterEventHandler(EventType.Message, "ClearTarget", ClearTarget)
RegisterEventHandler(EventType.Message, "AttackTarget", HandleAttackTarget)
RegisterEventHandler(EventType.Message, "RequestMagicalAttack", HandleMagicalAttackRequest)

function HandleWeaponDamageReceived(damager, isCrit, srcWeapon, isReflected)
	local damageInfo = {
		Attacker = damager,
		Victim = this,
		IsCrit = isCrit,
		Source = srcWeapon,
		IsReflected = isReflected
	}
	ApplyDamageToTarget(damageInfo)
end

function HandleTypeDamageReceived(damager, damage, type, isCrit, isReflected)
	local damageInfo = {
		Attacker = damager,
		Victim = this,
		Damage = damage,
		Type = type,
		IsCrit = isCrit,
		IsReflected = isReflected
	}
	ApplyDamageToTarget(damageInfo)
end

function HandleMagicDamageReceived(damager, damage, isCrit, isReflected)
	HandleTypeDamageReceived(damager, damage, "MAGIC", isCrit, isReflected)
end

function HandleTrueDamageReceived(damager, damage, isCrit, slot, isReflected)
	HandleTypeDamageReceived(damager, damage, "TrueDamage", isCrit, isReflected)
end

RegisterEventHandler(EventType.Message, "ProcessWeaponDamage", HandleWeaponDamageReceived)
RegisterEventHandler(EventType.Message, "ProcessTypeDamage", HandleTypeDamageReceived)
RegisterEventHandler(EventType.Message, "ProcessMagicDamage", HandleMagicDamageReceived)
RegisterEventHandler(EventType.Message, "ProcessTrueDamage", HandleTrueDamageReceived)
RegisterEventHandler(EventType.Message, "ExecuteMissAction", ExecuteMissAction)

-------------INITIALIZERS
--- cache some info on our weapons since they get used a lot.
UpdateWeaponCache("LeftHand")
UpdateWeaponCache("RightHand")
-- setup the mArrowTypes list
UpdatePreferredArrowType(this:GetObjVar("PreferredArrowType") or "Arrows")

if (mInCombatState) then
	InitiateCombatSequence()
end

if ( this:HasObjVar("WasHidden") ) then
	this:DelObjVar("WasHidden")
end

RegisterEventHandler(
	EventType.Message,
	"QueueWeaponAbility",
	function(ability)
		if (mQueuedWeaponAbility) then
			if (this:IsPlayer()) then
				-- anytime mQueuedWeaponAbility is set, we clear it when it's called. This works like a toggle.
				this:SendClientMessage("SetActionActivated", {"CombatAbility", mQueuedWeaponAbility.ActionId, false})
				this:SystemMessage(mQueuedWeaponAbility.DisplayName .. " cancelled.", "info")
			end
			-- 'activated' one that was already active. Clear it and stop here
			if (mQueuedWeaponAbility.ActionId == ability.ActionId) then
				mQueuedWeaponAbility = nil
				return
			end
		end
		mQueuedWeaponAbility = ability
		if (this:IsPlayer()) then
			this:SendClientMessage("SetActionActivated", {"CombatAbility", mQueuedWeaponAbility.ActionId, true})
			this:SystemMessage("You will attempt " .. mQueuedWeaponAbility.DisplayName .. " on your next attack.", "info")
			if (mInCombatState == false) then
				BeginCombat()
			end
		end
	end
)

-- Global functions inside helpers.

RegisterEventHandler(EventType.ClientUserCommand, "wa", function(primarySecondary)
    if (this:HasTimer("SpellPrimeTimer")) then
        this:SystemMessage("You cannot use an ability while casting a spell");
        return
    end
    PlayerUseWeaponAbility(this, primarySecondary)
end)
RegisterEventHandler(EventType.ClientUserCommand, "pa", function(prestigeClass,prestigeAbility)
    if (this:HasTimer("SpellPrimeTimer")) then
        this:SystemMessage("You cannot use an ability while casting a spell");
        return
    end
    PerformPrestigeAbility(this, mCurrentTarget, prestigeClass, prestigeAbility)
end)