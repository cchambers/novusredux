MobileEffectLibrary.PackedObject = 
{
    QTarget = true,

    OnEnterState = function(self,root,target,args)

        if ( not target or not target:IsValid() ) then
            EndMobileEffect(root)
            return
        end

        self.Template = target:GetObjVar("UnpackedTemplate")

        RegisterEventHandler(EventType.ClientTargetLocResponse, "UnpackLoc", function(success, loc, gameobj)
            if ( self.ParentObj:HasTimer("AntiSpamTimer") ) then
                self.ParentObj:SystemMessage("Please Wait.", "info")
                self.ReqLoc(self,root)
                return
            end
            self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(0.25), "AntiSpamTimer")
            if not(success) then return EndMobileEffect(root) end
            if not( loc ) then
                self.ParentObj:SystemMessage("That is not a valid location.", "info")
                self.ReqLoc(self,root)
                return
            end
            if ( self.ParentObj:GetLoc():Distance(loc) > 20 ) then
                self.ParentObj:SystemMessage("Too far away.", "info")
                self.ReqLoc(self,root)
                return
            end

            Plot.Unpack(self.ParentObj, target, loc, function(unpackedObj)
                if ( unpackedObj ) then
                    EndMobileEffect(root)
                else
                    self.ReqLoc(self,root)
                end
            end)
        end)

        self.ParentObj:SystemMessage("Where do you wish to place this object?","info")
        self.ReqLoc(self,root)
    end,
    
    ReqLoc = function(self,root)
        self.ParentObj:RequestClientTargetLocPreview(self.ParentObj, "UnpackLoc", self.Template, Loc(0,0,0), GetTemplateObjectScale(self.Template))
    end,

    OnExitState = function(self,root)
        UnregisterEventHandler("", EventType.ClientTargetLocResponse, "UnpackLoc")
    end,

}