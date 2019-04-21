mSkipAddCombatModule = true -- prevent base_mobile from attaching combat module
require 'base_mobile'
require 'combat'
require 'loop_effect'
-- require 'base_pet_casting'



_MyOwner = nil
-- if this is true, we need to clear path before setting new one
_IsPathing = false
-- refrence to gameobj that is being followed by this pet.
_IsFollowing = nil
-- who was being followed last?
_WasFollowing = nil
-- refrence to gameobj that pet is attacking, if any
_IsAttacking = nil


SetCurVitality(this,GetMaxVitality(this))

function CleanUpModule()
	this:SetObjectOwner(nil)
	this:SetSharedObjectProperty("Title", "Released Pet")
	RemoveTooltipEntry(this, "PetOwner", "Released Pet")
	
	local livingName = this:GetObjVar("LivingName")
	if ( livingName ) then
		this:SetName(livingName)
	end
	this:SetObjVar("WasTamed", true)

	this:StopMoving()

	this:AddModule("ai_prey")
	this:AddModule("released_pet")

	-- delete variables no longer needed
	this:DelObjVar("controller")
	this:DelObjVar("NoReset")
	this:DelObjVar("MobileTeamType")
	this:DelObjVar("CommandName")
	this:DelObjVar("TamingDifficulty") -- no longer tamable
	this:DelObjVar("Karma")

	Decay(this)

	this:SendMessage("UpdateName")
	this:DelModule("pet_controller")
end

function CheckOwner(newOwner)
	Verbose("PetController", "CheckOwner")
	if ( IsDead(this) ) then return end
	-- if setting new owner
	if ( newOwner ~= nil ) then
		UpdatePreviousOwners(newOwner)
		-- we have to also set the controller objvar so we can check when they are dead and we've removed object owner.
		this:SetObjVar("controller",newOwner)
		this:SetObjectOwner(newOwner)
		_MyOwner = newOwner
        local ownerTitle = StripColorFromString(_MyOwner:GetName()).."'s Pet"
		this:SetSharedObjectProperty("Title", ownerTitle)
		SetTooltipEntry(this, "PetOwner", ownerTitle)
		SyncPetToOwner(_MyOwner, this)
		UserPetCommand("follow", _MyOwner)
	else
	-- otherwise reading current owner.
		local wasNil = ( _MyOwner == nil )
		_MyOwner = this:GetObjectOwner()
		if ( not _MyOwner or not _MyOwner:IsValid() ) then
			local controller = this:GetObjVar("controller")
			if ( controller and controller:IsValid() ) then
				this:SetObjectOwner(controller)
				_MyOwner = controller
			end
		end
		-- forced pet sync on a first load.
		if ( wasNil and _MyOwner ) then
			SyncPetToOwner(_MyOwner, this)
		end
	end

	if ( _MyOwner == nil ) then
		Verbose("PetController", "CheckOwner:False")
		return false
	end

	return true
end

function UpdatePreviousOwners(newOwner)
	Verbose("PetController", "UpdatePreviousOwners")
	local previousOwners = this:GetObjVar("PreviousOwners") or {}
	for i,id in pairs(previousOwners) do
		if ( id == newOwner.Id ) then
			return -- tamer already exists in list as previous owner, no need to continue.
		end
	end
	table.insert(previousOwners, newOwner.Id)
	this:SetObjVar("PreviousOwners", previousOwners)
end

function ClearState(skipCombat)
	if ( _IsFollowing ) then
		_WasFollowing = _IsFollowing
		_IsFollowing = nil
	end
	if ( skipCombat ~= true and _IsAttacking ) then
		_IsAttacking = nil
		SetCurrentTarget(nil)
		SetInCombat(false, true)
	end
	ClearPath()
end

function ClearPath()
	if ( _IsPathing ) then
		this:ClearPathTarget()
		_IsPathing = false
	end
end

function Follow(target)
	ClearState()
	_IsFollowing = target
	UpdateFollow()
end

function UpdateFollow()
	if not( _IsFollowing ) then return end
	if ( not _IsFollowing:IsValid() or IsDead(_IsFollowing) ) then
		ClearState()
		return
	end
	if ( IsMounted(_IsFollowing) ) then
		-- go mount speed
		PathToTarget(
			_IsFollowing,
			ServerSettings.Pets.Follow.Distance,
			ServerSettings.Pets.Follow.Speed.Mounted
		)
	else
		PathToTarget(
			_IsFollowing,
			ServerSettings.Pets.Follow.Distance,
			ServerSettings.Pets.Follow.Speed.OnFoot
		)
	end
end

RegisterEventHandler(EventType.Message, "UpdateFollow", UpdateFollow)

function ValidCombatPetTarget(target)
	if not( _MyOwner ) then return false end
	return (
		ShouldSeeCloakedObject(this, target)
		and 
		ValidCombatTarget(_MyOwner, target)
	)
end

function Attack(target, force)
	Verbose("Pet", "Attack", target)
	if ( TooFarFromOwner() or not ValidCombatPetTarget(target) ) then return end
	-- if we currently don't have an attack target
	if ( force == true or (not _IsFollowing and (not _IsAttacking or not _IsAttacking:IsValid())) ) then
		ClearState(true)
		_IsAttacking = target
		mInCombatState = true
		SetCurrentTarget(target)
		-- follow the thing we are attacking
		PathToTarget(
			target,
			GetCombatRange(this, target),
			ServerSettings.Pets.Combat.Speed
		)
	end
end

RegisterEventHandler(EventType.Timer, GetSwingTimerName("RightHand"), function()
	if ( _IsAttacking and (TooFarFromOwner() or not ValidCombatPetTarget(_IsAttacking)) ) then
		ClearTarget()
	end
end)

function ClearTarget()
	if ( _WasFollowing ) then
		Follow(_WasFollowing)
		_WasFollowing = nil
	else
		Stay()
	end
end
-- OverrideEventHandler("combat", EventType.Message, "ClearTarget", ClearTarget)

function PathToTarget(target, distance, speed)
	ClearPath()
	if not ( target ) then return end
	this:PathToTarget(target, distance, speed)
	_IsPathing = true
end

function PathToLoc(target, speed)
	ClearPath()
	if not ( target ) then return end
	this:PathTo(target, speed)
	_IsPathing = true
end

function Stay()
	Verbose("PetController", "Stay")
	ClearState()
	this:StopMoving()
	_WasFollowing = nil
end

function Idle()
	Verbose("PetController", "Idle")
	ClearState()
	this:StopMoving()
	ClearGuarding()
	--TODO: make them 'wander'
end

if(initializer ~= nil) then
	for i,behaviorName in pairs(this:GetAllModules()) do
		if(behaviorName:match("ai")) then
			this:DelModule(behaviorName)
		end
		
		if(behaviorName:match("spawn_decay")) then
			this:DelModule(behaviorName)
		end
	end
end

if IsMount(this) then
	if not( this:IsEquipped() ) then		
		AddUseCase(this, "Mount", true, "IsController")
	end
end

AddUseCase(this, "Release", false, "IsController")
AddUseCase(this, "Rename", false, "IsController")
AddUseCase(this, "Transfer", false, "IsController")

if not( IsStabled(this) ) then
	CheckOwner()
	CallFunctionDelayed(TimeSpan.FromSeconds(1), function()
		UserPetCommand("follow", _MyOwner)
		-- re-establish guarding on a login/region transfer
		local wasGuarding = this:GetObjVar("Guarding")
		if ( wasGuarding ~= nil and wasGuarding:IsValid() ) then
			if not( wasGuarding:HasModule("pet_guard") ) then
				wasGuarding:AddModule("pet_guard")
			end
			wasGuarding:SendMessage("AddGuardPet", this)
		else
			this:DelObjVar("Guarding")
		end
	end)
end

function ConfirmRelease(player)
	ClientDialog.Show{
		TargetUser = player,
		ResponseObj = this,
		DialogId = "PetReleaseDialog",
		TitleStr = "Release your pet?",
		DescStr = "This pet will not be tamable, by anyone, once released.\n\nRelease "..this:GetName().."?",
		Button1Str = "Ok.",
		Button2Str = "Cancel."
	}
end

RegisterEventHandler(EventType.DynamicWindowResponse, "PetReleaseDialog", function(user,buttonId)
	local buttonId = tonumber(buttonId)
	if (user == nil) then return end
	if (buttonId == nil) then return end
	if ( buttonId == 0 ) then
		ReleaseSelf()
	end
end)

function ConfirmRename(player)
	TextFieldDialog.Show{
        TargetUser = player,
        ResponseObj = this,
        Title = "Rename your pet?",
        DialogId = "PetRenameDialog",
        Description = "Enter your pet's new name.",
        ResponseFunc = function(user,newName)
        	if (user == nil or user ~= player) then return end
        	if(newName == nil or newName == "") then return end
			-- dont allow colors
			newName = StripColorFromString(newName)
			
			local valid, error = ValidatePlayerInput(newName, 3, 15)
			if not( valid ) then
				user:SystemMessage("Pet names "..error, "info")
				return
			end

		   	UpdatePetName(this, newName, ColorizeMobileName(this,newName))
		end
    }
end

function ReleaseSelf()
	CleanUpModule()
end


----------------------------------------------------------------------------------------


function StableSelf()
	Verbose("PetController", "StableSelf")
	if ( CheckOwner() ) then
		local tempPack = _MyOwner:GetEquippedObject("TempPack")
		if ( tempPack ~= nil ) then
			ClearState()
			this:MoveToContainer(tempPack,Loc(0,0,0))
		end
	end
end

function UnStableSelf()
	-- should be in temp pack.
	local topMost = this:TopmostContainer()
	if ( topMost == nil ) then return end -- can't unstable, already in the world!

	this:SetWorldPosition(topMost:GetLoc())

	if ( CheckOwner() ) then
		UserPetCommand("follow", _MyOwner)
	end
end

RegisterEventHandler(EventType.Message, "Stable", StableSelf)
RegisterEventHandler(EventType.Message, "Unstable", UnStableSelf)

RegisterEventHandler(EventType.Message, "SetPetOwner", CheckOwner)

RegisterEventHandler(EventType.Message, "OnResurrect", function()
	if(this:DecayScheduled()) then this:RemoveDecay() end
	if(this:HasModule("decay")) then this:DelModule("decay") end
	CheckOwner()
	if (_MyOwner == nil) then
		DebugMessage("[pet_controller] ERROR: "..this:GetName().." with id of "..this.Id.." has no controller.")
		return
	end
	SyncPetToOwner(_MyOwner, this)
	UserPetCommand("follow", _MyOwner)
end)

function TooFarFromOwner()
	if ( _MyOwner == nil or not _MyOwner:IsValid() ) then return true end
		
	return (this:GetLoc():Distance(_MyOwner:GetLoc()) > ServerSettings.Pets.Command.Distance)
end

function UserPetCommand(cmdName, target, forceAccept)
	Verbose("PetController", "UserPetCommand", cmdName)

	if( IsStabled(this) and cmdName ~= "unstable" ) then
		return 
	end

	CheckOwner()

	if not ( _MyOwner ) then
		Verbose("PetController", "UserPetCommand:ReturnNoMyOwner")
		CheckOwner()
		return
	end

	-- prevent ghosts from commanding pets
	if ( IsDead(_MyOwner) ) then
		Verbose("PetController", "UserPetCommand:ReturnDeadOwner")
		return
	end

	if ( TooFarFromOwner() and (this:ContainedBy() == nil) ) then
		_MyOwner:SystemMessage("Too far away to command "..StripColorFromString(this:GetName())..".","info")
		return
	end

	if ( cmdName == "release" ) then
		if ( target == this ) then
			ConfirmRelease(_MyOwner)
		end
		return
	end

	if ( cmdName == "aggressive" ) then
		SetPetStance(this, PetStance.Aggressive)
		return
	end

	if ( cmdName == "passive" ) then
		SetPetStance(this, PetStance.Passive)
		return
	end

	if ( forceAccept ~= true and this:HasTimer("IgnoringCommandsTimer") ) then
		_MyOwner:SystemMessage(this:GetName().." is ignoring you.", "info")
		return
	end

	if ( forceAccept ~= true and not CheckControlSuccess(_MyOwner, this) ) then
		Stay()
		_MyOwner:SystemMessage(this:GetName().." refuses to "..cmdName..".")
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(math.random(1, 6)), "IgnoringCommandsTimer")
		return
	end

	if ( cmdName == "guard" ) then
		if ( target ~= nil ) then
			Guard(target)
		end
		return
	end

	if ( cmdName == "attack" or cmdName == "autoattack" ) then
		if ( target ~= nil ) then
			Attack(target, true) -- force the target
		end
		return
	end

	if ( cmdName == "follow" ) then
		if ( CheckOwner() and target ~= nil ) then
			Follow(target)
		end
		return
	end

	if ( cmdName == "stay" or cmdName == "go" ) then
		Stay()
		if ( cmdName == "go" ) then
			PathToLoc(target, ServerSettings.Pets.Combat.Speed)
		end
		return
	end

	if ( cmdName == "stop" ) then
		Idle()
		return
	end
end

function Guard(target)
	if ( target:IsValid() == false) then return end
	
	if ( target == this ) then return end
	if not( target:HasModule("pet_guard") ) then
		target:AddModule("pet_guard")
	end
	local wasGuarding = this:GetObjVar("Guarding")
	if ( wasGuarding ~= nil and wasGuarding:IsValid() ) then
		wasGuarding:SendMessage("RemoveGuardPet", this)
	end
	this:SetObjVar("Guarding", target)
	target:SendMessage("AddGuardPet", this)
	this:NpcSpeech("*guarding "..StripColorFromString(target:GetName()).."*")
end

function ClearGuarding()
	if ( this:HasObjVar("Guarding") ) then
		local guarding = this:GetObjVar("Guarding")
		if ( guarding:IsValid() ) then
			guarding:SendMessage("RemoveGuardPet", this)
		end
		this:DelObjVar("Guarding")
	end
end

local baseDoMobileDeath = DoMobileDeath
function DoMobileDeath(damager, damageSource)
	Stay()
	this:SetObjVar("controller", _MyOwner)
	this:SetObjectOwner(nil) -- prevent corpses from following cross regions
	-- freeze the Owner's current conflict table onto the pet corpse
	if ( _MyOwner and _MyOwner:IsValid() ) then
		FreezeConflictTable(_MyOwner, this)
	end
	baseDoMobileDeath(damager, damageSource)
end

RegisterEventHandler(EventType.Message, "UserPetCommand", UserPetCommand)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "TransferPetTarget",
	function (target,user)

		CheckOwner()

		if user ~= _MyOwner then 
			return
		end

		if not( CanBeTransferred(_MyOwner, this) ) then return end

		if ( not target or not target:IsValid() or not target:IsPlayer()) then
			user:SystemMessage("Invalid Target.", "info")
			return
		end

		--if ( target:IsPlayer() ) then
			-- make sure they can control the pet
			if not( CanControlCreature(target, this) ) then
				user:SystemMessage("They have no chance of controlling this pet.", "info")
				return
			end
			-- make sure the player has room to take this pet
			if ( GetPetSlots(this) > GetRemainingActivePetSlots(target) ) then
				user:SystemMessage("They cannot control anymore pets.", "info")
				return
			end
			-- transfer to the new owner.
			if ( CheckOwner(target) ) then
				ClearGuarding()
				target:SystemMessage(this:GetName() .. " now answers to you.", "info")
				user:SystemMessage(this:GetName() .. " has been transferred to "..target:GetName()..".", "info")
			end
		--end
	end)

RegisterEventHandler(EventType.Message, "Follow", function(target)
	UserPetCommand("follow", target)
end)

RegisterEventHandler(EventType.Message, "UseObject", function(user,usedType)
	if ( IsDead(this) or IsDead(user) ) then return end -- neither one can be dead to do anything further.

	CheckOwner()

	if user ~= _MyOwner then 
		return
	end

	if(usedType == "Mount") then
		if(GetEquipSlot(this) == "Mount" and (this:IsEquipped() or _MyOwner == user) ) then
			if (MountMobile(user,this) ~= false) then
				Stay()
			end
		end
		-- dismount is handled on the mobile that is mounted
	elseif ( usedType == "Release" ) then
		ConfirmRelease(user)
	elseif ( usedType == "Rename" ) then
		ConfirmRename(user)
	elseif ( usedType == "Transfer" ) then
		if ( CanBeTransferred(_MyOwner, this) ) then
			user:SystemMessage("Select new owner for "..this:GetName()..".", "info")
			user:RequestClientTargetGameObj(this, "TransferPetTarget")
		end
	elseif(usedType == "Dismiss") then
		ClearState()
		user:SendMessage("StartMobileEffect", "MountDismiss", this)
	end
end)

function CanBeTransferred(owner, pet)
	local backpack = pet:GetEquippedObject("Backpack")
	if ( backpack and #backpack:GetContainedObjects() > 0 ) then
		owner:SystemMessage("Cannot transfer pets with items on them.", "info")
		return false
	end
	return true
end

local HandleApplyDamage_base = HandleApplyDamage
function HandleApplyDamage(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected)
	HandleApplyDamage_base(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected)
	-- fight back
	Attack(damager)
end