-- Completely skip this custom death stuff if the mob is possessed
if(IsPossessed(this)) then
	return
end

mBackpack = nil

function OnDeathStart()
	if(this:HasObjVar("OverrideDeath")) then
		return 
	end

	-- make IsDead() checks pass for this mobile
	this:SetObjVar("IsDead", true)
	-- gray out screen
	this:PlayLocalEffect(this,"GrayScreenEffect")
	this:PlayMusic("Death")
	this:SetCloak(true)

	this:SystemMessage("[D70000]You have died![-]","event")
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
			this:SetObjVar("LastDeathRegion",GetRegionAddress())

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
				elseif ( slot ~= "TempPack" and slot ~= "Bank" ) then
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
		end		
	end)

function TransferBackpackContentsToCorpse(corpseContainer, dropFullLoot, backpack)
	if ( backpack == nil ) then backpack = this:GetEquippedObject("Backpack") end
	-- transfer all their items over to the corpse, skipping blessed
	if ( backpack ~= nil and dropFullLoot ) then
		local backpackObjects = backpack:GetContainedObjects()
		for i=1,#backpackObjects do
			if not( backpackObjects[i]:HasObjVar("Blessed") ) then
				backpackObjects[i]:MoveToContainer(corpseContainer, backpackObjects[i]:GetLoc())
			end
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

		-- remove PlayerObject from their corpse (if existant) preventing a resurrect on a corpse after they have been resurrected from their ghost.
		local oldCorpse = this:GetObjVar("CorpseObject")
		if ( oldCorpse ~= nil and oldCorpse:IsValid()) then
			oldCorpse:DelObjVar("PlayerObject")
			-- remove 'appearance' items if not full loot
			if not ( ServerSettings.PlayerInteractions.FullItemDropOnDeath ) then
			    local leftHand = oldCorpse:GetEquippedObject("LeftHand")
			    local rightHand = oldCorpse:GetEquippedObject("RightHand")
			    local chest = oldCorpse:GetEquippedObject("Chest")
			    local legs = oldCorpse:GetEquippedObject("Legs")
			    local head = oldCorpse:GetEquippedObject("Head")
			    local body = oldCorpse:GetEquippedObject("BodyPartHead")
			    local hair = oldCorpse:GetEquippedObject("BodyPartHair")

			  	if ( leftHand ~= nil ) then leftHand:Destroy() end
			  	if ( rightHand ~= nil ) then rightHand:Destroy() end
			  	if ( chest ~= nil ) then chest:Destroy() end
			  	if ( legs ~= nil ) then legs:Destroy() end
			  	if ( head ~= nil ) then head:Destroy() end
			  	if ( body ~= nil) then body:Destroy() end
			  	if ( hair ~= nil) then hair:Destroy() end
			
				-- turn the corpse into a skeleton
				oldCorpse:SetAppearanceFromTemplate("skeleton")
				oldCorpse:DelObjVar("NoSkele")
			end
		end
		EndDeath()
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

	    local leftHand = corpse:GetEquippedObject("LeftHand")
	    local rightHand = corpse:GetEquippedObject("RightHand")
	    local chest = corpse:GetEquippedObject("Chest")
	    local legs = corpse:GetEquippedObject("Legs")
	    local head = corpse:GetEquippedObject("Head")

	  	if ( leftHand ~= nil ) then this:EquipObject(leftHand) end
	  	if ( rightHand ~= nil ) then this:EquipObject(rightHand) end
	  	if ( chest ~= nil ) then this:EquipObject(chest) end
	  	if ( legs ~= nil ) then this:EquipObject(legs) end
	  	if ( head ~= nil ) then this:EquipObject(head) end
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

		EndDeath()
	end)
end

function EndDeath()
	this:StopEffect("GrayScreenEffect")
	
	-- stop looking like a ghost
	ChangePlayerBackFromGhost()

	-- stop being treated like a ghost
	this:DelObjVar("IsDead")
	
	this:SendMessage("SetFullLevelPct",50)

	SetMobileMod(this, "HealthRegenPlus", "Death", nil)
	SetMobileMod(this, "ManaRegenPlus","Death", nil)
	SetMobileMod(this, "StaminaRegenPlus","Death", nil)
	SetMobileMod(this, "VitalityRegenPlus","Death", nil)

	this:SetMobileFrozen(false, false)

	if ( ServerSettings.Vitality.AdjustOnDeathEnd and not IsInitiate(this) and GetCurVitality(this) > 0 ) then
        AdjustCurVitality(this, ServerSettings.Vitality.AdjustOnDeathEnd)
	end
end

GHOST_HUE = "0xC100FFFF"
function TurnPlayerIntoGhost(shouldHueEquipment)
	-- force them out of combat
	this:SendMessage("EndCombatMessage")
	-- make them look like a ghost
	local hueTable = {}
	hueTable.SelfHue = this:GetColor()
	this:SetColor(GHOST_HUE)

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

	this:SetObjVar("OldHues",hueTable)
	this:SetObjVar("IsGhost",true)
	this:SetCloak(true)
end

function ChangePlayerBackFromGhost()
	local hueTable = this:GetObjVar("OldHues")
	if (hueTable ~= nil) then
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
	this:SetCloak(false)
end

baseMobileDeath = DoMobileDeath
function DoMobileDeath(damager)
	Verbose("PlayerDeath", "DoMobileDeath", damager, this)
	baseMobileDeath(damager)

	if ( damager ~= nil and damager ~= this and damager:IsPlayer() ) then
		damager:SystemMessage("[0AB4F7] You have vanquished [-][F70A79]" .. this:GetName(), "event")
	end

	mBackpack = this:GetEquippedObject("Backpack")

	-- close all open container windows in the players backpack
	if (mBackpack ~= nil) then
		CloseContainerRecursive(this,mBackpack)
	end

	-- GW if you are carrying something under the mouse cursor and die, it should drop to the ground
	local carriedObject = this:CarriedObject()
	if(carriedObject ~= nil and carriedObject:IsValid()) then
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
