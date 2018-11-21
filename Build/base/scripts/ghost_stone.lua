
RegisterSingleEventHandler(EventType.ModuleAttached, "ghost_stone", 
    function ()
         SetTooltipEntry(this,"ghost_stone", "Perhaps you should inspect this item further")
         AddUseCase(this,"Examine",true,"HasObject")
    end)

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Use" and usedType ~= "Examine") then return end
        local cont = this:TopmostContainer()
        if(cont ~= user) then
            user:SystemMessage("[$1816]")
            return
        end
        --[[user:SendMessage("StartQuest","GraveyardQuest")
        if (GetPlayerQuestState(user,"GraveyardQuest") ~= "GhostStone") then
            user:SendMessage("AdvanceQuest","GraveyardQuest","GhostStone")
        end]]
        user:SetObjVar("CanSeeGhosts",true)
        TaskDialogNotification(user,"[$1817]")
        user:PlayAnimation("cast")
		SetMobileModExpire(this, "Freeze", "Busy", true, TimeSpan.FromSeconds(0.25))
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.25),"imbue",user)
    end)

RegisterEventHandler(EventType.Timer,"imbue", 
    function(user)
        user:PlayAnimation("cast_heal")
        user:PlayEffect("GhostEffect")
        user:PlayObjectSound("CastAir",false,2)
        this:Destroy()
    end)