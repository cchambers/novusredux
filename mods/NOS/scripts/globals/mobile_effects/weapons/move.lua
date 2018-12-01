MobileEffectLibrary.Move = 
{
    teleportGo = function() 
        this:RequestClientTargetGameObj(this, "select_teleport_target")
        this:SystemMessage("Who do you want to move?")
    end,
    
    handleWhoTarget = function(target, user)
        self.who = target
        user:SystemMessage("Where to?")
        user:RequestClientTargetLoc(this, "select_teleport_destination")
    end,
    
    moveTarget = function(target, user)
        self.who:SetWorldPosition(target)
        user:SystemMessage("Moved!")
    end,
    
    OnEnterState = function(self,root,target)
        -- self.Target = Target
        RegisterEventHandler(EventType.ClientTargetGameObjResponse, "select_teleport_target", self.handleWhoTarget)
        RegisterEventHandler(EventType.ClientTargetLocResponse, "select_teleport_destination", self.moveTarget)
        self.teleportGo();
    end,
    
    OnExitState = function()
    end,
}