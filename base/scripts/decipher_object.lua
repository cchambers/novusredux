RegisterSingleEventHandler(EventType.ModuleAttached, "decipher_object", 
    function ()
        AddUseCase(this,"Decipher",true)
        SetTooltipEntry(this,"decipher","Used to decipher writing in other languages.")
    end)

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Decipher") then return end
        user:RequestClientTargetGameObj(this, "keyTarget")
    end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "keyTarget", 
    function(target,user)
        if( target == nil ) then
            return
        end
        
        if( target ~= nil and target:HasObjVar("AnotherLanguage") ) then
            --target:DelObjVar("AnotherLanguage")
            user:SystemMessage("The magic in the scroll dissipates.")
            target:SendMessage("DecipherReadObject",user)
            this:Destroy()
        end
    end)