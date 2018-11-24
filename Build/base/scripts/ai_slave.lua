require 'ai_default'
require 'incl_faction'
require 'incl_ai_stabled'

AI.SlaveAsk={
    "Please, I beg of you, set me free!",
    "[$1599]",
    "[$1600]",
    "No, please I beg of you to unchain me!",
    "I beg of you, please set me free! Please!",
    "C'mon, let me go! I'll return the favor, I promise",
}

AI.SlaveReward = 
{
	"[$1601]",
	"[$1602]",
	"[$1603]",
}
this:SetSharedObjectProperty("Faction","None")
this:SetObjVar("AlwaysFriendly",true)
this:SetObjVar("AutoUnstable",true)
AI.Settings.CanConverse = false

AI.StateMachine.AllStates.Follow =
{
		GetPulseFrequencyMS = function() return 3000 end,

		OnEnterState = function() 
			AI.ClearAggroList()

			local controller = this:GetObjVar("controller")
			if (controller ~= nil and controller:IsValid() and not IsDead(controller)) then
				this:PathToTarget(controller,1.0,4.0)
			else
				AI.StateMachine.ChangeState("Idle")
			end
		end,

		AiPulse = function() 
		end,	
}

oldDecideIdleState = DecideIdleState
function DecideIdleState()
	if not(AI.IsActive()) then return end
    
    if (IsInCombat(this)) then
        this:SendMessage("EndCombatMessage")
    end

	local controller = this:GetObjVar("controller")
	--DebugMessage("controller is "..tostring(controller))
	if (controller ~= nil and controller:IsValid() and not IsDead(controller)) then
		AI.StateMachine.ChangeState("Follow")
	else
		oldDecideIdleState()
	end
end

oldIsFriend = IsFriend
function IsFriend(target)
	local owner = this:GetObjVar("controller")
	if (target == owner) then
		return true
	end
    if (AI.InAggroList(target)) then
        return false
	else
		if (target:IsPlayer()) then
			return true
		else
			return oldIsFriend()
		end
	end
end

function IsInRuins(user)
    local inRuins = false
    local regions = GetRegionsAtLoc(user:GetLoc())
    for i,j in pairs(regions) do
        if j == "CultistRuins" then
            inRuins = true
        end
    end
    return inRuins
end

function ShouldProvokeCultists(user)
    local nearbyCultists = FindObjects(SearchMulti(
    {
    SearchMobileInRange(15), --in 20 units
    SearchModule("ai_cultist"), --find demon quest slayers
    }))
    if not IsInRuins(user) then return false end
    local controller = this:GetObjVar("controller")
    if (controller ~= user and nearbyCultists ~= nil and IsTableEmpty(nearbyCultists) == false) then 
		--DebugMessage("Should provoke")
    	return true 
    end
    return false
end

function ProvokeCultists(user)
	--DebugMessage("Provoking")
    local nearbyCultists = FindObjects(SearchMulti(
    {
    SearchMobileInRange(15), --in 20 units
    SearchModule("ai_cultist"), --find demon quest slayers
    }))
    if not IsInRuins(user) then return end
    if (#nearbyCultists == 0) then return end
    local controller = (this:GetObjVar("controller") or nearbyCultists[math.random(1,#nearbyCultists)])
    if (controller ~= user and nearbyCultists ~= nil and IsTableEmpty(nearbyCultists) == false) then 
    	--DebugMessage("Cultists nearby")
		SetFactionToAmount(user,-10,controller:GetObjVar("MobileTeamType"))
   	 	for i,j in pairs(nearbyCultists) do
			--DebugMessage("Attacking "..i)
    		j:SendMessage("AttackEnemy",user)
    	end
	end
end

canRansom = 1--math.random(1,3)
startingCoin = CountCoins(this)
if (canRansom == 1 and startingCoin > 0) then
	canRansom = true
else
	canRansom = false
end

function DialogSlave(user)

			local penaltyWarning = ""
			local penaltyColor = ""
			local penaltyColorClose = ""
			local provoke = ShouldProvokeCultists(user)
			--if (provoke == true) then 
			--	penaltyWarning = "[$1604]"
			---	penaltyColor = "[f70a0a]"
			--	penaltyColorclose = "[-]"
			--end

			response = {}
			if (not canRansom) then
				local speechIndex = math.random(1,#AI.SlaveAsk)

				for i,j in pairs(AI.SlaveAsk) do
					if i == speechIndex then
						text = AI.SlaveAsk[i] --..penaltyWarning
					end
				end
			else
				local speechIndex = math.random(1,#AI.SlaveReward)

				for i,j in pairs(AI.SlaveReward) do
					if i == speechIndex then
						text = AI.SlaveReward[i] --..penaltyWarning
					end
				end
			end

			response[1] = {}
			response[1].text = penaltyColor .. "You are now my prisoner." .. penaltyColorClose
			response[1].handle = "Capture" 

			response[2] = {}
			response[2].text = penaltyColor .. "You are free to go.".. penaltyColorClose
			response[2].handle = "Release" 

			if (canRansom) then
				response[3] = {}
				response[3].text = penaltyColor .. "Give me the gold and you can go.".. penaltyColorClose
				response[3].handle = "Ransom" 
			end

			response[4] = {}
			response[4].text = "Nevermind."
			response[4].handle = "" 

			NPCInteraction(text,this,user,"Interact",response)

end

RegisterEventHandler(EventType.DynamicWindowResponse, "Interact",
	function (user,buttonId)
		if (buttonId == "Capture") then
			if not(this:HasObjVar("CannotBeCaptured")) then
				ProvokeCultists(user)
				this:SetObjVar("controller",user)
				AI.StateMachine.ChangeState("Follow")
			end
		elseif (buttonId == "Release" or buttonId == "Ransom") then
			if (this:HasObjVar("CannotBeCaptured")) then
				return
			end
			
			if (buttonId == "Ransom") then
				local amount = CountCoins(this)
				local money = GetResourcesInContainer(this,"coins")
				if(money) then
					local backpackObj = user:GetEquippedObject("Backpack")
					local randomLoc = GetRandomDropPosition(backpackObj)
					--DebugMessage("Money is"..tostring(money))
					for i,j in pairs(money) do
						j:MoveToContainer(backpackObj,randomLoc)
					end
					user:SystemMessage("You received "..amount.." coins!","info")
				end
			end
			ProvokeCultists(user)
			this:DelObjVar("controller")
			--OldAI = this:GetObjVar("OldAI")
			--if OldAI ~= nil and not IsTableEmpty(OldAI) then
			--	for i,moduleName in pairs(OldAI) do
			--		DebugMessageA(this,"returning module is "..tostring(moduleName))
			--		this:AddModule(moduleName)
			--	end
			--else
			--	DebugMessageA(this,"Attaching default human AI")

			local lifetimeStats = user:GetObjVar("LifetimePlayerStats")
			lifetimeStats.SlavesFreed = (lifetimeStats.SlavesFreed or 0) + 1
			CheckAchievementStatus(user, "Other", "SlavesFreed", nil, {Description = "", CustomAchievement = "Slaves Freed", Reward = {Title = "Slaves Freed"}})
			user:SetObjVar("LifetimePlayerStats",lifetimeStats)

			local firstName = this:GetObjVar("FirstName")
			if (firstName ~= nil) then
				this:SetName(firstName)
			else
				this:SetName("Freed Prisoner")
			end
			this:SendMessage("UpdateName")
			this:SetObjVar("MyReleaser",user)
			--end
			this:DelObjVar("MobileTeamType")
			AI.StateMachine.ChangeState("Idle")
			this:NpcSpeech("Thank you!")
		    this:PlayAnimation("cast_heal")
		    CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function ( ... )
		        CreateObj("portal",this:GetLoc(),"dismiss_portal_created")
		    end)
		    CallFunctionDelayed(TimeSpan.FromSeconds(1.5),function ( ... )
		        PlayEffectAtLoc("TeleportToEffect",this:GetLoc())
		        this:Destroy()
		    end)
		end
	end)

RegisterEventHandler(EventType.CreatedObject,"dismiss_portal_created",
    function (success,objRef )
        Decay(objRef, 5)
    end)


--Schedule a timer... that...
RegisterEventHandler(EventType.Message, "SoldSlaveMessage",
function()
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(60), "SlayDecay")
		this:SetName("Slave")
		this:SendMessage("UpdateName")
		--AI.StateMachine.ChangeState("DecideIdleState")
		--AI.StateMachine.ChangeState("Follow")
end)

RegisterEventHandler(EventType.Message, "ChangeOwnerMessage",
function(newOwner)
		this:SetObjVar("controller",newOwner)
		local controller = this:GetObjVar("controller")
		if (controller ~= nil and controller:IsValid() and not IsDead(controller)) then
			this:PathToTarget(controller,1.0,4.0)
		else
			AI.StateMachine.ChangeState("Idle")
			return
		end
		AI.StateMachine.ChangeState("Follow")
end)

--...makes them die of disease after a minute. Grim right?
RegisterEventHandler(EventType.Timer, "SlayDecay", 
function ()
    this:SendMessage("ProcessTrueDamage", this, 5000, true) --DFB TODO: Poison damage maybe?
    return
end)

RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
    	if(usedType ~= "Interact") then return end
		--DebugMessage("user is "..tostring(user))
		DialogSlave(user)
		AI.StateMachine.ChangeState("Follow")
		return
	end)

this:SendMessage("EndCombatMessage")
--Delete all the old AIs from the object
for i,moduleName in pairs(this:GetAllModules()) do
	if(string.match(moduleName,"ai_") and not string.match(moduleName,"ai_slave") ) then
		--table.insert(OldAI,moduleName)
		this:DelModule(moduleName)
		DebugMessageA(this,"Attaching "..tostring(moduleName))
	end
end


--make him friendly and force him to stand still
AI.SetSetting("CanFlee",false)
AI.SetSetting("CanWander",false)
this:StopMoving()
this:SetMobileType("Friendly")
AI.SetSetting("Leash",false)

if (initializer ~= nil) then
    if(initializer.SlaveNames ~= nil) then
		local firstName = initializer.SlaveNames[math.random(1,#initializer.SlaveNames)]
		this:SetName(firstName .." The Slave")
		this:SetObjVar("FirstName",firstName)
	else
		this:SetName(StripFromString(this:GetName()," (Prisoner)"))
		this:SetName(this:GetName().." [D7D700](Prisoner)")
	end
end

--Next we drop his armor and all his stuff into his backpack.
backpackObj = this:GetEquippedObject("Backpack")

if (backpackObj == nil) then DebugMessageA(this,"[ai_slave] Error: No Backpack Detected!") end

weapon = this:GetEquippedObject("RightHand") 
otherWeapon = this:GetEquippedObject("LeftHand") 
armor = this:GetEquippedObject("Chest") 
if (weapon ~= nil) then
	if (backpackObj ~= nil) then
		local randomLoc = GetRandomDropPosition(backpackObj)
		weapon:MoveToContainer(backpackObj,randomLoc)
	else
		weapon:Destroy()
	end
end
if (otherWeapon ~= nil) then
	if (backpackObj ~= nil) then
		local randomLoc = GetRandomDropPosition(backpackObj)
		otherWeapon:MoveToContainer(backpackObj,randomLoc)
	else
		otherWeapon:Destroy()
	end
end
if (armor ~= nil) then
	if (backpackObj ~= nil) then
		local randomLoc = GetRandomDropPosition(backpackObj)
		armor:MoveToContainer(backpackObj,randomLoc)
	else
		armor:Destroy()
	end
end
--Assign the old AI if he's freed later.
--this:SetObjVar("OldAI",OldAI)