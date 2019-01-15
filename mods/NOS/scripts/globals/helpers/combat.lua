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
    local name = mobile:GetName()
    local api = tostring("http://localhost:1337/api/player/"..task)
    local payload = ""

    if (task == "murder") then
        payload = [[ {"id":"]]..id..[["} ]]
    else
        -- default just updates player
        local skill = GetSkillTotal(mobile)
        payload = [[ {
            id: "]]..id..[[",
            name: "]]..name..[[",
            skillTotal: ]]..skill..[[,
            murders: 0
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


-- function sendRequest()
--     local path = "http://requestb.in/12j0kaq1?param_1=one&param_2=two&param_3=three"
--       local payload = [[ {"key":"My Key","name":"My Name","description":"The description","state":1} ]]
--       local response_body = { }
    
--       local res, code, response_headers, status = http.request
--       {
--         url = path,
--         method = "POST",
--         headers =
--         {
--           ["Authorization"] = "Maybe you need an Authorization header?", 
--           ["Content-Type"] = "application/json",
--           ["Content-Length"] = payload:len()
--         },
--         source = ltn12.source.string(payload),
--       }
--       luup.task('Response: = ' .. table.concat(response_body) .. ' code = ' .. code .. '   status = ' .. status,1,'Sample POST request with JSON data',-1)
--     end