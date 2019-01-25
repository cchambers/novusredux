require 'default:player'

if(IsDemiGod(this)) then
	require 'default:base_player_mobedit'
end
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
		
		-- this:PlayLocalEffect(this,"BloodSplatter"..choice.."Effect", 1)		
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

nameSuffix = {
	{Suffix = function(guild)
			return "[" .. guild.Tag .. "]"
		end, Condition = function(guild)
			return guild ~= nil and guild.Tag ~= nil
		end}
}

namePrefix = {
	{Prefix = function()
			return "Noob "
		end, Condition = function(targetObj)
			return IsInitiate(targetObj)
		end},
	{Prefix = function()
			return "Admin "
		end, Condition = function(targetObj)
			return IsGod(targetObj) and not (TestMortal(targetObj))
		end},
	{Prefix = function()
			return "GM "
		end, Condition = function(targetObj)
			return IsDemiGod(targetObj) and not (IsGod(this)) and not (TestMortal(targetObj))
		end},
	{Prefix = function()
			return "Counselor "
		end, Condition = function(targetObj)
			return IsImmortal(targetObj) and not (IsDemiGod(this)) and not (TestMortal(targetObj))
		end}
}

local karmaLevels = { 10000, 5000, 2500, 625, 0, -625, -2500, -5000, -10000 }
local fameLevels = { 0, 1250, 2500, 5000, 9999 }
local titleTable = {
	p10000 = {
		"Trustworthy",	"Estimable", 	"Great",		"Glorious",		"Glorious"
	},
	p5000 = {
		"Honest",		"Commendable",	"Famed", 		"Illustrious", 	"Illustrious"
	},
	p2500 = {
		"Good",			"Honorable",	"Admirable",	"Noble",		"Noble"
	},
	p625 = {
		"Fair",			"Upstanding",	"Reputable",	"Distinguished","Distinguished"
	},
	p0 = {
		"",				"Notable",		"Prominent",	"Renowned",		"Renowned"
	},
	n625 = {
		"Rude",			"Disreputable",	"Notorious",	"Infamous",		"Infamous"
	},
	n1250 = {
		"Unsavory",		"Dishonorable",	"Ignoble",		"Sinister",		"Sinister"
	},
	n2500 = {
		"Scoundrel",	"Malicious",	"Vile",			"Villainous",	"Villainous"
	},
	n5000 = {
		"Despicable",	"Dastardly",	"Wicked",		"Evil",			"Evil"
	},
	n10000 = {
		"Outcast",		"Wretched",		"Nefarious",	"Dread",		"Dread"
	}
}

function GetFameLevel(targetObj, from)
	local fame = targetObj:GetObjVar("Fame")
	if (fame == nil) then targetObj:SetObjVar("Fame", 0); fame = 0 end
	local flevel = 1
	
	if (fame ~= nil) then
		while fame > fameLevels[flevel] do
			flevel = flevel + 1
			if (flevel == 6) then break end
		end
	end
	flevel = flevel - 1
	return flevel
end

function GetTitle(targetObj)
	local karma = targetObj:GetObjVar("Karma") or 0
	local title = ""
	local klevel = 1
	while karma < karmaLevels[klevel] do
		klevel = klevel + 1
	end

	klevel = karmaLevels[klevel]
	if (klevel >= 0) then
		title = "p"
	else 
		title = "n"
	end

	klevel = tostring(title .. math.abs(klevel))
	title = titleTable[klevel]
	
	flevel = GetFameLevel(targetObj, "GetTitle")

	title = title[flevel] or ""

	if (flevel == 5) then
		if(IsMale(targetObj)) then
			title = title .. " Lord"
		else
			title = title .. " Lady"
		end
	end
	return title
end

function GetLord(targetObj)
	local flevel = GetFameLevel(targetObj, "GetLord")
	if (flevel == 5) then
		if(IsMale(targetObj)) then
			title = "Lord "
		else
			title = "Lady "
		end
	end
	return title
end

function GetNameSuffix()
	local guild = GuildHelpers.Get(this)
	local suffix = ""
	if (guild) then 
		suffix = suffix .. " [" .. guild.Tag .. "]"
	end

	if (this:HasObjVar("IsCriminal")) then
		suffix = suffix .. "\n[FF8C00][i]criminal[-]"
	end
	return suffix
end

function GetNamePrefix(targetObj)
	local prefix = ""
	for i, prefixEntry in pairs(namePrefix) do
		if (prefixEntry.Condition(targetObj or this)) then
			prefix = prefixEntry.Prefix()
		end
	end
	local lord = GetLord(this)
	if (lord) then prefix = lord .. prefix end
	return prefix
end

function UpdateName()
	Verbose("Player", "UpdateName")
	local charName = ColorizePlayerName(this, GetNamePrefix() .. this:GetName() .. GetNameSuffix())
	this:SetSharedObjectProperty("DisplayName", charName)
end

function OnLoad(isPossessed)
	if(Totem ~= nil) then Totem(this, "update") end
	-- Logged out Incognito
	if (this:HasObjVar("NameActual")) then
		this:SetName(this:GetObjVar("NameActual"))
		this:DelObjVar("NameActual")
		this:SendMessage("UpdateName")
	end

	this:DelObjVar("BuffIcons")	

	local hasStats = this:HasModule("hud_tracker")
	if (not(hasStats)) then
		this:AddModule("hud_tracker")
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"Hud.UpdateStats")


	-- GM Detect Hidden Passive
	local detectSkill = GetSkillLevel(this, "DetectHiddenSkill")
	local hasPassiveDetect = this:HasModule("passive_detecthidden")
	if (not(hasPassiveDetect) and detectSkill >= 100) then this:AddModule("passive_detecthidden") end

	for i,moduleName in pairs(this:GetAllModules()) do
		if(string.match(moduleName,"sp_")) then
			this:DelModule(moduleName)
		end
	end
	

	-- POWER HOUR FIXER
	local powerhour = this:GetObjVar("PowerHourEnds")

	if (powerhour) then
		powerhour = powerhour - 1;
		if (powerhour > -1) then
			this:SetObjVar("PowerHourEnds", powerhour)
			this:SendMessage("StartMobileEffect", "PowerHourBuff")
		else
			this:DelObjVar("PowerHourEnds")
			this:SystemMessage("Your Power Hour has ended.")
		end
	end

	-- MAGIC REFLECT -- 
	if (this:HasObjVar("MagicReflection")) then
		this:SendMessage("StartMobileEffect", "SpellMagicReflection")
	end

	local murders = this:GetObjVar("Murders")
	if (murders ~= nil) then
		this:SendMessage("StartMobileEffect", "Murderer")
	end

	if(this:HasObjVar("IsCriminal")) then
		this:SendMessage("StartMobileEffect", "Criminal")
	end

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

			InitializeClientConflicts(this)

			if not(IsPossessed(this)) then
				UpdateName()

				if ( IsMounted(this) and this:IsInRegion("NoMount") ) then
					DismountMobile(this)
				end			
			end
		end)

	CallFunctionDelayed(TimeSpan.FromSeconds(10.0),
	function()		
		if this:HasObjVar("AchievementWaiting") then
			this:SendClientMessage("SetAchievementNotification",true)
		end
	end)

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(5 + math.random()),"UpdateChatChannels")
end
RegisterEventHandler(EventType.Message,"OnLoad",function(...) OnLoad(...) end)

RegisterEventHandler(EventType.Message,"User_Ping", function(from)
	local location = this:GetLoc()
	local region = GetRegionalName(location)
	local me = {
		Name = this:GetName(),
		Loc = location,
		Id = this.Id,
		Region = region,
		player = this
	}
	from:SendMessage("User_Pong", me)
end)

RegisterEventHandler(EventType.Message,"OpenBank", function (bankSource)
	local bankObj = this:GetEquippedObject("Bank")
	this:SetObjVar("BankSource",bankSource)
	if( bankObj ~= nil ) then
		bankObj:SendOpenContainer(this)					
	end

	local searchDistanceFromBank = SearchSingleObject(bankSource,SearchObjectInRange(12))
	AddView("BankCloseCheck",searchDistanceFromBank,1.0)
	RegisterSingleEventHandler(EventType.LeaveView,"BankCloseCheck", function()
		local bankObj = this:GetEquippedObject("Bank")
		if( bankObj ~= nil ) then
			CloseContainerRecursive(this,bankObj)
			CloseMap()
		end
	end)
end)

RegisterEventHandler(EventType.StartMoving,"",function (success)
	if (this:HasObjVar("IsHarvesting")) then
		local harvestingTool = this:GetObjVar("HarvestingTool")
		harvestingTool:SendMessage("CancelHarvesting",this)
	end
	if (this:HasObjVar("IsBuryingRune")) then
		this:SendMessage("CancelBury", this)
	end
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
	
	HandleGmResponseWindow()
	
	-- ShowStatusElement(this,{IsSelf=true,ScreenX=10,ScreenY=10})
	-- IS THIS STILL NEEDED NOW THAT THE BUTTON HAS BEEN MOVED?
end

function DailyTaxWarn()
	return
end

OverrideEventHandler("default:player",EventType.UserLogin, "", 
	function(loginType)
		if not( IsPossessed(this) ) then
			local clusterController = GetClusterController()
			if ( clusterController ) then
				clusterController:SendMessage("UserLogin",this,loginType)			
			end
			if ( loginType == "Connect" ) then
				if (Guild ~= nil) then Guild.Initialize() end
				-- KHI HERE FIX PLS K
				-- warn about their plot taxes
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