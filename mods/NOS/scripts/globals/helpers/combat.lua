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
    local name = mobile:GetName()
    local api = tostring("http://localhost:1337/api/player/"..task)
    local payload = ""

    if (task == "murders") then
        payload = [[ {"worldid": "]]..id..[["} ]]
    else
        -- default just updates player
        local skill = GetSkillTotal(mobile)
        payload = [[ {
            "account": "]]..account..[[",
            "worldid": "]]..id..[[",
            "name": "]]..name..[[",
            "skillTotal": ]]..skill..[[,
            "murders": 0
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
