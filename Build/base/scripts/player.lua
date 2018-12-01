-- The login region uses a custom player script (for character creation and starting region selection)
if(ServerSettings.WorldName=="Login") then
	require 'login_player'
	return
end

require 'base_mobile_advanced'
require 'base_mobile_restregen'
require 'base_skill_sys'
require 'base_mission_sys'
require 'base_player_hotbar'
require 'base_skill_tracker'
require 'base_player_charwindow'
require 'base_skill_window'
require 'base_prestige_window'
require 'base_allegiance_window'
require 'base_player_titles'
require 'base_player_achievement'
require 'base_player_quest_window'
require 'base_player_godwindow'
require 'base_player_mapwindow'
require 'base_player_keyring'
require 'base_player_death'
require 'base_player_buff_debuff'
require 'base_player_weather'
require 'scriptcommands'
require 'incl_player_group'
require 'incl_gametime'
require 'incl_mobile_helpers'
require 'incl_resource_source'
require 'incl_player_names'

require 'player_say_commands'
require 'player_starting_screen'

if(IsGod(this)) then
	require 'base_player_mobedit'
end

-- WEIGHT SYSTEM NOT REALLY IMPLEMENTED YET
maxCarryWeight = 1000000
maxTotalWeight = 1000000

carriedObjectSource = nil
carriedObjectSourceLoc = nil
carriedObjectSourceEquipSlot = nil
AUTOLOOT_DELAY = 1.0

currentRegionalName = nil

-- Overriding the base_mobile apply damage to check for pvp rules
local BaseHandleApplyDamage = HandleApplyDamage
function HandleApplyDamage(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected)
	Verbose("Player", "HandleApplyDamage", damager, damageAmount, damageType, isCrit, wasBlocked, isReflected)

	-- if we are being attacked by a player
	if ( IsPlayerCharacter(damager) or IsPet(damager) ) then
		if ( ServerSettings.PlayerInteractions.PlayerVsPlayerEnabled ~= true and damager ~= this and not IsGod(damager) ) then
			-- if pvp enabled, not damaging ourselves, and the damager is not a god, stop here (disabled PVP)
			return true
		end
	else
		-- autodefend against NPCs (auto defending against players could result in guard whack for both attacker and victim)
		this:SendMessage("ForceCombat", damager)
	end

	local newHealth = BaseHandleApplyDamage(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected)
	if(newHealth and newHealth > 0) then
		local magnitude = math.clamp(damageAmount/3, 1, 4)		
		
		--DebugMessage("Choice = "..tostring(choice))
		local doNotShakeScreenOnHit = this:GetObjVar("doNotShakeScreenOnHit")
		
		if(doNotShakeScreenOnHit) then

		else
			--this:PlayLocalEffect(this,"ScreenShakeEffect", 0.3,"Magnitude="..magnitude)
		end
		
		local healthRatio = (newHealth/GetMaxHealth(this))
		local choice = 1
		if(healthRatio <= 0.2) then
			choice = 2
		end
		
		this:PlayLocalEffect(this,"BloodSplatter"..choice.."Effect", 1)				
	end

	return newHealth
end

--On resurrection
OverrideEventHandler("default:base_mobile",EventType.Message, "Resurrect", 
	function (statPercent, resurrector, force)
		if( not(IsDead(this)) ) then return end

		if ( not(force) ) then
			-- confirm they want to be resurrected from their ghost
			local extraInfo = "You will be given a new body"
			if ( ServerSettings.PlayerInteractions.FullItemDropOnDeath ) then
				extraInfo = extraInfo .. " with none of your previous items." -- naked af, birthday suit tho
			else
				extraInfo = extraInfo .. " with what you were wearing on death."
			end
			this:SetMobileFrozen(true,true)
			ClientDialog.Show{
			    TargetUser = this,
			    DialogId = "ResurrectDialog",
			    TitleStr = "You are being resurrected.",
			    DescStr = "Would you like to be resurrected from your ghost? " .. extraInfo,
			    Button1Str = "Yes",
			    Button2Str = "No",
			    ResponseFunc = function (user, buttonId)
					buttonId = tonumber(buttonId)
					this:SetMobileFrozen(false,false)
					if( buttonId == 0) then
						DoResurrect(statPercent, resurrector)						
					end
				end
			}
		else
			DoResurrect(statPercent, resurrector, force)
		end		
	end)


-- this function checks range of the topmost object from this player
function IsInRange(targetObj)
	Verbose("Player", "IsInRange", targetObj)
	local userPos = this:GetLoc()
	local dropLoc = nil

	local topmostObj = targetObj:TopmostContainer() or targetObj

	local dropRange = topmostObj:GetObjVar("DropRange")
	if(topmostObj:GetLoc():Distance(userPos) > (dropRange or OBJECT_INTERACTION_RANGE) ) then		
		return false
	end

	return true
end

function CanPickUp(targetObj,quiet,isQuickLoot)
	Verbose("Player", "CanPickUp", targetObj,quiet,isQuickLoot)
	--DebugMessage("It is calling this function")	
	if (IsDead(this)) then return false end

	if not(IsInRange(targetObj)) then
		if(IsImmortal(this)) then
			this:SystemMessage("Your godly powers allow you to reach that.","info")
		else
			if not(quiet) then
				this:SystemMessage("You cannot reach that.","info")
			end
			return false
		end
	end

	-- dont even let gods pick these up since it can mess up the object
	if( IsLockedDown(targetObj) or targetObj:GetSharedObjectProperty("DenyPickup") == true) then
		if not(quiet) then
			this:SystemMessage("You cannot pick that up.","info")
		end
		return false
	end	

	if (mapWindowOpen) then
		if (targetObj == this:GetObjVar("ActiveMap")) then
			CloseMap()
		end
	end

	-- and we can pick it up
	local weight = targetObj:GetSharedObjectProperty("Weight")

	-- note: even gods should not be able to pick up -1 weight items normally	
	if( weight == nil or weight == -1 ) then
		if not(quiet) then
			this:SystemMessage("You cannot pick that up.","info")
		end
		return false
	end

	--DFB HACK: Pickpocketing checks
	local topCont = targetObj:TopmostContainer() or this
	--if it's a mailbox and it's locked down then
	--DebugMessage(1)
	if (topCont:HasObjVar("IsMailbox") and topCont:GetObjVar("LockedDown")) then
	--if I'm not the owner
		--DebugMessage(2)
		if (not Plot.IsOwnerForLoc(this,topCont:GetLoc())) then
			--DebugMessage(3)
			this:SystemMessage("You can't pick up someone else's mail.","info")
			return false
		end
	end 

	--Used for stealing skill
	if (targetObj:HasObjVar("StealingDifficulty")) then
		this:SystemMessage("This object does not belong to you.","info")
		return false
	end
	--DebugMessage("topCont is "..tostring(topCont:GetName()))
	--if (not this:HasModule("ska_pickpocket")) then
	--DebugMessage("Really big check:",topCont ~= nil,topCont:IsMobile(),(topCont:IsPlayer() or not(IsDead(topCont))),topCont ~= this,not(IsDemiGod(this)))
	if(topCont ~= nil and topCont:IsMobile()
		and (topCont:IsPlayer() or not(IsDead(topCont)))
		and topCont ~= this and not(IsDemiGod(this))) then
		local owner = GetHirelingOwner(topCont) or topCont:GetObjVar("controller")
			--DebugMessage("Smaller check: ",owner ~= this)
		if(owner ~= this) then
			if not(quiet) then
					--DebugMessage("Yep that's it.")
				this:SystemMessage("You cannot pick that up.","info")
			end		
			return false
		end
	end
	--elseif (this:HasModule("ska_pickpocket") and topCont:IsMobile() and (not IsDead(topCont)) and (not (topCont == this))) then
	--	this:SendMessage("PickPocketRoll")
		--DebugMessage("Pick pocket roll")
	--end
	--DebugMessage("Result: ",this:HasModule("ska_pickpocket"),topCont:IsMobile(),(not IsDead(topCont)),(topCont == this))
	if ( targetObj:HasObjVar("noloot") ) then
		if IsGod(this) == false then
			this:SystemMessage("You cannot pick that up.","info")
			return false
		end
		this:SystemMessage("Your godly powers allow you to loot a noloot.","info")
	end

	if ( ( topCont:HasObjVar("noloot") or topCont:HasObjVar("guardKilled") ) and (IsDemiGod(this) == false)) then
		this:SystemMessage("You can't pick that up.","info")
		return false
	end

	--DebugMessage("topCont is "..tostring(topCont))
	if (not this:HasLineOfSightToObj(topCont,ServerSettings.Combat.LOSEyeLevel)) then
		this:SystemMessage("Cannot see that.","info")
		return false
	end

	-- make sure this item is not in a container that is for sale
	local inSaleContainer = false
    ForEachParentContainerRecursive(targetObj,false,
        function (parentObj)
            if(parentObj:HasModule("hireling_merchant_sale_item")) then                
                inSaleContainer = true
                return false
            end
            return true
        end)

    if(inSaleContainer) then
        this:SystemMessage("[$2402]","info")
        return false
    end

    -- make sure it's not in a locked container
    local lockedContainer = nil
    ForEachParentContainerRecursive(targetObj,false,
        function (parentObj)
            if( parentObj:HasObjVar("locked") ) then                
                lockedContainer = parentObj
                return false
            end
            return true
        end)

    if( lockedContainer ~= nil ) then
		if ( not lockedContainer:HasObjVar("SecureContainer") or not Plot.HasObjectControl(this, lockedContainer, lockedContainer:HasObjVar("FriendContainer")) ) then
	        this:SystemMessage("That is in a locked container.","info")
	        return false
    		end
    	end

    -- only block items inside containers inside the trade window
    local isTrade, depth = IsInTradeContainer(targetObj)
    if(isTrade and depth > 0) then
    	return false
    end

	return true
end

function UpdateName()
	Verbose("Player", "UpdateName")
	local charName = ColorizePlayerName(this, this:GetName() .. GetNameSuffix())
	this:SetSharedObjectProperty("DisplayName", charName)
end

function UpdateTitle()
	Verbose("Player", "UpdateTitle")
	-- DAB NOTE: THIS WILL CHANGE YOUR TITLE IF YOU GET A NEW ACCOUNT BASED TITLE
	local titleIndex = this:GetObjVar("titleIndex") or 1
	local oldTitle = GetActiveTitle(playerObj)
	local allTitles = GetAllAchievementsObtained(playerObj, true)

	if(titleIndex == nil) then titleIndex = #allTitles end

	titleIndex = math.min(titleIndex,#allTitles)
	--DebugMessage("Alphamaan")
	if( titleIndex ~= 0 ) then
		--DebugMessage("Betamaan")
		local newTitle = allTitles[titleIndex].Title
		if( oldTitle ~= newTitle ) then
			--DebugMessage("Cetamaan")
			this:SetObjVar("titleIndex",titleIndex)
			this:SetSharedObjectProperty("Title", newTitle)
			this:SystemMessage("Your title has been set to "..newTitle,"info")
			SetTooltipEntry(this,"Title",newTitle,100)
		end		
	elseif(oldTitle ~= "") then
		this:SetObjVar("titleIndex",titleIndex)		
		this:SetSharedObjectProperty("Title", "")
		RemoveTooltipEntry(this,"Title")
		this:SystemMessage("Your title has been cleared.","info")
	end

	this:SendMessage("UpdateCharacterWindow")
end

function UpdateChatChannels()
	-- each entry in the chat channels is the name and command in array form
	local chatChannels = { {"Say","say"} }
	local guild = Guild.Get(this)
	if(guild ~= nil) then
		table.insert(chatChannels,{ "Guild", "g" })
	end
	local groupId = GetGroupId(this)
	if ( groupId ~= nil and GetGroupVar(groupId, "Leader") ~= nil ) then
		table.insert(chatChannels,{ "Group", "group" })
	end
	--DebugMessage("UpdateChatChannels: "..DumpTable(chatChannels))
	this:SendClientMessage("UpdateChatChannels",chatChannels)

	--DAB HACK: Fix to make sure players have the correct chat channels until we can fix it correctly
	-- The bug was the ChatChannelSelector on the client was not initialized right when the client loads in
	-- We need to delay client messages until Unity is fully loaded
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(60 + math.random()),"UpdateChatChannels")
end

function TryHarvestItem(objRef)
	if( not(objRef) or not(objRef:IsValid()) ) then return end

	if (IsMobileDisabled(this)) then 
		this:SystemMessage("Cannot harvest now", "info")
		return 
	end

	local requiredTool = GetRequiredTool(objRef)
	if( requiredTool ~= nil ) then
		local toolObj = nil
		if( requiredTool == "BareHands" ) then
			toolObj = this		
		else			
			local weapon = this:GetEquippedObject("RightHand")
			
			if( weapon ~= nil and weapon:GetObjVar("ToolType") == requiredTool) then
				toolObj = weapon
			else
				toolObj = GetHarvestToolInBackpack(this,requiredTool)
			end
		end

		if( toolObj ~= nil ) then
			-- bare hands are also a tool and attached to player
			toolObj:SendMessage("HarvestObject",objRef,this)
			return true
		else
			this:SystemMessage("You need a "..requiredTool.." to harvest that.","info")
		end
	end

	return false
end

function UpdateTooltip()
	-- DAB TODO: Only show this if we are on Uaran
	local kills = this:GetObjVar("PlayerKills") or 0
	local deaths = this:GetObjVar("PlayerDeaths") or 0
	local loyalty = this:GetObjVar("LifetimePvPLoyalty") or 0

	local tooltipStr = ""
	if( kills > 0 or deaths > 0 ) then		
		tooltipStr = tooltipStr .. "Kills/Deaths: "..kills.."/"..deaths
	end

	if( loyalty > 0 ) then
		if(tooltipStr ~= "") then
			tooltipStr = tooltipStr .. "\n"
		end
		tooltipStr = tooltipStr .. "Lifetime Loyalty: "..loyalty
	end

	SetTooltipEntry(this,"pvp_stats", tooltipStr)
end

function HandleRequestPickUp(pickedUpObject)
	--DebugMessage("Tried to pick up "..pickedUpObject:GetName())
	local carriedObject = this:CarriedObject()
	if( carriedObject ~= nil and carriedObject:IsValid() and pickedUpObject ~= carriedObject) then
		this:SystemMessage("You are already carrying something.","info")
		this:SendPickupFailed(pickedUpObject)
		return
	end

	if not(CanPickUp(pickedUpObject)) then
		this:SendPickupFailed(pickedUpObject)
		return
	end
	--DebugMessage("Pick up here")
	this:SendMessage("BreakInvisEffect", "Pickup")

	-- keep track of the source location so we can undo the pickup
	local sourceContainer = pickedUpObject:ContainedBy()
	local sourceTopmost = pickedUpObject:TopmostContainer() or sourceContainer
	local sourceLoc = pickedUpObject:GetLoc()
	local sourceEquipSlot = nil
	local equipSlot = GetEquipSlot(pickedUpObject)
	--check to see if the containers have noloot on them
	if (sourceContainer ~= nil) then 
		if (sourceContainer:HasObjVar("noloot") and (IsDemiGod(this) == false)) then
			this:SystemMessage("You can't pick that up.","info")
			this:SendPickupFailed(pickedUpObject)
			return
		end
	end
	if sourceTopmost ~= nil then
		if sourceTopmost:HasObjVar("noloot") and (IsDemiGod(this) == false) then
			this:SystemMessage("You can't pick that up.","info")
			this:SendPickupFailed(pickedUpObject)
			return
		end
		if ( CheckKarmaLoot(this, sourceTopmost) == false ) then
			this:SendPickupFailed(pickedUpObject)
			return
		end
	end
	
	--GW we may have just died instantly due to insta whack guards, and the karma check above
	if( IsDead(this)) then
		this:SendPickupFailed(pickedUpObject)
		return
	end
	if (sourceContainer == nil or sourceContainer ~= this:GetEquippedObject("Backpack")) then
		local weight = pickedUpObject:GetSharedObjectProperty("Weight")
		local canAdd,weightCont,maxWeight = CanAddWeightToContainer(this:GetEquippedObject("Backpack"),weight)
		if ( not canAdd) then
			if not (IsImmortal(this)) then
				this:SystemMessage("You are carrying too much (Max: " .. tostring(maxWeight) .. " stones)","info")
				SetMobileMod(this, "Disable", "OverweightPickup", true)
				AddBuffIcon(this,"Overweight","Overweight","steal","Cannot move again until item is dropped.")
			end
		end
	end
	if(equipSlot ~= nil and this:GetEquippedObject(equipSlot) == pickedUpObject) then
		sourceEquipSlot = equipSlot
	end

	if( pickedUpObject:MoveToContainer(this,Loc(0,0,0)) ) then
		if(pickedUpObject:DecayScheduled()) then
			pickedUpObject:RemoveDecay()
		end

		carriedObjectSource = sourceContainer
		carriedObjectSourceLoc = sourceLoc
		carriedObjectSourceEquipSlot = sourceEquipSlot
		if(sourceEquipSlot ~= nil) then
			pickedUpObject:SendMessage("WasUnequipped", this)
		end
	end
end

-- will attempt to return the carried object back to its source container and location
function UndoPickup()
	local carriedObject = this:CarriedObject()
	if( carriedObject ~= nil and carriedObject:IsValid() ) then
		if(carriedObjectSource ~= nil and carriedObjectSource:IsValid()) then
			if(carriedObjectSource == this and carriedObjectSourceEquipSlot ~= nil) then
				DoEquip(carriedObject,this)
			else
				local destLoc = carriedObjectSourceLoc or GetRandomDropPosition(carriedObjectSource)
				TryPutObjectInContainer(carriedObject, carriedObjectSource, destLoc)
			end
		elseif(carriedObjectSourceLoc ~= nil) then
			carriedObject:SetWorldPosition(carriedObjectSourceLoc)
		end
	end
end

function DropInWorld(droppedObject,dropLocation)
	droppedObject:SetWorldPosition(dropLocation)
	Decay(droppedObject, ServerSettings.Misc.ObjectDecayTimeSecs)
end

function HandleRequestDrop(droppedObject, dropLocation, dropObject, dropLocationSpecified)

	if( not droppedObject:IsBeingCarriedBy(this) ) then
		-- something really bad happened
		DebugMessage("LUA ERROR: Tried to drop object that is not that players carried object!")
		this:SendPickupFailed(droppedObject)
		return
	end
	if( dropObject ~= nil and dropObject:IsValid() ) then		
		-- if we are dropping this on ourself put it in the backpack
		if( dropObject == this ) then
			local backpackObj = this:GetEquippedObject("Backpack")
			if( backpackObj ~= nil ) then				
				dropObject = backpackObj
			else
				return
			end
		-- confirm that the drop object is not too far away
		elseif not(IsInRange(dropObject)) then
			this:SystemMessage("Too far away.","info")
			return
		end
		
		if ( dropObject:HasObjVar("HandlesDrop") ) then
			local resourceType = dropObject:GetObjVar("ResourceType")
			if ( resourceType ~= nil and ResourceEffectData[resourceType] and ResourceEffectData[resourceType].MobileEffectDropHandle ) then
				StartMobileEffect(this, ResourceEffectData[resourceType].MobileEffectDropHandle, dropObject, droppedObject)
			else
				dropObject:SendMessage("HandleDrop",this,droppedObject)
			end
		elseif( dropObject:IsContainer() ) then
	        -- mortals and immortals can't drop into another mobile's pack	  
			local topCont = dropObject:TopmostContainer() or dropObject

			if ( topCont:IsMobile() and not(IsInPetPack(dropObject,this,topCont,true)) ) then
				if ( not IsDemiGod(this) or TestMortal(this) ) then
					if ( IsDead(topCont) ) then
						if ( topCont == dropObject ) then
							-- disallow dropping stuff directly onto a corpse
							this:SystemMessage("Cannot drop items onto a corpse.", "info")
							return
						end
					elseif( topCont ~= this ) then
						if ( topCont:HasObjVar("HasPetPack") ) then
							dropObject = topCont:GetEquippedObject("Backpack")
							if ( dropObject == nil ) then
								this:SystemMessage("That pet does not have a pack.","info")
								return
							end
						else
							this:SystemMessage("Cannot drop that onto someone else's pack.","info")
							return
						end
					end
				end
			end

			local grant = false
			-- check if the container we are dropping onto is locked
			if( dropObject:HasObjVar("locked") ) then
				-- allow plot secure containers to work like unlocked containers only for those with permission
				if ( dropObject:HasObjVar("SecureContainer") ) then
					grant = Plot.HasObjectControl(this, dropObject, dropObject:HasObjVar("FriendContainer"))
					end
			else
				grant = true
				end

			-- also apply the same check to the topmost container
			if ( grant and topCont ~= dropObject and topCont:HasObjVar("locked") ) then
				grant = false
				if ( topCont:HasObjVar("SecureContainer") ) then
					grant = Plot.HasObjectControl(this, topCont, topCont:HasObjVar("FriendContainer"))
				end
			end

			if not( grant ) then
				this:SystemMessage("Container is Locked.", "info")
				return
			end

			-- stop players from putting things other than food into a cooking pot
			if ( dropObject:HasModule("cooking_crafting") and not IsIngredient(droppedObject) ) then
				this:SystemMessage("That cannot be cooked.", "info")
				return
			end

			if( not(IsDemiGod(this)) and dropObject:HasObjVar("merchantContainer") ) then
				this:SystemMessage("You are not allowed to do that.","info")
				return
			end

			-- if we got a nil drop pos we pick a random position in the container
			if not(dropLocationSpecified) then
				-- didnt stack so put in random location
				dropLocation = GetRandomDropPosition(dropObject)
			end
			local canHold, reason = TryPutObjectInContainer(droppedObject, dropObject, dropLocation, IsDemiGod(this), not(dropLocationSpecified))
			if( not canHold ) then
				-- DAB TODO: Distinguish between full container and not a container
				this:SystemMessage("You cannot drop that there. "..(reason or ""),"info")
				return
			end
		
		else
			local dropContainer = dropObject:ContainedBy()
			if( dropContainer ~= nil ) then
				if(not dropLocationSpecified) then
					dropLocation = dropObject:GetLoc()
				end
				if (dropObject ~= nil) then
					local canHold, reason = TryPutObjectInContainer(droppedObject, dropContainer, dropLocation, IsDemiGod(this), true)
					if( not canHold ) then
						this:SystemMessage("You cannot drop that there. "..(reason or ""),"info")
						return
					end
					if( CanStack(dropObject,droppedObject) ) then
						RequestStackOnto(dropObject,droppedObject)
					end
				end
			else
				if( CanStack(dropObject,droppedObject) ) then
					RequestStackOnto(dropObject,droppedObject)
				else
					if not(dropLocationSpecified) then
						dropLocation = dropObject:GetLoc()
					end
					--DebugMessage(tostring(dropLocation) .." is drop location")
					DropInWorld(droppedObject,dropLocation)
				end
			end
		end
	elseif( dropLocation ~= nil ) then
		if(this:GetLoc():Distance(dropLocation) > OBJECT_INTERACTION_RANGE ) then		
			this:SystemMessage("You cannot reach that.","info")
			return
		end

		DropInWorld(droppedObject,dropLocation)
	end	
	RemoveBuffIcon(this, "Overweight")
	SetMobileMod(this, "Disable", "OverweightPickup", nil)
end

function HandleRequestEquip(equipObject, equippedOn)
	local topmostObj = equipObject:TopmostContainer()
	if(topmostObj ~= this) then
		this:SystemMessage("You can only equip things you are already carrying","info")
		return
	end
	DoEquip(equipObject,equippedOn,this)
end

--[[function UpdateFactions()
	local friendlyFactions = ""
	for i,faction in pairs(Factions) do
		local minFriendlyLevel = faction.MinFriendlyLevel
		local curFaction = this:GetObjVar(faction.InternalName .. "Favorability") or 0
		if (curFaction >= minFriendlyLevel) then
			friendlyFactions = friendlyFactions ..",".. faction.InternalName
		end
	end
    --DebugMessage("FriendlyFactions"..friendlyFactions)
	this:SetSharedObjectProperty("FriendlyFactions",friendlyFactions)
end]]

-- DAB TODO: We should make locking other objects stats as a separate function since it should
-- be for GOD characters only
function HandleLockStatRequest(myStat,targetObjId)	
	local myTarg = this
	if not (targetObjId == nil) then
		local targObj = GameObj(tonumber(targetObjId))
		if(targObj == nil) or not(targObj:IsValid()) then
			this:SystemMessage("Invalid set target","info")
			return
		end
		myTarg = targObj
	end
	local mySname =string.sub(myStat,2,3)
	local mySstart = string.sub(myStat,1,1)
	myStat = string.upper(mySstart) .. string.lower(mySname)
	myTarg:SetObjVar(myStat .. "Lock", true)
	if(myTarg:IsPlayer()) then
		myTarg:SystemMessage(myTarg:GetName() .. " locked ".. myStat,"info") 
	end
end

function HandleUnlockStatRequest(myStat,targetObjId)	
	local myTarg = this
	if not (targetObjId == nil) then
		local targObj = GameObj(tonumber(targetObjId))
		if(targObj == nil) or not(targObj:IsValid()) then
			this:SystemMessage("Invalid set target","info")
			return
		end
		myTarg = targObj
	end
	local mySname =string.sub(myStat,2,3)
	local mySstart = string.sub(myStat,1,1)
	myStat = string.upper(mySstart) .. string.lower(mySname)
	if(myTarg:HasObjVar(myStat .. "Lock")) then
		myTarg:DelObjVar(myStat .. "Lock")
	end
	if(myTarg:IsPlayer()) then
		myTarg:SystemMessage(myTarg:GetName() .. " unlocked ".. myStat,"info") 
	end
end	

function DoUse(usedObject,usedType)
	if (usedObject == nil or not usedObject:IsValid()) then return end

	if (not(IsInCombat(this)) and usedObject:HasModule("merchant_sale_item") == true and usedType == "Attack") then
		usedType = usedObject:GetSharedObjectProperty("DefaultInteraction")
	end

	--If the object is in a locked container, players cannot use it
	if (usedType ~= "God Info" and usedObject:IsInContainer()) then
		local container = usedObject:ContainedBy()
		local key = GetKey(this,container)
		if (container:GetObjVar("locked")) then
			-- Secure Containers allow a user to open and view contents without unlocking and rendering the container vulnerable
			if ( not container:HasObjVar("SecureContainer") or not Plot.HasObjectControl(this, container, container:HasObjVar("FriendContainer")) ) then
				this:SystemMessage("That is in a locked container.","info")
				return
			end
		end
	end

	--Load the use case ranges from use_cases.lua	
	local usedCaseRange = OBJECT_INTERACTION_RANGE
	local topmost = usedObject

	if not(usedObject:IsPermanent()) then
		if( IsDead(this) and not usedObject:HasObjVar("UseableWhileDead")) then
			return
		end

		topmost = usedObject:TopmostContainer() or usedObject
		if (AllUseCases[usedType] ~= nil) then
			usedCaseRange = AllUseCases[usedType].Range or OBJECT_INTERACTION_RANGE
			if (AllUseCases[usedType].Restriction == "God" and not IsGod(this)) then
				DebugMessage("WARNING: Player "..this:GetName().." attempted to use a use case restricted to gods! usedType is "..tostring(usedType))
				return
			end
			if (AllUseCases[usedType].Restriction == "Immortal" and not IsGod(this)) then
				DebugMessage("WARNING: Player "..this:GetName().." attempted to use a use case restricted to immortals! usedType is "..tostring(usedType))
				return
			end
			if (AllUseCases[usedType].Restriction == "DemiGod" and not IsGod(this)) then
				DebugMessage("WARNING: Player "..this:GetName().." attempted to use a use case restricted to demigods! usedType is "..tostring(usedType))
				return
			end
		end

		if(IsInTradeContainer(usedObject) and (not(usedObject:IsContainer()) or usedType ~= "Open")) then
			return
		end
	else
		if( IsDead(this) ) then
			return
		end
	end

	if (this:GetLoc():Distance2(topmost:GetLoc()) > usedCaseRange and not IsGod(this)) then
		this:SystemMessage("You are too far to do that.","info")
		return 
	end

	--DebugMessage("DoUse: "..tostring(usedObject)..", "..tostring(usedType))
	if(usedObject:IsValid()) then
		if(usedObject:IsPermanent()) then			
			--DebugMessage("DoUsePermanent",this:GetName(),tostring(usedObject),tostring(usedObject:GetSharedObjectProperty("ResourceSourceId")),tostring(usedType))

			-- right now the only thing you can do with permanents is harvest
			TryHarvestItem(usedObject)
		else
			if(usedType == nil or usedType == "") then
				usedType = usedObject:GetSharedObjectProperty("DefaultInteraction") or "Use"
			end

			--DebugMessage("DoUse",this:GetName(),tostring(usedObject),usedObject:GetName(),tostring(usedType))
			if(usedType == "Character") then
				this:SendMessage("OpenCharacterWindow")
			elseif(usedType == "Stand") then
				this:SendMessage("StopSitting")
				this:SetWorldPosition(this:GetObjVar("PositionBeforeUsing"))
				RemoveUseCase(this, "Stand")
			elseif(usedType == "Wake Up") then
				this:SendMessage("WakeUp")
				this:SetWorldPosition(this:GetObjVar("PositionBeforeUsing"))
				RemoveUseCase(this, "Wake Up")
			elseif(usedType == "Inspect" or usedType == "Disrobe") then
				OpenInspectWindow(usedObject)
			elseif (usedType == "Kick from Group") then
				local groupId = GetGroupId(usedObject)
				if ( groupId ~= nil and GetGroupVar(groupId, "Leader") == this ) then
					GroupRemoveMember(groupId, usedObject)
				end
			elseif (usedType == "Invite to Group") then
				GroupInvite(this, usedObject)
			elseif (usedType == "Group") then
				if ( this:HasModule("group_ui") ) then
					this:SendMessage("GroupUpdate")
				else
					this:AddModule("group_ui")
				end
			elseif (usedType == "Invite to Guild") then
				Guild.Invite(this, usedObject)				
			elseif (usedType == "Trade") then
				if(IsInActiveTrade(this)) then
					this:SystemMessage("You already have an active trade in progress.","info")
				elseif(IsInActiveTrade(usedObject)) then
					this:SystemMessage("The target already has an active trade in progress.","info")
				else
					this:AddModule("trading_controller",{TradeTarget=usedObject})
				end
			elseif (usedType == "Duel") then
				DuelInvite(usedObject)
			elseif (usedType == "Loot All") then
				local targetContainer = usedObject
				if (targetContainer:IsMobile()) then	
					local backpackObj = targetContainer:GetEquippedObject("Backpack")    
					if(backpackObj) then
						targetContainer = backpackObj
					end
				elseif (targetContainer:IsContainer()) then
					if(targetContainer:HasObjVar("locked")) then
						if ( not targetContainer:HasObjVar("SecureContainer") or not Plot.HasObjectControl(this, targetContainer, targetContainer:HasObjVar("FriendContainer")) ) then
				    	   this:SystemMessage("That appears to be locked.","info")
				    	   return
				        end
				    end
				end
				StartLootAll(targetContainer)
			elseif (usedType == "God Info") then
				if (IsDemiGod(this)) then
					DoInfo(usedObject)
				else
					DebugMessage("WARNING: Player "..this:GetName().." attempted to open a god info window for "..usedObject:GetName()..", player is not a God character.")
				end
			elseif (usedType == "Edit Mob") then
				if(IsGod(this)) then
					DoMobEdit(usedObject)
				end
			elseif(usedType == "Pick Up" or usedType == "God Pick Up") then
				HandleRequestPickUp(usedObject)
			elseif(usedType == "Quick Loot") then
				ProgressBar.Show{TargetUser=this,Label="Looting",Duration=AUTOLOOT_DELAY}
				this:ScheduleTimerDelay(TimeSpan.FromSeconds(AUTOLOOT_DELAY),"autolootitem",usedObject,usedObject:ContainedBy())
			elseif(usedType == "Harvest" or usedType == "Chop" or usedType == "Mine" or usedType == "Skin" or usedType == "Forage") then
				TryHarvestItem(usedObject)
			-- DAB TODO: Handle gods and subordinates
			elseif(usedType == "Equip") then
				if(usedObject:TopmostContainer() ~= this) then
					this:SystemMessage("[$2404]","info")
				else
					DoEquip(usedObject,this)
				end
			elseif (usedType == "Tame") then
				if not( HasMobileEffect(this, "Tame") ) then
					StartMobileEffect(this, "Tame", usedObject)
				end
			elseif (usedType == "Attack") then
				--DebugMessage("Getting here.")
				this:SendMessage("AttackTarget",usedObject)
			elseif(usedType == "Unequip") then
				if(usedObject:IsEquippedOn(this)) then
					user:SystemMessage("You can only unequip items from yourself.","info")
				else
					DoUnequip(usedObject,this)
				end
			-- always try to harvest objects with a resource source id
			elseif(usedObject:HasObjVar("ResourceSourceId") and usedType == "Use") then
				if not(TryHarvestItem(usedObject)) then
					usedObject:SendMessage("UseObject",this,usedType)
				end
			elseif( ValidResourceUseCase(usedObject, usedType) ) then
				TryUseResource(this, usedObject, usedType)
			else
				usedObject:SendMessage("UseObject",this,usedType)
			end
		end		
	end
end

function HandleUseCommand(usedObjectId,...)
	if( usedObjectId == nil ) then return end
	local usedObject = GameObj(tonumber(usedObjectId))
	-- the use type can contain spaces so combine it since its the last argument
	local usedType = CombineArgs(...)
	DoUse(usedObject,usedType)
end

function HandleUsePermanentCommand(permanentId,usedType)
	if( permanentId == nil ) then return end
	local usedObject = PermanentObj(tonumber(permanentId))
	
	DoUse(usedObject,usedType)
end

function HandleUseResourceCommand(resourceType)
	if ( resourceType == nil or resourceType == "" or IsDead(this) ) then return end

	local backpackObj = this:GetEquippedObject("Backpack")
	if ( backpackObj ~= nil ) then
		local resourceObj = FindItemInContainerRecursive(backpackObj, function(item)
			--Check if resource is in a locked container
			if (item:GetObjVar("ResourceType") == resourceType) then            
				if (item:IsInContainer()) then
					local container = item:ContainedBy()
					if (container:GetObjVar("locked")) then
						this:SystemMessage("That is in a locked container.","info")
						return false
					end
				end
				return true
			end
			return false
           --return item:GetObjVar("ResourceType") == resourceType
        end)

		if ( resourceObj ~= nil ) then TryUseResource(this, resourceObj) end
	end
end

RegisterEventHandler(EventType.CreatedObject,"NewLootStack",function (success,objRef,amount)
	if (success) then
		RequestSetStack(objRef,amount)
	end
end)

function AutolootItem(objRef,quiet)
	if not(CanPickUp(objRef,quiet)) then
		return
	end

	local sourceContainer = objRef:TopmostContainer() or objRef
	if ( CheckKarmaLoot(this, sourceContainer) == false ) then
		return
	end

	--GW we may be dead from insta whack guards and the karma check
	if (IsDead(this)) then
		return
	end

	-- and we are wearing a backpack
	local backpackObj = this:GetEquippedObject("Backpack")
	if( backpackObj == nil ) then		
		return
	end	
	
	local topmostContainer = objRef:TopmostContainer()
	if (topmostContainer ~= nil) then
		if (not this:HasLineOfSightToObj(topmostContainer,ServerSettings.Combat.LOSEyeLevel)) then
			this:SystemMessage("Cannot see that.","info")
			return
		end
	end

	-- look for lootbags
	local lootBag = FindItemInContainer(backpackObj,function(containedObj)
			return containedObj:HasObjVar("LootBag") and not this:HasObjVar("locked")
		end)

	local targetContainer = lootBag or backpackObj
	--DebugMessage(1)
	if not(CanAddWeightToContainer(targetContainer,GetWeight(objRef))) then
		--DebugMessage(2)
		this:SystemMessage("Your backpack cannot hold any more weight!","info")			
		return
	end
	-- try to autostack
	if( TryStack(objRef, targetContainer) ) then
		local resourceType = objRef:GetObjVar("ResourceType")
		local num = 1
		if ( resourceType == "coins" ) then
			num = GetAmountStr(objRef:GetObjVar("Amounts"),false,true)
		elseif ( IsStackable(objRef) ) then
			num = GetStackCount(objRef)
		end
		this:NpcSpeech("[F4FA58]+"..num.." "..StripColorFromString(GetResourceDisplayName(resourceType)).."[-]","combat")
		return
	end

	local dropLocation = GetRandomDropPosition(targetContainer)
	local canHold, reason = TryPutObjectInContainer(objRef, targetContainer, dropLocation, IsDemiGod(this), false)
	if( not canHold ) then
		if not(quiet) then
			this:SystemMessage("You cannot drop that there. "..(reason or ""),"info")
		end
		return
	else
		this:NpcSpeech("[F4FA58]Looted "..StripColorFromString(objRef:GetName()).."[-]","combat")
		if(objRef:DecayScheduled()) then
			objRef:RemoveDecay()
		end
	end
end

RegisterEventHandler(EventType.Timer,"autolootitem",
	function (objRef, containerObj)
		if( objRef:ContainedBy() == containerObj and CanPickUp(objRef)) then 
			AutolootItem(objRef)
		end
	end)

function HandleAutoLootCommand(usedObjectId)
	if( usedObjectId == nil ) then return end

	local usedObject = GameObj(tonumber(usedObjectId))
	if(usedObject:IsValid()) then
		-- if the item is in a corpse
		local topCont = usedObject:TopmostContainer() or usedObject
		if( topCont ~= this and CanPickUp(usedObject)) then
			ProgressBar.Show{TargetUser=this,Label="Looting",Duration=AUTOLOOT_DELAY}
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(AUTOLOOT_DELAY),"autolootitem",usedObject,usedObject:ContainedBy())
		-- otherwise if it is in one of the player's containers
		elseif( topCont == this and usedObject:ContainedBy() ~= this) then
			-- and its equippable
			if( GetEquipSlot(usedObject) ~= nil and GetEquipSlot(usedObject) ~= "Backpack") then
				DoEquip(usedObject,this)
			end
		end
	end
end

RegisterEventHandler(EventType.Timer,"autolootall",
	function (lootItems, containerObj)		
		local newLootItems = {}

		local looted = false
		for i,lootItem in pairs(lootItems) do
			if( lootItem:ContainedBy() == containerObj ) then
				if not(looted) then 
					AutolootItem(lootItem)
					looted = true
				else
					table.insert(newLootItems,lootItem)
				end
			end
		end

		if(#newLootItems > 0) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(AUTOLOOT_DELAY),"autolootall",newLootItems,containerObj)
		else
			ProgressBar.Cancel("Looting",this)
		end
	end)

RegisterEventHandler(EventType.Timer,"autolootall_timeout",
	function (args)
		this:RemoveTimer("autolootall")
	end)

function StartLootAll(targetContainer)

	if(targetContainer == nil) then
		return
	end

	if not(targetContainer:IsValid()) then
		return 
	end

	if not(targetContainer:IsContainer()) then 
		AutolootItem(targetContainer,false)
		return
	end	

	local topmostContainer = targetContainer:TopmostContainer()
	if (topmostContainer ~= nil) then
		if (not this:HasLineOfSightToObj(topmostContainer,ServerSettings.Combat.LOSEyeLevel)) then
			this:SystemMessage("Cannot see that.","info")
			return
		end
	end

	local topmostContainer = targetContainer:TopmostContainer() or targetContainer
	if((topmostContainer:HasObjVar("noloot")
			or topmostContainer:HasObjVar("guardKilled")
			or topmostContainer:HasObjVar("locked"))and (IsDemiGod(this) == false)) then
		this:SystemMessage("You can't loot that.","info")
		return
	end	

	if(topmostContainer:IsMobile() and not(IsDead(topmostContainer)))	 then
		this:SystemMessage("That's still alive.","info")
		return	
	end

	local lootItems = {}

	for i,objRef in pairs(targetContainer:GetContainedObjects()) do
		if(CanPickUp(objRef,true)) then
		    table.insert(lootItems,objRef)
		end
	end

	if(#lootItems == 0) then
		this:SystemMessage("You find nothing of value in that container.","info")
	else
		this:SendMessage("BreakInvisEffect", "Pickup")
		local lootDuration = AUTOLOOT_DELAY * #lootItems
		ProgressBar.Show({TargetUser=this,Label="Looting",Duration=TimeSpan.FromSeconds(lootDuration)})
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(AUTOLOOT_DELAY),"autolootall",lootItems,targetContainer)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(lootDuration+AUTOLOOT_DELAY),"autolootall_timeout")
	end
end

function HandleLootAllCommand(targetContainer)
	local targetContainerObj = GameObj(tonumber(targetContainer))
	if (not targetContainerObj:IsValid()) then return end

	if ( targetContainerObj:IsMobile() ) then
		local backpackObj = targetContainerObj:GetEquippedObject("Backpack")
		if ( backpackObj ~= nil ) then
			targetContainerObj = backpackObj
		end
	end

	StartLootAll(targetContainerObj)
end

function HandleEquipCommand(equippedObj)
	local equippedObj = GameObj(tonumber(equippedObj))
	local backpackObj = this:GetEquippedObject("Backpack")
	local equipSlot = GetEquipSlot(equippedObj)
	--DebugMessage("----- " .. tostring(topCont) .. " " .. tostring(equipSlot))
	-- first see if we are carrying it
	if( equipSlot ~= nil and equipSlot ~= "Backpack") then
		-- if its in our body then we have it equipped
		if( equippedObj:ContainedBy() == this ) then
			DoUnequip(equippedObj,this)
		elseif( equippedObj:ContainedBy() == backpackObj ) then
			DoEquip(equippedObj,this)
		end
	end
end

function HandleStuckCommand()
	if(( IsDead(this) and not this:HasObjVar("IsGhost") )
			or (HasMobileEffect(this, "GodFreeze"))) then
		return
	end
	
	this:SystemMessage("[$2409]","event")
	this:SendMessage("BreakInvisEffect", "Action")

	if( IsGod(this) ) then
		UnstickPlayer(this)
	else
		this:SetObjVar("stuckLoc",this:GetLoc())
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(15),"StuckTimer")
	end
end

function HandleStuckTimer(args)	
	local stuckLoc = this:GetObjVar("stuckLoc")
	if ( this:GetLoc() == stuckLoc ) then
		UnstickPlayer(this)
	else
		this:SystemMessage("You have moved. Unstuck Canceled.", "info")
	end
	this:DelObjVar("stuckLoc")
end

function HandleCraftItem(recipe, variation, skill)
	USAGE_DISTANCE = 5

	if (this:HasTimer("CraftingTimer")) then
		this:SystemMessage("You are already crafting something.","info")
		return
	end

	local nearbyTool = nil

	local backpack = this:GetEquippedObject("Backpack")
	if ( backpack ) then
		nearbyTool = FindItemInContainerRecursive(backpack, function(fobj)
			if fobj:HasModule("tool_base") and fobj:HasObjVar("ToolSkill") then
				local skilltype = fobj:GetObjVar("ToolSkill")
				if(skilltype == skill or skilltype == "All") then
					return fobj;
				end
			end
		end)
	end

	if(nearbyTool == nil) then 
		local tools = FindObjects(SearchMulti({
		SearchModule("tool_base"),
		SearchHasObjVar("ToolSkill"),
		SearchRange(this:GetLoc(),USAGE_DISTANCE),
		}))

		for i,j in pairs(tools) do
			if (j:GetObjVar("ToolSkill") == skill or j:GetObjVar("ToolSkill") == "All") then
				nearbyTool = j
			end
		end
	end

	if (nearbyTool ~= nil) then
		--check here to see if tool is nearby
		--DebugMessage("Recipe is "..tostring(recipe).." Variation is " .. tostring(variation).." Skill is "..tostring(skill))
		if (not this:HasModule("base_crafting_controller")) then
			this:AddModule("base_crafting_controller")
		end
		this:SendMessage("CraftItem", this,recipe,variation,skill,nearbyTool)
	else
		this:SystemMessage("[$2411]","info")
	end
end

function CheckKillAchievements(victim, damageAmount, damageType, damageSource)
	if (victim == nil or not victim:IsValid()) then
		return
	end

	local killTable = this:GetObjVar("LifetimePlayerStats")
	if (killTable == nil) then
		killTable = {}
		killTable.Players = 0
		killTable.TotalMonsterKills = 0
	end

	--First, check for PvP achievements
	if (IsPlayerCharacter(victim) == true) then
		local karmaLevelVictim = GetKarmaLevel(GetKarma(victim))

		if (karmaLevelVictim.Name == "Trustworthy") then
			if (killTable.BluePlayers == nil) then
				killTable.BluePlayers = 0
			end

			killTable.BluePlayers = killTable.BluePlayers + 1

			CheckAchievementStatus(this, "PvP", "VersusBlue", killTable.BluePlayers, nil, "PvP")
		elseif (karmaLevelVictim.Name == "Outcast") then
			if (killTable.RedPlayers == nil) then
				killTable.RedPlayers = 0
			end

			killTable.RedPlayers = killTable.RedPlayers + 1

			CheckAchievementStatus(this, "PvP", "VersusRed", killTable.RedPlayers, nil, "PvP")
		end

		killTable.Players = killTable.Players + 1
		CheckAchievementStatus(this, "PvP", "VersusAny", killTable.Players, nil, "PvP")
		this:SetObjVar("LifetimePlayerStats",killTable)
	--Then check for executioner achievements
	elseif (damageSource ~= nil) then
		local executionerType = damageSource:GetObjVar("Executioner")
		if (executionerType ~= nil and executionerType == victim:GetObjVar("MobileKind")) then
			
			if (killTable[executionerType.."Kills"] == nil) then
				killTable[executionerType.."Kills"] = 0
			end

			killTable[executionerType.."Kills"] = killTable[executionerType.."Kills"] + 1
			killTable.TotalMonsterKills = killTable.TotalMonsterKills + 1
			CheckAchievementStatus(this, "Executioner", executionerType, killTable[executionerType.."Kills"])
			this:SetObjVar("LifetimePlayerStats",killTable)
		end
	end
end

--function that checks for more title gains such as attaining all relics, etc.
function CheckMoreTitleAchivements(actionId)
	--DFB NOTE: if you add a title check here, DON'T send an identifier argument in CheckTitleGain!
	local killTable = this:GetObjVar("LifetimePlayerStats")

	if (killTable == nil) then
		killTable = {}
	end
	--DebugMessage(actionId)
	local args = StringSplit(actionId,"|")
	local identifier = args[1]
	local value = args[2]

	--assign the values if they don't exist.
	if (killTable["relic_of_the_void"] == nil) then
		killTable["relic_of_the_void"] = 0
	end
	if (killTable["relic_of_the_ancients"] == nil) then
		killTable["relic_of_the_ancients"] = 0
	end
	if (killTable["relic_of_the_firstborn"] == nil) then
		killTable["relic_of_the_firstborn"] = 0
	end
	if (killTable["cultist_relic"] == nil) then
		killTable["cultist_relic"] = 0
	end
	if (killTable["relic_of_the_primordial"] == nil) then
		killTable["relic_of_the_primordial"] = 0
	end

	--DebugMessage("identifier is "..tostring(identifier))
	if (identifier ~= nil) then
		--DFB HACK (sort of), we should have a system where we check items from a function table?
		if (identifier:match("relic_")) then
			--add to the relic table
			killTable[identifier] = (killTable[identifier] or 0) + 1

			--check to see if we got all relics
			if (	killTable["relic_of_the_void"] > 1 
			and 	killTable["relic_of_the_ancients"] 
			and 	killTable["relic_of_the_firstborn"] 
			and 	killTable["cultist_relic"]
			and 	killTable["relic_of_the_primordial"] ) then
				CheckAchievementStatus(this, "Other", "AllRelics", nil, {Description = "", CustomAchievement = "All Relics", Reward = {Title = "All Relics"}})
			end
			--check to see if we unlocked a title based on the total relics
			local totalRelics = killTable["relic_of_the_void"] + killTable["relic_of_the_ancients"] + killTable["relic_of_the_firstborn"] + killTable["cultist_relic"] + killTable["relic_of_the_primordial"]

			--PlayerTitles.CheckTitleGain(this,AllTitles.ActivityTitles.Relics,totalRelics)
		end
	end
	--reassign the kill table
	this:SetObjVar("LifetimePlayerStats",killTable)
end

RegisterEventHandler(EventType.Message, "UseObject", HandleUseObject)

RegisterEventHandler(EventType.RequestPickUp, "", HandleRequestPickUp)
RegisterEventHandler(EventType.RequestDrop, "", HandleRequestDrop)
RegisterEventHandler(EventType.RequestEquip, "", HandleRequestEquip)

RegisterEventHandler(EventType.ClientUserCommand, "CraftItem", HandleCraftItem)

RegisterEventHandler(EventType.ClientUserCommand, "unlockstat", HandleUnlockStatRequest)
RegisterEventHandler(EventType.ClientUserCommand, "lockstat", HandleLockStatRequest)
RegisterEventHandler(EventType.ClientUserCommand, "use", HandleUseCommand)
RegisterEventHandler(EventType.ClientUserCommand, "usepermanent", HandleUsePermanentCommand)
RegisterEventHandler(EventType.ClientUserCommand, "useresource", HandleUseResourceCommand)
RegisterEventHandler(EventType.ClientUserCommand, "autoloot", HandleLootAllCommand)
RegisterEventHandler(EventType.ClientUserCommand, "lootall", HandleLootAllCommand)
RegisterEventHandler(EventType.ClientUserCommand, "equip", HandleEquipCommand)
RegisterEventHandler(EventType.ClientUserCommand, "stuck", HandleStuckCommand)

OverrideEventHandler("base_mobile", EventType.Message, "UpdateName", UpdateName)
RegisterEventHandler(EventType.Message, "PickupObject", HandleRequestPickUp)
RegisterEventHandler(EventType.Message, "UpdateTitle", UpdateTitle)
RegisterEventHandler(EventType.Message, "VictimKilled", CheckKillAchievements)
RegisterEventHandler(EventType.Message, "TitleValueIncrease", CheckMoreTitleAchivements)
RegisterEventHandler(EventType.Message, "LootAll", StartLootAll)

RegisterEventHandler(EventType.Timer, "StuckTimer", HandleStuckTimer)
RegisterEventHandler(EventType.Message,"SystemMessage",function (message,type)
	this:SystemMessage(message,type)
	if(type=="event") then
		this:SystemMessage(message)
	end
end)

RegisterEventHandler(EventType.Message, "TryHarvest",
	function(objRef)
		TryHarvestItem(objRef)
	end)

RegisterEventHandler(EventType.StartMoving,"",
	function (speedModifier)
		if( this:GetObjVar("IsHarvesting") ) then		
			-- this is a messy hack since the tool itself does the gathering right now
			local weapon = this:GetEquippedObject("RightHand")
			if( weapon ~= nil and weapon:HasObjVar("ToolType") ) then
				weapon:SendMessage("CancelHarvesting",this)
			end
			this:SendMessage("CancelHarvesting",this)
		end

		if( this:HasTimer("autolootitem")) then
			this:RemoveTimer("autolootitem")
			ProgressBar.Cancel("Looting",this)
		end
		if( this:HasTimer("autolootall")) then
			this:RemoveTimer("autolootall")
			this:RemoveTimer("autolootall_timeout")
			ProgressBar.Cancel("Looting",this)
		end		
	end)

--If the player stands near a camfire, they will set down after a delay
RegisterEventHandler(EventType.StopMoving,"",
	function ()
		if (HasMobileEffect(this, "Campfire")) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "SitCampfire")
		end
	end)

RegisterEventHandler(EventType.Timer, "SitCampfire", 
	function()
		if (HasMobileEffect(this, "Campfire") and this:IsMoving() == false and not IsMounted(this)) then
			this:PlayAnimation("sit_ground")
		end
	end)

RegisterEventHandler(EventType.Timer, "UpdateTooltip", 
	function()
		UpdateTooltip()
	end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(20),"UpdateTooltip")

-- Initialization Code

RegisterEventHandler(EventType.Message,"DamageInflicted",function(damager, damageAmount, damageType, isCrit, wasBlocked, isReflected)
	if ( this:HasTimer("StuckTimer") ) then
		this:RemoveTimer("StuckTimer")
		this:SystemMessage("Damage taken, Unstuck Canceled.", "info")
	end
end)
----------------------------------------------------------------------

function AddDynamicWindowRangeCheck(targetObj,windowHandle,maxDistance)
	--DebugMessage("AddDynamicWindowRangeCheck",tostring(targetObj),tostring(windowHandle),tostring(maxDistance))
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"CheckWindow-"..windowHandle)

	RegisterEventHandler(EventType.Timer, "CheckWindow-"..windowHandle, 
		function ()
			--DebugMessage("CheckWindow-"..windowHandle.." fired.")
			maxDistance = maxDistance or OBJECT_INTERACTION_RANGE
			
			if (targetObj == nil or not(targetObj:IsValid())) then	
				this:CloseDynamicWindow(windowHandle)
				UnregisterEventHandler("player",EventType.Timer,"CheckWindow-"..windowHandle)
			else	
				if (targetObj:DistanceFrom(this) < (maxDistance)) then
					this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"CheckWindow-"..windowHandle)
				else
					this:CloseDynamicWindow(windowHandle)
					UnregisterEventHandler("player",EventType.Timer,"CheckWindow-"..windowHandle)
				end
			end
		 end)
end

RegisterEventHandler(EventType.Message,"DynamicWindowRangeCheck",
	function(...)
		AddDynamicWindowRangeCheck(...)
	end)

RegisterEventHandler(EventType.Message,"OpenBank",
	function (bankSource)
		local bankObj = this:GetEquippedObject("Bank")
		this:SetObjVar("BankSource",bankSource)
		if( bankObj ~= nil ) then
			bankObj:SendOpenContainer(this)					
		end

		local searchDistanceFromBank = SearchSingleObject(bankSource,SearchObjectInRange(OBJECT_INTERACTION_RANGE))
		--DebugMessage("OBJECT_INTERACTION_RANGE is "..tostring(OBJECT_INTERACTION_RANGE))
		--DebugMessage("BankSource is "..tostring(bankSource))
		AddView("BankCloseCheck",searchDistanceFromBank,1.0)
		RegisterSingleEventHandler(EventType.LeaveView,"BankCloseCheck",
			function()
				-- close their bank window
				-- DebugMessage("Exited View")
				local bankObj = this:GetEquippedObject("Bank")
				if( bankObj ~= nil ) then
					--DebugMessage("Bank closed")
					CloseContainerRecursive(this,bankObj)
					CloseMap()
				end
			end)
	end)

RegisterEventHandler(EventType.Message,"BindToLocation",
	function(targetLoc,quiet)
		this:SetObjVar("SpawnPosition",{Region=ServerSettings.RegionAddress,Loc=targetLoc})
		if not(quiet) then
			this:SystemMessage("Your spirit has become bound to this location.","event")
			this:PlayEffect("TeleportFromEffect")
		end
	end)


-- Move to globals
-----

function CreateStartingItems(playerObj)
	-- build the list first so we don't create duplicates
	local itemsToCreate = {}
	for i, skillItemInfo in pairs(CharacterCustomization.StartingItems) do
		if( skillItemInfo.Skill == "" or GetSkillLevel(playerObj,skillItemInfo.Skill) > 0) then
			for i, itemInfo in pairs(skillItemInfo.Items) do
				local template = nil
				local stackCount = 1
				if(type(itemInfo) == "table") then
					template = itemInfo[1]
					stackCount = itemInfo[2]
				else
					template = itemInfo
				end

				itemsToCreate[template] = stackCount
			end
		end
	end

	if not(initializer) then initializer = {} end
	if not(initializer.HotbarActions) then initializer.HotbarActions = {} end

	local nextHotbarItemSlot = 21

	-- DAB TODO: Place items intelligently
	-- only equip one item per slot
	local slotsEquipped = {}
	for itemTemplate, stackCount in pairs(itemsToCreate) do
		if(stackCount > 1) then
			CreateStackInBackpack(playerObj,itemTemplate,stackCount,"StartingItem")
		else
			local templateData = GetTemplateData(itemTemplate)
            local equipSlot = templateData.SharedObjectProperties.EquipSlot
            if(equipSlot and not(equipSlot == "Trade") and not(slotsEquipped[equipSlot])) then
            	local equippedObj = this:GetEquippedObject(equipSlot)
            	if(equippedObj ~= nil) then
            		DoUnequip(equippedObj, this)
            	end

            	CreateEquippedObj(itemTemplate,playerObj,"StartingItem")
            	slotsEquipped[equipSlot] = true
            else
				CreateObjInBackpack(playerObj,itemTemplate,"StartingItem")
			end

			-- arrows are the only item you dont really need on your hotbar
			if(itemTemplate ~= "arrow") then
				table.insert(initializer.HotbarActions,{ Slot=nextHotbarItemSlot, Type="Object", Name=itemTemplate} )
				nextHotbarItemSlot = nextHotbarItemSlot + 1
			end

			if(itemTemplate == "spellbook_noob") then
				table.insert(initializer.HotbarActions,{ Slot=1, Type="Spell", Name="Heal"})
            	table.insert(initializer.HotbarActions,{ Slot=2, Type="Spell", Name="Ruin"})
            	table.insert(initializer.HotbarActions,{ Slot=3, Type="Spell", Name="ManaMissile"})
			end
		end
	end

	RegisterEventHandler(EventType.CreatedObject,"StartingItem",
		function (success,objRef)
			if ( success ) then
				SetItemTooltip(objRef)
			end
		end)
end

-----

-- On clusters that run the login region, this should not happen until they have entered the world (after character creation)
function InitializePlayer()
	--DebugMessage("Initialize Player")

	--this:AddModule("guard_protect")

	if not(IsImmortal(this)) then
		this:AddModule("temp_afkkick")	

		ShowTutorialUI(this)

		if(ServerSettings.NewPlayer.InitiateSystemEnabled) then		
			this:SetObjVar("InitiateMinutes", ServerSettings.NewPlayer.InitiateDurationMinutes)
			this:AddModule("npe_player")
			AddSubMapByName(this, ServerSettings.SubregionName)
		end		
	else
		this:SetObjVar("Invulnerable",true)
	    -- show the welcome dialog here since 
		-- mortals get it when they complete the starting quest
		--ShowWelcomeDialog()			
	end

	-- starting template gets set from the login region				
	if(this:HasObjVar("CharCreateNew")) then
		CreateStartingItems(this)
		this:DelObjVar("CharCreateNew")		
	-- if it's not set let them pick their appearance
	else
		this:AddModule("custom_char_window")
	end

	this:AddModule("tool_barehands")

	if not( this:HasObjVar("Karma") ) then
		SetKarma(this, ServerSettings.Karma.NewPlayerKarma)
		SetKarmaAlignment(this, ServerSettings.Karma.NewPlayerKarmaAlignment)
	end

	-- bind their hearth for the first time
	BindLocationIfNot(this)

	if not( this:HasObjVar("CreationDate") ) then 
		this:SetObjVar("CreationDate", DateTime.UtcNow)
	end

	--Check for achievement for every skills on character creation
	CheckAchievementStatusAllSkills(this)
end

-- This gets called on both creation and loading from backup
function OnLoad(isPossessed)		
	if not(isPossessed) then
		if(not(this:HasObjVar("playerInitialized"))) then
			this:SetObjVar("playerInitialized",true)
			InitializePlayer()			
		end

		--DAB/DFB hack: If the position is not valid send them to the outcast spawn position.
		if (not this:GetLoc():IsValid()) then
			local spawnPosition = FindObjectWithTag("OutcastSpawnPosition")
			if (spawnPosition == nil) then
				this:SetWorldPosition(GetPlayerSpawnPosition(this))
			else
				this:SetWorldPosition(spawnPosition:GetLoc())
			end
		end

		-- DAB TODO: When the attached object can change we might need to change this
		this:SetObjectTag("AttachedUser")

		if(isPossessed) then
			this:SetSharedObjectProperty("Title","")
		end

		this:SetObjVar("LoginTime",DateTime.UtcNow)
		bankBox = this:GetEquippedObject("Bank")
		if( bankBox == nil ) then
			CreateEquippedObj("bank_box", this)
		end

		tempPack = this:GetEquippedObject("TempPack")
		if( tempPack == nil ) then
			CreateEquippedObj("crate_empty", this, "temppack_created")
			-- create the key ring inside the temp pack
			RegisterSingleEventHandler(EventType.CreatedObject,"temppack_created",
				function (success,objRef)
					objRef:SetSharedObjectProperty("Weight",-1)
					objRef:SetName("Internal Temp Pack")
					CheckKeyRing(objRef)
				end)
		else
			CheckKeyRing()
		end	
	
		ShowSkillTracker()
		if not this:HasObjVar("LifetimePlayerStats") then
			
			local newLifetimeStats = 
			{
			Players = 0,
			TotalMonsterKills = 0,
			}

			this:SetObjVar("LifetimePlayerStats",newLifetimeStats)
		end

		this:SendClientMessage("PlayerRunSpeeds",
			{
				ServerSettings.Stats.WalkSpeedModifier,
				ServerSettings.Stats.RunSpeedModifier
			})
		this:SetMaxMoveSpeedModifier(ServerSettings.Stats.RunSpeedModifier)

		--UpdateFactions()

		this:SetStatValue("PrestigeXPMax",ServerSettings.Prestige.PrestigePointXP)

		if ( this:GetSharedObjectProperty("IsSneaking") ) then
			StartMobileEffect(this, "Hide", nil, {Force = true})
		end
	else
		this:SendClientMessage("PlayerRunSpeeds",
			{
				1.0,
				this:GetObjVar("AI-ChargeSpeed") or 2.0
			})
	end

	-- send skill values to player
	SendSkillList()

	UpdateClientSkill(this,this)

	--refresh the quest UI
	--this:SendMessage("RefreshQuestUI")	

	SendTimeUpdate(this)	

	InitializeHotbar()

	if(UpdateWeatherViews) then
		UpdateWeatherViews()
	end

	this:SendMessage("LoggedIn")

	this:SendClientMessage("SetKarmaState", GetKarmaAlignmentName(this))
	
	-- DAB TODO: Sometimes EnterView will fire on another object (teleporter) before this fires
	-- some scripts might not want to act on someone who has just entered the world
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"EnteringWorld")

	this:DelObjVar("BuffIcons")	

	-- Delayed OnLoadStuff
	CallFunctionDelayed(TimeSpan.FromSeconds(0.5),
		function()		
			if(initializer and initializer.HotbarActions) then
				BuildHotbar(initializer.HotbarActions)
			end

			-- this technically does not need to be called every time you come from the backup
			UpdateFixedAbilitySlots()						

			-- These functions are found in globals/dynamic_window/hud
			UpdateHotbar(this)
			UpdateSpellBar(this)
			UpdateItemBar(this)
			ShowStatusElement(this,{IsSelf=true,ScreenX=10,ScreenY=10})

			if this:HasObjVar("AchievementWaiting") then
				this:SendClientMessage("SetAchievementNotification",true)
			end

			InitializeClientConflicts(this)

			if not(IsPossessed(this)) then
				UpdateName()

				if ( IsMounted(this) and this:IsInRegion("NoMount") ) then
					DismountMobile(this)
				end			
			end
		end)

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(5 + math.random()),"UpdateChatChannels")
end
RegisterEventHandler(EventType.Message,"OnLoad",function(...) OnLoad(...) end)

function CheckStartingQuest()
	local worldName = ServerSettings.WorldName
	if(worldName == "Limbo" or worldName == "Celador") then
		--this:SendMessage("StartQuest","StartingQuest")
	end

	-- if we didn't start in limbo, skip right to find the mayor
	if(worldName == "Celador") then
		this:SetObjVar("ChoseClass","Warrior")
		CallFunctionDelayed(TimeSpan.FromSeconds(1),function() this:SendMessage("AdvanceQuest","StartingQuest","FindMayor") end)
	end
end	

RegisterSingleEventHandler(EventType.ModuleAttached,"player",
	function()
		local attachType = initializer.AttachType or "Player"

		if(ServerSettings.WorldName ~= "Login") then
			OnLoad(attachType == "Possess")
		end		
	end)

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
	function()
		local isPossessed = IsPossessed(this)
		if(isPossessed and not(this:GetAttachedUserId())) then
			EndPossession(this)
		end

		OnLoad(isPossessed)
		
		if not(isPossessed) then
			if not( this:HasModule('autofix') ) then
				this:AddModule("autofix")
			else
				this:SendMessage("autofix")
			end

			--If we have any items in our trade pouch for some reason then move them back into our backpack.
			local tradePouch = this:GetEquippedObject("Trade")
			if (tradePouch ~= nil) then			
			    local myPackItems = tradePouch:GetContainedObjects()
			    if (myPackItems ~= nil) then
					for i,j in pairs(myPackItems) do
				  		local randomLoc = GetRandomDropPosition(backpackObj)
				  		j:MoveToContainer(backpackObj,randomLoc)
					end
				end
				tradePouch:Destroy()
			end
		end
	end)


function DoLogout(logoutType)
    -- body
	this:DelObjVar("StatMods")
	--this:DelObjVar("MapMarkers")

	if(logoutType == "Transfer") then 
		this:SetObjVar("TransferTime",DateTime.UtcNow)
		this:SetObjVar("TransferSource",ServerSettings.RegionAddress)
	elseif (logoutType == "Disconnect") then

		if not( IsPossessed(this) ) then
			local clusterController = GetClusterController()
			if ( clusterController ) then
				clusterController:SendMessage("UserLogout", this)
			end
		end

		--gods log out instantly
		if (IsImmortal(this)) then
			CallFunctionDelayed(TimeSpan.FromSeconds(2),function() this:CompleteLogout() end)
		elseif(HasAnyActiveConflictRecords(this) == false) then
			if ( this:IsInRegion("WorldInns") or Plot.IsInHouse(this,true) ) then
				CallFunctionDelayed(TimeSpan.FromSeconds(2),function() this:CompleteLogout() end)
			end
		end
	end

	if ( logoutType ~= "Transfer" ) then
		EventTracking.UpdatePlayerRecord(this)
	end
end
RegisterEventHandler(EventType.Message,"DoLogout",function (...) DoLogout(...) end)

RegisterEventHandler(EventType.UserLogout,"", 
	function (logoutType)

		-- if holding something
		local carriedObject = this:CarriedObject()
		if ( carriedObject ~= nil and carriedObject:IsValid() ) then
			-- try to put into backpack
			local backpack = this:GetEquippedObject("Backpack")
			if ( backpack and CanAddWeightToContainer(backpack, carriedObject:GetSharedObjectProperty("Weight")) ) then
				carriedObject:MoveToContainer(backpack,GetRandomDropPosition(backpack))
			else
				-- or drop to ground if backpack cannot hold
				carriedObject:SetWorldPosition(this:GetLoc())
			end
		end

		-- DAB TODO: Allow players to take possessed objects across server lines
		-- if we are possessed we need to restore the AI on this creature and forward the logout message
		-- to the actual owner
		local possessionOwner = GetPossessionOwner(this)
		if(possessionOwner) then
			EndPossession(targetObj)
			possessionOwner:SendMessage("DoLogout",logoutType)
		else
			DoLogout(logoutType)
		end
	end)

RegisterEventHandler(EventType.UserLogin,"",
	function(loginType)

		if not( IsPossessed(this) ) then
			local clusterController = GetClusterController()
			if ( clusterController ) then
				clusterController:SendMessage("UserLogin",this,loginType)			
			end
		end

		if(loginType == "ChangeWorld") then
			if (ServerSettings.WorldName == "Catacombs") then
				CheckAchievementStatus(this, "Activity", "Dungeon", 1)
			end
			return
		end

		if(ServerSettings.WorldName == "Catacombs") then
			local sendto = GetRegionAddressesForName("SouthernHills")
			if not(#sendto == 0 or not IsClusterRegionOnline(sendto[1])) then
				TeleportUser(this,this,MapLocations.NewCelador["Southern Hills: Catacombs Portal"],sendto[1], 0, true)	
			end			
		end
	end)

RegisterEventHandler(EventType.Message,"UpdateChatChannels",
	function()
		UpdateChatChannels()
	end)

RegisterEventHandler(EventType.Timer,"UpdateChatChannels",
	function()
		UpdateChatChannels()
	end)

-- update all players on login, kept running into missing player record problems, it's worth it to prevent missing data.
--- the event a player would login, kill some stuff (thus being a part of death events) and server crashed there would be no
-- player record and since we need to parse chronologically we can't continue without the player record.
EventTracking.UpdatePlayerRecord(this)

function UpdateFixedAbilitySlots()
	-- setup initial weapon abilites.
	local curAction = GetWeaponAbilityUserAction(this, true)
	AddUserActionToSlot(curAction)
	curAction = GetWeaponAbilityUserAction(this, false)
	AddUserActionToSlot(curAction)

	UpdateAllPrestigeAbilityActions(this)
end
RegisterEventHandler(EventType.Message,"UpdateFixedAbilitySlots",UpdateFixedAbilitySlots)


-- Conflict stuff
RegisterEventHandler(EventType.Message, "ClearClientConflict", function(mobile)
	this:SendClientMessage("UpdateMobileConflictStatus", { { mobile, "" } })
end)


-- Prestige stuff.
RegisterEventHandler(EventType.Timer, "CastPrestigeAbility", CompleteCastPrestigeAbility)
RegisterEventHandler(EventType.Message, "AddPrestigeXP", function(amount)
	AddPrestigeXP(this,tonumber(amount))
end)

-- This is the player tick, it's performed once per minute. It's the alternative to having multiple systems all updating under their own timers.
function PerformPlayerTick(notFirst)
	-- prevent logins and reloads from taking minutes away
	if ( notFirst ) then
		-- check initiate
		CheckInitiate(this)
	else
		-- give daily login bonus
		DailyLogin(this)
	end

	VitalityCheck(this)

	-- check allegiance titles always
	CheckAllegianceTitle(this)

	CheckBidRefund()
end

local checkingBidRefund = false
function CheckBidRefund()
	if not( checkingPlotRefund ) then
		checkingPlotRefund = true
		-- see if there are any auctions I didn't win
		Plot.CheckBidRefund(this, function()
			checkingPlotRefund = false
		end)
	end
end

-- using an event handler so we can mark local checkingBidRefund and prevent a double whammy
RegisterEventHandler(EventType.Message, "CheckBidRefund", CheckBidRefund)

RegisterEventHandler(EventType.ClientUserCommand, "karmastate", function(alignment)
	local level = GetKarmaLevelFromAlignmentName(alignment)
	SetKarmaAlignment(this, level)
	this:SendMessage("UpdateKarmaWindow")
end)

-- this command is fired by the orderoptin window opened from karma.lua in globals/helpers
RegisterEventHandler(EventType.ClientUserCommand, "orderoptin", function()
	if not(this:HasTimer("ChaoticWarning")) then
		return
	end

	this:SendMessage("StartMobileEffect", "Chaotic")
    -- remove the timer
    this:RemoveTimer("ChaoticWarning")
end)
-- this closes the orderoptin window when the timer expires
RegisterEventHandler(EventType.Timer,"ChaoticWarning",
	function ( ... )
		this:CloseDynamicWindow("OrderOptIn")
	end)

RegisterEventHandler(EventType.Timer, "PlayerTick", function()
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(1), "PlayerTick")
	local minutes = this:GetObjVar("PlayMinutes") or 0
	this:SetObjVar("PlayMinutes", minutes+1)
	PerformPlayerTick(true)
end)
if not( this:HasTimer("PlayerTick") ) then
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(1), "PlayerTick")
end
CallFunctionDelayed(TimeSpan.FromSeconds(4), PerformPlayerTick)
-- end player tick

-- player guard stuff
--[[
RegisterEventHandler(EventType.CreatedObject, "super_guard", function(success,objRef,target)
	if not( success ) then return end
	if ( objRef ~= nil and objRef:IsValid() ) then
		objRef:SendMessage("AttackEnemy",target)
		--CreateObj("spawn_portal",objRef:GetLoc(),"spawn_portal")
		objRef:NpcSpeech(SuperGuardThingsToSay[math.random(1,#SuperGuardThingsToSay)])
	end
end)]]

this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"PlayerShortTick")
RegisterEventHandler(EventType.Timer,"PlayerShortTick", function ( ... )
	UpdatePlayerProtection(this)

	local newRegionalName = GetRegionalName(this:GetLoc())
	if(newRegionalName ~= nil and newRegionalName ~= currentRegionalName) then
		currentRegionalName = newRegionalName
		this:SystemMessage("You have entered "..currentRegionalName,"event")
		this:SendMessage("EnteredRegionalName", currentRegionalName)
		UpdateRegionStatus(this,currentRegionalName)
	end

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"PlayerShortTick")
end)
-- end player guard stuff

RegisterEventHandler(EventType.StartMoving,"",function (success)
	if (this:HasObjVar("IsHarvesting")) then
		local harvestingTool = this:GetObjVar("HarvestingTool")
		harvestingTool:SendMessage("CancelHarvesting",this)
	end
end)

RegisterEventHandler(EventType.Message,"ShowTutorialUI",
	function ( ... )
		ShowTutorialUI(this)
	end)

if(TRAILER_BUILD) then
	RegisterEventHandler(EventType.ClientUserCommand, "dig", 
		function ( ... )
			this:PlayAnimation("dig")
			CallFunctionDelayed(TimeSpan.FromSeconds(1),
				function ( ... )
					
					CreateObj("treasurechest_buried",this:GetLoc():Project(this:GetFacing()+40,0.8))					
				end)
		end)
end