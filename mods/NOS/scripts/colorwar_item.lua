--[[
- Destroy when not in TestMap or TwoTowers
- Color itself to match wielder's skin tone
- 
]]--


function HandleRequestPickup(user) 
	this:SetHue(user:GetHue())
end

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(),
	function()	
		this:SetObjVar("ColorwarItem", true)
		this:SetObjVar("NoDecay", true)
	end)

RegisterEventHandler(EventType.RequestPickUp, "", HandleRequestPickUp)