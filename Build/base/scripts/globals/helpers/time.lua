function TimeSpanToWords(tmspn, singular)
    local str = ""
    if ( tmspn.Days > 0 ) then
        str = str .. tmspn.Days .. " day"
        if ( not singular and tmspn.Days > 1 ) then
            str = str .. "s "
        else
            str = str .. " "
        end
    end
    if ( tmspn.Hours > 0 ) then
        str = str .. tmspn.Hours .. " hour"
        if ( not singular and tmspn.Hours > 1 ) then
            str = str .. "s "
        else
            str = str .. " "
        end
    end
    if ( tmspn.Minutes > 0 ) then
        str = str .. tmspn.Minutes .. " minute"
        if ( not singular and tmspn.Minutes > 1 ) then
            str = str .. "s "
        else
            str = str .. " "
        end
    end
    if ( tmspn.Seconds > 0 ) then
        str = str .. tmspn.Seconds .. " second"
        if ( not singular and tmspn.Seconds > 1 ) then
            str = str .. "s "
        else
            str = str .. " "
        end
    end
    return StringTrim(str)
end

function GetNow()
    return os.time(os.date("!*t"))
end

--- Get the time meant to be used in IsTime
-- @param time - os.time()
-- @return luaTable of current time
function GetTimeTable(time)
    if ( time ) then
        return os.date("!*t", time)
    else
        return os.date("!*t")
    end
end

--- Will take a minimal luaTable containing any members from os.date(!t) (including wday [1-7]) and fill in the details.
-- @param date - a table would normally go into os.time but with support for wday
-- @param now - GetTimeTable()
function FixDate(date, now)
    if not( date ) then
        LuaDebugCallStack("[FixDate] date not provided.")
        return nil
    end
    if not( now ) then now = GetTimeTable() end
    -- clone the provided table
    local out = {}
    for key,value in pairs(date) do out[key] = value end

    -- prevent trying to go backwards in time if today is the same day as defined wday
    local same = ( out.hour and out.hour >= now.hour )
    if not( out.hour ) then out.hour = now.hour end
    if not( same ) then same = ( out.min and out.min >= now.min ) end
    if not( out.min ) then out.min = now.min end
    if not( same ) then same = ( out.sec and out.sec >= now.sec ) end
    if not( out.sec ) then out.sec = now.sec end

    -- if wday is sent for date, we convert date into a full os.date
    if ( out.wday ) then
        local t,d = os.time(now)
        for i=1,7 do
            d = os.date("*t", t+(same and 86400*(i-1) or 86400*i))
            if ( d.wday == out.wday ) then
                -- fill in the defaults
                out.year = d.year
                out.month = d.month
                out.day = d.day
                break
            end
        end
    end

    -- ensure minimum requirements
    if not( out.year ) then out.year = now.year end
    if not( out.month ) then out.month = now.month end
    if not( out.day ) then out.day = now.day end
    out.isdst = false -- needs to be explicitly set since we are using UTC

    return out
end

-- check if date and now are the same within resolution (seconds past or seconds past/before)
-- @param date -- see !*t here: http://lua-users.org/wiki/OsLibraryTutorial
-- @param now -- (optional) defaults to GetTimeTable()
-- @param resolution - (optional) resolution in seconds, defaults to 0
-- @param updown - boolean(optional) if true, resolution will count + / -,
-- @return boolean
function IsTime(date, now, resolution, updown)
    if ( updown ) then
        return math.abs(TimeUntil(date, now)) <= (resolution or 0)
    else
        -- only check if exactly or past time (within resolution)
        local timeUntil = TimeUntil(date, now)
        return timeUntil <= 0 and timeUntil > -(resolution or 0)
    end
end

--- return the number of second from date to an os.date
-- @param date - Works like os.time parameter but will also handle wdays (Week Days)
-- @param now - GetTimeTable()
-- @return number of seconds until now (negative if in the past)
function TimeUntil(date, now)
    if not( date ) then
        LuaDebugCallStack("[TimeUntil] date not provided.")
        return 0
    end
    if not( now ) then now = GetTimeTable() end

    -- fill in the blanks if only minor details were provided
    date = FixDate(date, now)

    return os.time(date) - os.time(now)
end