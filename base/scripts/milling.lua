require 'incl_container'

mWood = nil
mResourceType = nil
mBackpack = nil
mTool = nil
mFinalBoards = 0

WOOD_TO_BOARD_TYPE = {
	Wood = "Boards"
}

function TryMill(wood)
	mWood = wood
	mResourceType = mWood:GetObjVar("ResourceType")
	mBackpack = this:GetEquippedObject("Backpack")
	mTool = GetNearbyTool()

	if not( VerifyMill() ) then
		CleanUp()
		return
	end

	MillWood()
end

function VerifyMill()

	if ( this:HasTimer("PreventMillingSpamTimer") ) then
		this:SystemMessage("Must wait a little between milling.", "info")
		return false
	end

	if ( mBackpack == nil ) then
		this:SystemMessage("Must have a backpack to mill wood.", "info")
		return false
	end

	if not( mWood:IsContainedBy(mBackpack) ) then
		this:SystemMessage("The wood must be in your backpack to mill it.", "info")
		return false
	end

	if ( mTool == nil ) then
		this:SystemMessage("Must be near a carpentry table to mill.", "info")
		return false
	end

	return true
end

function MillWood()
	this:PlayObjectSound("Woodsmith", false, 2)
	FaceObject(this,mTool)

	local stackCount = GetStackCount(mWood)

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "PreventMillingSpamTimer")
	mFinalBoards = stackCount
	ConsumeResources(stackCount)
end

function GetNearbyTool()
	return FindObject(SearchMulti(
    {
        SearchRange(this:GetLoc(), 3),
        SearchTemplate("tool_carpentry_table")
    }))
end

function ConsumeResources(amount)
	RequestConsumeResource(this,mResourceType, amount, "MillConsumeResource", this)
end

function CreateBoards()
	this:SystemMessage("You mill the wood into "..mFinalBoards.." boards.", "info")

	local resourceType = WOOD_TO_BOARD_TYPE[mResourceType]

	local added, addtostackreason = TryAddToStack(resourceType, mBackpack, mFinalBoards)
	if ( added ) then
		CleanUp()
		return
	end

	local createId = "mill_wood_"..uuid()
	RegisterSingleEventHandler(EventType.CreatedObject, createId,
		function(success, objRef, amount)
			SetItemTooltip(objRef)
			if success and amount > 1 then
				RequestSetStack(objRef,amount)
			end
			CleanUp()
		end)
	local canCreateInBag, reason = CreateObjInBackpackOrAtLocation(this, ResourceData.ResourceInfo[resourceType].Template, createId, mFinalBoards)
end

function CleanUp()
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
	function (success, transactionId, user)
		if ( transactionId == "MillConsumeResource" ) then
			if ( success ) then
				CreateBoards()
			end
		end
	end)

RegisterEventHandler(EventType.Message, "MillWood", function(wood)
	TryMill(wood)
end)