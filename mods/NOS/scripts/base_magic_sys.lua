require 'incl_magic_sys'

--TODO
-- Mana Take on Cast
-- Mana Refund on cancel

mEqBonusDict = {}
SPV_MAX_EFFECTIVENESS_MOD = 20
SPV_MIN_EFFECTIVENESS_MOD = 15

mCastingDisplayName = ""
mCurSpell = nil
mPrimedSpell = nil
mQueuedTarget = nil
mQueuedTargetLoc = nil
mCombatStance = nil
mConSize = 0
mConsumed = {}
mConSuccess = {}
mFreeSpell = false
mSpellName = nil;

--Messages
--ObjVars

--Spells
mySpellsFlyingDict = {}
myBonusDict = {}
mSpellSource = nil
mAutoTarg = nil
mAutoTargLoc = nil

--scroll casting support
mScrollObj = nil


--
function GetSpellTargetType(spellName)
	Verbose("Magic", "GetSpellTargetType", spellName)
	local myTarget = GetSpellInformation(spellName, "TargetType")
	--DebugMessage("MyTarget return " .. tostring(myTarget))
	if(myTarget == "TargetSelf") then return this end
	if(myTarget == nil) then return nil end
	if(myTarget == "targetMobile") then return "RequestTarget" end
	if(myTarget == "targetObject") then return "RequestTarget" end
	if(myTarget == "LeftHand") then 
		return this:GetEquippedObject("LeftHand")
	end
	if(myTarget == "RightHand") then 
		return this:GetEquippedObject("RightHand")
	end
	if(myTarget == "targetLocation") then return "RequestLocation" end
	return nil

end

function ValidateSpellCastTarget(spellName,spellTarget,spellSource)
	Verbose("Magic", "ValidateSpellCastTarget", spellName,spellTarget,spellSource)
	local targetType = GetSpellInformation(spellName,"TargetType")

	if (not(spellTarget)) then spellTarget = this end

	if ( not IsInSpellRange(spellName, spellTarget, this)) then
		this:SystemMessage("Not in range.", "info")
		CancelSpellCast()
		return false
	elseif ( spellTarget ~= nil and targetType == "targetMobile" and not(spellTarget:IsMobile())) then
		if not (spellTarget:HasObjVar("Attackable")) then
			return false
		end
	elseif( not LineOfSightCheck(spellName, spellTarget)) then
		this:SystemMessage("Cannot see that.", "info")
		CancelSpellCast()
		return false
	elseif (not TargetDeadCheck(spellName,spellTarget)) then
		local mustBeDead = GetSpellInformation(spellName, "TargetMustBeDead") 
		local mustBeAlive = GetSpellInformation(spellName, "TargetMustBeAlive")
		if (mustBeDead) then
			this:SystemMessage(spellTarget:GetName() .. " is alive. Target must be dead. " .. spellName)
			return false
		end
		if (mustBeAlive) then
			this:SystemMessage(spellTarget:GetName() .. " is dead. Target must be alive. " .. spellName)
			return false
		end
	elseif spellTarget:IsCloaked() and (not ShouldSeeCloakedObject(this, spellTarget)) then
		if not (this:IsPlayer()) then 
			this:SendMessage("CannotSeeTarget", spellTarget) 
			return false
		else
			this:SystemMessage("Cannot see that.", "info")
			return false
		end
	elseif IsAttackTypeSpell(spellName) and not ValidCombatTarget(this, spellTarget) then
		return false
	elseif (SpellData.AllSpells[spellName].BeneficialSpellType == true and SpellData.AllSpells[spellName].SkipKarmaCheck ~= true) and not AllowFriendlyActions(this, spellTarget, true) then
		return false
	elseif (GetSpellInformation(spellName, "TargetResource")) then
		if (spellTarget:GetObjVar("ResourceType") ~= GetSpellInformation(spellName, "TargetResource")) then
			return false		
		end
	end

	return true
end

function PrimeSpell(spellName, spellSource)
	Verbose("Magic", "PrimeSpell", spellName, spellSource)
	if(spellSource == nil) then spellSource = this end
	if(spellName == nil) then return false end

	-- if (this:GetEquippedObject("LeftHand") ~= nil) then
	-- 	DoUnequip(player:GetEquippedObject("LeftHand"), spellSource)
	-- end
	-- if (this:GetEquippedObject("RightHand") ~= nil) then
	-- 	DoUnequip(this:GetEquippedObject("RightHand"), spellSource)
	-- end

	CancelCurrentSpellEffects()

	if ( HasMobileEffect(this, "Silence") ) then
		if(this:IsPlayer()) then
			this:SystemMessage("You are silenced.", "info")
		end
		return false
	end

	if( IsMobileDisabled(this) ) then
		if ( this:IsPlayer() ) then
			this:SystemMessage("Cannot cast right now.", "info")
		end
		return false
	end

	if ( this:HasTimer("SpellGlobalCooldownTimer") ) then
		if ( this:IsPlayer() ) then
			this:SystemMessage("You are still recovering.", "info")
		end
		return false
	end

	if(spellName == "Reflectivearmor") then
		if(this:HasModule("sp_reflective_armor")) then
			this:SystemMessage("You are already protected.", "info")
			return
		end
		if(this:HasTimer("ReflectiveArmorTimer")) then
			this:SystemMessage("Cannot cast that spell again yet.", "info")
			return
		end
	end

	--DebugMessage("Priming..")
	local myTable = GetSpellSchoolTable(spellName)
	if(myTable == nil) then
		if(this:IsPlayer()) then	
			--LuaDebugCallStack(spellName)
			this:SystemMessage(spellName.. " is not a valid spell.","info")
		end
		return false
	end

	spellSource:SendMessage("BreakInvisEffect", "Casting")

	if not( HasManaForSpell(spellName, this) ) then 
		if ( this:IsPlayer() ) then
			this:SystemMessage("Not enough mana.", "info")
		end
		return
	end
	
	local myTargType = GetSpellTargetType(spellName)


	local myCastTime = GetSpellCastTime(spellName, spellSource)
	if (myCastTime == nil) then 
		--DebugMessage("[ERROR] Invalid Spell Casttime")
		return false 
	end

	this:PlayAnimation("cast")

	if ( this:IsPlayer() and SpellData.AllSpells[spellName].PowerWords ~= nil ) then
		this:NpcSpeech(SpellData.AllSpells[spellName].PowerWords, "combat")
	end

	DebugMessage("MADE IT TO HERE BOSS")
	local castingTime
	if(myCastTime > 0) then
	--D*ebugMessage("Cast Time:" .. tostring(myCastTime))
	--D*ebugMessage("spellName: " ..spellName)

		local castFX = GetSpellInformation(spellName, "SpellPrimeFXName")
		if (castFX ~= nil) then
			local mySpEffectArgs = GetSpellInformation(spellName, "SpellPrimeFXArgs")
		--D*ebugMessage("CFX: " ..tostring(castFX) .. " CTIM: " ..tostring(myCastTime) .. this:GetName())
			if(mySpEffectArgs) then
				this:PlayEffectWithArgs(castFX,myCastTime,mySpEffectArgs)
			else
				this:PlayEffect(castFX,myCastTime)--,"Bone=Ground")
			end			
		end
		local castFX2 = GetSpellInformation(spellName, "SpellPrimeFX2Name")
		if (castFX2 ~= nil) then
			local mySpEffectArgs2 = GetSpellInformation(spellName, "SpellPrimeFX2Args")
		--D*ebugMessage("CFX: " ..tostring(castFX2) .. " CTIM: " ..tostring(myCastTime) .. this:GetName())
			if(mySpEffectArgs2) then
				this:PlayEffectWithArgs(castFX2,myCastTime,mySpEffectArgs2)
			else
				this:PlayEffect(castFX2,myCastTime)--,"Bone=Ground")
			end			
		end

		local mySound = GetSpellInformation(spellName, "SpellPrimeSFX")
		if not (mySound == nil) then
			--DebugMessage("SpellSound: " .. mySound)
			this:PlayObjectSound(mySound,false,myCastTime)
		end
		castingTime = TimeSpan.FromMilliseconds( myCastTime * 1000 )
		this:ScheduleTimerDelay(castingTime, "SpellPrimeTimer", spellName, spellSource)

		if ( IsPlayerCharacter(this) ) then	
			local spellDisplayName = SpellData.AllSpells[spellName].SpellDisplayName

			this:SendClientMessage("StartCasting",myCastTime)
			mCastingDisplayName = tostring(spellDisplayName)
			this:SetObjVar("LastSpell",spellDisplayName)

			ProgressBar.Show(
			{
				TargetUser = spellSource,
				Label="Casting "..spellDisplayName,
				Duration=myCastTime,
				PresetLocation="UnderPlayer",
			})
		end

		-- if not(CanMoveWhileCasting(spellName)) then
		-- 	mSwingReady.RightHand = false
		-- 	mSwingReady.LeftHand = false
		-- 	SetMobileMod(this, "Disable", "CastFreeze", true)
		-- 	this:ScheduleTimerDelay(TimeSpan.FromSeconds(myCastTime), "CastFreezeTimer")
		-- end
		return true
	else
		--AdjustCurMana(this,-manaCost)
		this:FireTimer("SpellPrimeTimer", spellName, spellSource)
		return true
	end
end

-- RegisterEventHandler(EventType.Timer, "CastFreezeTimer", function()
-- 	DelaySwingTimer(ServerSettings.Combat.CastSwingDelay, "All")
-- 	SetMobileMod(this, "Disable", "CastFreeze", nil)
-- end)

function IsInstantHitSpell(spellName)
	local mySpInfo = GetSpellInformation(spellName, "InstantHitSpell")
	if mySpInfo == nil then mySpInfo = false end
	return mySpInfo
end

function IsHitTypeSpell(spellName)
	local myHitType = GetSpellInformation(spellName, "SpellType")
	if(myHitType == "MagicAttackTypeSpell") then return true end
	return false
end

function IsAttackTypeSpell(spellName)
	return ( 
		SpellData.AllSpells[spellName]
		and
		SpellData.AllSpells[spellName].AttackSpellType == true
	)
end

function IsBeneTypeSpell(spellName)
	return ( 
		SpellData.AllSpells[spellName]
		and
		SpellData.AllSpells[spellName].BeneficialSpellType == true
	)
end

function SetSpellTravelTime(spellName, spTarget, spellSource)
	Verbose("Magic", "SetSpellTravelTime", spellName, spTarget, spellSource)
	
	if (spellSource == nil) then spellSource = this end

	spellSource:SendMessage("BreakInvisEffect", "Action")

	if not ( mFreeSpell == true ) then

		if not( CheckMana(spellName, spellSource) ) then 
			return
		end

		if not ( CheckReagents(spellName, spellSource, mScrollObj) ) then
			return
		end

		if not( CheckSpellCastSuccess(spellName, spellSource, mScrollObj) ) then
			return
		end
	end
	mFreeSpell = false
	mScrollObj = nil

	local manaCost = GetManaCost(spellName)
	local mySpEffectType = GetSpellInformation(spellName, "effectType")
	local mySpEffect = GetSpellInformation(spellName, "SpellFXName")
	local overrideRate = 10
	local isRaySpell = false
	local timer = 0

	local spellFireAnim = GetSpellInformation(spellName, "SpellFireAnim")
	if( spellFireAnim ~= nil ) then
		this:PlayAnimation(spellFireAnim)
	end

	if(mySpEffectType == "RayProjectile") then
		overrideRate = 0.01
		local mySpEffectArgs = GetSpellInformation(spellName, "SpellFXArgs")
		this:PlayProjectileEffectTo(mySpEffect,spTarget,overrideRate,1,mySpEffectArgs)
	elseif(mySpEffectType == "Projectile") then 
		local mySpEffectDespawnDelay = GetSpellInformation(spellName, "SpellFXDespawnDelay") or 0
		overrideRate = GetSpellInformation(spellName, "SpellTravelRate")
		isReverseProjectile = GetSpellInformation(spellName, "IsReverseProjectile")
		if (overrideRate == nil ) then overrideRate = 10 end
		local bodyOffset = .5
		local castLoc = this:GetLoc()
		local targLoc = spTarget:GetLoc()
		local dist = targLoc:Distance(castLoc)
		timer = (dist - .5) / overrideRate	
		local indirect = GetSpellInformation(spellName, "IndirectProjectile")
		local spellLaunchFX = GetSpellInformation(spellName, "SpellLaunchFX")
		--DebugMessage("spellLaunch:" ..tostring(spellLaunchFX))
		if(indirect == true and spellLaunchFX ~= nil) then
			this:PlayEffect(spellLaunchFX)
		elseif( mySpEffect ~= nil ) then
			--DebugMessage ("Projectile")
			local mySpEffectArgs = GetSpellInformation(spellName, "SpellFXArgs")
			local mySpEffectDelay = GetSpellInformation(spellName, "SpellFXDelay") 			
			if(mySpEffectDelay) then				
				CallFunctionDelayed(TimeSpan.FromSeconds(mySpEffectDelay),
					function()
						if (isReverseProjectile) then
							spTarget:PlayProjectileEffectTo(mySpEffect,this,overrideRate,timer,mySpEffectArgs, mySpEffectDespawnDelay)
						else
							this:PlayProjectileEffectTo(mySpEffect,spTarget,overrideRate,timer,mySpEffectArgs, mySpEffectDespawnDelay)
						end
					end)
			else
				if (isReverseProjectile) then
					spTarget:PlayProjectileEffectTo(mySpEffect,this,overrideRate,timer,mySpEffectArgs)
				else
					this:PlayProjectileEffectTo(mySpEffect,spTarget,overrideRate,timer,mySpEffectArgs)
				end
			end
		end
	else
		if( mySpEffect ~= nil ) then
			local mySpEffectArgs = GetSpellInformation(spellName, "SpellFXArgs") or ""
			local mySpEffectDelay = GetSpellInformation(spellName, "SpellFXDelay") 
			local mySpEffectDuration = GetSpellInformation(spellName, "SpellFXDuration") or 0
			if(mySpEffectDelay) then				
				CallFunctionDelayed(TimeSpan.FromSeconds(mySpEffectDelay),
					function()
						if(mySpEffectArgs ~= nil) then
							spTarget:PlayEffectWithArgs(mySpEffect,mySpEffectDuration, mySpEffectArgs)
						else
							spTarget:PlayEffect(mySpEffect,mySpEffectDuration)
						end
					end)
			else
				if(mySpEffectArgs ~= nil) then
					spTarget:PlayEffectWithArgs(mySpEffect,mySpEffectDuration, mySpEffectArgs)
				else
					spTarget:PlayEffect(mySpEffect,mySpEffectDuration)
				end
			end
		end
	end

	local myLauchSFX = GetSpellInformation(spellName, "SpellLaunchSFX")
	if( myLauchSFX ~= nil ) then
		spellSource:PlayObjectSound(myLauchSFX,false)
	end

	local myDict = mySpellsFlyingDict or {}
	local minTravTime = GetSpellInformation(spellName, "MinTravelTime")
	if(minTravTime ~= nil) then timer = math.max(timer,minTravTime) end
	--if(this:HasObjVar("SpellsInFlight")) then myDict = this:GetObjVar("SpellsInFlight") end	
	
	local myBaseTimer = nil
	local mySpellTime = timer * 1000
	local myTime = ServerTimeMs() + (timer * 1000)

	AdjustCurMana(this,-manaCost)
	ApplyReleaseEffects(spellName, spTarget, spellSource, nil)
	local myArgs = {
		spellName,
		spTarget,
		myTime,
		spellSource }
	--DebugMessage(" Vect5: " .. tostring(myArgs[1]) .. " " .. tostring(myArgs[2]) .. " " .. tostring(myArgs[3]) .. " " .. tostring(myArgs[4]))

	local myKey = tostring(spellName) .. tostring(myTime)
	myDict[myKey] = myArgs
	mySpellsFlyingDict = myDict

	if(mySpellTime > 0) then

		CallFunctionDelayed(TimeSpan.FromMilliseconds(mySpellTime), 
			function()

				HandleSpellTravelled(spellName, spTarget, spSource, myKey)
			end)
	else
		HandleSpellTravelled(spellName, spTarget, spSource, myKey)
	end
	
end

function GetSpellDamageType(spellName)
	local myDamType = GetSpellInformation(spellName, "effectDamageType")
	if(myDamType == nil) then return "Piercing" end
	return myDamType
end

function ApplyReleaseEffects(spellName, spTarget, spellSource, targLoc)
	Verbose("Magic", "ApplyReleaseEffects", spellName, spTarget, spellSource, targLoc)

	if (spTarget ~= nil and not(IsBeneTypeSpell(spellName))) then
		spTarget:SendMessage("AttackedBySpell",this,spellName)
	end
	--DebugMessage("ApplyingReleaseEffect")
	local userReleaseEffect = GetSpellInformation(spellName, "SpellReleaseUserScript")
	if (userReleaseEffect ~= nil) and not this:HasModule(userReleaseEffect) then
		this:AddModule(userReleaseEffect)
		this:SendMessage(spellName .. "SelfEffectApplying")
		--DebugMessage("AddingModule On User: " .. userReleaseEffect)
		if(targLoc ~= nil) then this:SendMessage(spellName .. "SpellTargetLoc",targLoc) end
	end
	if(spTarget == nil) then return end
	local targetReleaseEffect = GetSpellInformation(spellName, "SpellReleaseTargetScript")
	if (targetReleaseEffect ~= nil) and not (spTarget:HasModule(targetReleaseEffect)) then
		spTarget:AddModule(targetReleaseEffect)
		spTarget:SendMessage("TargetReleaseEffect" .. targetReleaseEffect,spellSource,spTarget,targLoc)
	end

	local userReleseMobileEffect = GetSpellInformation(spellName, "SpellReleaseUserMobileEffect")
	if(userReleseMobileEffect ~= nil) then
		this:SendMessage("StartMobileEffect", userReleseMobileEffect, this, { Target = spTarget, SpellLoc = targLoc})
	end
end


function ApplySpellCompletionEffects(spellName, spTarget, spellSource)
	Verbose("Magic", "ApplySpellCompletionEffects", spellName, spTarget, spellSource)
	local mobileEffect = GetSpellInformation(spellName, "MobileEffect")
	if ( mobileEffect ~= nil ) then
		local args = GetSpellInformation(spellName, "MobileEffectArgs") or {}
		-- TODO: Add a bonus of sorts here from spell power or whatever
		StartMobileEffect(this, mobileEffect, this, args)
	end

	local spCasterEffectScript = GetSpellInformation(spellName, "completionEffectUserScript")
	if not(spCasterEffectScript == nil) and not(this:HasModule(spCasterEffectScript)) then
		this:AddModule(spCasterEffectScript)
	end
	--DebugMessage("SendingSpellCompletionMessage")
		if(spCasterEffectScript ~= nil) then this:SendMessage("CompletionEffect"..spCasterEffectScript) end

	local spTargetEffectScript = GetSpellInformation(spellName, "completionEffectTargetScript")
	if not(spTargetEffectScript == nil) and not(spTarget == nil) and not(spTarget:HasModule(spTargetEffectScript)) then
		spTarget:SetObjVar(spTargetEffectScript .. "Source", this)
		spTarget:AddModule(spTargetEffectScript)
		spTarget:SendMessage("SpellEffect" .. spTargetEffectScript,spellSource,spTarget)
	end
end
function ApplySpellEffects(spellName, spTarget, spellSource)
	Verbose("Magic", "ApplySpellEffects", spellName, spTarget, spellSource)
	--DebugMessage("ApplySpellEffects")
	if(spellSource == nil) then spellSource = this end
	local spellType = GetSpellInformation(spellName, "SpellType")
	if spellType == nil then 
		--DebugMessage("[ERROR] **Invalid Spell Type")
		return 
	end
	if (spTarget ~= nil and not(IsBeneTypeSpell(spellName))) then
		spTarget:SendMessage("AttackedBySpell",this,spellName)
	end
	--DebugMessage("**SpellType: " .. spellType)
	if(spellType == "HealTypeSpell") then
		PerformSpellHeal(spellName, spTarget, spellSource)
	end

	if (
		SpellData.AllSpells[spellName] ~= nil 
		and
		SpellData.AllSpells[spellName].BeneficialSpellType == true
		and
		SpellData.AllSpells[spellName].SkipKarmaCheck ~= true
	) then
		if ( spTarget ~= this and IsPlayerCharacter(this) ) then
			CheckKarmaBeneficialAction(this, spTarget)
		end
	end

	local spCasterEffectScript = GetSpellInformation(spellName, "spellHitEffectUserScript")
	if not(spCasterEffectScript == nil) then
		if not(this:HasModule(spCasterEffectScript)) then
			this:AddModule(spCasterEffectScript)
		end
		this:SendMessage("SpellHitUserEffect" .. spCasterEffectScript, spTarget)
	end
	--DebugMessage("SendingSpellCompletionMessage")

	if ( spTarget ~= nil ) then
		local spTargetHitEffectScript = GetSpellInformation(spellName, "spellHitEffectTargetScript")
		if not( spTargetHitEffectScript == nil ) then
			if not(spTarget:HasModule(spTargetHitEffectScript)) then
				spTarget:SetObjVar(spTargetHitEffectScript .. "Source", this)
				spTarget:AddModule(spTargetHitEffectScript)
			end
			spTarget:SendMessage("SpellHitEffect" .. spTargetHitEffectScript, this)
		else
			local targetMobileEffect = GetSpellInformation(spellName, "TargetMobileEffect")
			if ( targetMobileEffect ~= nil ) then
				local args = GetSpellInformation(spellName, "TargetMobileEffectArgs") or {}
				-- TODO: Add a bonus of sorts here from spell power or whatever
				spTarget:SendMessage("StartMobileEffect", targetMobileEffect, this, args)
			end

			local mobileEffect = GetSpellInformation(spellName, "MobileEffect")
			if ( mobileEffect ~= nil ) then
				local args = GetSpellInformation(spellName, "MobileEffectArgs") or {}
				-- TODO: Add a bonus of sorts here from spell power or whatever
				StartMobileEffect(this, mobileEffect, spTarget, args)
			end
		end

		local spellHitFX = GetSpellInformation(spellName, "SpellHitFX")
		if( spellHitFX ~= nil ) then
			spTarget:PlayEffect(spellHitFX)
		end

		local mySound = GetSpellInformation(spellName, "SpellHitSFX")
		if (mySound ~= nil) then
			--DebugMessage("SpellHitSound: " .. mySound)
			spTarget:PlayObjectSound(mySound)
		end

	end
	spellName = nil

end

function PerformSpellLocationActions(spellName,spellTarget, targetLoc, spellSource)
	Verbose("Magic", "PerformSpellLocationActions", spellName,spellTarget, targetLoc, spellSource)

	spellSource:SendMessage("BreakInvisEffect", "Action")

	if not( CheckMana(spellName, spellSource) ) then
		return
	end

	if not( CheckReagents(spellName, spellSource, mScrollObj) ) then
		return
	end

	if not( CheckSpellCastSuccess(spellName, spellSource, mScrollObj) )then
		return
	end

	mScrollObj = nil

	local spellFireAnim = GetSpellInformation(spellName, "SpellFireAnim")
	if( spellFireAnim ~= nil ) then
		this:PlayAnimation(spellFireAnim)
	end

	local manaCost = GetManaCost(spellName)
	AdjustCurMana(this,-manaCost)
	if(spellTarget == nil) then spellTarget = this end

	-- DAB NOTE: This has to happen before SpellTargetResult message
	ApplyReleaseEffects(spellName, spellTarget, spellSource, targetLoc)

	local spCasterEffectScript = GetSpellInformation(spellName, "completionEffectUserScript")
	if not(spCasterEffectScript == nil) and not(this:HasModule(spCasterEffectScript)) then
		this:AddModule(spCasterEffectScript)
	end
	this:SendMessage(spellName .. "SpellTargetResult",targetLoc)

	local spellHitFX = GetSpellInformation(spellName, "SpellHitFX")
	if( spellHitFX ~= nil ) then
		PlayEffectAtLoc(spellHitFX,targetLoc)
	end

	local mySound = GetSpellInformation(spellName, "SpellHitSFX")
	if (mySound ~= nil) then
		--DebugMessage("SpellHitSound: " .. mySound)
		this:PlayObjectSound(mySound)
	end

	local myLauchSFX = GetSpellInformation(spellName, "SpellLaunchSFX")
	if( myLauchSFX ~= nil ) then
		spellSource:PlayObjectSound(myLauchSFX,false)
	end
end

function GetSpellHealAmount(spellName, spellSource)
	Verbose("Magic", "GetSpellHealAmount", spellName, spellSource)
    if(spellSource == nil) then spellSource = this end
	
	local healAmount = 0
	local magicSkill = GetSkillLevel(spellSource,"MagerySkill")
	if(spellName == "Heal") then
		healAmount = (magicSkill / 7.5) + (math.floor(math.random(1, 3) + 0.5))
	elseif(spellName == "Greaterheal") then
		healAmount = (magicSkill * 0.4) + (math.floor(math.random(1, 10) + 0.5))
	else
		-- DebugMessage("Unknown healing spell "..spellName)
		return 0
	end
	--round to nearest int
	healAmount = math.floor(healAmount + 0.5)

	return healAmount * 4
end

function IsInSpellRange(spellName, spellTarget, spellSource)
	Verbose("Magic", "IsInSpellRange", spellName, spellTarget, spellSource)
	local myLoc = this:GetLoc()

	local topmostObj = spellTarget:TopmostContainer() or spellTarget
	local theirLoc = topmostObj:GetLoc()

	local bodyOffset = GetBodySize(this) or ServerSettings.Combat.DefaultBodySize
	local theirOffset = GetBodySize(spellTarget) or ServerSettings.Combat.DefaultBodySize

	local dist = theirLoc:Distance(myLoc) 
	local spellRange = GetSpellInformation(spellName, "SpellRange") 
	if (spellRange == nil) then spellRange = DEFAULT_SPELL_RANGE end
	if((spellRange + bodyOffset + theirOffset) >= dist) then return true end
	return false
end

function IsLocInSpellRange(spellName, targetLoc, spellSource)
	Verbose("Magic", "IsLocInSpellRange", spellName, targetLoc, spellSource)
	local myLoc = this:GetLoc()
	local theirLoc = targetLoc
	local dist = theirLoc:Distance(myLoc) 
	local spellRange = GetSpellInformation(spellName, "SpellRange") 
	if (spellRange == nil) then spellRange = DEFAULT_SPELL_RANGE end
	if((spellRange) >= dist) then return true end
	return false

end

function LineOfSightCheck(spellName, spellTarget)
	Verbose("Magic", "LineOfSightCheck", spellName, spellTarget)
	local reqLOS = GetSpellInformation(spellName, "requireLineOfSight") 
	local targetType = GetSpellInformation(spellName,"TargetType")
	if( reqLOS ~= nil and reqLOS ) then
		if(targetType == "targetObject" or targetType == "targetMobile") then
			local topmostObj = spellTarget
			if(targetType == "targetObject") then
				topmostObj = spellTarget:TopmostContainer() or spellTarget
			end
			
			if( not(this:HasLineOfSightToObj(topmostObj,ServerSettings.Combat.LOSEyeLevel)) ) then
				return false
			end
		elseif( targetType == "targetLocation" and not(this:HasLineOfSightToLoc(spellTarget,ServerSettings.Combat.LOSEyeLevel)) ) then
			return false
		end
	end

	return true
end

function TargetDeadCheck(spellName, spellTarget)
	Verbose("Magic", "TargetDeadCheck", spellName, spellTarget)
	local mustBeDead = GetSpellInformation(spellName, "TargetMustBeDead") 
	local mustBeAlive = GetSpellInformation(spellName, "TargetMustBeAlive")
	if (mustBeDead) then
		if (not IsDead(spellTarget)) then
			return false
		end
	end
	if (mustBeAlive) then
		if (IsDead(spellTarget)) then
			return false
		end
	end
	return true
end

function PerformSpellHeal(spellName, spellTarget, spellSource)
	Verbose("Magic", "PerformSpellHeal", spellName, spellTarget, spellSource)
	if ( spellSource == nil ) then spellSource = this end
	if ( IsDead(spellTarget) ) then
		spellSource:SystemMessage("Your spell fails to stir the corpse.", "info")
		return
	end

	if ( HasMobileEffect(spellTarget, "MortalStruck") ) then
		this:SystemMessage("Your magic seems to have no effect.", "info")
		return false
	end

	local healAmount = GetSpellHealAmount(spellName, spellSource)
	-- variance
	healAmount = randomGaussian(healAmount, healAmount * 0.20)
	spellTarget:SendMessage("HealRequest", healAmount, this)
	
	if ( HasMobileEffect(this, "Empower") ) then
		local effects = this:GetObjVar("MobileEffects")
		if ( effects and effects.Empower and effects.Empower[2] and effects.Empower[2].Modifier ) then
			spellTarget:SendMessage("StartMobileEffect", "EmpowerAoE", this, {Heal=(healAmount * effects.Empower[2].Modifier)})
		end
	end

	return
end

function CanMoveWhileCasting(spellName)
	local myRet = GetSpellInformation(spellName, "CanMoveWhileCasting")
	if (myRet == true) then return true end
	return false
end

function IsSpellEnabled(spellName, spellSourceObj)
	if ( not SpellData.AllSpells[spellName] or not SpellData.AllSpells[spellName].SpellEnabled ) then
		if ( spellSourceObj and IsPlayerCharacter(spellSourceObj) ) then
			spellSourceObj:SystemMessage("Use of "..spellName.." is disabled.", "info")
		end
		return false
	end
	return true
end

--Casting Activity

function DoUnequip(equipObject,equippedOn,user)
	if( equippedOn == nil ) then
		LuaDebugCallStack("nil equippedOn provided.")
	end
	if( user == nil ) then user = equippedOn end

	-- check valid object
	if( equipObject ~= nil and equipObject:IsValid() ) then
		local equipSlot = GetEquipSlot(equipObject)
		-- check it is equipped in that slot
		if(equipSlot ~= nil and equippedOn:GetEquippedObject(equipSlot) == equipObject) then
			local backpackObj = equippedOn:GetEquippedObject("Backpack")
			-- make sure we have a backpack
			if( backpackObj ~= nil) then				
   				local randomLoc = GetRandomDropPosition(backpackObj)
   				-- try to put the object in the container
   				if(TryPutObjectInContainer(equipObject, backpackObj, randomLoc)) then
   					equipObject:SendMessage("WasUnequipped", equippedOn)
				end
			end
		end
	end
end




function HandleSpellCastCommand(spellName, spellTargetObj, spellSourceObj)
	Verbose("Magic", "HandleSpellCastCommand", spellName, spellTargetObj, spellSourceObj)
	local spellTarget = nil
	local spellSource = this 
	if(spellSourceObj ~= nil) then
		local spellSourceReq = GameObj(tonumber(spellSourceObj))
		if(not spellSourceReq:IsValid()) then spellSource = this end
		if(spellSourceReq:TopmostContainer() == this) or (spellSourceReq:GetObjVar("controller") == this) then
			spellSource = spellSourceReq
		else
			this:SystemMessage("Invalid spell source: Reverting to self.")
		end
	end
	if(spellTargetObj ~= nil) then
		spellTarget = GameObj(tonumber(spellTargetObj))
	end

	mAutoTarg = nil

	mScrollObj = nil

	CastSpell(spellName, spellSource, spellTarget)
end

function HandleScrollCastRequest(spellName, scrollObj)
	Verbose("Magic", "HandleScrollCastRequest", spellName, scrollObj)
	if(spellName == nil or scrollObj == nil) then return end

	mScrollObj = scrollObj
	CastSpell(spellName, this)
end

function HandleSpellCastRequest(spellName,spellSource,preDefTarg,targetLoc)
	Verbose("Magic", "HandleSpellCastRequest", spellName,spellSource,preDefTarg,targetLoc)
	if(spellName == nil) then return end
	if(spellSource == nil) then spellSource = this end

	if not(preDefTarg == nil) and not (preDefTarg:IsValid()) and targetLoc == nil then
		--DebugMessage("Error targetloc is nil and no target")
		preDefTarg = nil
		return
	end
	if (spellSource:IsPlayer()) then
		CastSpell(spellName, spellSource, preDefTarg)
	elseif (spellSource:HasLineOfSightToObj(preDefTarg)) then
		spellSource:SendMessage("RequestMagicalAttack", spellName,preDefTarg,spellSource,false,true)
	end
end

function CastSpell(spellName, spellSource, spellTarget)
	DebugMessage(tostring(spellName .. " ~ "))
	Verbose("Magic", "CastSpell", spellName, spellSource, spellTarget)
	if  not( IsSpellEnabled(spellName, spellSource) ) then return end
	local player = spellSource:IsPlayer()

	if( spellTarget ~= nil ) then
		local targetType = GetSpellInformation(spellName,"TargetType")
		if(targetType == "targetMobile" and not(spellTarget:IsMobile())) then
			return
		end
	end

	if not( HasSpell(spellName, this, mScrollObj) ) then
		if ( player ) then
			spellSource:SystemMessage("You do not have that spell.", "info")
		end
		return
	end

	if( IsDead(spellSource) ) then
		if ( player ) then
			spellSource:SystemMessage("OooOoOOooOOoOoOooooO", "info")
		end
		return
	end

	if( IsAsleep(spellSource) ) then
		if ( player ) then
			spellSource:SystemMessage("ZZZzzzz....", "info")
		end
		return
	end

	-- put us into combat
	if(IsAttackTypeSpell(spellName)) then
		BeginCombat()
	end

	mCurSpell = nil
	--mPrimedSpell = nil
	mQueuedTarget = nil
	mQueuedTargetLoc = nil

	mCurSpell = spellName
	if(spellTarget ~= nil) then mQueuedTarget = spellTarget end
	local myTarget = GetSpellInformation(spellName, "TargetType");
	if ((myTarget == "Self") or (myTarget == "LeftHand") or (myTarget == "RightHand")) then
		PrimeSpell(spellName, spellSource)
		return;
	end

	mSpellName = spellName;
	mSpellSource = spellSource;
	
	local myTargType = GetSpellTargetType(spellName)

	if(myTargType == "RequestTarget") or (myTargType == "RequestLocation") then
		-- DebugMessage(spellName)
		RequestSpellTarget(spellName)
	end
end

function RequestSpellTarget(spellName)
	Verbose("Magic", "RequestSpellTarget", spellName)
	if (this:IsPlayer()) then
		local myTargType = GetSpellTargetType(spellName)
		local spellDisplayName = SpellData.AllSpells[spellName].SpellDisplayName or spellName
		-- DebugMessage("Target Type Set to " .. tostring(myTargType))
		if (myTargType == "RequestTarget") and (mQueuedTarget == nil) then
				this:RequestClientTargetGameObj(this, "QueueSpellTarget")
			return
		end
		if(myTargType == "RequestLocation") then
				this:RequestClientTargetLoc(this, "QueueSpellLoc")
			return
		end
	else
		return
	end
end

function HandleSuccessfulSpellPrime(spellName, spellSource, free)
	Verbose("Magic", "HandleSuccessfulSpellPrime", spellName, spellSource, free)


	if ( SpellData.AllSpells[spellName].PreventTownCast == true and GetGuardProtection(this) == "Town" ) then
		this:SystemMessage("Cannot cast that spell in town.", "info")
		CancelSpellCast()
		return
	end

	mFreeSpell = false
	if ( free == true ) then
		mFreeSpell = true
	end
	
	local _spellTarget;
    if (mQueuedTarget ~= nil) then
        _spellTarget = mQueuedTarget;
    end

    if (mQueuedTargetLoc == nil) then
        if (not ValidateSpellCastTarget(spellName,_spellTarget,this)) then        
            CancelSpellCast();
			return
        end
    end
	
	this:PlayAnimation("idle")	
	this:DelObjVar("LastSpell")
	if (spellName == nil) then spellName = mCurSpell end
	if (spellName == nil) then LuaDebugCallStack("NIL SPELL") end

	local spellDisplayName = SpellData.AllSpells[spellName].SpellDisplayName or spellName
	mCastingDisplayName = spellName
	mSpellSource = spellSource or this
	mCurSpell = nil

	mSpellSource:SendMessage("BreakInvisEffect", "Action")

	--Trying it off
	--this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500), "SpellGlobalCooldownTimer")

	local myTargType = GetSpellTargetType(spellName)
	--DebugMessage("Target Type Set to " .. tostring(myTargType))

	if (myTargType == "RequestTarget") then
		-- disallow 'utility' spells
		if ( SpellData.AllSpells[spellName].SpellType ~= "BuffTypeSpell" ) then
			-- Handle chambering spells
			-- can't check for HasMobileEffect for SpellChamber since it works through stacking.
			local spellChamberLevel = spellSource:GetObjVar("SpellChamberLevel")
			if ( spellChamberLevel ~= nil and (SpellData.AllSpells[spellName].Circle or 8) <= spellChamberLevel ) then
				if not( CheckMana(spellName, spellSource) ) then 
					return
				end

				if not ( CheckReagents(spellName, spellSource, mScrollObj) ) then
					return
				end

				if not( CheckSpellCastSuccess(spellName, spellSource, mScrollObj) ) then
					return
				end

				spellSource:SendMessage("ChamberSpell", spellName, spellDisplayName)
				CancelSpellCast()
				return
			end
		end

		mPrimedSpell = spellName
		
		if not(this:IsPlayer()) then 
			if(mAutoTarg == nil) then return end
			--DebugMessage("FiringSpell: " ..spellName .. " at " .. mAutoTarg:GetName())
			HandleSpellTargeted(mAutoTarg)
			mAutoTarg = nil
		else
			if(mQueuedTarget ~= nil) then 
				HandleSpellTargeted(mQueuedTarget)
				mQueuedTarget = nil
			else
				-- this:RequestClientTargetGameObj(this, "SelectSpellTarget")
			end
		end
	elseif(myTargType == "RequestLocation") then
		mPrimedSpell = spellName
		if(mQueuedTargetLoc ~= nil) then
			HandleSpellLocTargeted(true, mQueuedTargetLoc)
			mQueuedTargetLoc = nil
		else
			local spellDisplayName = SpellData.AllSpells[spellName].SpellDisplayName
			this:SystemMessage("Select Location for " .. spellDisplayName)
			this:RequestClientTargetLoc(this, "SelectSpellLoc")
		end
	else
		mPrimedSpell = nil

		if not ( CheckMana(spellName, spellSource) ) then
			return
		end

		if not ( CheckReagents(spellName, spellSource, mScrollObj) ) then
			return
		end

		if not( CheckSpellCastSuccess(spellName, spellSource, mScrollObj) ) then
			return
		end

		mScrollObj = nil

		local manaCost = GetManaCost(spellName)
		AdjustCurMana(spellSource,-manaCost)
		ApplySpellCompletionEffects(spellName, myTarg, mSpellSource)	
		mSpellSource = nil		
	end
	
	if( mPrimedSpell ~= nil ) then
		if( this:IsPlayer() ) then
			local spellRange = GetSpellInformation(spellName, "SpellRange") or 0

			-- DAB TODO: If it is area effect, send the area effect radius
			clientInfo = {
				spellName,
				myTargType,
				spellRange 
			}
			--DebugMessage(" Vect7: " .. tostring(clientInfo[1]) .. " " .. tostring(clientInfo[2]) .. " " .. tostring(clientInfo[3]))

			this:SendClientMessage("SpellPrimed",clientInfo)
		end

		local primedFX = GetSpellInformation(spellName, "SpellPrimedFXName") 	
		if( primedFX ~= nil ) then
			local mySpEffectArgs = GetSpellInformation(spellName, "SpellPrimedFXArgs")
		    --D*ebugMessage("CFX: " ..tostring(primedFX) .. " " .. this:GetName())
			if(mySpEffectArgs) then
				this:PlayEffectWithArgs(primedFX,60,mySpEffectArgs)
			else
				this:PlayEffect(primedFX,60)--,"Bone=Ground")
			end	
		end
		local primedFX2 = GetSpellInformation(spellName, "SpellPrimedFX2Name") 	
		if( primedFX2 ~= nil ) then
			local mySpEffectArgs2 = GetSpellInformation(spellName, "SpellPrimedFX2Args")
			--D*ebugMessage("CFX: " ..tostring(primedFX2) .. " " .. this:GetName())
			if(mySpEffectArgs2) then
				this:PlayEffectWithArgs(primedFX2,60,mySpEffectArgs2)
			else
				this:PlayEffect(primedFX2,60)--,"Bone=Ground")
			end	
		end
	end
end

-- FIZZLE

function DoFizzle(mobileObj)
    mobileObj:NpcSpeech("*fizzle*", "combat")
    mobileObj:PlayObjectSound("event:/animals/worm/worm_pain",false)
    if ( mobileObj:IsPlayer() ) then
        mobileObj:SystemMessage("Cast failed.", "info")
    end
end

function HandleSpellTargeted(spellTarget)
	Verbose("Magic", "HandleSpellTargeted", spellTarget)
	--DebugMessage("SpellTargeted")
	
	if mPrimedSpell == nil then return end
		--DebugMessage("[HandleScriptCommandTargetObject] ".. tostring(spellTarget))

	local spellName = mPrimedSpell
	--DebugMessage("Reloaded")
	if( spellTarget == nil ) then
		mPrimedSpell = nil
	elseif not(spellTarget:IsValid()) then
		mPrimedSpell = nil
	elseif (not ValidateSpellCastTarget(spellName,spellTarget,this)) then		
		this:RequestClientTargetGameObj(this, "SelectSpellTarget")
		return
	elseif not(this:HasTimer("SpellPrimeTimer")) then
		if not (mSpellSource:IsPlayer()) then 
			mSpellSource:SendMessage("SpellFired", spellTarget) 
		end
		SetSpellTravelTime(mPrimedSpell, spellTarget, mSpellSource)
		mPrimedSpell = nil
	else
		mPrimedSpell = nil
		this:SystemMessage("You are already casting.", "info")
		return
	end

	if( mPrimedSpell == nil ) then		
		if( this:IsPlayer() ) then
			this:SendClientMessage("ClearPrimed")
		end
			
		local primedFX = GetSpellInformation(spellName, "SpellPrimedFXName") 	
		if( primedFX ~= nil ) then
			this:StopEffect(primedFX)
		end

		if(spellTarget ~= this and spellTarget ~= nil) then this:SetFacing(this:GetLoc():YAngleTo(spellTarget:GetLoc())) end
	end
end
				

function HandleSpellLocTargeted(success, targetLoc)
	Verbose("Magic", "HandleSpellLocTargeted", success, targetLoc)
	--DebugMessage("Loc Targeted")
	if mPrimedSpell == nil then DebugMessage("mPrimedSpell is nil") return end

	local spellName = mPrimedSpell

		--DebugMessage("[HandleScriptCommandTargetObject] ".. tostring(spellTarget))
	if not(success) then
		mPrimedSpell = nil
		--DebugMessageA(this,"target cleared")
	elseif not(IsLocInSpellRange(mPrimedSpell, targetLoc, mSpellSource)) then
		this:SystemMessage("Not in range.", "info")
		this:RequestClientTargetLoc(this, "SelectSpellLoc")
		--DebugMessageA(this,"not in range")
		return
	elseif not(LineOfSightCheck(mPrimedSpell, targetLoc)) then
		this:SendMessage("CannotSeeTarget", spellTarget) 
		--DebugMessageA(this,"Can't see target")
		this:RequestClientTargetLoc(this, "SelectSpellLoc")
	elseif not(this:HasTimer("SpellPrimeTimer")) then
		PerformSpellLocationActions(mPrimedSpell, this,  targetLoc, mSpellSource)
		--DebugMessageA(this,"No spell prime timer")
		mSpellSource = nil
		mPrimedSpell = nil
	else
		mPrimedSpell = nil
		mSpellSource = nil
		--DebugMessageA(this,"already casting")
		this:SystemMessage("Already casting.", "info")
		return
	end
	--DebugMessage("Reached end")
	if( mPrimedSpell == nil ) then		
		if( this:IsPlayer() ) then
			this:SendClientMessage("ClearPrimed")
		end
			
		local primedFX = GetSpellInformation(spellName, "SpellPrimedFXName") 	
		if( primedFX ~= nil ) then
			this:StopEffect(primedFX)
		end
		if(targetLoc ~= this:GetLoc() and targetLoc ~= nil) then this:SetFacing(this:GetLoc():YAngleTo(targetLoc)) end
	end
end

function HandleSpellTravelled(spellName, spTarget, spellSource, spellID)
	Verbose("Magic", "HandleSpellTravelled", spellName, spTarget, spellSource, spellID)
	if(spellSource == nil) then spellSource = this end
	if(IsHitTypeSpell(spellName)) then
		local overrideTarg = GetSpellInformation(spellName, "DoNotReplaceTarget")
		if (overrideTarg == nil) then overrideTarg = false end					
			this:SendMessage("RequestMagicalAttack", spellName,spTarget,spellSource,overrideTarg,true)
			--DebugMessage(" Vect2: " .. tostring(mySend[1]) .. " " .. tostring(mySend[2]) .. " " .. tostring(mySend[3]) .. " " .. tostring(mySend[4]))
	else
		ApplySpellEffects(spellName, spTarget, spellSource)
	end 
	
end

function CancelCurrentSpellEffects()
	if (mPrimedSpell ~= nil) then
		local primedFX = GetSpellInformation(mPrimedSpell, "SpellPrimedFXName") 	
		if( primedFX ~= nil ) then
		--DebugMessage("RemovingEffect")
			this:StopEffect(primedFX)
		end
		local primedFX2 = GetSpellInformation(mPrimedSpell, "SpellPrimedFX2Name") 	
		if( primedFX2 ~= nil ) then
		--DebugMessage("RemovingEffect")
			this:StopEffect(primedFX2)
		end
	end
end

function CancelSpellCast()
	Verbose("Magic", "CancelSpellCast")

	if ( this:HasTimer("CastFreezeTimer") ) then
		this:FireTimer("CastFreezeTimer")
	end
	--DebugMessage("MagicDeathCleanup")
	CancelCurrentSpellEffects()
	
	if(this:GetTimerDelay("SpellPrimeTimer") ~= nil) then
		--DebugMessage("Removing Timer")
		this:RemoveTimer("SpellPrimeTimer")
	end
	if ( IsPlayerCharacter(this) ) then
		this:SendClientMessage("CancelSpellCast")
	 	if ( this:HasObjVar("LastSpell") ) then
			ProgressBar.Cancel("Casting " ..this:GetObjVar("LastSpell"),this)
		end
	end
	mCastingDisplayName = ""
	mCurSpell = nil
	mPrimedSpell = nil

	this:PlayAnimation("idle")
	DoFizzle(this);
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "QueueSpellTarget", 
	function(target)
		if(target == nil) then return end
		if(target:IsValid()) then
			mQueuedTarget = target
			PrimeSpell(mSpellName, mSpellSource);
		end

		end)
RegisterEventHandler(EventType.ClientTargetLocResponse, "QueueSpellLoc", 
	function(success,targetLoc)
			if(success) then
				mQueuedTargetLoc = targetLoc
				PrimeSpell(mSpellName, mSpellSource);
			else
				mQueuedTargetLoc = nil
			end
	
	end)

RegisterEventHandler(EventType.Message, "ScrollCastSpell", HandleScrollCastRequest)
RegisterEventHandler(EventType.ClientUserCommand, "cancelspellcast", CancelSpellCast)
RegisterEventHandler(EventType.Message, "CastSpellMessage", HandleSpellCastRequest)
RegisterEventHandler(EventType.ClientUserCommand, "sp", HandleSpellCastCommand)
RegisterEventHandler(EventType.ClientTargetGameObjResponse, "SelectSpellTarget", HandleSpellTargeted)
RegisterEventHandler(EventType.ClientTargetLocResponse, "SelectSpellLoc", HandleSpellLocTargeted)
RegisterEventHandler(EventType.Timer, "SpellPrimeTimer", HandleSuccessfulSpellPrime)
RegisterEventHandler(EventType.Message, "HasDiedMessage", CancelSpellCast)
RegisterEventHandler(EventType.Message, "CancelSpellCast", CancelSpellCast)