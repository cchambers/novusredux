require 'incl_container'

STACK_LOSS_PERCENT_ON_FAIL = 0.10

mOre = nil
mResourceType = nil
mBackpack = nil
mTool = nil
mFinalIngots = 0

ORE_TO_INGOT_TYPE = {
	IronOre = "IronIngots"
}

function TrySmelt(ore)
	mOre = ore
	mResourceType = mOre:GetObjVar("ResourceType")
	mBackpack = this:GetEquippedObject("Backpack")
	mTool = GetNearbyTool()

	if not( VerifySmelt() ) then
		CleanUp()
		return
	end

	SmeltOre()
end

function VerifySmelt()

	if ( this:HasTimer("PreventSmeltingSpamTimer") ) then
		this:SystemMessage("Must wait a little between smelting ore.", "info")
		return false
	end

	if ( mBackpack == nil ) then
		this:SystemMessage("Must have a backpack to smelt ore.", "info")
		return false
	end

	if not( mOre:IsContainedBy(mBackpack) ) then
		this:SystemMessage("The ore must be in your backpack to smelt it.", "info")
		return false
	end

	if ( mTool == nil ) then
		this:SystemMessage("Must be near a forge to smelt.", "info")
		return false
	end

	return true
end

function SmeltOre()
	this:PlayObjectSound("SoupCook", false, 2)
	FaceObject(this,mTool)

	local miningSkill = GetSkillLevel(this,"MiningSkill") or 0
	local chance = 0
	if ( miningSkill >= 25 ) then
		chance = ( miningSkill - 25 ) * 2
	end

	local stackCount = GetStackCount(mOre)

	if ( CheckSkill(this,"MiningSkill", ( mOre:GetObjVar("Difficulty") or 25 ) ) ) then
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "PreventSmeltingSpamTimer")
		mFinalIngots = stackCount*2
		ConsumeResources(stackCount)
	else
		local newCount = stackCount - math.ceil( stackCount * STACK_LOSS_PERCENT_ON_FAIL )
		if ( newCount <= 0 ) then
			mOre:Destroy()
			this:SystemMessage("You fail, destroying the ore.", "info")
		else
			RequestSetStack(mOre,newCount)
			this:SystemMessage("You fail, destroying some ore.", "info")
		end
		CleanUp()
	end
end

function GetNearbyTool()
	return FindObject(SearchMulti(
    {
        SearchRange(this:GetLoc(), 3),
        SearchTemplate("tool_forge")
    }))
end

function ConsumeResources(amount)
	RequestConsumeResource(this,mResourceType, amount, "SmeltConsumeResource", this)
end

function CreateIngots()
	this:SystemMessage("You smelt the ore into "..mFinalIngots.." ingots.", "info")

	local resourceType = ORE_TO_INGOT_TYPE[mResourceType]

	local added, addtostackreason = TryAddToStack(resourceType, mBackpack, mFinalIngots)
	if ( added ) then
		CleanUp()
		return
	end

	local createId = "smelt_ingot_"..uuid()
	local canCreateInBag, reason = CreateObjInBackpackOrAtLocation(this, ResourceData.ResourceInfo[resourceType].Template, createId, mFinalIngots)
	RegisterSingleEventHandler(EventType.CreatedObject, createId,
		function(success, objRef, amount)
			SetItemTooltip(objRef)
			if success and amount > 1 then
				RequestSetStack(objRef,amount)
			end
			CleanUp()
		end)
end

function CleanUp()
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
	function (success, transactionId, user)
		if ( transactionId == "SmeltConsumeResource" ) then
			if ( success ) then
				CreateIngots()
			end
		end
	end)

RegisterEventHandler(EventType.Message, "SmeltOre", function(ore)
	TrySmelt(ore)
end)