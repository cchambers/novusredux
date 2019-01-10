function ShowStatusElement(mobileObj, args)
	args = {
		DialogId = args.DialogId or ("Status" .. mobileObj.Id),
		ScreenX = args.ScreenX or 300,
		ScreenY = args.ScreenY or 300,
		IsSelf = args.IsSelf or false,
		FrameImage = args.FrameImage or "UtilityBar_Frame",
		User = args.User or mobileObj
	}

	local width = 166
	local height = (args.IsSelf and 58) or 44
	local statusWindow = DynamicWindow(args.DialogId, "", width, height, args.ScreenX, args.ScreenY, "Transparent")
	-- local online = GlobalVarRead("User.Online")
	-- local userCount = "CNX: " .. tostring(#online)
	-- 	statusWindow:AddLabel(
	-- 		200, -- (number) x position in pixels on the window 
	-- 		10, -- (number) y position in pixels on the window 
	-- 		userCount)
	-- 	-- RegisterEventHandler(EventType.Message, "CheckCount", 
	-- 	-- function(user,count)
		
	-- 	-- end)	
	-- end
	
	-- this is a special command that handles the click client side by targeting the mob with the id of the buttonid
	statusWindow:AddButton(0, 0, "", "", width, height, "", "$target " .. mobileObj.Id, false, "Invisible")

	statusWindow:AddImage(0, 0, args.FrameImage)

	local modifiedName = StripColorFromString(mobileObj:GetName())
	statusWindow:AddLabel(16, 6, modifiedName, 140, 20, 15, "left", false, true, "SpectralSC-SemiBold")

	local statusFrameImage = (args.IsSelf and "UtilityBar_StatusFrame") or "UtilityBar_StatusFrameSingle"
	statusWindow:AddImage(14, 20, statusFrameImage, 135, 0, "Sliced")

	statusWindow:AddStatBar(17, 23, 129, 7, "Health", "FF0000", mobileObj)

	if (args.IsSelf) then
		statusWindow:AddStatBar(17, 33, 129, 4, "Mana", "3388ff", mobileObj)
		statusWindow:AddStatBar(17, 40, 129, 4, "Stamina", "fffd52", mobileObj)
	end

	args.User:OpenDynamicWindow(statusWindow)
end

function UpdateItemBar(mobileObj)
	local itemSlotStartIndex = 21

	--local curSlot = itemSlotStartIndex
	--local backpack = this:GetEquippedObject("Backpack")
	--for i,objRef in pairs(backpack:GetContainedObjects()) do
	--	if(i <= 8) then
	--		local curAction = GetItemUserAction(objRef,this)
	--		curAction.Slot = curSlot
	--		AddUserActionToSlot(curAction)

	--		curSlot = curSlot + 1
	--	end
	--end

	-- two rows of 4
	local itemSize = 43
	local itembarHeight = itemSize * 4

	local spellBarWindow = DynamicWindow("itembar", "", 0, 0, 0, -(itembarHeight / 2), "Transparent", "Right")
	for itemIndex = 0, 7 do
		local yIndex = ((itemIndex) % 4)
		local xIndex = math.floor((itemIndex) / 4)

		spellBarWindow:AddHotbarAction(
			-(2 + itemSize) - (xIndex * itemSize),
			(yIndex * itemSize),
			itemSlotStartIndex + itemIndex,
			0,
			0,
			"Circle",
			true
		)
	end

	mobileObj:OpenDynamicWindow(spellBarWindow)
end

function UpdateSpellBar(mobileObj)
	--local curAction = GetSpellUserAction("Fireball")
	--curAction.Slot = 1
	--AddUserActionToSlot(curAction)
	--curAction = GetSpellUserAction("Greaterheal")
	--curAction.Slot = 2
	--AddUserActionToSlot(curAction)
	--curAction = GetSpellUserAction("Lightning")
	--curAction.Slot = 3
	--AddUserActionToSlot(curAction)

	local spellItemSize = 48
	local spellbarHeight = spellItemSize * 10
	local spellSlotStartIndex = 1

	local spellBarWindow = DynamicWindow("spellbar", "", 0, 0, 0, -(spellbarHeight / 2), "Transparent", "Left")
	local curX = 2
	for x = 0, 1 do
		for y = 0, 9 do
			local index = (x * 10) + y
			spellBarWindow:AddHotbarAction(curX, y * spellItemSize, index + spellSlotStartIndex, 0, 0, "Square", true)
		end
		curX = curX + spellItemSize
	end

	mobileObj:OpenDynamicWindow(spellBarWindow)
end

function UpdateHotbar(mobileObj)
	local abilitySlotStartIndex = 29

	local hasPrimary = GetWeaponAbility(mobileObj, true) ~= nil
	local hasSecondary = GetWeaponAbility(mobileObj, false) ~= nil
	local isNewPlayer = mobileObj:GetObjVar("InitiateMinutes") ~= nil

	local abilityCount = 0
	if (hasPrimary) then
		abilityCount = abilityCount + 1
	end
	if (hasSecondary) then
		abilityCount = abilityCount + 1
	end
	if (isNewPlayer) then
		abilityCount = abilityCount + 1
	end

	if (abilityCount == 0) then
		mobileObj:CloseDynamicWindow("actionbar")
	else
		local actionWindow = DynamicWindow("actionbar", "", 0, 0, -90, -68, "Transparent", "Bottom")
		local curX = 0
		if (abilityCount == 1) then
			curX = 65
		elseif (abilityCount == 2) then
			curX = 35
		end

		if (hasPrimary) then
			actionWindow:AddHotbarAction(curX, 0, abilitySlotStartIndex, 0, 0, "SquareFixed", false)
			curX = curX + 60
		end

		if (hasSecondary) then
			actionWindow:AddHotbarAction(curX, 0, abilitySlotStartIndex + 1, 0, 0, "SquareFixed", false)
			curX = curX + 60
		end

		if (isNewPlayer) then
			data = {
				ID = "magicalguide",
				ActionType = "CustomCommand",
				DisplayName = "Summon Guide",
				Tooltip = "Summon or talk to your magical guide.\n\nYour magical guide can help you find places and give you tips as you explore this new land.",
				Icon = "magicalguide",
				ServerCommand = "Guide",
				Enabled = true
			}
			--GW need to revert this back to NoHotKey with new client.
			actionWindow:AddUserAction(curX, 0, data, 0, 0, "SquareFixedNoHotkey")
		end

		mobileObj:OpenDynamicWindow(actionWindow)
	end
end

local guardProtectionStrs = {
	["Neutral"] = "[E1BB00]Neutral[-]",
	["Protection"] = "[00FF00]Guarded[-]",
	["Town"] = "[FFD700]Town[-]"
}

function UpdateRegionStatus(playerObj, areaName, curProtection)
	areaName = areaName or GetRegionalName(playerObj:GetLoc())
	curProtection = curProtection or playerObj:GetObjVar("GuardProtection") or ""

	local protectionStr = guardProtectionStrs[curProtection] or "[FF0000]Wilderness[-]"

	local dynWindow = DynamicWindow("regionstatus", "", 0, 0, -196, 190, "Transparent", "TopRight")
	dynWindow:AddLabel(100, 0, areaName, 0, 0, 20, "center", false, true, "SpectralSC-SemiBold")
	dynWindow:AddLabel(100, 18, protectionStr, 0, 0, 16, "center", false, true, "SpectralSC-SemiBold")

	-- not the best place to put the god button but it works
	if (IsImmortal(playerObj)) then
		dynWindow:AddButton(157, -77, "", "", 22, 21, "", "ToggleGodWindow", false, "God")
	end

	playerObj:OpenDynamicWindow(dynWindow)
end
