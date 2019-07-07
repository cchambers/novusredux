-- DAB Beta TODO: Decide what to do about timberboxes!!
-- For now im just hacking it so people have access to heat sources



-- When players are nearby they will get a boost to their stat regen,

-- different levels of campfires can be created by setting the ObjVar BaseBonus on the campfire object.

_PlayersNearby = {}

-- keep track of the player that owns this campfire so only their group members get the benefit
_Owner = nil

function DisturbCampfire(mobileObj)
	if ( mobileObj ) then
		for i,player in pairs(_PlayersNearby) do
			player:SystemMessage(mobileObj:GetName().." disturbed the campfire!", "info")
		end
	end
	ExtinguishCampfire()
end

function ExtinguishCampfire()
	DelView("MobileNearbyCampfire")

	-- turn off the flames
	this:SetSharedObjectProperty("IsLit", false)
	
	-- unbuff any that this campfire buffed
	EndCampfireEffectForAll()

	-- prevent cooking
	this:DelObjVar("HeatSource")

	-- make it more useful
	RemoveUseCase(this, "Put Out")
	AddUseCase(this, "Destroy")
end

function EndCampfireEffectForAll()
	for i,player in pairs(_PlayersNearby) do
		if ( player and player:IsValid() ) then
			player:SendMessage("EndCampfireEffect", this)
		end
	end
	_PlayersNearby = {}
end

function IgniteCampfire(igniter)
	if ( igniter and this:HasObjVar("CannotBeLit") ) then
		igniter:SystemMessage("That campfire is spent.", "info")
		return
	end
	-- turn on the flames
	this:SetSharedObjectProperty("IsLit", true)
	
	--RemoveUseCase(this, "Reignite")
	RemoveUseCase(this, "Destroy")

	if ( this:HasObjVar("BaseBonus") ) then
		AddUseCase(this,"Put Out")

		AddView("MobileNearbyCampfire", SearchMobileInRange(ServerSettings.Campfire.MaxRange, true), 1.0)
	end
end

function ApplyCampfireBuff(mobileObj)
	if ( this:GetSharedObjectProperty("IsLit") ) then
		table.insert(_PlayersNearby, mobileObj)
		mobileObj:SendMessage("StartMobileEffect", "Campfire", this)
	end
end

function InGroupWithOwner(mobileObj)
	if not( ServerSettings.Campfire.RequireGroup ) then return true end
	-- if the owner logged off or whatever, it can be a freebie campfire.
	if ( not _Owner or not _Owner:IsValid() ) then return true end

	return ShareGroupCheckPet(_Owner, mobileObj)
end

if ( ServerSettings.Campfire.Disturb.Players or ServerSettings.Campfire.Disturb.NPCs ) then
	RegisterEventHandler(EventType.Message, "DisturbCampfire", DisturbCampfire)
end

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if not ( ValidateRangeWithError(5, user, this, "Too far away.") ) then return end
		if ( this:GetSharedObjectProperty("IsLit") ) then
			if ( usedType == "Put Out") then
				-- prevent putting out fires that have no bonus to them
				if ( not this:HasObjVar("BaseBonus") or not InGroupWithOwner(user) ) then
					user:SystemMessage("You can't put that out.", "info")
					return
				end
				ExtinguishCampfire()
			end
		else
			if not( this:HasObjVar("BaseBonus") ) then return end -- only buff fires can be altered like this
			if ( usedType == "Destroy" ) then
				this:Destroy()
				return
			end
		end
	end)

RegisterEventHandler(EventType.EnterView, "MobileNearbyCampfire", function(mobileObj)
	if ( IsDead(mobileObj) ) then return end
	
	if ( InGroupWithOwner(mobileObj) ) then
		if ( mobileObj:GetSharedObjectProperty("CombatMode") == true ) then
			DisturbCampfire(mobileObj)
		else
			ApplyCampfireBuff(mobileObj)
		end
	elseif not( IsPlayerCharacter(mobileObj) ) then
		-- make monsters disturb campfires too. (but no buff for them)
		if ( mobileObj:GetSharedObjectProperty("CombatMode") == true ) then
			DisturbCampfire(mobileObj)
		end
	end

end)

-- so we can apply the buff to a player upon them joining a group and are in the buff area already.
RegisterEventHandler(EventType.Message, "ApplyCampfireBuff", ApplyCampfireBuff)

RegisterEventHandler(EventType.LeaveView, "MobileNearbyCampfire", function(mobileObj)
	if ( mobileObj:IsPlayer() ) then
		mobileObj:SendMessage("EndCampfireEffect", this)
		-- remove the player from the list
		for i,player in pairs(_PlayersNearby) do
			if ( player == mobileObj ) then
				_PlayersNearby[i] = nil
			end
		end
	end
end)

RegisterSingleEventHandler(EventType.ModuleAttached, "tinderbox_campfire", function()
	SetTooltipEntry(this,"campfire","The warmth of a campfire causes you to heal more quickly. Any combat near the fire will extinguish the flames.")

	_Owner = GameObj(initializer.OwnerId)
	
	if ( _Owner and _Owner:IsValid() ) then
		IgniteCampfire()
	end

	if ( this:HasObjVar("BaseBonus") ) then
		-- fires that buff go out eventually.
		this:ScheduleTimerDelay(ServerSettings.Campfire.Expire, "CampfireExpire")
	end
end)

RegisterEventHandler(EventType.Timer, "CampfireExpire", function()
	this:SetObjVar("CannotBeLit", true)

	ExtinguishCampfire()

	-- remove it soon
	Decay(this, ServerSettings.Campfire.DecaySeconds)
end)

-- regen campfires will destroy themselves on loading from backup
RegisterEventHandler(EventType.LoadedFromBackup,"", function()
	if ( this:HasObjVar("BaseBonus") ) then
		this:Destroy()
	end
end)