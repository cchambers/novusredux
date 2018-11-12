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