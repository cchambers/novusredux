MobileEffectLibrary.LandDeed = 
{
    QTarget = true,
    
    OnEnterState = function(self,root,target,args)
        if ( self.ParentObj:HasTimer("LandDeedTimer") ) then
            self.ParentObj:SystemMessage("Please wait to use this again.", "info")
            EndMobileEffect(root)
            return
        end
        self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(2.5), "LandDeedTimer")

        RegisterSingleEventHandler(EventType.ClientTargetLocResponse, "ClaimLand", function(success, loc, gameobj)
            if ( not success or not loc or not target or not target:IsValid() ) then
                self.ErrorInvalidLocation(self,root)
                return
            end
            if ( self.ParentObj:GetLoc():Distance(loc) > 15 ) then
                self.ParentObj:SystemMessage("Too far away.", "info")
                EndMobileEffect(root)
                return
            end
            if not( self.ParentObj:HasLineOfSightToLoc(loc) ) then
                self.ParentObj:SystemMessage("Cannot see that.", "info")
                EndMobileEffect(root)
                return
            end
            Plot.New(self.ParentObj, loc, function(controller)
                if ( controller ) then
                    target:Destroy()
                    -- achievement for creating a plot
                    CheckAchievementStatus(self.ParentObj, "Activity", "LandOwner", 1)

                    Plot.ShowControlWindow(self.ParentObj,controller,"Manage")
                end
                EndMobileEffect(root)
            end)
        end)
        self.ParentObj:RequestClientTargetLocPreview(self.ParentObj, "ClaimLand","plot_preview",Loc(0,0,0),Loc(1,1,1))
	end,

    OnExitState = function(self,root)
        
    end,
    
    ErrorInvalidLocation = function(self,root)
        self.ParentObj:SystemMessage("That is not a valid location.", "info")
        EndMobileEffect(root)
    end,

}