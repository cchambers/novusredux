require 'NOS:base_ai_mob'
require 'NOS:base_ai_casting'
require 'NOS:base_ai_intelligent'
require 'NOS:base_ai_conversation'
require 'NOS:incl_regions'
require 'NOS:incl_faction'

AI.Settings.Debug = false
-- set charge speed and attack range in combat ai
FleeTalk = nil
AI.Settings.AggroRange = 10.0
AI.Settings.ChaseRange = 15.0
AI.Settings.LeashDistance = 25
AI.Settings.CanConverse = true
AI.Settings.ScaleToAge = false
AI.Settings.CanWander = true
AI.Settings.CanUseCombatAbilities = true
AI.Settings.CanCast = true
AI.Settings.ChanceToNotAttackOnAlert = 2
AI.Settings.ShouldFlee = true
--AI.Settings.SpeechTable = "Bandit"
AI.Settings.RobberyEnabled = false

-- Every top level script needs to initialize the ai state machine
AddAIView("robberyView", SearchMobileInRange(7))

playerResponses = 
{
	"Let's fight.",
	"I don't think so.",
	"You want a fight? You got it.",
	"From my cold, dead, fingers.",
	"Prepare to die.",
	"Screw you!",
	"Not a chance.",
	"Let's fight then.",
	"I'll shove them down your throat.",
	"Sure, when I'm dead.",
	"Whatever, screwup."
}

banditDialog = 
{
	"[$5]",
	"[$6]",
	"[$7]",
	"[$8]",
	"[$9]",
	"[$10]",
	"[$11]",
	"[$12]",
	"[$13]",
}

banditAttack =
{
	"Kill him!",
	"Chop him into bits!",
	"Attack!",
	"You're dead!",
}

robberySuccess =
{
	"Thanks for nothing loser!",
	"Thanks for the money, now get lost!",
	"Thanks for the money!",
	"We appreciate your donation, now get lost!",
}

banditFullRobbery = 
{
	{"RightHand","[$14]"},
	{"LeftHand","[$15]"},
	{"Chest","[$16]"},
	{"Legs","[$17]"},
	{"Backpack","[$18]"},	
	{"Head","That's a nice hat by the way. Hand it over."},	
}

 --Function that determine's what team I'm on. Override this for custom behaviour.
function IsFriend(target)
    DebugMessageA(this,"Checking if friend")
    --Override if this is my "target"
    if (AI.InAggroList(target)) then
        return false
    end

    if (not AI.GetSetting("ShouldAggro")) then
        return true
    end

    DebugMessageA(this,tostring(target))
    if (target == nil) then
        return true
    end

    local myController = this:GetObjVar("controller")
    local hisController = target:GetObjVar("controller")
    if(myController == target or hisController == this) then
        return true
    end

    local myTeam = this:GetObjVar("MobileTeamType")
    if (myTeam == nil) then --If I have no team, then attack everyone!
        DebugMessageA(this,"NO TEAM")
        return false
    end

    local otherTeam = target:GetObjVar("MobileTeamType")
    local myTeam = this:GetObjVar("MobileTeamType")
    local targetFaction = GetFaction(target,this:GetObjVar("MobileTeamType"))
    if (targetFaction ~= nil and myTeam ~= otherTeam) then 
    end

    local otherTeam = target:GetObjVar("MobileTeamType")

    if (this:HasObjVar("NaturalEnemy") ~= nil)  then
        if (this:GetObjVar("NaturalEnemy") == otherTeam and otherTeam ~= nil) then
            AI.AddThreat(damager,4)
            return false
        end
    end

    if (target:GetMobileType() == "Animal" ) then --Animals don't usually attack animals
        if AI.GetSetting("AggroChanceAnimals") == 0 then
            if (not IsInCombat(this)) then
                return false
            else 
                return true
            end
        end
        if (this:DistanceFrom(target) < AI.Settings.AggroRange or math.random(AI.GetSetting("AggroChanceAnimals")) == 1) then            
            --AI.AddThreat(damager,-1)--Don't aggro them
            return (myTeam == otherTeam) 
        else
            return true
        end
    end
    if (myTeam == "Villagers" and target:IsPlayer()) then return true end
    if (otherTeam == nil) then
        return false
    end
    --Villagers are a special case.
    return (myTeam == otherTeam) --Return true if they have the same team, false if not.
end

function ShouldFlee()
	if (hasRobbed == true) then return true end
    return (AI.GetSetting("CanFlee") and (GetCurHealth(this) < GetMaxHealth(this)*AI.GetSetting("InjuredPercent") and math.random(1,AI.GetSetting("FleeChance")) == 1))
end

AI.StateMachine.AllStates.FleeAfterRobbery = {
        GetPulseFrequencyMS = function() return 2000 end,

        OnEnterState = function()
            local fleeAngle = FindSafestAngle()
            local fleeDest = this:GetLoc():Project(fleeAngle, AI.GetSetting("FleeDistance"))
            local fleeSpeed = AI.GetSetting("FleeSpeed")
            this:PathTo(fleeDest,fleeSpeed,"Flee")
        end,
    }

AI.StateMachine.AllStates.Alert = {       
        OnEnterState = function() 
            this:PlayAnimation("alarmed")
            
            alertTarget = FindAITarget()
            if( alertTarget == nil ) then
               DebugMessageA(this,"Changing to idle from alert")
                AI.StateMachine.ChangeState("Idle")
            else
                FaceObject(this,alertTarget)
            end
            ----AI.StateMachine.--DebugMessage("ENTER ALERT")
        end,

        GetPulseFrequencyMS = function() return 1700 end,

        AiPulse = function()    
            --AI.StateMachine.--DebugMessage("Alert pulse")
            --this:NpcSpeech("[f70a79]*Alert!*[-]")
            alertTarget = FindAITarget()
            if( alertTarget == nil ) then
               DebugMessageA(this,"Changing to idle from alert")
                AI.StateMachine.ChangeState("Idle")
            else
                FaceObject(this,alertTarget)
                --We found a new mobile, handle it
                if (alertTarget:HasTimer("RobbedTimer"))
                	then return end
                
                if not IsFriend(alertTarget) then                
                	if ((not alertTarget:IsPlayer() and RobberyTarget == nil) or not(AI.GetSetting("RobberyEnabled"))) then
                		if (math.random(1,AI.GetSetting("ChanceToNotAttackOnAlert")) == 1  or alertTarget:DistanceFrom(this) < AI.GetSetting("AggroRange")) then
                        	AttackEnemy(alertTarget)
                    	end
                	else
    	            	RobPlayer(alertTarget)
	                end
	            end
            end
        end,
    }

AI.StateMachine.AllStates.AwaitResponse = {   
        GetPulseFrequencyMS = function() return 5000 end,

        OnEnterState = function()
        end,

        AiPulse = function()   
	        if (RobberyTarget ~= nil) then
	        	FaceObject(this,FineTarget)
	        else	
	        	AI.StateMachine.ChangeState("Idle")
	        end
        end,

}

function RobPlayer(target)
	if (target == nil or not target:IsValid()) then return end
	if (not (target:IsPlayer())) then this:SendMessage("AttackEnemy",target,true) return end
	if (#(GetNearbyEnemies())) > 1 then this:SendMessage("AttackEnemy",target,true) return end
	target:ScheduleTimerDelay(TimeSpan.FromSeconds(15),"RobbedTimer")
	if (hasRobbed == true ) then return false end
	AI.StateMachine.ChangeState("AwaitResponse")
	this:PathToTarget(target,4.0,4)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(15),"robbery_timer")
	RobberyTarget = target

	local coins = CountCoins(target)

	text = banditDialog[math.random(1,#banditDialog)]

	response = {}
	if (coins > 0) then
		response[1] = {}
		response[1].text = "Don't hurt me! Take the money!"
		response[1].handle = "Pay" 
	else
		response[1] = {}
		response[1].text = "I don't have any money."
		response[1].handle = "Fight" 
	end

	response[2] = {}
	response[2].text = playerResponses[math.random(1,#playerResponses)]
	if (math.random(1,500) == 1) then response[2].text = "Fuck you, asshole!" end
	response[2].handle = "Fight" 

	--response[3] = {}
	--response[3].text = "Need a job?"
	--response[3].handle = "Hire" 

	NPCInteraction(text,this,RobberyTarget,"Robbery",response,nil,20)
end

function  MoreRobbery()
	if (RobberyTarget == nil or not RobberyTarget:IsValid()) then return end
	--chance to end robbery
	--if (math.random(1,2) == 1) then 
	--	this:SendMessage("RobberySuccess") 
	--	return 
	--end
	--they want more!
	robberyType = banditFullRobbery[math.random(1,#banditFullRobbery)]

	--he doesn't even have an item, end it
	if (RobberyTarget:GetEquippedObject(robberyType[1]) == nil) then
		this:SendMessage("RobberySuccess") 
		return 
	end

	text = robberyType[2]

	response = {}

	response[1] = {}
	response[1].text = "Take it!"
	response[1].handle = "GiveUpItem" 

	response[2] = {}
	response[2].text = playerResponses[math.random(1,#playerResponses)]
	--if (math.random(1,300) == 1) then response[2].text = "Fuck you, asshole!" end
	response[2].handle = "Fight" 

	NPCInteraction(text,this,RobberyTarget,"MoreRobbery",response,nil,20)
end

function AttackRobberyTarget()
	if (RobberyTarget == nil) then return end
    RobberyTarget:CloseDynamicWindow("Robbery")
    RobberyTarget:CloseDynamicWindow("MoreRobbery")
    this:SendMessage("AttackEnemy",RobberyTarget)
	local nearbyBandits = FindObjects(SearchMulti(
	{
		SearchMobileInRange(20), --in 10 units
		SearchObjVar("MobileTeamType","Bandits"), --find slaver guards
	}))
	for i,j in pairs (nearbyBandits) do
		j:SendMessage("AttackEnemy",RobberyTarget) --defend me
	end
	RobberyTarget = nil
end

RegisterEventHandler(EventType.LeaveView, "robberyView", 
    function (mobileObj)
    	if (mobileObj == RobberyTarget) then
    		this:SendMessage("AttackEnemy",mobileObj)
    	end
    end)

RegisterEventHandler(EventType.Timer, "robberyRestart", 
	function ()
		hasRobbed = false
	end)
RegisterEventHandler(EventType.Timer, "robbery_timer", 
	function ()
    	if (RobberyTarget ~= nil and not hasRobbed) then
    		--this:NpcSpeech("Time's up!")
    		AttackRobberyTarget()
    	end
	end)

RegisterEventHandler(EventType.Message, "RobberySuccess",
	function ()
		this:NpcSpeech(robberySuccess[math.random(1,#robberySuccess)])
		local region = GetRegionsAtLoc(this:GetLoc())
		region = region[math.random(1,#region)]
		hasRobbed = true
		if (AI.GetSetting("ShouldFlee")) then
			AI.StateMachine.ChangeState("FleeAfterRobbery")
			CallFunctionDelayed(TimeSpan.FromSeconds(6),function ( ... )
				hasRobbed = false
				if (AI.StateMachine.CurState == "Flee") then
					AI.StateMachine.ChangeState("Idle")
				end
			end)
			this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(45000), "robberyRestart")
		else
			AI.StateMachine.ChangeState("Idle")
			this:StopMoving()
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "MoreRobbery",
	function (user,buttonId)
		if (user == nil or not user:IsValid()) then return end
		if (buttonId == "GiveUpItem") then
			if (robberyType[1] == "Backpack") then
				local backpackUser = user:GetEquippedObject("Backpack")
				local backpackObj = this:GetEquippedObject("Backpack")
				local objects = FindItemsInContainerRecursive(backpackUser)
				user:SystemMessage("[D70000]The bandit takes all of your items in your backpack![-]")	 --DFB TODO: Localize this to $3323
				for i,j in pairs(objects) do
					local randomLoc = GetRandomDropPosition(backpackObj)
					j:MoveToContainer(backpackObj,randomLoc)
				end
				MoreRobbery()
			else
				local item = user:GetEquippedObject(robberyType[1])
				local backpackObj = this:GetEquippedObject("Backpack")
				local randomLoc = GetRandomDropPosition(backpackObj)
				user:SystemMessage("[D70000]The bandit takes the item![-]")	 --DFB TODO: Localize this to $3322
				if (item ~= nil) then
					item:MoveToContainer(backpackObj,randomLoc)
				end
				MoreRobbery()
			end
		else
			AttackRobberyTarget()
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "Robbery",
	function (user,buttonId)
		if (user == nil) then return end
		if (buttonId == "Pay") then
			local backpackObj = this:GetEquippedObject("Backpack")
			local backpackUser = user:GetEquippedObject("Backpack")
			local money = GetResourcesInContainer(backpackUser,"coins")
			local count = CountCoins(user)
			local randomLoc = GetRandomDropPosition(backpackObj)
			for i,j in pairs (money) do
				j:MoveToContainer(backpackObj,randomLoc)
			end
			user:SystemMessage("[$19]")
			MoreRobbery()
		else
			AttackRobberyTarget()
		end
	end)

--reduce faction for damaging cultists
--When I get hit.
RegisterEventHandler(EventType.Message, "DamageInflicted", 
function (damager,damageAmt)    
    if (damager == nil or not damager:IsValid()) then return end
    if (IsFriend(damager) and AI.Anger < 100) then return end
        --but attack anyone that attack's my bretheren
    local nearbyCultists = FindObjects(SearchMulti(
    {
        SearchMobileInRange(AI.GetSetting("ChaseRange")), --in 10 units
        SearchObjVar("MobileTeamType",this:GetObjVar("MobileTeamType")), --find cultists
    }))
    for i,j in pairs (nearbyCultists) do
        if (not IsInCombat(j) and not j:HasTimer("RecentlyAlerted")) then
            j:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"RecentlyAlerted")
            --DebugMessage("Sending message to j")
                --DebugMessage("attacking enemy")
            j:SendMessage("AttackEnemy",damager,true) --defend me
        end
    end
    --end
    if (not this:HasObjVar("HasFaction")) then return end
    if (damager:HasObjVar("controller")) then
        damager = damager:GetObjVar("controller")
    end
    ChangeFactionByAmount(damager,-4,this:GetObjVar("MobileTeamType"))
end)

RegisterEventHandler(EventType.Message, "DamageInflicted",
	function (damager)
        if (IsFriend(attacker) and AI.Anger < 100) then return end
		if (RobberyTarget ~= nil) then
		    RobberyTarget:CloseDynamicWindow("Robbery")
		    RobberyTarget:CloseDynamicWindow("MoreRobbery")
		end
		if AI.IsValidTarget(damager) then
			DebugMessageA(this,"Target Damager")
            local myTeamType = this:GetObjVar("MobileTeamType")
		    local nearbyTeamMembers = FindObjects(SearchMulti(
		    {
		        SearchMobileInRange(20), --in 10 units
		        SearchObjVar("MobileTeamType",myTeamType), --find others with my team type
		    }))
		    for i,j in pairs (nearbyTeamMembers) do
		        j:SendMessage("AttackEnemy",damager) --defend me
		    end
		end
	end)
