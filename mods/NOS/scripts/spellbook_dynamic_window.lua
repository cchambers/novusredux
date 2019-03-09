require "default:incl_magic_sys"

--[[

Seperate module that attaches directly to the user to allow for capturing EventType.DynamicWindowResponse

]]
SPELLBOOK_X_OFFSET = 0.77
SPELLBOOK_Y_OFFSET = 0.77
SPELLBOOK_WIDTH = 789
SPELLBOOK_HEIGHT = 455

SPELLBOOK_CALC_WIDTH = SPELLBOOK_WIDTH * SPELLBOOK_X_OFFSET
SPELLBOOK_CALC_HEIGHT = SPELLBOOK_HEIGHT * SPELLBOOK_Y_OFFSET

mSpellBook = nil
mPageType = "CircleIndex"
mPageNumber = 1

allSpells = nil
allSpellsIndexed = {}

function ShowSpellBookDialog(from)
	local detailPageStr = "CircleSpellDetail"

	if (circle == nil) then
		circle = 1
	end

	if (allSpells == nil) then
		allSpells = SpellData.AllSpells
	end
	local bookSpells = mSpellBook:GetObjVar("SpellList") or nil
	local spellsSorted = {}

	if (bookSpells) then
		local spellIndex = 0
		for k, v in pairs(allSpells) do
			spellIndex = spellIndex + 1
			allSpellsIndexed[spellIndex] = {Name = k, Data = v}
			if (bookSpells[k]) then
				local nextCircle = mPageNumber + 1
				if (v.Circle == mPageNumber) then
					table.insert(spellsSorted, {Name = k, Data = v, id = spellIndex})
				elseif (v.Circle == nextCircle) then
					table.insert(spellsSorted, {Name = k, Data = v, id = spellIndex})
				end
			end
		end

		table.sort(
			spellsSorted,
			function(a, b)
				local circleA = (a.Data.Circle or 0)
				local circleB = (b.Data.Circle or 0)
				if (circleA == circleB) then
					return a.Data.SpellDisplayName < b.Data.SpellDisplayName
				else
					return circleA < circleB
				end
			end
		)

	-- DebugMessage("Total Spells: " .. tostring(#spellsSorted))
	end

	local dynamicWindow =
		DynamicWindow(
		"SpellBook",
		"",
		SPELLBOOK_WIDTH,
		SPELLBOOK_HEIGHT,
		-SPELLBOOK_WIDTH / 2,
		-SPELLBOOK_HEIGHT / 2,
		"TransparentDraggable",
		"Center"
	)

	dynamicWindow:AddImage(0, 0, "Spellbook", SPELLBOOK_WIDTH, SPELLBOOK_HEIGHT)
	dynamicWindow:AddButton(726, 22, "", "", 0, 0, "", "", true, "CloseSquare", buttonState)

	dynamicWindow:AddButton(
		3,
		100,
		"ChangePage|CircleIndex|1",
		"Circles 1 & 2",
		100,
		40,
		"",
		"",
		false,
		"Default",
		"default"
	)
	dynamicWindow:AddButton(
		3,
		150,
		"ChangePage|CircleIndex|3",
		"Circles 3 & 4",
		100,
		40,
		"",
		"",
		false,
		"Default",
		"default"
	)
	dynamicWindow:AddButton(
		3,
		200,
		"ChangePage|CircleIndex|5",
		"Circles 5 & 6",
		100,
		40,
		"",
		"",
		false,
		"Default",
		"default"
	)
	dynamicWindow:AddButton(
		3,
		250,
		"ChangePage|CircleIndex|7",
		"Circles 7 & 8",
		100,
		40,
		"",
		"",
		false,
		"Default",
		"default"
	)
	if(IsDemiGod(this)) then
		dynamicWindow:AddButton(
			3,
			300,
			"ChangePage|CircleIndex|9",
			"Circles 9 & 10",
			100,
			40,
			"",
			"",
			false,
			"Default",
			"default"
		)
	end
	if (mPageType == "CircleIndex") then
		dynamicWindow:AddImage(110, 80, "SpellIndexInfo_Divider", 250, 0, "Sliced")
		local xOffset = 110
		local yOffset = 80
		local circleIndex = 0
		for i, spellEntry in pairs(spellsSorted) do
			if (circleIndex == 0) then
				circleIndex = mPageNumber
				nextCircle = circleIndex + 1
				local labelStr = "[412A08]Circle " .. circleIndex .. "[-]"
				dynamicWindow:AddLabel(236, 40, labelStr, 0, 0, 46, "center", false, false, "Kingthings_Calligraphica_Dynamic")
				local labelStr = "[412A08]Circle " .. nextCircle .. "[-]"
				dynamicWindow:AddLabel(550, 40, labelStr, 0, 0, 46, "center", false, false, "Kingthings_Calligraphica_Dynamic")
			end

			if (spellEntry.Data.Circle == circleIndex) then
			else
				circleIndex = spellEntry.Data.Circle
				yOffset = 80
				xOffset = xOffset + 320
			end

			local command = "ChangePage|" .. detailPageStr .. "|" .. spellEntry.id
			local name = spellEntry.Data.SpellDisplayName
			local skill = spellEntry.Data.Skill
			skill = string.sub(skill, 1, 1)
			local circle = tostring(spellEntry.Data.Circle or 1)
			dynamicWindow:AddButton(xOffset, yOffset, command, skill .. "|" .. name, 250, 34, "", "", false, "BookList")
			yOffset = yOffset + 31
		end
	end

	-- IS DETAIL PAGE
	if (mPageType == detailPageStr) then
		-- local pageActual = 1
		local pageActual = mPageNumber

		-- if ((mPageNumber % 2) == 0) then
		-- 	pageActual = mPageNumber - 1
		-- else
		-- end
		local xOffset = 0
		local spellStart = mPageNumber
		local spellEnd = mPageNumber + 1

		if (allSpellsIndexed[mPageNumber] ~= nil) then
			ShowSpellDetail(dynamicWindow, allSpellsIndexed[mPageNumber], 0)
		end
		-- if (allSpellsIndexed[spellEnd] ~= nil) then ShowSpellDetail(dynamicWindow, allSpellsIndexed[spellEnd], 320) end

		-- dog ears
		-- local isFirstPage = (mPageNumber == 1)
		-- local isLastPage = ((allSpellsIndexed[mPageNumber + 1] == nil))

		-- if not (isFirstPage) then
		-- 	local pageStr = tostring(mPageNumber - 1)
		-- 	dynamicWindow:AddButton(
		-- 		60,
		-- 		24,
		-- 		"ChangePage|" .. detailPageStr .. "|" .. pageStr,
		-- 		"",
		-- 		154,
		-- 		93,
		-- 		"",
		-- 		"",
		-- 		false,
		-- 		"BookPageDown"
		-- 	)
		-- end

		-- if not (isLastPage) then
		-- 	local pageStr = tostring(mPageNumber + 1)
		-- 	dynamicWindow:AddButton(
		-- 		574,
		-- 		24,
		-- 		"ChangePage|" .. detailPageStr .. "|" .. pageStr,
		-- 		"",
		-- 		154,
		-- 		93,
		-- 		"",
		-- 		"",
		-- 		false,
		-- 		"BookPageUp"
		-- 	)
		-- end
	end

	this:OpenDynamicWindow(dynamicWindow)
	mOpen = true
end

function ShowSpellDetail(dynamicWindow, spellEntry, xOffset)
	dynamicWindow:AddLabel(
		xOffset + 236,
		44,
		"[412A08]" .. spellEntry.Data.SpellDisplayName .. "[-]",
		0,
		0,
		46,
		"center",
		false,
		false,
		"Kingthings_Calligraphica_Dynamic"
	)

	dynamicWindow:AddImage(xOffset + 110, 80, "SpellIndexInfo_Divider", 250, 0, "Sliced")

	local actionData = GetSpellUserAction(spellEntry.Name)
	-- add spell user action
	dynamicWindow:AddUserAction(xOffset + 110, 100, actionData, 128, 128)

	dynamicWindow:AddLabel(
		xOffset + 250,
		118,
		"[412A08]Circle: " .. (spellEntry.Data.Circle or 1) .. "[-]",
		0,
		0,
		32,
		"center",
		false,
		false,
		"Kingthings_Calligraphica_Dynamic"
	)

	dynamicWindow:AddImage(xOffset + 110, 180, "SpellInfo_ReagentFrame", 250, 190, "Sliced")

	local regStr = GetReagentStr(spellEntry.Data.Reagents)
	if (regStr ~= "") then
		dynamicWindow:AddLabel(
			xOffset + 128,
			194,
			"[412A08]" .. regStr .. "[-]",
			0,
			0,
			32,
			"left",
			false,
			false,
			"Kingthings_Calligraphica_Dynamic"
		)
	end
end

RegisterEventHandler(
	EventType.Message,
	"OpenSpellBook",
	function(spellBook, pageType)
		if (spellBook == nil) then
			DebugMessage("[spellbook_dynamic_window|Message:OpenSpellBook] ERROR: spellBook is nil")
			return
		end
		if (pageType) then
			mPageType = pageType
			mPageNumber = 1
		end
		mSpellBook = spellBook
		ShowSpellBookDialog("open spellbook")
	end
)

RegisterEventHandler(
	EventType.DynamicWindowResponse,
	"SpellBook",
	function(user, returnId)
		if (returnId ~= nil) then
			local result = StringSplit(returnId, "|")
			if (result[1] == "ChangePage") then
				mPageType = result[2]
				mPageNumber = tonumber(result[3])
				ShowSpellBookDialog("change page to " .. tostring(mPageNumber))
				return
			elseif (returnId == "Drop") then
				local carriedObject = user:CarriedObject()
				if (carriedObject) then
					local spell = carriedObject:GetObjVar("Spell")
					if (spell and SpellData.AllSpells[spell]) then
						TryAddSpellToSpellbook(mSpellBook, carriedObject, user)
					end
				end
				return
			end
		end

		this:DelModule("spellbook_dynamic_window")
	end
)

RegisterEventHandler(
	EventType.ClientObjectCommand,
	"dropAction",
	function(user, sourceId, actionType, actionId, slot)
		--DebugMessage(1)
		--DebugMessage(user,sourceId,actionType,actionId,slot)
		if ((sourceId == "SpellBook") and slot ~= nil) then
			--DebugMessage(2)
			local hotbarAction = GetSpellUserAction(actionId)
			hotbarAction.Slot = tonumber(slot)
			RequestAddUserActionToSlot(user, hotbarAction)
		end
	end
)

RegisterEventHandler(
	EventType.ModuleAttached,
	GetCurrentModule(),
	function()
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "SWABNOCleanup")
	end
)

-- Spell Window Attached But Not Open Cleanup
RegisterEventHandler(
	EventType.Timer,
	"SWABNOCleanup",
	function()
		if not (mOpen) then
			this:DelModule("spellbook_dynamic_window")
		end
	end
)
