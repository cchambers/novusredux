require "default:globals.helpers.combat"

function DoResist(target, resistLevel, damage)
    local resistAmount = (resistLevel * 10 - 400) / 15
    -- target:SystemMessage(tostring("Damage: " .. damage .. " Resist: " .. resistAmount))
    target:PlayEffect("HoneycombShield", 1.5)
    return (damage * (resistAmount) * 0.01)
end

-- STATS --

http = LoadExternalModule("http")
ltn12 = LoadExternalModule("ltn12")

function Totem(mobile, task)
    local id = mobile.Id
    local account = tostring(mobile:GetAttachedUserId())
    local ip = tostring(mobile:GetIPAddress())
    local name = mobile:GetName()
    local api = tostring("http://localhost:1337/api/player/"..task)
    local payload = ""

    if (task == "murder") then
        payload = [[ {"worldid": "]]..id..[["} ]]
    else
        -- default just updates player
        local skill = GetSkillTotal(mobile)
        local playMinutes = mobile:GetObjVar("PlayMinutes")
        local fame = mobile:GetObjVar("Fame")
        local karma = mobile:GetObjVar("Karma")

        payload = [[ {
            "account": "]]..account..[[",
            "ip": "]]..ip..[[",
            "worldid": "]]..id..[[",
            "name": "]]..name..[[",
            "skillTotal": ]]..skill..[[,
            "playMinutes": ]]..playMinutes..[[,
            "fame": ]]..fame..[[,
            "karma": ]]..karma..[[
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
