RegisterSingleEventHandler(EventType.ModuleAttached, "holy_water", 
    function ()
        SetTooltipEntry(this,"holy_water","You aren't sure what this might be used for.")
        AddUseCase(this,"Pour",true,"HasObject")
    end)

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Use") then return end
        
        user:RequestClientTargetGameObj(this, "keyTarget")
    end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "keyTarget", 
    function(target,user)
        if( target == nil ) then
            return
        end

        if (not target:HasObjVar("HolyWaterTarget")) then
            user:SystemMessage("You shouldn't waste the Holy Water on that.")
            return
        end
        
        if( target ~= nil ) then
            --target:DelObjVar("AnotherLanguage")
            user:SystemMessage("You pour the water.")
            target:SendMessage("HolyWaterPour",user)
            this:Destroy()
        end
    end)