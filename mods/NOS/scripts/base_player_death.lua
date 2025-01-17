-- Completely skip this custom death stuff if the mob is possessed
if(IsPossessed(this)) then
	return
end

mBackpack = nil

function OnDeathStart()
	if(this:HasObjVar("OverrideDeath")) then
		return 
	end

	if (this:HasObjVar("ProtectionSpell")) then
		this:DelObjVar("ProtectionSpell")
	end

	if(this:HasObjVar("ColorWarPlayer")) then
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(30),"CanRekit")
	end
	
	if(this:HasObjVar("MagicReflection")) then
		this:DelObjVar("MagicReflection")
	end

	this:SendMessage("NOSDebuff")

	local fame = this:GetObjVar("Fame") or 0
	fame = fame - (fame * 0.25)
	fame = math.round(fame, 0)
	this:SetObjVar("Fame", fame)


	-- make IsDead() checks pass for this mobile
	this:SetObjVar("IsDead", true)
	-- gray out screen
	this:PlayLocalEffect(this,"GrayScreenEffect")
	this:PlayMusic("Death")
	this:SendMessage("AddInvisEffect", "player_death")

	this:SystemMessage("[D70000]You have died and lost a little fame![-]","info")
	this:SystemMessage("[$1681]")
	this:SetMobileFrozen(true,true)
	CallFunctionDelayed(TimeSpan.FromSeconds(2),function ( ... )
		this:SetMobileFrozen(false,false)
	end)

	this:PlayAnimation("roar")

	-- create their corpse
	local corpseTemplate = GetTemplateData("player_corpse")

	if not(ServerSettings.PlayerInteractions.FullItemDropOnDeath) or IsInitiate(this) then
		corpseTemplate.ObjectVariables.NoDisrobe = true
	end

	-- sorta messy
	corpseTemplate.ClientId = this:GetIconId()
	corpseTemplate.ScaleModifier = this:GetScale().X
	corpseTemplate.Color = this:GetColor()
	corpseTemplate.Hue = this:GetHue()

	-- put proper ownership text to the name for the corpse.
	local name = this:GetName()
	if ( string.sub(name, -1, -1) == "s" ) then
		name = name .. "'"
	else
		name = name .. "'s"
	end
	corpseTemplate.Name = ColorizePlayerName(this, name .. " Corpse")
	CreateCustomObj("player_corpse", corpseTemplate, this:GetLoc(), "created_corpse", this:GetFacing())
end

RegisterEventHandler(EventType.CreatedObject, "created_corpse", function (success, objRef, facing)
		if (success) then
			-- create a backpack on the corpse
			-- disabled (this method doesn't allow us to loot equipped items from the corpse)
			--CreateEquippedObj("backpack",objRef,"backpack_corpse_creation")

			-- set a refrence to the player this corpse belongs to, allows resurrecting the player by targeting their corpse.
			objRef:SetObjVar("PlayerObject", this)
			-- visa versa.
			this:SetObjVar("CorpseObject", objRef)
			this:SetObjVar("CorpseAddress", ServerSettings.RegionAddress)

			if ( facing ~= nil ) then
				objRef:SetFacing(facing)
			end
			objRef:SetMobileFrozen(true,true)
			objRef:PlayAnimation("die")

			objRef:SetObjVar("BackpackOwner", this)
			SetKarma(objRef, GetKarma(this) or 0)
			local allegiance = GetAllegianceId(this)
			if ( allegiance ~= nil ) then
				objRef:SetObjVar("Allegiance", allegiance)
			end
			if ( this:HasObjVar("IsChaotic") ) then
				objRef:SetObjVar("IsChaotic", true)
			end
			local groupKarma = this:GetObjVar("GroupKarma")
			if ( groupKarma ) then
				objRef:SetObjVar("GroupKarma", groupKarma)
			end
			-- freeze the current conflict table on the corpse
			FreezeConflictTable(this, objRef)
			-- clear the conflict table
        	SetAllRelationsGuardIgnore(this)
			
			-- set copy as corpse
			objRef:SetSharedObjectProperty("IsDead", true)
			objRef:SendMessage("CheckSpawns",this)
			-- set what happens when you interact in the default way (left click for example)
			objRef:SetSharedObjectProperty("DefaultInteraction", "Open Pack")
			
			local dropFullLoot = ShouldDropFullLoot(this)

			TurnPlayerIntoGhost(not(dropFullLoot))

			local backpack = nil

			local equippedObjects = this:GetAllEquippedObjects()
			for i=1,#equippedObjects do
				local slot = GetEquipSlot(equippedObjects[i])
				if ( slot == "Backpack" ) then
					backpack = equippedObjects[i]
				elseif ( slot ~= "TempPack" and slot ~= "Bank" and slot ~= nil) then
					if ( slot:match("BodyPart") ) then
						-- replicate the hair
						if ( slot == "BodyPartHair" or slot == "BodyPartFacialHair" ) then
							CreateEquippedObj(equippedObjects[i]:GetCreationTemplateId(), objRef, "corpse_body_parts_created", equippedObjects[i]:GetHue())
						end
					elseif ( dropFullLoot ) then
						-- move over all equipped items to the corpse, skipping blessed
						if not( equippedObjects[i]:HasObjVar("Blessed") ) then
							objRef:EquipObjectWithLoc(equippedObjects[i], GetRandomDropPosition(objRef))
						end
					end
				end
			end

			-- move all items from our backpack to the corpse.
			TransferBackpackContentsToCorpse(objRef, dropFullLoot, backpack)
			TurnNearbyMossIntoBloodMoss()
		end		
	end)

function TurnNearbyMossIntoBloodMoss()
	-- TODO - Verlorens - Globalize this call, so it's not in base_player_death.lua AND base_ai_mob.lua
	-- Right now it's set so if something that is not Undead, dies close enough to it, it turns into bloodmoss.
	local nearbyMoss = FindObjects(SearchMulti(
		{
			SearchRange(this:GetLoc(), 8),
			SearchObjVar("ResourceSourceId","Moss"),
		}))
	for i,j in pairs(nearbyMoss) do
		--if( this:GetObjVar("MobileKind") ~= "Undead") then
			if(math.random(0,10) > 2) then
				CreateTempObj("plant_bloodmoss", j:GetLoc(), "bloodmoss_created_by_death")
				j:Destroy()
			end
		--end
	end
end

RegisterEventHandler(EventType.CreatedObject,"bloodmoss_created_by_death",function (success,objRef)
    if (success) then
        if( not (objRef:HasModule("harvestable_plant")) ) then
            -- A safety check in case the harvestable_plant module is not attached.
            objRef:AddModule("harvestable_plant")
        end
        objRef:SendMessage("TransitionColorFromMossToBloodmoss", objRef)
	end
end)

function TransferBackpackContentsToCorpse(corpseContainer, dropFullLoot, backpack)
	if ( backpack == nil ) then backpack = this:GetEquippedObject("Backpack") end
	-- transfer all their items over to the corpse, skipping blessed
	if ( backpack ~= nil and dropFullLoot ) then
		local corpseItems = {}
		local blessed = false
		ForEachItemInContainerRecursive(backpack, function(item)
			blessed = item:HasObjVar("Blessed")
			-- item is in top level of backpack
			if ( item:ContainedBy() == backpack ) then
				-- and item is not blessed (nothing must be done with blessed items already in top level of backpack)
				if not( blessed ) then
					-- move to corpse (eventually)
					corpseItems[#corpseItems+1] = item
				end
			else
			-- item is not in top level of backpack (sub container)
				if ( blessed ) then
					-- move to top level in backpack, item is blessed.
					item:MoveToContainer(backpack, item:GetLoc())
				end
			end
			return true -- keep going
		end)
		-- move top level non-blessed items to the corpse
		for i=1,#corpseItems do
			corpseItems[i]:MoveToContainer(corpseContainer, corpseItems[i]:GetLoc())
		end
	end
end

RegisterEventHandler(EventType.CreatedObject, "corpse_body_parts_created", function(success, objRef, hue)
	if ( success and hue ~= nil ) then
		objRef:SetHue(hue)
	end
end)

-- corpse should only be passed when the resurrector is resurrecting a corpse vs resurrecting a ghost.
function OnDeathEnd( resurrector, corpse, force )
	this:CloseDynamicWindow("ResurrectDialog")
	
	this:SetMobileFrozen(true,true)
	if ( corpse ~= nil ) then
		-- the player was resurrected from their corpse, so..

		-- let's validate the corpse.
		if ( corpse ~= this:GetObjVar("CorpseObject") ) then
			-- corpses don't match
			return
		end

		if not( corpse:HasObjVar("PlayerObject") ) then
			if ( IsPlayerCharacter(resurrect) ) then
				resurrector:SystemMessage("They have already been resurrected.", "info")
			end
			return
		end

		if ( force ) then
			ResurrectCorpse(corpse)
			return
		end

		-- ask them if they want to be resurrected at their corpse
		ClientDialog.Show{
		    TargetUser = this,
		    DialogId = "ResurrectDialog",
		    TitleStr = "You are being resurrected.",
		    DescStr = "[$1683]",
		    Button1Str = "Yes",
		    Button2Str = "No",
		    ResponseFunc = function (user, buttonId)
				buttonId = tonumber(buttonId)
				this:SetMobileFrozen(false, false)
				if( buttonId == 0) then
					ResurrectCorpse(corpse)
				end
			end
		}

	else
		-- player was resurrected from their ghost.
		this:PlayEffect("ResurrectEffect", 1.5)

		local oldCorpse = this:GetObjVar("CorpseObject")
		if ( oldCorpse ~= nil and oldCorpse:IsValid()) then
			-- try to do it local first
			if not( UpdateCorpseOnPlayerResurrected(oldCorpse) ) then
				local corpseAddress = this:GetObjVar("CorpseAddress") or ServerSettings.RegionAddress
				-- local failed, tell remote cluster to do the update
				MessageRemoteClusterController(corpseAddress, "PlayerResurrected", oldCorpse)
			end
		end

		EndDeath(true)
	end
end

function ResurrectCorpse(corpse)
	-- cloak the player
	this:SetCloak(true)

	-- play resurrect effect
	corpse:PlayEffect("ResurrectEffect")

	-- make corpse stand up
	corpse:SetSharedObjectProperty("IsDead", false)
	--give them their health.
	SetCurHealth(this,GetMaxHealth(this))
	-- move the player to the location of their corpse.
	this:SetWorldPosition(corpse:GetLoc())

	-- move equipment back if it was taken
	if ( ServerSettings.PlayerInteractions.FullItemDropOnDeath ) then
		local slots = ITEM_SLOTS
		local item = nil
		for i=1,#slots do
			if ( slot ~= "Familiar" ) then
				item = corpse:GetEquippedObject(slots[i])
				if ( item ~= nil ) then
					this:EquipObject(item)
				end
			end
		end
	end
	
	local backpack = this:GetEquippedObject("Backpack")
	if ( backpack == nil ) then
		-- TODO
		-- no backpack, should we stop it? I mean all the items are going to be destoyed..
	end
	-- move the rest of the corpses contents back into their backpack
	if ( backpack ~= nil ) then
		local corpseObjects = corpse:GetContainedObjects()
		for index,object in pairs(corpseObjects) do
			local slot = GetEquipSlot(object)
			if ( slot == nil or ( slot ~= "TempPack" and slot ~= "Bank" and not slot:match("BodyPart")) ) then
				object:MoveToContainer(backpack,object:GetLoc())
			end
		end
	end

	CallFunctionDelayed(TimeSpan.FromMilliseconds(400), function()
		--destroy the corpse
		corpse:Destroy()
		-- uncloak player
		this:SetCloak(false)

		EndDeath(false)
	end)
end

function EndDeath(ghostResurrect)
	this:StopEffect("GrayScreenEffect")
	
	-- stop looking like a ghost
	ChangePlayerBackFromGhost()

	-- stop being treated like a ghost
	this:DelObjVar("IsDead")
	--this:SetHideNearbyMobiles(false)

	
	local nearbyMobiles = FindObjects(SearchMobileInRange(this:GetUpdateRange()))
	for i=1,#nearbyMobiles do
		nearbyMobiles[i]:ForceObjectUpdate(this)
	end
	
	this:SendMessage("SetFullLevelPct",50)

	SetMobileMod(this, "HealthRegenPlus", "Death", nil)
	SetMobileMod(this, "ManaRegenPlus","Death", nil)
	SetMobileMod(this, "StaminaRegenPlus","Death", nil)
	SetMobileMod(this, "VitalityRegenPlus","Death", nil)

	this:SetMobileFrozen(false, false)

	if ( ghostResurrect ) then
		if ( ServerSettings.Vitality.AdjustOnGhostResurrect and not IsInitiate(this) and GetCurVitality(this) > 0 ) then
			AdjustCurVitality(this, ServerSettings.Vitality.AdjustOnGhostResurrect)
		end
	end
end

GHOST_HUE = "0xC0C0C0FF"
function TurnPlayerIntoGhost(shouldHueEquipment)
	-- force them out of combat
	RegisterEventHandler(EventType.Message, "CombatStatusUpdate", function(state)
		if (state) then 
			this:SystemMessage("You can be seen by the living.")
			this:SendMessage("BreakInvisEffect", "player_death")
		else 
			this:SystemMessage("You are invisible to the living world. Toggle combat mode to be seen.")
			this:SendMessage("AddInvisEffect", "player_death")
		end
	end)
	
	this:SendMessage("EndCombatMessage")
	
	-- make them look like a ghost
	local hueTable = {}
	hueTable.SelfHue = this:GetColor()
	if (this:GetEquippedObject("BodyPartHair") ~= nil) then
		--DebugMessage("Yessir")
		hueTable.HairHue = this:GetEquippedObject("BodyPartHair"):GetColor()
		this:GetEquippedObject("BodyPartHair"):SetObjVar("OldHue",hueTable.HairHue)
		this:GetEquippedObject("BodyPartHair"):SetColor(GHOST_HUE)
	end

	if(shouldHueEquipment) then
		if (this:GetEquippedObject("Chest") ~= nil) then
			hueTable.ChestHue = this:GetEquippedObject("Chest"):GetColor()
			this:GetEquippedObject("Chest"):SetObjVar("OldHue",hueTable.ChestHue)
			this:GetEquippedObject("Chest"):SetColor(GHOST_HUE)
		end
		if (this:GetEquippedObject("Legs") ~= nil) then
			hueTable.LegsHue = this:GetEquippedObject("Legs"):GetColor()
			this:GetEquippedObject("Legs"):SetObjVar("OldHue",hueTable.LegsHue)
			this:GetEquippedObject("Legs"):SetColor(GHOST_HUE)
		end
		if (this:GetEquippedObject("Head") ~= nil) then
			hueTable.HeadHue = this:GetEquippedObject("Head"):GetColor()
			this:GetEquippedObject("Head"):SetObjVar("OldHue",hueTable.HeadHue)
			this:GetEquippedObject("Head"):SetColor(GHOST_HUE)
		end		
		if (this:GetEquippedObject("RightHand") ~= nil) then
			--DebugMessage("Yessir")
			hueTable.RightHand = this:GetEquippedObject("RightHand"):GetColor()
			this:GetEquippedObject("RightHand"):SetObjVar("OldHue",hueTable.RightHand)
			this:GetEquippedObject("RightHand"):SetColor(GHOST_HUE)
		end
		if (this:GetEquippedObject("LeftHand") ~= nil) then
			--DebugMessage("Yessir")
			hueTable.LeftHand = this:GetEquippedObject("LeftHand"):GetColor()
			this:GetEquippedObject("LeftHand"):SetObjVar("OldHue",hueTable.LeftHand)
			this:GetEquippedObject("LeftHand"):SetColor(GHOST_HUE)
		end

	end

	hueTable.formTemplate = this:GetObjVar("FormTemplate")

	this:SetObjVar("OldHues",hueTable)
	this:SetObjVar("IsGhost",true)
	CallFunctionDelayed(TimeSpan.FromMilliseconds(400), function()
		this:SetCloak(true)
		this:SetColor(GHOST_HUE)
	end)
	-- this:SetAppearanceFromTemplate("death_shroud")
	-- this:SetScale(0.4*this:GetScale())
end

function ChangePlayerBackFromGhost()
	
	UnregisterEventHandler("",EventType.Message, "CombatStatusUpdate")

	
	local hueTable = this:GetObjVar("OldHues")
	
	if (hueTable ~= nil) then
		-- this:SetAppearanceFromTemplate(hueTable.formTemplate)
		-- this:SetObjVar("FormTemplate",hueTable.formTemplate)
		-- this:SetScale((1/0.4)*this:GetScale())
		if (this:GetEquippedObject("Chest") ~= nil and hueTable.ChestHue) then
			this:GetEquippedObject("Chest"):SetColor(hueTable.ChestHue)
		end
		if (this:GetEquippedObject("Legs") ~= nil and hueTable.LegsHue) then
			this:GetEquippedObject("Legs"):SetColor(hueTable.LegsHue)
		end
		if (this:GetEquippedObject("Head") ~= nil and hueTable.HeadHue) then
			this:GetEquippedObject("Head"):SetColor(hueTable.HeadHue)
		end
		if (this:GetEquippedObject("BodyPartHair") ~= nil and hueTable.HairHue) then
			this:GetEquippedObject("BodyPartHair"):SetColor(hueTable.HairHue)
		end
		if (this:GetEquippedObject("LeftHand") ~= nil and hueTable.LeftHand) then
			this:GetEquippedObject("LeftHand"):SetColor(hueTable.LeftHand)
		end
		if (this:GetEquippedObject("RightHand") ~= nil and hueTable.RightHand) then
			this:GetEquippedObject("RightHand"):SetColor(hueTable.RightHand)
		end
		this:SetColor(hueTable.SelfHue)
	else
		DebugMessage("[base_player_death] ERROR: Could not load player hue table on death! Resetting hues!")
		if (this:GetEquippedObject("Chest") ~= nil) then
			this:GetEquippedObject("Chest"):SetColor(this:GetEquippedObject("Chest"):GetObjVar("OldHue") or "0xFFFFFFFF")
		end
		if (this:GetEquippedObject("Legs") ~= nil) then
			this:GetEquippedObject("Legs"):SetColor(this:GetEquippedObject("Legs"):GetObjVar("OldHue") or "0xFFFFFFFF")
		end
		if (this:GetEquippedObject("Head") ~= nil) then
			this:GetEquippedObject("Head"):SetColor(this:GetEquippedObject("Head"):GetObjVar("OldHue") or "0xFFFFFFFF")
		end
		if (this:GetEquippedObject("BodyPartHair") ~= nil) then
			this:GetEquippedObject("BodyPartHair"):SetColor(this:GetEquippedObject("BodyPartHair"):GetObjVar("OldHue") or "0xFFFFFFFF")
		end
		if (this:GetEquippedObject("LeftHand") ~= nil) then
			this:GetEquippedObject("LeftHand"):SetColor(this:GetEquippedObject("LeftHand"):GetObjVar("OldHue") or "0xFFFFFFFF")
		end
		if (this:GetEquippedObject("RightHand") ~= nil) then
			this:GetEquippedObject("RightHand"):SetColor(this:GetEquippedObject("RightHand"):GetObjVar("OldHue") or "0xFFFFFFFF")
		end
		this:SetColor("0xFFFFFFFF")
	end
	this:DelObjVar("OldHues")
	this:DelObjVar("IsGhost")
	this:SendMessage("BreakInvisEffect", "player_death")
	this:SetCloak(false)
end

baseMobileDeath = DoMobileDeath
function DoMobileDeath(damager)
	Verbose("PlayerDeath", "DoMobileDeath", damager, this)
	baseMobileDeath(damager)
	local name = this:GetName()

	if ( damager ~= nil and damager ~= this and damager:IsPlayer() ) then
		damager:SystemMessage("[0AB4F7] You have vanquished [-][F70A79]" .. name, "info")
	end

	-- if (damager == nil) then
	-- 	Totem(this, "death")
	-- elseif (damager == this) then
	-- 	Totem(this, "death", { aggressor = this:GetName(), kind = 1 })
	-- elseif (damager:IsPlayer()) then
	-- 	Totem(this, "death", { aggressor = damager:GetName(), kind = 2 })
	-- else
	-- 	local what = damager:GetObjVar("MobileTeamType"):lower() or "creature"
	-- 	local power = damager:GetObjVar("Power") or 0
	-- 	local kind = 3 -- mob
	-- 	if (power > 0) then
	-- 		kind = kind + math.round(power / 5)
	-- 		if (kind > 10) then kind = 10 end
	-- 	end

	-- 	Totem(this, "death", { aggressor = what, kind = kind })
	-- end

	mBackpack = this:GetEquippedObject("Backpack")

	-- close all open container windows in the players backpack
	if (mBackpack ~= nil) then
		CloseContainerRecursive(this,mBackpack)
	end

	-- if you are carrying something under the mouse cursor and die, it should drop to the ground
	local carriedObject = this:CarriedObject()
	if ( carriedObject ~= nil and carriedObject:IsValid() ) then
		carriedObject:SetWorldPosition(this:GetLoc())
	end
	
	OnDeathStart()
end

RegisterEventHandler(EventType.Message, "PlayerResurrect", 
	function ( resurrector, corpse, force )
		OnDeathEnd( resurrector, corpse, force )
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ( ... )		
		if(IsDead(this)) then
			if(this:HasObjVar("OverrideDeath")) then
				return 
			end
						
			CallFunctionDelayed(TimeSpan.FromSeconds(0.5),
			function ( ... )
				this:PlayLocalEffect(this,"GrayScreenEffect")
			end)				
		end
	end)
