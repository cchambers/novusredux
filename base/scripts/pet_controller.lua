require 'base_mobile'
require 'combat'

if ( this:HasModule("combat") ) then
	CallFunctionDelayed(TimeSpan.FromSeconds(0.1),function()
		this:DelModule("combat") end)
end

_MyOwner = nil
-- if this is true, we need to clear path before setting new one
_IsPathing = false
-- refrence to gameobj that is being followed by this pet.
_IsFollowing = nil
-- who was being followed last?
_WasFollowing = nil
-- refrence to gameobj that pet is attacking, if any
_IsAttacking = nil

function CheckOwner(newOwner)
	Verbose("PetController", "CheckOwner")
	if ( newOwner ~= nil ) then
		UpdatePreviousOwners(newOwner)
		this:SetObjectOwner(newOwner)
		SetKarma(this, GetKarma(newOwner))
		-- DAB: setting controller objvar for legacy support
		this:SetObjVar("controller",newOwner)
		_MyOwner = newOwner
        local ownerTitle = StripColorFromString(_MyOwner:GetName()).."'s Pet"
		this:SetSharedObjectProperty("Title", ownerTitle)
		SetTooltipEntry(this, "PetOwner", ownerTitle)
		UserPetCommand("follow", _MyOwner)
		this:SetSharedObjectProperty("DisplayName", ColorizePlayerName(_MyOwner, StripColorFromString(this:GetName())))
		this:SendMessage("UpdateName")
	else
		_MyOwner = this:GetObjectOwner()
	end

	if ( _MyOwner == nil ) then
		--CleanUpModule()
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

function ClearState()
	if ( _IsFollowing ) then
		_WasFollowing = _IsFollowing
		_IsFollowing = nil
	end
	if ( _IsAttacking ) then
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
	if ( not target or not target:IsValid() or IsDead(target) ) then
		return
	end
	ClearState()
	_IsFollowing = target
	UpdateFollow()
end

function UpdateFollow()
	if not( _IsFollowing ) then return end
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

function Attack(target)
	Verbose("Pet", "Attack", target)
	if ( not target or not target:IsValid() or IsDead(target) or not ValidCombatTarget(this, target) ) then
		return
	end
	-- already attacking
	if ( target == _IsAttacking ) then return end
	ClearState()
	mInCombatState = true
	SetCurrentTarget(target)
	-- follow the thing we are attacking
	PathToTarget(
		target,
		GetCombatRange(this, target),
		ServerSettings.Pets.Combat.Speed
	)
	_IsAttacking = target
end

RegisterEventHandler(EventType.Timer, GetSwingTimerName("RightHand"), function()
	if ( _IsAttacking ) then
		if (
			TooFarFromOwner()
			or
			not _IsAttacking:IsValid()
			or
			IsDead(_IsAttacking)
			or
			not ValidCombatTarget(this, _IsAttacking)
		) then
			if ( _WasFollowing ) then
				Follow(_WasFollowing)
				_WasFollowing = nil
			else
				Stay()
			end
		end
	end
end)

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

RegisterEventHandler(EventType.Message, "HasDiedMessage", function()
	Stay()
	this:SetObjVar("controller", this:GetObjectOwner())
	this:SetObjectOwner(nil)	
end)

if(initializer ~= nil) then
	aiList = {}
	for i,behaviorName in pairs(this:GetAllModules()) do
		if(behaviorName:match("ai")) then
			DebugMessage("Removing AI: " .. behaviorName)
			table.insert(aiList,behaviorName)
			this:DelModule(behaviorName)
		end
	end
	this:SetObjVar("StoredAI", aiList)
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
		DescStr = "Release, for now, will DESTROY your pet.\nRelease "..this:GetName().."?",
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
        	if (user == nil) then return end
        	if(newName == nil or newName == "") then return end
			-- dont allow colors
    		newName = StripColorFromString(newName)

	   		if (string.len(newName) < 3) then
				user:SystemMessage("Pet names must longer than 3 characters.", "info")
				return
			end

	   		if (string.len(newName) > 12) then
				user:SystemMessage("Pet names must be less than 15 characters.", "info")
				return
			end

			if(#newName:gsub("[%a ]","") ~= 0) then
				user:SystemMessage("Pet names may only contain letters and spaces", "info")
				return
			end

		   	if(ServerSettings.Misc.EnforceBadWordFilter and HasBadWords(newName)) then
		    	user:SystemMessage("Pet names may not contain any foul language. Sorry!", "info")
		    	return
		   	end

		   	UpdatePetName(this, newName, ColorizeMobileName(this,newName))
		end
    }
end

function ReleaseSelf()
	this:Destroy()
end

function CreatePetStatue()
	Verbose("PetController", "CreatePetStatue")
	local mountType = this:GetObjVar("MountType") or "Horse"
	local statueType = PetMountStatueTypes[mountType]
	RegisterSingleEventHandler(EventType.CreatedObject,"PetStatueCreation",
        function (success,objRef, petFrom)
           	if(success) and (petFrom == this) then
           	    objRef:SetObjVar("Worthless",true)
       	        objRef:SetName("A Pet Statue of " .. this:GetName())
       	        this:SetObjVar("PetStatue", objRef)
 				objRef:SetObjVar("PetTarget", this)
 				StatuifySelf()
			end
		end)
		
	CreateObjInBackpack(_MyOwner,statueType,"PetStatueCreation", this)  
end


----------------------------------------------------------------------------------------

-- ai helpers
function CleanUpModule()
	this:SetSharedObjectProperty("Title", "")

	this:StopMoving()
	this:SetObjVar("MobileTeamType", this:GetObjVar("OldMobileTeamType"))

	--this:SetObjVar("AI-ShouldAggro", false)
	-- TODO Put AI Settings back how they were

	-- TODO Put same ai back on animal they had before
	this:AddModule("ai_default_animal")

	-- delete variables no longer needed
	this:DelObjVar("NoReset")
	this:DelObjVar("CommandName")

	Decay(this)

	this:DelModule("pet_controller")
end

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

function StatuifySelf()
	Verbose("PetController", "StatuifySelf")
	if not( CanStatuify(this, _MyOwner) ) then return end
	if ( CheckOwner() ) then
		local controlStatue = this:GetObjVar("PetStatue")
		if(controlStatue == nil) or (not controlStatue:IsValid()) then
			 CreatePetStatue()
		else
			ClearState()
			local ownerPack = _MyOwner:GetEquippedObject("Backpack")
			local randomLoc = GetRandomDropPosition(ownerPack)
			controlStatue:MoveToContainer(ownerPack, randomLoc)
			this:MoveToContainer(controlStatue,Loc(0,0,0))
		end

	end
end

function UnStatuifySelf(user)
	if ( user == nil ) then return end
	local topMost = this:TopmostContainer()

	-- can't unstatuify, already in the world!
	if ( topMost == nil ) then return end

	-- must be on the user to unstatuify
	if ( topMost ~= user ) then
		user:SystemMessage("That must be in your possession.", "info")
		return
	end

	-- make sure they can control the pet
	if not( CanControlCreature(user, this) ) then
		user:SystemMessage("You have no chance of controlling this pet.", "info")
		return
	end
	-- make sure the player has room to take this pet
	if ( GetPetSlots(this) > GetRemainingActivePetSlots(user) ) then
		user:SystemMessage("You cannot control anymore pets.", "info")
		return
	end

	local controlStatue = this:GetObjVar("PetStatue")
	local tempPack = this:GetEquippedObject("TempPack")
	if( tempPack == nil ) then			
		RegisterSingleEventHandler(EventType.CreatedObject,"temppack_created",
			function (success,objRef)
				if not(success) then
					controlStatue:Destroy()
					this:DelObjVar("PetStatue")
				end
				objRef:SetSharedObjectProperty("Weight",-1)
				objRef:SetName("Internal Temp Pack")
				controlStatue:MoveToContainer(objRef,Loc(0,0,0))
			end)
		CreateEquippedObj("crate_empty", this, "temppack_created")
	else
		--If pet already unstatufied, it will not try to unstatufy it
		local findItem = FindItemInContainer(tempPack, function(item)
				return item == controlStatue
			end)
		if (findItem) then
			return
		end

		-- wait a frame (solves inf recursion of TopmostContainer)
		CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
			controlStatue:MoveToContainer(tempPack,Loc(0,0,0))
		end)
	end

	this:SetWorldPosition(user:GetLoc())
	this:SetObjectOwner(user)
	UserPetCommand("follow", user)
end


function UnStableSelf()
	-- should be in backpack.
	local topMost = this:TopmostContainer()
	if ( topMost == nil ) then return end -- can't unstable, already in the world!

	this:SetWorldPosition(topMost:GetLoc())
	this:SetObjectOwner(topMost)

	if ( CheckOwner() ) then
		UserPetCommand("follow", _MyOwner)
	end
end

RegisterEventHandler(EventType.Message, "Stable", StableSelf)
RegisterEventHandler(EventType.Message, "Unstable", UnStableSelf)

RegisterEventHandler(EventType.Message, "Statuify", StatuifySelf)
RegisterEventHandler(EventType.Message, "UnStatuify", UnStatuifySelf)

RegisterEventHandler(EventType.Message, "SetPetOwner", CheckOwner)

RegisterEventHandler(EventType.Message, "OnResurrect", function()
	this:SetObjectOwner(this:GetObjVar("controller"))
	local newName = StripFromString(this:GetName()," Corpse")
	this:SetName(ColorizePlayerName(_MyOwner, newName))
	if(this:DecayScheduled()) then this:RemoveDecay() end
	if(this:HasModule("decay")) then this:DelModule("decay") end
	CheckOwner()
	if (_MyOwner == nil) then
		DebugMessage("[pet_controller] ERROR: "..this:GetName().." with id of "..this.Id.." has no controller.")
		return
	end
	UserPetCommand("follow", _MyOwner)
end)

function TooFarFromOwner()
	if ( _MyOwner == nil or not _MyOwner:IsValid() ) then return true end
		
	return (this:GetLoc():Distance(_MyOwner:GetLoc()) > ServerSettings.Pets.Command.Distance)
end

function UserPetCommand(cmdName, target, forceAccept)
	Verbose("PetController", "UserPetCommand", cmdName)

	if( IsStabled(this) and cmdName ~= "unstable" ) then
		if ( _MyOwner ~= nil ) then -- really shouldn't warn users about this..
			_MyOwner:SystemMessage("[$2391]")	
		end
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
		_MyOwner:SystemMessage("Too far away to command pet.")
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
			Attack(target)
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

RegisterEventHandler(EventType.Message, "UserPetCommand", UserPetCommand)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "TransferPetTarget",
	function (target,user)

		CheckOwner()

		if user ~= _MyOwner then 
			return
		end

		if ( not target or not target:IsValid() ) then
			user:SystemMessage("Invalid Target.", "info")
			return
		end

		if ( target:IsPlayer() ) then
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
				user:SystemMessage(this:GetName() .. " has been transfered to "..target:GetName()..".", "info")
			end
		end
	end)

RegisterEventHandler(EventType.Message, "Follow", function(target)
	UserPetCommand("follow", target)
end)

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if ( IsDead(this) or IsDead(user) ) then return end -- neither one can be dead to do anything further.

		CheckOwner()

		if user ~= _MyOwner then 
			return
		end

		if(usedType == "Mount") then
			if(GetEquipSlot(this) == "Mount" and (this:IsEquipped() or this:GetObjectOwner() == user) ) then
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
			user:SystemMessage("Select new owner for "..this:GetName()..".", "info")
			user:RequestClientTargetGameObj(this, "TransferPetTarget")		
		elseif(usedType == "Dismiss") then
			if not( CanStatuify(this, user) ) then return end

			this:PlayEffect("CloakEffect")
			this:PlayObjectSound("Pain")
			CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function ( ... )
				StatuifySelf()
			end)
			
		end
	end)

function CanStatuify(pet, user)
	if(IsGod(user) or TestMortal(user)) then
		return true
	end

	if not(IsMount(pet)) then
		user:SystemMessage("You can only dismiss mounts.","info")
		return false
	end

	if(GetPetSlots(pet) > ServerSettings.Pets.MaxSlotsToAllowDismiss) then
		user:SystemMessage("This mount is too strong to dismiss.","info")
		return false
	end		

	if(IsPetCarryingItems(pet)) then
		user:SystemMessage("You can not dismiss a mount that is carrying something.","info")
		return false
	end

	return ValidateRangeWithError(5, user, pet, "Too far away.")
end

local HandleApplyDamage_base = HandleApplyDamage
function HandleApplyDamage(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected)
	HandleApplyDamage_base(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected)
	-- if we aren't already attacking anything
	if not( mInCombatState ) then
		-- fight back
		Attack(damager)
	end
end