require "default:globals.helpers.combat"

function DoResist(target, resistLevel, damage)
    local resistAmount = (resistLevel * 10 - 400) / 15
    -- target:SystemMessage(tostring("Damage: " .. damage .. " Resist: " .. resistAmount))
    target:PlayEffect("HoneycombShield", 1.5)
    if (target:HasObjVar("ProtectionSpell")) then
        resistAmount = resistAmount - (resistAmount * 0.35)
    end
    return (damage * (resistAmount) * 0.01)
end

-- STATS --
DebugMessage("TOTEM LOADED")

mPowerHourTrigger = 1250000

http = LoadExternalModule("http")
ltn12 = LoadExternalModule("ltn12")

function TotemGlobalEvent(task) 
    local api = tostring("http://localhost:1337/api/"..task)
    
    local payload = ""

    if (task == "powerhour") then
        payload = [[ { "name": "nada" } ]]
        local res, code, response_headers, status =
        http.request{
            url = api,
            method = "POST",
            headers = { 
                ["Content-Type"] = "application/json",
                ["Content-Length"] = payload:len()
            },
            source = ltn12.source.string(payload),
            sink = ltn12.sink.table(response_body)
        }
    end
    
end

function Totem(mobile, task, args)
    local id = mobile.Id
    local account = tostring(mobile:GetAttachedUserId())
    local ip = tostring(mobile:GetIPAddress())
    local name = mobile:GetName()
    local api = tostring("http://localhost:1337/api/player/"..task)
    local when = tostring(os.date())
    local where = tostring(mobile:GetLoc())
    local payload = ""

    if (task == "murder") then
        payload = [[ {"worldid": "]]..id..[["} ]]
    elseif (task == "page") then
        api = tostring("http://localhost:1337/api/page")
        local who = tostring(name .. " (" .. id .. ")")
        payload = [[ {
            "who": "]]..who..[[",
            "what": "]]..args..[[",
            "when": "]]..when..[[",
            "where": "]]..where..[["
        } ]]
    elseif (task == "death") then
        if (args) then 
            payload = [[ {
                "name": "]]..name..[[",
                "aggressor": "]]..args.aggressor..[[",
                "kind": "]]..args.kind..[[",
                "when": "]]..when..[[",
                "where": "]]..where..[["
            } ]]
        else 
            payload = [[ {
                "name": "]]..name..[[",
                "when": "]]..when..[[",
                "where": "]]..where..[["
            } ]]
        end
    else
        -- default just updates player
        local skill = GetSkillTotal(mobile) or 0
        local playMinutes = mobile:GetObjVar("PlayMinutes") or 0
        local fame = mobile:GetObjVar("Fame") or 0
        local karma = mobile:GetObjVar("Karma") or 0
        local staff = IsImmortal(mobile)

        payload = [[ {
            "account": "]]..account..[[",
            "ip": "]]..ip..[[",
            "worldid": "]]..id..[[",
            "name": "]]..name..[[",
            "skillTotal": ]]..skill..[[,
            "playMinutes": ]]..playMinutes..[[,
            "fame": ]]..fame..[[,
            "karma": ]]..karma..[[,
            "staff": ]]..tostring(staff)..[[
        } ]]
    end

    -- diff paylods for diff tasks?
    local res, code, response_headers, status =
        http.request{
            url = api,
            method = "POST",
            headers = { 
                ["Content-Type"] = "application/json",
                ["Content-Length"] = payload:len()
            },
            source = ltn12.source.string(payload),
            sink = ltn12.sink.table(response_body)
        }
end


function DonateItem(obj) 
    local obj = obj or this
    local value = GetItemValue(obj) or 10
    if (value < 10) then value = 10 end
    PowerHourDonate(value)
    CallFunctionDelayed(TimeSpan.FromSeconds(2), function() 
        obj:Destroy()
    end)
end

function PowerHourDonate(amount) 
    local donations = GlobalVarReadKey("GlobalPowerHour", "Donations") or 0
    donations = donations + amount
	GlobalVarWrite("GlobalPowerHour", nil, function(record) 
        record["Donations"] = donations;
        return true;
	end);
    DebugMessage(tostring("Another item donated! (+" .. amount .. ") > GlobalPowerHour at " .. donations))
    if (donations >= mPowerHourTrigger) then
        local overflow = donations - mPowerHourTrigger
        TriggerGlobalPowerHour(overflow)
    end
end

function TriggerGlobalPowerHour(overflow) 
    DebugMessage("Global Power Hour triggered!")
    GlobalVarWrite("GlobalPowerHour", nil, function(record) 
        record["Donations"] = 0
        record["Ends"] = DateTime.UtcNow:Add(TimeSpan.FromHours(1))
        return true;
    end);
    local online = GlobalVarRead("User.Online") or {}
	local results = {}
	for gameObj,dummy in pairs(online) do
        gameObj:SendMessageGlobal("StartGlobalPowerHour")
    end

    if (overflow > 0) then 
        CallFunctionDelayed(TimeSpan.FromSeconds(2), function() 
            PowerHourDonate(overflow) 
        end)
    end

    TotemGlobalEvent("powerhour")
end


function ColorWarStart()
    local obj = GameObj(68381273)
    obj:SendMessage("ColorWar.Go")
end

function ColorWarVote(user)
    local open = GlobalVarReadKey("ColorWar.Vote", "open")
    if (open) then
        local queued = GlobalVarReadKey("ColorWar.Queue", user)
        if (queued) then
            GlobalVarWrite("ColorWar.Queue", nil, function (record) 
                record[user] = nil
                return true
            end)
            user:SystemMessage("You have un-voted.", "info")
        else
            GlobalVarWrite("ColorWar.Queue", nil, function (record) 
                record[user] = true
                return true
            end)
            user:SystemMessage("You have voted to start Color Wars!", "info")
        end
    else -- VOTE NOT RUNNING
        if (user:HasTimer("NoVote")) then
            user:SystemMessage("You are doing that too quickly.", "info")
            return
        end
        local cwController = GameObj(68381273)
        if (cwController) then
            if (cwController:HasTimer("ColorWar.NoVote")) then
                user:SystemMessage("Color Wars vote can not be started yet.", "info")
                user:ScheduleTimerDelay(TimeSpan.FromSeconds(30), "NoVote")
                return
            else
                GlobalVarWrite("ColorWar.Queue", nil, function (record) 
                    record[user] = true
                    return true
                end)
                cwController:SendMessage("ColorWar.VoteStart")
            end
        end
    end
end