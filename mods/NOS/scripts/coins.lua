require 'default:coins'

function UpdateWeight(amounts)
	if(GetWeight(this) ~= -1) then
        local oldWeight = this:GetSharedObjectProperty("Weight")
        if (oldWeight ~= "1") then
            this:SetSharedObjectProperty("Weight", "1");
            return
        end
		-- amounts = amounts or GetAmounts()

		-- local singleWeight = ServerSettings.Misc.CoinWeight or 1
		-- local stackWeight = math.ceil(math.max(1,GetCoinCount(amounts)*singleWeight))
		-- if(this:GetSharedObjectProperty("Weight") ~= stackWeight) then
		-- 	this:SetSharedObjectProperty("Weight",stackWeight)
		-- end

		-- local newWeight = this:GetSharedObjectProperty("Weight")
		-- local adjustWeightBy = newWeight - oldWeight		
		-- if(adjustWeightBy ~= 0) then
		-- 	DebugMessage("Adjusted weight by "..adjustWeightBy)
		-- 	local containedObj = this:ContainedBy()
		-- 	if(containedObj ~= nil) then
		-- 		containedObj:SendMessage("AdjustWeight", adjustWeightBy)
		-- 	end
		-- end
	end
end