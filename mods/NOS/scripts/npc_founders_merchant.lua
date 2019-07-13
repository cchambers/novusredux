require 'NOS:npc_founders_vip_merchant'

CanBuyItem = function (buyer,item)
    return IsFounder(buyer)
end
CanUseNPC = CanBuyItem
