this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"ColorWar.Item")

function HandleCreation()
	if (this:IsContainer()) then
		local top = this:TopmostContainer()
		local backpackObj = top:GetEquippedObject("Backpack")
		local objects = FindItemsInContainerRecursive(this)
		for i, j in pairs(objects) do
			local randomLoc = GetRandomDropPosition(backpackObj)
			j:MoveToContainer(backpackObj, randomLoc)

			if (IsPlayerCharacter(top)) then
				SetItemTooltip(j)
				if (HasUseCase(j, "Equip")) then
					DoEquip(j, top)
				end
			end
		end
		this:Destroy()
	else
		this:SetObjVar("ColorWarItem", true)
		this:SetObjVar("NoDecay", true)
		SetItemTooltip(this)
	end
end

RegisterEventHandler(EventType.Timer,"ColorWar.Item", HandleCreation)
