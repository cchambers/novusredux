DebugMessage("TOTEM LOADED")

mPowerHourTrigger = 2500000

http = LoadExternalModule("http")
ltn12 = LoadExternalModule("ltn12")

function Totem(mobile, task, args)
    local id = mobile.Id
    local account = tostring(mobile:GetAttachedUserId())
    local ip = tostring(mobile:GetIPAddress())
    local name = mobile:GetName()
    local api = tostring("http://localhost:1337/api/player/"..task)
    local payload = ""

    if (task == "murder") then
        payload = [[ {"worldid": "]]..id..[["} ]]
    elseif (task == "page") then
		local when = tostring(os.date())
		local where = tostring(mobile:GetLoc())
        payload = [[ {
            "who": "]]..id..[[",
            "what": "]]..args..[[",
            "when": "]]..when..[[",
            "where": "]]..where..[["
        } ]]
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
	local value = GetItemValue(obj)
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
    if (donations > mPowerHourTrigger) then
        TriggerGlobalPowerHour()
    end
end

function TriggerGlobalPowerHour() 
    DebugMessage("Global Power Hour triggered!")
    GlobalVarWrite("GlobalPowerHour", nil, function(record) 
        record["Donations"] = 0
        record["Ends"] = DateTime.UtcNow:Add(TimeSpan.FromHours(1))
        return true;
    end);
    local online = GlobalVarRead("User.Online") or {}
	local results = {}
	for gameObj,dummy in pairs(online) do
        local user = gameObj
        user:SetObjVar("PowerHourEnds", 60)
        user:SendMessage("StartMobileEffect", "PowerHourBuff")
        user:PlayAnimation("roar")
        user:PlayEffect("ImpactWaveEffect", 2)
        user:SystemMessage("Global Power Hour triggered for free! ENJOY [ff0000]<3[-]")
    end
end