--[[
- Destroy when not in TestMap or TwoTowers
- Color itself to match wielder's skin tone
- 
]]--

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(),
	function()	
		this:SetObjVar("ColorwarItem", true)
	end)
