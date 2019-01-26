require "default:scriptcommands"
require "account_functions"

-- RegisterCommand{ Command="prestige", AccessLevel = AccessLevel.Mortal, Func=function(a,b,c,d) PrestigeAbilityWindow(this,a,b,c,d) end, Desc="Handy dandy prestige window." }

RegisterCommand {
    Command = "jail",
    AccessLevel = AccessLevel.Immortal,
    Func = function(targetObjId)
        this:RequestClientTargetGameObj(this, "jail")
    end,
    Desc = "Jail a player."
}

RegisterCommand {
    Command = "cd",
    Category = "God Power",
    AccessLevel = AccessLevel.Immortal,
    Func = function()
        local mFrom = 5
        RegisterEventHandler(
            EventType.Timer,
            "countdown",
            function()
                if (mFrom == 0) then
                    this:NpcSpeech("[b][ff0000]FIGHT![-]")
                    this:PlayEffect("ShockwaveEffect")
                    CallFunctionDelayed(TimeSpan.FromSeconds(0.5), function ()
                        this:PlayEffect("BodyExplosion")
                    end)
                    CallFunctionDelayed(TimeSpan.FromSeconds(0.55), function ()
                        ImmortalCommandFuncs.Cloak()
                    end)
                else
                    this:NpcSpeech(tostring("[b][bada55]" .. mFrom .. "[-]"))
                    this:PlayEffect("ImpactWaveEffect")
                    mFrom = mFrom - 1
                    this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "countdown")
                end
            end
        )

        this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "countdown")

    end,
    Desc = "Countdown."
}

RegisterCommand {
    Command = "exit",
    Category = "God Power",
    AccessLevel = AccessLevel.Immortal,
    Func = function()
        this:PlayEffect("BodyExplosion")
        CallFunctionDelayed(TimeSpan.FromSeconds(0.1), ImmortalCommandFuncs.Cloak)
    end,
    Desc = "Exit in a cool cool way."
}

RegisterCommand {
    Command = "pets",
    Category = "Mortal Power",
    AccessLevel = AccessLevel.Mortal,
    Func = function()
        local remaining = GetRemainingActivePetSlots(this)
        local max = MaxActivePetSlots(this)
        this:SystemMessage(tostring("You can control " .. max .. " slots worth of pets."))
        this:SystemMessage(tostring("You have " .. remaining .. " remaining slots open."))
    end,
    Desc = "Check pet slots."
}

-- RegisterCommand {
-- 	Command = "pve",
-- 	Category = "Mortal Power",
-- 	AccessLevel = AccessLevel.Mortal,
-- 	Func = function(user, buttonId)
--         ClientDialog.Show {
--             TargetUser = user,
--             DialogId = "CareBear" .. user.Id,
--             TitleStr = "CONVERT TO PvE ONLY",
--             DescStr = string.format("This will PERMANENTLY alter your character! If you enter PvE mode, you will never be able to participate in PvP with this character. Are you sure you want to be Player vs Environment only?"),
--             Button1Str = "Continue",
--             Button2Str = "Cancel",
--             ResponseObj = user,
--             ResponseFunc = function(user, buttonId)
--                 local buttonId = tonumber(buttonId)
--                 if (user == nil or buttonId == nil) then
--                     return
--                 end
--                 -- Handles the invite command of the dynamic window
--                 if (buttonId == 0) then
--                     user:SetObjVar("CareBear", true)
--                     return
--                 end
--             end
--         }
--     end,
-- 	Desc = "Exit in a cool cool way."
-- }

RegisterCommand {
    Command = "fixtracks",
    AccessLevel = AccessLevel.Mortal,
    Func = function()
        this:DelObjVar("TrackedSkills")
        this:DelObjVar("SkillFavorites")
        this:SystemMessage("Your tracked and favorited skills have been reset.")
    end,
    Desc = "Reset your tracked skills."
}

RegisterCommand {
    Command = "setjail",
    AccessLevel = AccessLevel.Immortal,
    Func = function()
        this:RequestClientTargetLoc(this, "set_jail_loc")
    end,
    Desc = "Sets the jail location in the world."
}

RegisterEventHandler(
    EventType.ClientTargetGameObjResponse,
    "jail",
    function(target, user)
        if (target == nil) then
            return
        end
        local user_id = target:GetAttachedUserId()

        WriteAccountVar(user_id, "jail", "jailLocation", target:GetLoc())
        WriteAccountVar(user_id, "jail", "isJailed", true)
        WriteAccountVar(user_id, "jail", "jailTime", os.time())
        WriteAccountVar(user_id, "jail", "sentence", 240)
        WriteAccountVar(user_id, "jail", "characterJailed", tostring(target))

        target:SetObjVar("NoGains", true)

        local jail_settings = GlobalVarRead("settings_jail")

        local jailLocation = jail_settings["location"]

        DoSlay(target)

        target:SetWorldPosition(jailLocation)

        this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1500), "resurrectTimer")

        RegisterEventHandler(
            EventType.Timer,
            "resurrectTimer",
            function()
                target:SystemMessage(
                    "You were just jailed, until your sentence is served you can only log in to this character, any attempt to login to another character will kick you automatically. You can pick up horse maneure to speed up your release."
                )
                target:SendMessage("PlayerResurrect", this, nil, true)
            end
        )
    end
)

RegisterEventHandler(
    EventType.ClientTargetLocResponse,
    "set_jail_loc",
    function(success, location, objectSelected)
        this:SystemMessage(tostring(location))
        WriteAccountVar("settings", "jail", "location", location)
    end
)
