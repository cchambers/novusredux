
RegisterSingleEventHandler(EventType.ModuleAttached, "artifact", 
    function ()
         SetTooltipEntry(this,"artifact", "Perhaps you should inspect this item further.")
         AddUseCase(this,"Examine",true)
    end)

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        user:SystemMessage("[$1612]","info")
        --user:SendMessage("StartQuest","ArcheologistQuest")
    end)
