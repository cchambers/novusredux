function ValidateUse(user)
	local topmostObj = this:TopmostContainer() or this
	if(topmostObj:GetLoc():Distance(user:GetLoc()) > OBJECT_INTERACTION_RANGE ) then    
        user:SystemMessage("You cannot reach that.","info")  
        return false
    end

    if (not IsDead(user)) then
        user:SystemMessage("Return here when you die.","info")
        return
    end

    return true
end

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Resurrect") then return end
        if not( ValidKarmaPlayer(user) ) then 
            user:SystemMessage("Karma is too low to use this resurrect stone", "info")
            return 
        end
        if (not ValidateUse(user)) then return end
        if (IsDead(user)) then
            user:SendMessage("Resurrect", 0.65)
            return
        end
    end)

function OnLoad()
    CallFunctionDelayed(TimeSpan.FromSeconds(1),function()
            --Register shrines with the cluster controller for later use
            local clusterController = GetClusterController()
            clusterController:SendMessage("register_resurrection_shrine",this)
        end)
end

function ValidKarmaPlayer(player)
    --Overriding karma check and return true if this shrine has objvar ReviveAll
    if (this:HasObjVar("ReviveAll")) then return true end
    local karmaLevel = GetKarmaLevel(GetKarma(player))
    return not( karmaLevel.DisallowBlueResurrectShrines == true )
end

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
    function()
        OnLoad()
    end)

RegisterSingleEventHandler(EventType.ModuleAttached, "shrine",
	function()
		SetTooltipEntry(this,"shrine","[$2524]")
        AddUseCase(this,"Resurrect",true)

        OnLoad()
	end)

AddView("ResView", SearchMulti({SearchPlayerInRange(5,true),SearchObjVar("IsDead",true)}),1.0)

RegisterEventHandler(EventType.EnterView,"ResView",function(mobile)
    if ( mobile:IsPlayer() ) then
        if ( ValidKarmaPlayer(mobile) ) then
            --DFB TODO: Give only a percent of the health back.
            mobile:SendMessage("Resurrect", 0.65)
        else
            mobile:SystemMessage("Karma is too low to use this resurrect stone", "info")
        end
    end
end)

this:SetObjVar("UseableWhileDead",true)