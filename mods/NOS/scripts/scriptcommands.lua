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
    Command = "setj_loc",
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

        target:SetObjVar("NoGains", true);
        
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
