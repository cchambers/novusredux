require "default:incl_magic_sys"

--[[

Seperate module that attaches directly to the user to allow for capturing EventType.DynamicWindowResponse

]]
RUNEBOOK_X_OFFSET = 0.77
RUNEBOOK_Y_OFFSET = 0.77
RUNEBOOK_WIDTH = 789
RUNEBOOK_HEIGHT = 455

RUNEBOOK_CALC_WIDTH = RUNEBOOK_WIDTH * RUNEBOOK_X_OFFSET
RUNEBOOK_CALC_HEIGHT = RUNEBOOK_HEIGHT * RUNEBOOK_Y_OFFSET

mRuneBook = nil

function ShowRuneBookDialog(from)

	local Runes = mRuneBook:GetObjVar("RuneList")
	DebugMessage(tostring(CountTable(Runes)))
	local dynamicWindow =
		DynamicWindow(
		"RuneBook",
		"",
		RUNEBOOK_WIDTH,
		RUNEBOOK_HEIGHT,
		-RUNEBOOK_WIDTH / 2,
		-RUNEBOOK_HEIGHT / 2,
		"TransparentDraggable",
		"Center"
	)

	dynamicWindow:AddImage(0, 0, "PrestigeBook", RUNEBOOK_WIDTH, RUNEBOOK_HEIGHT)
	dynamicWindow:AddButton(726, 22, "", "", 0, 0, "", "", true, "CloseSquare", buttonState)	

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
			if (result[1] == "ChangePage") then
				mPageType = result[2]
				mPageNumber = tonumber(result[3])
				ShowRuneBookDialog("change page to " .. tostring(mPageNumber))
				return
			elseif (returnId == "Drop") then
				local carriedObject = user:CarriedObject()
				if (carriedObject) then
					local spell = carriedObject:GetObjVar("Spell")
					if (spell and SpellData.AllSpells[spell]) then
						TryAddSpellToSpellbook(mRuneBook, carriedObject, user)
					end
				end
				return
			end
		end

		this:DelModule("runebook_dynamic_window")
	end
)


-- KHI: MAKE IT SO YOU CAN DRAG/DROP RUNES TO THE GROUND?!

-- RegisterEventHandler(
-- 	EventType.ClientObjectCommand,
-- 	"dropAction",
-- 	function(user, sourceId, actionType, actionId, slot)
-- 		--DebugMessage(1)
-- 		--DebugMessage(user,sourceId,actionType,actionId,slot)
-- 		if ((sourceId == "RuneBook") and slot ~= nil) then
-- 			--DebugMessage(2)
-- 			local hotbarAction = GetSpellUserAction(actionId)
-- 			hotbarAction.Slot = tonumber(slot)
-- 			RequestAddUserActionToSlot(user, hotbarAction)
-- 		end
-- 	end
-- )

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
