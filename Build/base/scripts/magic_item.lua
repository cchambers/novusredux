require 'magic_item_helpers'

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(),
	function()
		local originalName = this:GetName()
		this:SetObjVar("OriginalName", originalName)
		local name, color = StripColorFromString(originalName)
		this:SetName("A Magic "..name)
		this:SendMessage("IdentifyItem")
	end)