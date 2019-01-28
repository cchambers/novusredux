--[[
- Destroy when not in TestMap or TwoTowers
- Color itself to match wielder's skin tone
- 
]]--


function HandleRequestPickup() 
    DebugMessage("CW ITEM PICKUP")
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(),
	function()	
		this:SetObjVar("ColorwarItem", true)
	end)

RegisterEventHandler(EventType.RequestPickUp, "", HandleRequestPickUp)