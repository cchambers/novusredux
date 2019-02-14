require 'default:stackable'


function SetStack(amount)
	local singleWeight = this:GetObjVar("UnitWeight") or 1
	
	local curWeight = this:GetSharedObjectProperty("Weight")
	local newWeight = math.max(1, amount*singleWeight)
	local adjustWeightBy = newWeight - curWeight

	this:SetObjVar("StackCount", amount)
	UpdateStackName(amount, this)
	if(adjustWeightBy ~= 0) then
		this:SetSharedObjectProperty("Weight", newWeight)
		local containedObj = this:ContainedBy()
        if(containedObj ~= nil) then
            if (not(containedObj:HasModule("container_magic"))) then
                containedObj:SendMessage("AdjustWeight", adjustWeightBy)
            end
		end
	end
end

function AdjustStack(delta)
	local stackCount = this:GetObjVar("StackCount") or 1
	local singleWeight = this:GetObjVar("UnitWeight") or 1
	stackCount = stackCount + delta
	if( stackCount <= 0 ) then
		this:Destroy()
	else
		local curWeight = this:GetSharedObjectProperty("Weight")
		local totalWeight = math.max(1, stackCount*singleWeight)
		local adjustWeightBy = totalWeight - curWeight

		this:SetObjVar("StackCount", stackCount)
		UpdateStackName(stackCount)

		if(adjustWeightBy ~= 0) then
			this:SetSharedObjectProperty("Weight", totalWeight)
			--DebugMessage("Adjusting Stack Weight By  "..adjustWeightBy.." - Old: "..curWeight.." New: "..totalWeight)

			local containedObj = this:ContainedBy()
			if(containedObj ~= nil) then
                --DebugMessage("(2) adjustWeightBy is "..tostring(adjustWeightBy))
                if (not(containedObj:HasModule("container_magic"))) then
                    containedObj:SendMessage("AdjustWeight", adjustWeightBy)
                end
			end
		end
	end
end
