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

circleIndex = 3

-- page types are ManifestationIndex, EvocationIndex, ManifestationSpellDetail, EvocationSpellIndex
mPageType = "EvocationIndex"
mPageNumber = 1

function ShowSpellDetail(dynamicWindow, spellEntry, xOffset)
	dynamicWindow:AddLabel(
		xOffset + 236,
		44,
		"[412A08]" .. (spellEntry.Data.SpellDisplayName or spellEntry.Name) .. "[-]",
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

function ShowSpellBookDialog()
	if (circle == nil) then
		circle = 1
	end

	local castingSkill = "EvocationSkill"
	if (mPageType == "ManifestationIndex" or mPageType == "ManifestationSpellDetail") then
		castingSkill = "ManifestationSkill"
	end

	local detailPageStr =
		(mPageType == "ManifestationIndex" or mPageType == "ManifestationSpellDetail") and "ManifestationSpellDetail" or
		"EvocationSpellDetail"
	local isDetailPage = (mPageType == "ManifestationSpellDetail" or mPageType == "EvocationSpellDetail")

	local bookSpells = mSpellBook:GetObjVar("SpellList") or nil
	local spellsSorted = {}

	if (bookSpells) then
		for k, v in pairs(SpellData.AllSpells) do
			if (mPageType == "CircleIndex") then
				local nextCircle = circleIndex + 1
				if (v.Circle == circleIndex) then
					table.insert(spellsSorted, {Name = k, Data = v})
				elseif (v.Circle == nextCircle) then
					table.insert(spellsSorted, {Name = k, Data = v})
				end
			elseif (bookSpells[k] and v.Skill == castingSkill) then
				table.insert(spellsSorted, {Name = k, Data = v})
			end
		end

		table.sort(
			spellsSorted,
			function(a, b)
				local circleA = (a.Data.Circle or 0)
				local circleB = (b.Data.Circle or 0)
				if (circleA == circleB) then
					return a.Name < b.Name
				else
					return circleA < circleB
				end
			end
		)
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

	if (isDetailPage) then
		local isFirstPage = (mPageNumber == 1)
		local isLastPage = (mPageNumber == math.ceil(#spellsSorted / 2))

		if not (isFirstPage) then
			local pageStr = tostring(mPageNumber - 1)
			dynamicWindow:AddButton(
				60,
				24,
				"ChangePage|" .. detailPageStr .. "|" .. pageStr,
				"",
				154,
				93,
				"",
				"",
				false,
				"BookPageDown"
			)
		end

		if not (isLastPage) then
			local pageStr = tostring(mPageNumber + 1)
			dynamicWindow:AddButton(
				574,
				24,
				"ChangePage|" .. detailPageStr .. "|" .. pageStr,
				"",
				154,
				93,
				"",
				"",
				false,
				"BookPageUp"
			)
		end
	end

	dynamicWindow:AddButton(726, 22, "", "", 0, 0, "", "", true, "CloseSquare", buttonState)

	local buttonState = ""
	if (mPageType == "EvocationIndex" or mPageType == "EvocationSpellDetail") then
		buttonState = "pressed"
	end

	dynamicWindow:AddButton(3, 70, "ChangePage|EvocationIndex|1", "", 78, 58, "", "", false, "EvocationTab", buttonState)

	buttonState = ""
	if (mPageType == "ManifestationIndex" or mPageType == "ManifestationSpellDetail") then
		buttonState = "pressed"
	end

	dynamicWindow:AddButton(
		3,
		126,
		"ChangePage|ManifestationIndex|1",
		"",
		76,
		58,
		"",
		"",
		false,
		"ManifestationTab",
		buttonState
	)

	dynamicWindow:AddButton(3, 200, "ChangePage|CircleIndex|1", "Circle 3-4", 76, 58, "", "", false, "Default", "default")

	if (mPageType == "ManifestationIndex" or mPageType == "EvocationIndex") then
		local labelStr = (mPageType == "ManifestationIndex") and "[412A08]Manifestation[-]" or "[412A08]Evocation[-]"

		dynamicWindow:AddLabel(236, 44, labelStr, 0, 0, 46, "center", false, false, "Kingthings_Calligraphica_Dynamic")

		dynamicWindow:AddImage(110, 80, "SpellIndexInfo_Divider", 250, 0, "Sliced")

		local xOffset = 110
		local yOffset = 90
		local spellIndex = 1
		for i, spellEntry in pairs(spellsSorted) do
			local pageStr = tostring(math.ceil(spellIndex / 2))
			dynamicWindow:AddButton(
				xOffset,
				yOffset,
				"ChangePage|" .. detailPageStr .. "|" .. pageStr,
				tostring(spellEntry.Data.Circle or 1) .. "|" .. (spellEntry.Data.SpellDisplayName or spellEntry.Name),
				250,
				34,
				"",
				"",
				false,
				"BookList"
			)

			yOffset = yOffset + 36
			spellIndex = spellIndex + 1
			if (spellIndex == 9) then
				yOffset = 48
				xOffset = xOffset + 320
			end
		end

		-- ADD SCROLL DROPZONE
		dynamicWindow:AddButton(
			xOffset,
			yOffset,
			"Drop",
			"+|Drop spell scroll here bitch",
			250,
			34,
			"",
			"",
			false,
			"BookList",
			"faded"
		)
	elseif (mPageType == "CircleIndex") then -- MY SPECIAL PAGE
		dynamicWindow:AddImage(110, 80, "SpellIndexInfo_Divider", 250, 0, "Sliced")
		local xOffset = 110
		local yOffset = 90
		local spellIndex = 1
		local circleIndex = 0
		for i, spellEntry in pairs(spellsSorted) do
			if (circleIndex == 0) then
				circleIndex = spellEntry.Data.Circle
				local labelStr = "[412A08]Circle " .. circleIndex .. "[-]"
				dynamicWindow:AddLabel(236, 44, labelStr, 0, 0, 46, "center", false, false, "Kingthings_Calligraphica_Dynamic")
				local labelStr = "[412A08]Circle " .. circleIndex+1 .. "[-]"
				dynamicWindow:AddLabel(550, 44, labelStr, 0, 0, 46, "center", false, false, "Kingthings_Calligraphica_Dynamic")
			end

			if (spellEntry.Data.Circle == circleIndex) then
			else
				circleIndex = spellEntry.Data.Circle
				yOffset = 90
				xOffset = xOffset + 320
			end

			local pageStr = tostring(math.ceil(spellIndex / 2))
			dynamicWindow:AddButton(
				xOffset,
				yOffset,
				"ChangePage|" .. detailPageStr .. "|" .. pageStr,
				tostring(spellEntry.Data.Circle or 1) .. "|" .. (spellEntry.Data.SpellDisplayName or spellEntry.Name),
				250,
				34,
				"",
				"",
				false,
				"BookList"
			)
			yOffset = yOffset + 36
			spellIndex = spellIndex + 1
		end
	else
		local xOffset = 0
		local spellIndex = 1
		local spellStart = ((mPageNumber - 1) * 2) + 1
		for i, spellEntry in pairs(spellsSorted) do
			if (spellIndex >= spellStart and spellIndex <= spellStart + 1) then
				ShowSpellDetail(dynamicWindow, spellEntry, xOffset)
				xOffset = 320
			end
			spellIndex = spellIndex + 1
		end
	end

	this:OpenDynamicWindow(dynamicWindow)
	mOpen = true
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
		ShowSpellBookDialog()
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
				ShowSpellBookDialog()
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
