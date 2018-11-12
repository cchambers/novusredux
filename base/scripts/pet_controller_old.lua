require 'incl_combatai'
require 'incl_regions'
require 'incl_skill_animalken'
--require 'base_ai_state_machine'
require 'base_ai_mob'

mMyOwner = nil

mCombatTarget = nil
mForcedTarget = nil
mForcedFollow = nil
-- last follow is used to cache who the pet was following before attacking, so when deciding idle state, we go back to the person we were following before the fight.
mLastFollow = nil
mLeaderMounted = false
mForcedStop = false

AI.Settings.AggroRange = 5.0
AI.Settings.ChaseRange = 8.0
AI.Settings.ChargeSpeed = ServerSettings.Pets.Combat.Speed
AI.Settings.ScaleToAge = true
AI.SetSetting("StationedLeash",false)
AI.SetSetting("Leash",false)

attackTarget = nil
-- ai helpers

function DecideIdleState()
	Verbose("PetController", "DecideIdleState")
    if (IsDead(this)) then AI.StateMachine.ChangeState("Dead") return end
    if not(AI.IsActive()) then return end
	if not( mForcedStop ) then
		if ( mForcedFollow or mLastFollow ) then
			UserPetCommand("follow", mForcedFollow or mLastFollow)
		end
	end
end

function IsFriend(target)
	return true
end

function CheckOwner(newOwner)
	Verbose("PetController", "CheckOwner")
	if ( newOwner ~= nil ) then
		UpdatePreviousOwners(newOwner)
		this:SetObjectOwner(newOwner)
		SetKarma(this, GetKarma(newOwner))
		-- DAB: setting controller objvar for legacy support
		this:SetObjVar("controller",newOwner)
		mMyOwner = newOwner
        local ownerTitle = StripColorFromString(mMyOwner:GetName()).."'s Pet"
		this:SetSharedObjectProperty("Title", ownerTitle)
		SetTooltipEntry(this,"PetOwner", ownerTitle)
		UserPetCommand("follow", mMyOwner)
		this:SetSharedObjectProperty("DisplayName", ColorizePlayerName(mMyOwner, StripColorFromString(this:GetName())))
		this:SendMessage("UpdateName")
	else
		mMyOwner = this:GetObjectOwner()
	end

	if ( mMyOwner == nil ) then
		--CleanUpModule()
		Verbose("PetController", "CheckOwner:False1")
		return false
	end

	if not ( mMyOwner:IsValid() ) then
		-- owner is offline or in another region..what do we do with this pet?
		-- should destroy them since they should be saved last time a character was..
		Verbose("PetController", "CheckOwner:False2")
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

AI.StateMachine.AllStates.Stabled = {
	OnEnterState = function()
		Verbose("PetController", "Stabled.OnEnterState")
		mForcedTarget = nil
		mCombatTarget = nil
		mForcedFollow = nil
		mForcedStop = false
		AI.ClearAggroList()
		this:StopMoving()
	end,
}

AI.StateMachine.AllStates.Mounted = {
	OnEnterState = function()
		Verbose("PetController", "Mounted.OnEnterState")
		mForcedTarget = nil
		mCombatTarget = nil
		mForcedFollow = nil
		mForcedStop = false
		AI.ClearAggroList()
		this:StopMoving()
	end,
}

AI.StateMachine.AllStates.Follow =
{

	GetPulseFrequencyMS = function() return 3000 end,

	OnEnterState = function()
		Verbose("PetController", "Follow.OnEnterState")
		if ( IsDead(this) ) then
			ShutdownAI()
			Verbose("PetController", "Follow.OnEnterState:IsDead")
			return
		end
		mCombatTarget = nil
		mForcedTarget = nil
		mForcedStop = false
		AI.ClearAggroList()
		SetAITarget(nil)
		if ( mForcedFollow == nil ) then
			if ( CheckOwner() ) then
				mForcedFollow = mMyOwner
			end
		end
		AI.StateMachine.AllStates.Follow.Pulse = 0
		mLeaderMounted = nil -- ensure it gets past the check
		AI.StateMachine.AllStates.Follow.FollowUpdate()
	end,

	FollowUpdate = function()
		if( mForcedFollow ~= nil and mForcedFollow:IsValid() and not IsDead(mForcedFollow) ) then
			if ( AI.StateMachine.AllStates.Follow.Pulse == 0 ) then
				-- recently started following
				this:ClearPathTarget()
				this:PathToTarget(mForcedFollow,ServerSettings.Pets.Follow.Distance,ServerSettings.Pets.Follow.Speed.OnFoot)
			end
			-- wait a couple pulses into this state to begin sprint speed (so players can't cause a follow, run up on a target, and attack (on mount this would be super OP pet transport))
			if ( AI.StateMachine.AllStates.Follow.Pulse > 0 ) then
				-- cache old mounted state of leader
				local leaderWasMounted = mLeaderMounted
				-- get (potentially) new mounted state of leader
				mLeaderMounted = ( IsMounted(mForcedFollow) )
				-- nil mLeaderMounted before function call will skip this verification
				if ( leaderWasMounted ~= nil and leaderWasMounted == mLeaderMounted ) then return end -- nothing changed, go no further.
				-- mounted
				if ( mLeaderMounted ) then
					-- go mount speed
					this:ClearPathTarget()
					this:PathToTarget(mForcedFollow,ServerSettings.Pets.Follow.Distance,ServerSettings.Pets.Follow.Speed.Mounted)
				else
					this:ClearPathTarget()
					this:PathToTarget(mForcedFollow,ServerSettings.Pets.Follow.Distance,ServerSettings.Pets.Follow.Speed.OnFoot)
				end
			end
		else
			-- leader went poof?
			AI.StateMachine.ChangeState("Idle")
		end
	end,

	AiPulse = function()
		-- do this in a pulse so creatures following other players (not the owner) will adjust to their speed.
		-- also easier application instead of firing a message every time an owner get on their/off their mount (don't want all pets switching to follow mode just cause owner mounted for example.)
		AI.StateMachine.AllStates.Follow.Pulse = AI.StateMachine.AllStates.Follow.Pulse + 1
		AI.StateMachine.AllStates.Follow.FollowUpdate()
	end,
}


AI.StateMachine.AllStates.Melee = {
    OnEnterState = function()
		Verbose("PetController", "Melee.OnEnterState")

        FaceTarget()
        RunToTarget()
        --DebugMessageA(this,"attack start")

        AI.SetMeleeTarget(AI.MainTarget)
    end,

	OnExitState = function(newState)
		Verbose("PetController", "Melee.OnExitState")
		mForcedTarget = nil
    end,

    GetPulseFrequencyMS = function() return 5000 end,

    AiPulse = function()
		
		-- decide our new target
		if ( IsDead(AI.MainTarget) ) then
			mForcedTarget = nil
			UserPetCommand("autoattack", mMyOwner:GetObjVar("CurrentTarget"))
		end
    end,
}

AI.StateMachine.AllStates.Stay = {
	OnEnterState = function()
		Verbose("PetController", "Stay.OnEnterState")
		mCombatTarget = nil
		mForcedTarget = nil
		mForcedFollow = nil
		mLastFollow = nil
	end
}



--When I get hit.
RegisterEventHandler(EventType.Message, "DamageInflicted", 
function (damger)
	Verbose("PetController", "OnDamageInflicted")
    if(IsDead(this)) then
        return
    end

    if ( mForcedFollow ~= nil ) then
    	return -- following, don't react to taking damage.
    end

    if ( mForcedTarget ~= nil ) then
   		return -- forced on a target, don't react.
    end
    -- not forced to do anything, so defend itself
    if ( damager ~= mCombatTarget ) then
   		this:SendMessage("AttackTarget", damager, true)
	end
end)

RegisterEventHandler(EventType.Message, "HasDiedMessage", 
function ()
	Verbose("PetController", "OnHasDiedMessage")
	ShutdownAI()
end)

function ShutdownAI()
	Verbose("PetController", "ShutdownAI")
	-- stop any pathing we might be doing.
	this:ClearPathTarget()
	-- turn AI off
	AI.StateMachine.Shutdown()
end

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

if IsMount(this) then --( GetEquipSlot(this) == "Mount" ) then
	if not( this:IsEquipped() ) then		
		AddUseCase(this, "Mount", true, "IsController")
	end
end

AddUseCase(this, "Release", false, "IsController")
AddUseCase(this, "Rename", false, "IsController")
AddUseCase(this, "Transfer", false, "IsController")

if( IsStabled(this) ) then
	AI.InitialState = "Stabled"
else
	CheckOwner()
	CallFunctionDelayed(TimeSpan.FromSeconds(1), function()
		UserPetCommand("follow", mMyOwner)
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
				user:SystemMessage("Pet names must longer than 3 characters.")
				return
			end

	   		if (string.len(newName) > 12) then
				user:SystemMessage("Pet names must be less than 15 characters.")
				return
			end

			if(#newName:gsub("[%a ]","") ~= 0) then
				user:SystemMessage("Pet names may only contain letters and spaces")
				return
			end

		   	if(ServerSettings.Misc.EnforceBadWordFilter and HasBadWords(newName)) then
		    	user:SystemMessage("Pet names may not contain any foul language. Sorry!")
		    	return
		   	end

		   	UpdatePetName(this, newName, newName)
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
		
	CreateObjInBackpack(mMyOwner,statueType,"PetStatueCreation", this)  
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


function HandleAttackTarget(target)
	Verbose("PetController", "HandleAttackTarget")
--DebugMessage("Initiating Attakc Command")
	if not( ValidCombatTarget(this, target) ) then
		UserPetCommand("follow", mMyOwner)
		return
	end
	if ( mForcedTarget == nil or mForcedTarget == target ) then
		Verbose("PetController", "HandleAttackTarget:AttackEnemy")
		AttackEnemy(target, true)
	end
end

function StableSelf()
	Verbose("PetController", "StableSelf")
	if ( CheckOwner() ) then

		local tempPack = mMyOwner:GetEquippedObject("TempPack")
	  	if( tempPack ~= nil ) then
			AI.StateMachine.ChangeState("Stabled")
			this:MoveToContainer(tempPack,Loc(0,0,0))
		end
	end
end

function StatuifySelf()
	Verbose("PetController", "StatuifySelf")
	if not( CanStatuify(this, mMyOwner) ) then return end
	if ( CheckOwner() ) then
		local controlStatue = this:GetObjVar("PetStatue")
		if(controlStatue == nil) or (not controlStatue:IsValid()) then
			 CreatePetStatue()
		else
			local ownerPack = mMyOwner:GetEquippedObject("Backpack")
			local randomLoc = GetRandomDropPosition(ownerPack)
			controlStatue:MoveToContainer(ownerPack, randomLoc)
			AI.StateMachine.ChangeState("Stabled")
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
			-- create the key ring inside the temp pack
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
		-- wait a frame (solves inf recursion of TopmostContainer)
		CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
			controlStatue:MoveToContainer(tempPack,Loc(0,0,0))
		end)
	end

	this:SetWorldPosition(user:GetLoc())
	if ( not IsDead(this) and CheckOwner(user) ) then
		UserPetCommand("follow", user)
	end
end


function UnStableSelf()
	-- should be in backpack.
	local topMost = this:TopmostContainer()
	if ( topMost == nil ) then return end -- can't unstable, already in the world!

	this:SetWorldPosition(topMost:GetLoc())

	if ( not IsDead(this) and CheckOwner(topMost) ) then
		UserPetCommand("follow", mMyOwner)
	end
end

RegisterEventHandler(EventType.Message, "Stable", StableSelf)
RegisterEventHandler(EventType.Message, "Unstable", UnStableSelf)

RegisterEventHandler(EventType.Message, "Statuify", StatuifySelf)
RegisterEventHandler(EventType.Message, "UnStatuify", UnStatuifySelf)

RegisterEventHandler(EventType.Message, "SetPetOwner", CheckOwner)

RegisterEventHandler(EventType.Message, "OnResurrect",
	function()
		local newName = StripFromString(this:GetName()," Corpse")
		this:SetName(ColorizePlayerName(mMyOwner, newName))
		if(this:DecayScheduled()) then
			this:RemoveDecay()
		end
		CheckOwner()
		if (mMyOwner == nil) then
			DebugMessage("[pet_controller] ERROR: "..this:GetName().." with id of "..this.Id.." has no controller.")
			return
		end
		UserPetCommand("follow", mMyOwner)
		end)

RegisterEventHandler(EventType.Message, "AteFood",
	function(newFill, newFillAdd)
		if(newFillAdd == nil) then newFillAdd = 1 end
		if not(this:HasTimer("FoodGainPetTimer")) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(300), "FoodGainPetTimer")
		end
	end)

function UserPetCommand(cmdName, target, forceAccept)
	Verbose("PetController", "UserPetCommand", cmdName)

	if( IsStabled(this) and cmdName ~= "unstable" ) then
		if ( mMyOwner ~= nil ) then -- really shouldn't warn users about this..
			mMyOwner:SystemMessage("[$2391]")	
		end
		return 
	end

	CheckOwner()

	if not ( mMyOwner ) then
		Verbose("PetController", "UserPetCommand:ReturnNoMyOwner")
		CheckOwner()
		return
	end

	-- prevent ghosts from commanding pets
	if ( IsDead(mMyOwner) ) then
		Verbose("PetController", "UserPetCommand:ReturnDeadOwner")
		return
	end

	if ( (this:GetLoc():Distance(mMyOwner:GetLoc()) > ServerSettings.Pets.Command.Distance) and (this:ContainedBy() == nil) ) then
		mMyOwner:SystemMessage("Too far away to command pet.")
		return
	end

	if ( cmdName == "release" ) then
		if ( target == this ) then
			ConfirmRelease(mMyOwner)
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
		mMyOwner:SystemMessage(this:GetName().." is ignoring you.", "info")
		return
	end

	if ( forceAccept ~= true and not CanControlCreature(mMyOwner, this) ) then
		AI.StateMachine.ChangeState("Idle")
		mMyOwner:SystemMessage(this:GetName().." refuses to "..cmdName..".")
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(math.random(1, 6)), "IgnoringCommandsTimer")
		return
	end

	if(cmdName == "guard" ) then
		if ( target ~= nil ) then
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
		return
	end

	if(cmdName == "autoattack" ) then
		if ( target ~= nil ) then
			mLastFollow = mForcedFollow
			mForcedFollow = nil
			HandleAttackTarget(target)
		end
		return
	end

	if(cmdName == "attack") then
		if(target ~= nil) then
			mLastFollow = mForcedFollow
			mForcedFollow = nil
			mForcedTarget = target
			HandleAttackTarget(target)
		end
		return
	end

	if(cmdName == "follow") then
		if ( CheckOwner() and target ~= nil ) then
			mLastFollow = nil
			mForcedFollow = target
			if ( this:GetObjVar("CurrentState") == "Follow" ) then
				AI.StateMachine.AllStates.Follow.Pulse = 0
				AI.StateMachine.AllStates.Follow.FollowUpdate()
			else
				AI.StateMachine.ChangeState("Follow")
			end
		end
		return
	end

	if ( cmdName == "stay" or cmdName == "go" ) then
		AI.ClearAggroList()
		SetAITarget(nil)
		mForcedStop = true
		AI.StateMachine.ChangeState("Stay")
		this:StopMoving()
		if ( cmdName == "go" ) then
			this:PathTo(target,ServerSettings.Pets.Combat.Speed)
		end
		return
	end

	if(cmdName == "stop") then
		mForcedFollow = nil
		mLastFollow = nil
		mCombatTarget = nil
		mForcedTarget = nil
		mForcedStop = true
		AI.ClearAggroList()
		SetAITarget(nil)
		AI.StateMachine.ChangeState("Idle")
		this:StopMoving()
		ClearGuarding()
		return
	end
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

		if user ~= mMyOwner then 
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
	mLastFollow = nil
	mForcedFollow = target
	AI.StateMachine.ChangeState("Follow")
end)

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if ( IsDead(this) or IsDead(user) ) then return end -- neither one can be dead to do anything further.

		CheckOwner()

		if user ~= mMyOwner then 
			return
		end

		if(usedType == "Mount") then
			if(GetEquipSlot(this) == "Mount" and (this:IsEquipped() or this:GetObjectOwner() == user) ) then
				AI.StateMachine.ChangeState("Mounted")
				MountMobile(user, this)
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
	return (
		(
			IsMount(pet)
			and
			GetPetSlots(pet) <= ServerSettings.Pets.MaxSlotsToAllowDismiss
			and
			ValidateRangeWithError(5, user, pet, "Too far away.")
		)
		or
		(
			IsGod(user)
			and
			not TestMortal(user)
		)
	)
end