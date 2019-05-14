-- most basic mobile script for animals that do not have loot

require 'weapon_cache'
-- this module handles derived stats and adding and removing stat modifiers
require 'base_mobilestats'
-- allows us to add temporary modifiers to this mobile.
require 'base_mobile_mods'
require 'use_object'

mInvisibilityEffects = {}
mInvisEffectsCount = 0



--[[ Damage / Heal tracking for mobs (used in the killboard / event record system)]]--

-- clear damagers/healers list on start
mDamagers = {}
mHealers = {}
this:DelObjVar("Damagers")
this:DelObjVar("Healers")

function UpdateDamagersList(attacker, damage)
	-- reasign to owner if applicable
	attacker = attacker:GetObjVar("controller") or attacker

	if(mDamagers[attacker]) then
		mDamagers[attacker].Amount = mDamagers[attacker].Amount + damage
	else
		mDamagers[attacker] = { Amount=damage }
	end

	this:SetObjVar("Damagers",mDamagers)
	
	-- set a timeout to clear their list after a 'battle'
	this:ScheduleTimerDelay(ServerSettings.Conflict.RelationDuration, "ClearDamagersHealers")
end

function UpdateHealersList(healer, amt)
	if(mHealers[healer]) then
		mHealers[healer].Amount = mHealers[healer].Amount + amt
	else
		mHealers[healer] = { Amount=amt }
	end

	this:SetObjVar("Healers",mHealers)

	-- set a timeout to clear their list after a 'battle'
	this:ScheduleTimerDelay(ServerSettings.Conflict.RelationDuration, "ClearDamagersHealers")
end

RegisterEventHandler(EventType.Timer, "ClearDamagersHealers", function()
    	Verbose("Mobile", "ClearDamagersHealers")
		mDamagers = {}
		mHealers = {}
		this:DelObjVar("Damagers")
		this:DelObjVar("Healers")
	end)

function Speak(entry)
    if( entry.Text ~= nil ) then
        this:NpcSpeech(entry.Text)
    end
    if( entry.Audio ~= nil ) then
        this:PlayObjectSound(entry.Audio)
    end
end

function DoMobileDeath(damager, damageSource)
	Verbose("Mobile", "DoMobileDeath", damager)
	SetCurHealth(this,0)

	EndMobileEffectsOnDeath(this)
	
	if not(damager == this) and (damager ~= nil) then		
		damager:SendMessage("VictimKilled", this, damageAmount, damageType, damageSource)
	end

	-- mounts are the only mobiles that can be equipped
	if(this:IsEquipped()) then
		DismountMobile(this:ContainedBy(), this)
	end

	this:SendMessage("HasDiedMessage", damager)
	this:PlayObjectSound("Death", true)
	
	this:StopMoving()
	this:ClearCollisionBounds()

	RemoveAllInvisibilityEffects()

	-- these should be calculated via MarkStatsDirty after IsDead returns true, but this works for now.

	SetMobileMod(this, "HealthRegenPlus", "Death", -1000)
	SetMobileMod(this, "ManaRegenPlus","Death", -1000)
	SetMobileMod(this, "StaminaRegenPlus","Death", -1000)

	local karmaLevel = GetKarmaLevel(GetKarma(this))
	if (this:IsPlayer() and not IsPossessed(this)) then
		if ( karmaLevel.GuardProtectPlayer == true ) then
			KarmaPunishAllAggressorsForMurder(this)
		end
		AllegianceRewardKill(this)
	else
		-- if it's a pet and the owner is valid
		if ( _MyOwner ~= nil and _MyOwner:IsValid() ) then
			if ( karmaLevel.GuardProtectPlayer == true ) then
				KarmaPunishAllAggressorsForMurder(this)
			end
		else
			HandleMobileDeathRewards(this, karmaLevel)
			FreezeConflictTable(this)
		
			if ( karmaLevel.GuardProtectNPC == true ) then
				KarmaPunishAllAggressorsForMurder(this)
			end
		end

		this:SetMobileFrozen(true,true)
		this:PlayAnimation("die")
		-- set as corpse
		this:SetSharedObjectProperty("IsDead", true)

		UpdateName(this:GetName() .. " Corpse")

		-- freeze conflict table on the mobile

		local spawnerObj = this:GetObjVar("Spawner")
		if(spawnerObj) then
			spawnerObj:SendMessage("MobHasDied",this)
		end		
		
		if (not this:HasObjVar("DoNotDecay") and not(this:DecayScheduled())) then
			Decay(this)
		end

		local oldUseCaseList = this:GetObjVar("UseCases")
		if(oldUseCaseList ~= nil) then
			this:SetObjVar("LivingUseCases",oldUseCaseList)
		end

		this:SetObjVar("UseCases",{})
	end
	
	-- record the event of death
	EventTracking.RecordDeathEvent(this,damager)
	-- clear damagers/healers list
	this:FireTimer("ClearDamagersHealers")
end

-- isReflected is not used in here, instead it's used in other things sending this message to determine if the damage should be reflected or not, 
	-- this is to prevent reflected damage from reflecting back and forth. It's not pretty when this happens.
--Damage source is being passed in to check for players kill achievement
function HandleApplyDamage(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected, damageSource)
	Verbose("Mobile", "HandleApplyDamage", damager, damageAmount, damageType, isCrit, wasBlocked, isReflected, damageSource)
	if( IsDead(this) or damageAmount == nil ) then
		return
	end

	if ( this:HasObjVar("Invulnerable") ) then
		this:NpcSpeech("[C0C0C0]Invulnerable[-]", "combat")
		return
	end

	this:SendMessage("BreakInvisEffect", "Damage")	

	if ( IsMobileImmune(this) ) then
		DoMobileImmune(this)
		return
	end
	
	local hasMageArmor = HasMobileEffect(this, "MageArmor")
	if ( not hasMageArmor and IsPlayerCharacter(damager) ) then
		CheckSpellCastInterrupt(this)
	end

	damageType = damageType or "Bashing"
	local typeData = CombatDamageType[damageType]
	-- not a real combat damage type, stop here.
	if not( typeData ) then
		LuaDebugCallStack("[HandleApplyDamage] invalid type: "..damageType)
		return
	end

	local mod = {plus = 0,times = 1}
	if ( typeData.Magic ) then
		if ( not isReflected and hasMageArmor ) then
			this:NpcSpeech("[ffffff]Reflected[-]", "combat")
			return
		end
		damageAmount = ( damageAmount + GetMobileMod(MobileMod.MagicDamageTakenPlus) ) * GetMobileMod(MobileMod.MagicDamageTakenTimes,1)
	else
		local mod = {
			plus = GetMobileMod(MobileMod.PhysicalDamageTakenPlus),
			times = GetMobileMod(MobileMod.PhysicalDamageTakenTimes, 1)
		}
		local modNames = {
			string.format("%sDamageTakenPlus", damageType),
			string.format("%sDamageTakenTimes", damageType)
		}
		if ( MobileMod[modNames[1]] ~= nil and MobileMod[modNames[2]] ~= nil ) then
			mod.plus = mod.plus + GetMobileMod(MobileMod[modNames[1]])
			mod.times = GetMobileMod(MobileMod[modNames[2]], mod.times)
		end
		damageAmount = ( damageAmount + mod.plus ) * mod.times
	end

	--to account for more absorbing then damage and prevent 0 damage done (or NaN or Infinity)
	if ( damageAmount < 0.5 or damageAmount ~= damageAmount or damageAmount > 9999999999 ) then
		damageAmount = 1
	end
	
	damageAmount = math.round(damageAmount)

	if(isCrit) then
		this:NpcSpeech("[FF0000]"..damageAmount.."[-]", "combat")
	else
		this:NpcSpeech("[FCF914]"..damageAmount.."[-]", "combat")
	end
	
	local curHealth = GetCurHealth(this) or 1
	if ( damageAmount > curHealth ) then damageAmount = curHealth end

	UpdateDamagersList(damager, damageAmount)
	-- advance conflict
	AdvanceConflictRelation(damager, this, nil, typeData.NoGuards)
	
	local newHealth = curHealth - damageAmount
	if (newHealth <= 0) then
		DoMobileDeath(damager, damageSource)
	else
		SetCurHealth(this,newHealth)
		if(damageAmount>=2) then 
			if not(wasBlocked) then
				this:PlayAnimation("was_hit")
			end

			if ( damageAmount > 3 ) then
				this:PlayObjectSound("Pain", true)
			end
			if ( damageAmount > 10 ) then
				this:PlayEffect("BloodEffect_A")
				local mountedDamager = (IsMounted(damager) and damager ~= this) 

				if(IsMounted(this) and ServerSettings.Combat.DazedOnDamageWhileMounted) then
					if (ServerSettings.Combat.DismountWhileDazed and HasMobileEffect(this, "Dazed") and not(ServerSettings.Combat.MountedAttackersCanTriggerDismount and mountedDamager)) then
						local dismountRoll = math.random(0,100)
						local dismountChance = ServerSettings.Combat.DismountWhileDazedChance or 50
						if(dismountRoll < dismountChance) then
							DismountMobile(this, nil)
						end
					else
						if not(ServerSettings.Combat.MountedAttackersCanTriggerDaze and mountedDamager) then
							this:SendMessage("StartMobileEffect", "Dazed", this, 3)
						end
					end
				end
			end			
		end
	end

	return newHealth
end

-- function HandleUseObject(user,usedType)
-- 	Verbose("Mobile", "HandleUseObject", user,usedType)
-- 	-- TODO: Check for guard protection (if you loot there it should alert the guards)	
-- 	if( usedType == "Open Pack" ) then
-- 		if(IsDead(this)) then
-- 			if(this:GetLoc():Distance(user:GetLoc()) > OBJECT_INTERACTION_RANGE ) then    
--         		user:SystemMessage("You cannot reach that.","info")  
--         		return false
--     		end
-- 	    	if not(user:HasLineOfSightToObj(this,ServerSettings.Combat.LOSEyeLevel)) then 
-- 	    		user:SystemMessage("[FA0C0C]You cannot see that![-]","info")
-- 	    		return false
-- 	    	end

-- 			if( this:HasObjVar("guardKilled") ) then
-- 				user:SystemMessage("[$1673]")
-- 			elseif( not(this:HasObjVar("lootable") or this:HasObjVar("HasPetPack")) ) then
-- 				user:SystemMessage("You find there is nothing of value on that corpse.","info")
-- 			else				
-- 		    	local backpackObj = this:GetEquippedObject("Backpack")
-- 			    if ( backpackObj == nil ) then
-- 					this:SendOpenContainer(user)
-- 				else
-- 					if ( #backpackObj:GetContainedObjects() > 0 ) then
-- 						backpackObj:SendOpenContainer(user)
-- 					else
-- 						user:SystemMessage("You find there is nothing of value on that corpse.","info")
-- 					end
-- 				end
-- 			end
-- 		elseif(this:HasObjVar("HasPetPack")) then
-- 			if(IsController(user,this) or IsDemiGod(user)) then
-- 				local backpackObj = this:GetEquippedObject("Backpack")
-- 			    if( backpackObj ~= nil ) then
-- 		    		backpackObj:SendMessage("OpenPack",user)
-- 			    end
-- 			else
-- 				user:SystemMessage("You can't do that.","info")
-- 			end
-- 		end
-- 	elseif( usedType == "Loot All" and IsDead(this) ) then

--     	local lootContainer = this:GetEquippedObject("Backpack")
-- 	    if( lootContainer == nil ) then
-- 			lootContainer = this
-- 		end
-- 		if ( #containerObj:GetContainedObjects() > 0 ) then
-- 			user:SendMessage("LootAll", this)
-- 		else
-- 			user:SystemMessage("You find nothing worth looting on this corpse.","info")
-- 			return
-- 		end
-- 	elseif(usedType == "Cut Off Head" and IsDead(this)) then
-- 		if (this:DistanceFrom(user) > 2) then
-- 			user:SystemMessage("You need to be next to them to cut their head off.","info")
-- 			return
-- 		end
-- 		if (this:GetObjVar("CanHarvestHead") == false) then 
-- 			user:SystemMessage("[D74444]Their head has already been cut off.[-]","info")
-- 			return
-- 		end
-- 		if(user:CarriedObject() ~= nil) then
-- 			user:SystemMessage("You are already carrying something.","info")
-- 			return
-- 		end
-- 		this:SetObjVar("CanHarvestHead", false)
-- 		--DebugMessage(1)
-- 		--DFB HACK: This functionality of pausing, playing an animation, and showing a progress bar should be a helper function
-- 		local killerTeam = user:GetObjVar("MobileTeamType")
-- 		local myTeam = this:GetObjVar("MobileTeamType")
-- 		local args = {myTeam,this:GetName(),this:GetCreationTemplateId()}
-- 		user:SendMessage("EndCombatMessage")
-- 		user:PlayObjectSound("event:/character/skills/gathering_skills/hunting/hunting_knife")
-- 		FaceObject(user,this)
-- 		ProgressBar.Show(
-- 		{
-- 			TargetUser = user,
-- 			Label="Slicing Head",
-- 			Duration=TimeSpan.FromSeconds(2.5),
-- 			PresetLocation="AboveHotbar"
-- 		})
-- 		CallFunctionDelayed(TimeSpan.FromSeconds(0.1),function ( ... )
-- 			SetMobileModExpire(this, "Disable", "CuttingHeadsOff", true, TimeSpan.FromSeconds(1))
-- 			user:PlayAnimation("carve")
-- 		end)
-- 		CallFunctionDelayed(TimeSpan.FromSeconds(1),function()	
-- 			user:PlayObjectSound("event:/objects/pickups/bounty_head/bounty_head_pickup",false)
-- 			user:PlayAnimation("idle")
-- 			RegisterEventHandler(EventType.CreatedObject, "CreateMobileBountyHead", HandleHeadCreated)
-- 			CreateObjInBackpack(user,"human_head","CreateMobileBountyHead",args)
-- 		end)
-- 	elseif(usedType == "Dismount" and user == this) then
-- 		local mountObj = this:GetEquippedObject("Mount")
-- 		if(mountObj ~= nil) then
-- 			if ( DismountMobile(this, mountObj) ) then
-- 				mountObj:SendMessage("UserPetCommand", "follow", this)
-- 			end
-- 		end
-- 	end
-- end

function HandleHeadCreated(success,headObj,args)
	--DebugMessage(2)
	if not(success) then return end
	--DebugMessage(3)
	local headTeam = args[1]
	local headName = args[2]
	local headTemplate = args[3]
	headName = string.gsub(headName, "Corpse", "")
	headObj:SetName(StripColorFromString(headName).."Head")
	headObj:SetObjVar("DeceasedMobileTeamType",headTeam)
	headObj:SetObjVar("DeceasedMobileTemplate",headTemplate)
end


function HandleHealRequest(amount, healer, skipMods)
	if( IsDead(this) ) then return end

	if( amount == nil or amount <= 0 or healer == nil or amount ~= amount or amount > 9999999999 ) then return end

	if ( potionObj ~= nil ) then
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "PotionHealCooldownTimer")
		-- consume potion
		potionObj:SendMessage("AdjustStack", -1)
		healer = potionObj
	end

	if ( skipMods ~= true ) then
		-- apply mods
		amount = ( amount + GetMobileMod(MobileMod.HealingReceivedPlus) ) * GetMobileMod(MobileMod.HealingReceivedTimes, 1)
	end

	-- ensure we don't over heal
	local myHealth = GetCurHealth(this)
	amount = math.floor(math.max(0,math.min(GetMaxHealth(this), myHealth + amount) - myHealth))

	-- do the health adjust and combat text
	AdjustCurHealth(this, amount)
	this:NpcSpeech("[00FF00]"..amount.."[-]", "combat")

	-- update the healers list (used for statistics and the like)
	if ( healer ) then
		UpdateHealersList(healer, amount)
	end
end

--[[ VISIBILITY CONTROL ]]--

function AddInvisibilityEffect(effectName)
	--DebugMessage(this:GetName() .. " Added Move Speed Mod: " .. effectName)

	if(mInvisibilityEffects[effectName] == nil) then
		mInvisibilityEffects[effectName] = effectName
		mInvisEffectsCount = mInvisEffectsCount + 1
	end
	this:SetCloak(true)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(15), "ValidateInvisStatus")
end

function RemoveInvisibilityEffect(effectName)
	if(mInvisibilityEffects[effectName]) then
		mInvisibilityEffects[effectName] = nil
		mInvisEffectsCount = mInvisEffectsCount - 1
		if(mInvisEffectsCount < 1) then
			this:SetCloak(false)
			ClearCanSeeGroup(this)
			this:RemoveTimer("ValidateInvisStatus")
		end
	end
end

function RemoveAllInvisibilityEffects()
	if(mInvisEffectsCount > 0) then
		mInvisibilityEffects = {}
		mInvisEffectsCount = 0
		this:SetCloak(false)
		ClearCanSeeGroup(this)
	end
end
		
function ValidateInvisStatus()
	if (this:ContainedBy()) then return end
	if (this:HasObjVar("IsGhost")) then return end 
	if (this:HasObjVar("VisibleToDeadOnly")) then return end

	if(mInvisibilityEffects ~= nil) then
		for i,v in pairs(mInvisibilityEffects) do
			-- DAB HACK: Hiding does not use a module!
			if not (this:HasModule(i)) and i ~= "Hiding" then
				RemoveInvisibilityEffect(i)
			end
		end
	end
	mInvisEffectsCount = CountTable(mInvisibilityEffects)

	if (mInvisEffectsCount < 1) then				
		this:SetCloak(false)
	else
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(15),"ValidateInvisStatus")
	end
end
RegisterEventHandler(EventType.Timer, "ValidateInvisStatus",ValidateInvisStatus)

-- [[ Stats ]]--

function SetStartingStats(statTable,quiet)	
	-- begin with base stats
	--HACK for new character creation, fix later.
	local initialStats = statTable.Stats or { Str=20, Agi=20, Int=20, Wis=20, Will=20, Con=20 }

	if not (quiet) then
		if (GetStr(this) < initialStats.Str) then
			this:SystemMessage("[F7CC0A]Your Strength has increased, now "..initialStats.Str.." (+" .. tostring(-GetStr(this) + initialStats.Str) .. ")","info")
		elseif (GetStr(this) > initialStats.Str) then
			this:SystemMessage("[F7CC0A]Your Strength has decreased, now "..initialStats.Str.." (-" .. tostring(GetStr(this) - initialStats.Str) .. ")","info")
		end
	end
	SetStr(this,initialStats.Str or 10)
	if not (quiet) then
		if (GetAgi(this) < initialStats.Agi) then
			this:SystemMessage("[F7CC0A]Your Agility has increased, now "..initialStats.Agi.." (+" .. tostring(-GetAgi(this) + initialStats.Agi) .. ")","info")
		elseif (GetAgi(this) > initialStats.Agi) then
			this:SystemMessage("[F7CC0A]Your Agility has decreased, now "..initialStats.Agi.." (-" .. tostring(GetAgi(this) - initialStats.Agi) .. ")","info")
		end
	end
	SetAgi(this,initialStats.Agi or 10)
	if not (quiet) then
		if (GetInt(this) < initialStats.Int) then
			this:SystemMessage("[F7CC0A]Your Intelligence has increased, now "..initialStats.Int.." (+" .. tostring(-GetInt(this) + initialStats.Int) .. ")","info")
		elseif (GetInt(this) > initialStats.Int) then
			this:SystemMessage("[F7CC0A]Your Intelligence has decreased, now "..initialStats.Int.." (-" .. tostring(GetInt(this) - initialStats.Int) .. ")","info")
		end
	end
	SetInt(this,initialStats.Int or 10)	
	if not (quiet) then
		if (GetCon(this) < initialStats.Con) then
			this:SystemMessage("[F7CC0A]Your Constitution has increased, now "..initialStats.Con.." (+" .. tostring(-GetCon(this) + initialStats.Con) .. ")","info")
		elseif (GetCon(this) > initialStats.Con) then
			this:SystemMessage("[F7CC0A]Your Constitution has decreased, now "..initialStats.Con.." (-" .. tostring(GetCon(this) - initialStats.Con) .. ")","info")
		end
	end
	SetCon(this,initialStats.Con or 10)	
	if not (quiet) then
		if (GetWis(this) < initialStats.Wis) then
			this:SystemMessage("[F7CC0A]Your Wisdom has increased, now "..initialStats.Wis.." (+" .. tostring(-GetWis(this) + initialStats.Wis) .. ")","info")
		elseif (GetWis(this) > initialStats.Wis) then
			this:SystemMessage("[F7CC0A]Your Wisdom has decreased, now "..initialStats.Wis.." (-" .. tostring(GetWis(this) - initialStats.Wis) .. ")","info")
		end
	end
	SetWis(this,initialStats.Wis or 10)	
	if not (quiet) then
		if (GetWill(this) < initialStats.Will) then
			this:SystemMessage("[F7CC0A]Your Will has increased, now "..initialStats.Will.." (+" .. tostring(-GetWill(this) + initialStats.Will) .. ")","info")
		elseif (GetWill(this) > initialStats.Will) then
			this:SystemMessage("[F7CC0A]Your Will has decreased, now "..initialStats.Will.." (-" .. tostring(GetWill(this) - initialStats.Will) .. ")","info")
		end
	end
	SetWill(this,initialStats.Will)	

	DoRecalculateStats()

	-- next do health / mana / stamina
	if not (quiet) then
		if (GetMaxHealth(this) > GetCurHealth(this))  then
			this:SystemMessage("[F7CC0A]Your Health has increased, now "..GetMaxHealth(this).." (+" .. tostring(-GetMaxHealth(this) + GetCurHealth(this)) .. ")","info")
		elseif (GetMaxHealth(this) < GetCurHealth(this)) then
			this:SystemMessage("[F7CC0A]Your Health has decreased, now "..GetMaxHealth(this).." (-" .. tostring(GetMaxHealth(this) - GetCurHealth(this)) .. ")","info")
		end
	end
	SetCurHealth(this,GetMaxHealth(this))

	if not (quiet) then
		if (GetMaxMana(this) > GetCurMana(this))  then
			this:SystemMessage("[F7CC0A]Your Mana has increased, now "..GetMaxMana(this).." (+" .. tostring(-GetMaxMana(this) + GetCurMana(this)) .. ")","info")
		elseif (GetMaxMana(this) < GetCurMana(this)) then
			this:SystemMessage("[F7CC0A]Your Mana has decreased, now "..GetMaxMana(this).." (-" .. tostring(GetMaxMana(this) - GetCurMana(this)) .. ")","info")
		end
	end
	SetCurMana(this,GetMaxMana(this))

	if not (quiet) then
		if (GetMaxStamina(this) > GetCurStamina(this))  then
			this:SystemMessage("[F7CC0A]Your Mana has increased, now "..GetMaxStamina(this).." (+" .. tostring(-GetMaxStamina(this) + GetCurStamina(this)) .. ")","info")
		elseif (GetMaxStamina(this) < GetCurStamina(this)) then
			this:SystemMessage("[F7CC0A]Your Health has decreased, now "..GetMaxStamina(this).." (-" .. tostring(GetMaxStamina(this) - GetCurStamina(this)) .. ")","info")
		end
	end
	SetCurStamina(this,GetMaxStamina(this))

	-- DAB TODO: Shouldn't this go in player.lua?
	if(this:IsPlayer()) then
		SetCurVitality(this,GetMaxVitality(this))
	end

	-- set skills
	if( statTable.Skills ~= nil ) then
		for name, value in pairs(statTable.Skills) do
			local skillName = name .. "Skill"
			if (SkillData.AllSkills[skillName]) then			
				if not (quiet) then
					if GetSkillLevel(this,skillName) > value then
						this:SystemMessage("[F7CC0A]Your knowledge of the art of " .. name .. " has decreased, now "..value.." (-" .. tostring(GetSkillLevel(this,skillName) - value) .. ")","info")	
					elseif GetSkillLevel(this,skillName) < value then
						this:SystemMessage("[F7CC0A]Your knowledge of the art of " .. name .. " has increased, now "..value.." (+" .. tostring(-GetSkillLevel(this,skillName) + value) .. ")","info")	
					end
				end
				SetSkillLevel(this, skillName, value, false)
			else
				DebugMessage("ERROR: Template specifies invalid skill Template: " .. (this:GetObjVar("FormTemplate") or this:GetCreationTemplateId()) .. " Name: "..name)
			end
		end
	end

	if not (quiet) then
		this:SystemMessage("Your equipment has changed.","info")
	end	
end

function DoResurrect(statPct, resurrector, force)
	if( not(IsDead(this)) ) then return end

	local controller = this:GetObjVar("controller")
	if ( controller and not controller:IsValid() ) then
		if ( resurrector and IsPlayerCharacter(resurrector) ) then
			resurrector:SystemMessage("Their owner is no where to be found, cannot resurrect.", "info")
		end
		return
	end

	if ( this:GetCreationTemplateId() == "player_corpse" ) then
		-- look for the player
		local playerOfCorpse = this:GetObjVar("PlayerObject")
		if ( playerOfCorpse ~= nil and playerOfCorpse:IsValid() ) then
			playerOfCorpse:SendMessage("PlayerResurrect", resurrector, this, force)
		else
			if( resurrector ~= nil and resurrector:IsValid() and resurrector:IsPlayer() ) then
				-- not online? / they have already resurrected
				resurrector:SystemMessage("Their soul will not realign with that body.", "info")
			end
		end
		return
	end

	--AddView("alert", SearchMobileInRange(GetSetting("AlertRange")))
	-- default to full stat values 
	local newStatPct = statPct or .05
	
	this:SetSharedObjectProperty("IsDead", false)

	-- start at statPercent specified
	SetCurHealth(this,GetMaxHealth(this) * newStatPct)
	SetCurStamina(this,GetMaxStamina(this) * newStatPct)
	SetCurMana(this,GetMaxMana(this) * newStatPct)

	if (this:DecayScheduled()) then
		this:RemoveDecay()
	end

	this:SendMessage("SetFullLevelPct",50)
	this:SendMessage("BeginRestState")
	if (this:IsPlayer()) then
		this:DelObjVar("CanHarvestHead")
	end
	this:SetMobileFrozen(false, false)
	this:DelObjVar("Disabled")
	this:SendMessage("OnResurrect")

	this:SetCollisionBoundsFromTemplate(this:GetObjVar("FormTemplate") or this:GetCreationTemplateId())

	if not( IsPlayerCharacter(this) ) then
		local livingUseCases = this:GetObjVar("LivingUseCases")
		if(livingUseCases ~= nil) then
			this:SetObjVar("UseCases",livingUseCases)
			this:DelObjVar("LivingUseCases")
		end
				
		local mobileType = this:GetMobileType()
		-- this order matters
		if(mobileType == "Friendly") then
			if IsMount(this) then
				if not( this:IsEquipped() ) then	
					SetDefaultInteraction(this,"Mount")
				end
			elseif ( HasUseCase(this,"Interact") ) then
				this:SetSharedObjectProperty("DefaultInteraction","Interact")
			else
				this:SetSharedObjectProperty("DefaultInteraction","Use")
			end
		else
			--if you're stupid enough to res an enemy mob.
			this:SetSharedObjectProperty("DefaultInteraction","Attack")
		end

		-- needed to clear sparkles on a resurrect
		local backpack = this:GetEquippedObject("Backpack")
		if ( backpack ~= nil and backpack:HasModule("tagged_mob") ) then
			backpack:SendMessage("ClearMobTag")
		end

		-- clear the conflict table on the mobile if they were resurrected for whatever reason
		ClearConflictTable(this)
	else
		this:SendMessage("PlayerResurrect", resurrector, nil, force)
	end

	SetMobileMod(this, "HealthRegenPlus", "Death", nil)
	SetMobileMod(this, "ManaRegenPlus","Death", nil)
	SetMobileMod(this, "StaminaRegenPlus","Death", nil)
	
	ApplyMobEffects()

	UpdateName()
end

RegisterEventHandler(EventType.Message, "AddXPLevel", 
    function (skillName,amount)
        AddXPLevel(this,skillName,amount)
    end)

--On resurrection
RegisterEventHandler(EventType.Message, "Resurrect", 
	function (statPercent, resurrector, force)
		if( not(IsDead(this)) ) then return end

		-- non player resurrects.
		DoResurrect(statPercent, resurrector, force)		
	end)


--- I was swug on (They missed a swing at me)
function HandleSwungOn(attacker)
    -- advance conflict
    AdvanceConflictRelation(attacker, this)
end

RegisterEventHandler(EventType.Message, "SwungOn", function(...) HandleSwungOn(...) end)
RegisterEventHandler(EventType.Message, "DamageInflicted", function(...) HandleApplyDamage(...) end)
RegisterEventHandler(EventType.Message, "HealRequest", HandleHealRequest)

RegisterEventHandler(EventType.Message, "RemoveInvisEffect", RemoveInvisibilityEffect)
RegisterEventHandler(EventType.Message, "AddInvisEffect", AddInvisibilityEffect)

RegisterSingleEventHandler(EventType.Timer,"mobile_delayed_init",
	function()
		if not(this:IsPlayer()) then
			-- give other scritps like AI a chance to set the name, then colorize it
			UpdateName()
		end
	end)

function LoadMobTraits()
	local mobTraits = nil
	if(initializer and initializer.MobTraits) then
		mobTraits = initializer.MobTraits
		this:SetObjVar("MobTraits", initializer.MobTraits)
	else
		mobTraits = this:GetObjVar("MobTraits")
	end

	if(mobTraits) then
		for trait,level in pairs(mobTraits) do 
			local traitData = MobTraits[trait]
			if( traitData and #traitData.Levels >= level and MobileMod[traitData.MobileMod] ) then
				if ( traitData.MobileMod == "MaxHealthTimes" or traitData.MobileMod == "MaxHealthPlus" ) then
					-- need to delay this since marking a stat dirty (HandleMobileMod) has a tiny delay within.
					RegisterSingleEventHandler(EventType.Timer, "DoRecalculateStats", function()
						SetCurHealth(this, GetMaxHealth(this))
					end)
				end
				HandleMobileMod(traitData.MobileMod, "MobTrait"..trait, traitData.Levels[level])
			else
				DebugMessage("ERROR: Invalid mob trait: "..tostring(trait).." "..level.. " Template: "..this:GetCreationTemplateId())
			end
		end
	end
end

function OnMobileLoad()
	-- clear disabled (remove obj var and clear mobile frozen)
	this:DelObjVar("Disabled")
	this:SetMobileFrozen(false, false)
	if not IsImmortal(this) and not IsDead(this) then
		this:SetCloak(false)
	end
	-- mobile mods are not persistent so we load them every time
	LoadMobTraits()
end

function OnMobileCreated()
	-- all mobiles have the ability to defend themselves
	if ( mSkipAddCombatModule ~= true ) then
		this:AddModule("combat")
	end
	--this:AddModule("mobile_footprints")

	if ( initializer.AvailableSpells ) then
		local availSpells = {}
		for i=1,#initializer.AvailableSpells do
			availSpells[initializer.AvailableSpells[i]] = true
		end
		this:SetObjVar("AvailableSpellsDictionary", availSpells)
	end

	SetStartingStats(initializer,true)

	-- dynamic combat abilities
	if ( initializer.CombatAbilities ~= nil ) then
		SetInitializerCombatAbilities(this, initializer.CombatAbilities)
	end

	-- dynamic weapon abilities
	if ( initializer.WeaponAbilities ~= nil ) then
		this:SetObjVar("WeaponAbilities", initializer.WeaponAbilities)
		this:SendMessage("UpdateFixedAbilitySlots")
	end

	-- all players can see this mobs health
	this:SetStatVisibility("Health","Global")
	this:SetStatVisibility("Mana","Restricted")
	this:SetStatVisibility("Stamina","Restricted")

    if initializer.StatMods ~= nil then
		LuaDebugCallStack("initializer StatMods have been removed, use traits instead.")
	end
	
	if ( initializer.MobileEffects ~= nil ) then
		this:SetObjVar("InitMobEffects", initializer.MobileEffects)
	end
    
	-- wait one frame to color the name
	this:FireTimer("mobile_delayed_init")			

	OnMobileLoad()

	ApplyMobEffects(initializer.MobileEffects)
end

function ApplyMobEffects(effects)
	effects = effects or this:GetObjVar("InitMobEffects")
	if ( effects == nil ) then return end
	for i=1,#effects do
		StartMobileEffect(this, effects[i][1], nil, effects[i][2])
	end
end

function UpdateName(displayName)
	displayName = StripColorFromString(displayName or this:GetName())
	this:SetSharedObjectProperty("DisplayName", ColorizeMobileName(this, displayName))
end
RegisterEventHandler(EventType.Message, "UpdateName", UpdateName)

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function()
		if(not(this:HasObjVar("mobileInitialized"))) then
			this:SetObjVar("mobileInitialized",true)
			OnMobileCreated()
		end
	end)

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
	function ()
		if ( mSkipAddCombatModule ~= true and not this:HasModule("combat") ) then
			this:AddModule("combat")
		end

		OnMobileLoad()

		ApplyPersistentMobileEffects(this)
	
		ApplyMobEffects()
	end)

RegisterEventHandler(EventType.Message,"StartMobileEffect",
	function(effectName,target,args)
		StartMobileEffect(this,effectName,target,args)
	end)