require "NOS:incl_magic_sys"

RUNEBOOK_X_OFFSET = 0.77
RUNEBOOK_Y_OFFSET = 0.77
RUNEBOOK_WIDTH = 789
RUNEBOOK_HEIGHT = 455

RUNEBOOK_CALC_WIDTH = RUNEBOOK_WIDTH * RUNEBOOK_X_OFFSET
RUNEBOOK_CALC_HEIGHT = RUNEBOOK_HEIGHT * RUNEBOOK_Y_OFFSET

mRuneBook = nil
mRunes = nil
mOpen = false
mUseRegs = false

function ShowRuneBookDialog(from)
	mRunes = mRuneBook:GetObjVar("RuneList") or {}
	local dynamicWindow = DynamicWindow("RuneBook", "", RUNEBOOK_WIDTH, RUNEBOOK_HEIGHT, -RUNEBOOK_WIDTH / 2, -RUNEBOOK_HEIGHT / 2, "TransparentDraggable", "Center")

	dynamicWindow:AddImage(0, 0, "PrestigeBook", RUNEBOOK_WIDTH, RUNEBOOK_HEIGHT)
	dynamicWindow:AddButton(726, 22, "", "", 0, 0, "", "", true, "CloseSquare")

	dynamicWindow:AddImage(110, 80, "SpellIndexInfo_Divider", 250, 0, "Sliced")
	dynamicWindow:AddLabel(250, 40, "[412A08]Recalls: " .. (mRuneBook:GetObjVar("Charges") or 0) .. "    Portals: " .. (mRuneBook:GetObjVar("PortalCharges") or 0) .. "[-]", 0, 0, 32, "center", false, false, "Kingthings_Calligraphica_Dynamic")

	mUseRegs = mRuneBook:GetObjVar("UseRegs") or false
	local regsState = ""
	if (mUseRegs) then regsState = "pressed" end
	dynamicWindow:AddLabel(480, 45, "[412A08]Use reagents: " .. tostring(mUseRegs))
	dynamicWindow:AddButton(450, 44, "ToggleUseRegs", "", 0, 0, "", "", false, "Selection", regsState)

	local xOffset = 100
	local yOffset = 70
	for i, rune in pairs(mRunes) do
		if (i == 11) then
			yOffset = 70
			xOffset = xOffset + 320
		end
		local name = rune.Name
		dynamicWindow:AddButton(xOffset, yOffset, "Recall|" .. i, "x|" .. name, 250, 34, "Recall", "", true, "BookList")
		dynamicWindow:AddButton(xOffset + 20, yOffset + 6, "Drop|" .. i, "", 0, 0, "Remove rune; place in pack", "", false, "CloseSquare")
		dynamicWindow:AddButton(xOffset + 250, yOffset + 7, "Portal|" .. i, "", 22, 22, "Portal", "", true, "Star")
		-- dynamicWindow:AddButton(xOffset+250, yOffset+7, "Portal|"..i, "", 22, 22, "Portal", "", false, "Track")
		yOffset = yOffset + 31
	end

	this:OpenDynamicWindow(dynamicWindow)
	mOpen = true
end

RegisterEventHandler(
	EventType.Message,
	"OpenRuneBook",
	function(runeBook)
		if (runeBook == nil) then
			DebugMessage("[runebook_dynamic_window|Message:OpenRuneBook] ERROR: runeBook is nil")
			return
		end
		mRuneBook = runeBook
		ShowRuneBookDialog("open runebook")
	end
)

RegisterEventHandler(
	EventType.DynamicWindowResponse,
	"RuneBook",
	function(user, returnId)
		if (returnId ~= nil) then
			local result = StringSplit(returnId, "|")
			local action = result[1]
			if (action == "Drop") then
				-- splice ID from table
				local id = result[2]
				DropRune(id)
				ShowRuneBookDialog()
				return			
			elseif (action == "Recall") then
				if ((mRuneBook:GetObjVar("Charges") or 0) == 0 and not(mUseRegs)) then
					user:SystemMessage("Charge your Rune Book with Recall Scrolls.", "info")
					return
				else
					if (not(mUseRegs)) then
						local charges = mRuneBook:GetObjVar("Charges")
						charges = charges - 1
						mRuneBook:SetObjVar("Charges", charges)
					end
				end
				local id = result[2]
				local rune = GetRune(id)
				user:SendMessage("RuneBookCastSpell", "Recall", rune, mUseRegs)
				return
			elseif (action == "Portal") then
				if ((mRuneBook:GetObjVar("PortalCharges") or 0) == 0 and not(mUseRegs)) then
					user:SystemMessage("Charge your Rune Book with Portal Scrolls.", "info")
					return
				else
					if (not(mUseRegs)) then
						local charges = mRuneBook:GetObjVar("PortalCharges")
						charges = charges - 1
						mRuneBook:SetObjVar("PortalCharges", charges)
					end
				end
				local id = result[2]
				local rune = GetRune(id)
				user:SendMessage("RuneBookCastSpell", "Portal", rune, mUseRegs)
				return
			elseif (action == "ToggleUseRegs") then
				if (mUseRegs) then
					mUseRegs = false
				else
					mUseRegs = true
				end
				mRuneBook:SetObjVar("UseRegs", mUseRegs)
				ShowRuneBookDialog("use regs toggle")
				return
			end
		end

		this:DelModule("runebook_dynamic_window")
	end
)

function GetRune(id)
	local runes = mRuneBook:GetObjVar("RuneList")
	local rune = nil
	for i, r in pairs(runes) do
		if (tostring(i) == tostring(id)) then
			rune = r.Rune
		end
	end
	if (rune) then
		return rune
	end
end

function DropRune(id)
	local runes = mRuneBook:GetObjVar("RuneList")
	local rune = nil
	local which = nil
	for i, r in pairs(runes) do
		if (tostring(i) == tostring(id)) then
			rune = r.Rune
			which = i
		end
	end
	if (rune) then
		local backpackObj = this:GetEquippedObject("Backpack")
		local randomLoc = GetRandomDropPosition(backpackObj)
		rune:MoveToContainer(backpackObj,randomLoc)
		table.remove(runes, which)
		mRuneBook:SetObjVar("RuneList", runes)
		ShowRuneBookDialog()
	else
		DebugMessage("RUNEBOOK ERROR DROPPING")
	end
end

RegisterEventHandler(
	EventType.ModuleAttached,
	GetCurrentModule(),
	function()
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "RWANOCleanup")
	end
)

-- Rune Window Attached But Not Open Cleanup
RegisterEventHandler(
	EventType.Timer,
	"RWANOCleanup",
	function()
		if not (mOpen) then
			this:DelModule("runebook_dynamic_window")
		end
	end
)
