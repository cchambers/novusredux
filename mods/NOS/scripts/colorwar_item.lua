RegisterSingleEventHandler(
	EventType.ModuleAttached,
	GetCurrentModule(),
	function()
		if (this:HasModule("container")) then
			local backpackObj = target:TopmostContainer()
			local objects = FindItemsInContainerRecursive(this)
			for i, j in pairs(objects) do
				local randomLoc = GetRandomDropPosition(backpackObj)
				j:MoveToContainer(backpackObj, randomLoc)

				-- if (HasUseCase(j, "Equip")) then
				-- 	DoEquip(j, backpackObj)
				-- end
			end
			this:Destroy()
		else
			this:SetObjVar("ColorWarItem", true)
			this:SetObjVar("NoDecay", true)
		end
	end
)
