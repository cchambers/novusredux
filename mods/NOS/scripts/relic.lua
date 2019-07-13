
RegisterSingleEventHandler(EventType.ModuleAttached, "relic", 
    function ()
         SetTooltipEntry(this,"relic", "[$2432]")
         AddUseCase(this,"Examine",true)
    end)

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Use" and usedType ~= "Examine") then return end
        local gate = FindObject(SearchModule("dead_gate_controller"))
        if( gate == nil ) then --if the player is off world
            user:SystemMessage("[$2433]","info")
            return
        end
        --user:SendMessage("StartQuest","RelicQuest")
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"update_quest",user)

        local myLoc = user:GetLoc()
        local distance = myLoc:Distance(gate:GetLoc())
        if( distance > 20 ) then
            local angleTo = user:GetLoc():YAngleTo(gate:GetLoc())

            local direction = nil
            if( angleTo > 337 or angleTo <= 22 ) then
                direction = "North"
            elseif( angleTo > 22 and angleTo <= 67 ) then
                direction = "Northeast"
            elseif( angleTo > 67 and angleTo <= 112 ) then
                direction = "East"  
            elseif( angleTo > 112 and angleTo <= 157 ) then
                direction = "Southeast"         
            elseif( angleTo > 157 and angleTo <= 202 ) then
                direction = "South"
            elseif( angleTo > 202 and angleTo <= 247 ) then
                direction = "Southwest"
            elseif( angleTo > 247 and angleTo <= 292 ) then
                direction = "West"
            else
                direction = "Northwest"
            end

            user:SystemMessage("[$2434]"..direction..".","info")
        else
            user:SystemMessage("[$2435]","info")
        end
    end)

RegisterEventHandler(EventType.Timer,"update_quest",function (user)
    user:SendMessage("AdvanceQuest","RelicQuest","FindSourceOfPower","TalkToRothchilde")
    user:SendMessage("AdvanceQuest","RelicQuest","FindSourceOfPower","FindRelic")
end)

