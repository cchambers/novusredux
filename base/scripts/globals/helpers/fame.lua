
--- Reward a player with fame and give them messages about it
-- @param player
-- @param amount
function RewardFame(player, amount)
	local maxFame = 15000
    local currentFame = player:GetObjVar("Fame") or 0
    -- if they aren't to cap yet
    if ( currentFame < maxFame ) then
        local newFame = math.min(currentFame + amount, maxFame)
        if amount >=40 then player:SystemMessage("You have gained a lot of fame.","info")
            elseif amount >=20 and amount < 40 then player:SystemMessage("You have gained a good amount of fame.","info")
                elseif amount >=10 and amount < 20 then player:SystemMessage("You have gained some fame.","info")
                    elseif amount >=0 and amount < 40 then player:SystemMessage("You have gained a little fame.","info")
        end
        player:SetObjVar("Fame", newFame)
    end
end