require 'base_mobile_advanced'
require 'scriptcommands'
require 'scriptcommands_possessee'
require 'incl_player_group'
require 'incl_player_friend'
require 'player_say_commands'
require 'base_player_hotbar'

RegisterSingleEventHandler(EventType.ModuleAttached,"possessee",
    function()
        this:SetObjectTag("AttachedUser")
        UpdateFixedAbilitySlotsPossessee()
        this:SendClientMessage("SetKarmaState", GetKarmaAlignmentName(this))
	end)

function UpdateFixedAbilitySlotsPossessee()
    local curAction = GetWeaponAbilityUserAction(this, true)
	AddUserActionToSlot(curAction)
	local curAction = GetWeaponAbilityUserAction(this, false)
    AddUserActionToSlot(curAction)
    --UpdateHotbar(this)
end

--[[_DoMobileDeath = DoMobileDeath
function DoMobileDeath(damager)
    --EndPossess(this)

    _DoMobileDeath(damager)

    --this:SendMessage(string.format("End%sEffect", "Charmed"))
end
]]