MobileEffectLibrary.HouseBlueprint = 
{

    OnEnterState = function(self,root,target,args)

        if ( not target or not target:IsValid() ) then
            EndMobileEffect(root)
            return
        end

        local houseType = target:GetObjVar("HouseType")
        self.HouseData = Plot.GetHouseData(houseType, args.Direction or 2)
        if ( self.HouseData == nil ) then
            EndMobileEffect(root)
            return
        end

        RegisterEventHandler(EventType.ClientTargetLocResponse, "HouseLoc", function(success, loc, gameobj)
            if ( self.ParentObj:HasTimer("AntiSpamTimer") ) then
                self.ParentObj:SystemMessage("Please Wait.", "info")
                self.ReqLoc(self,root)
                return
            end
            self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(0.75), "AntiSpamTimer")
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
            
            local success, controller = Plot.TryPlaceHouse(self.ParentObj, loc, self.HouseData)
            if ( success ) then
                Plot.CreateHouse(controller, loc, self.HouseData, function(house)
                    if ( house ) then
                        target:Destroy()
                    end
                    EndMobileEffect(root)
                end, true, self.ParentObj)
            else
                self.ReqLoc(self,root)
            end
        end)

        self.ReqLoc(self,root)
    end,
    
    ReqLoc = function(self,root)
        --self.ParentObj:SystemMessage("Where do you wish to place this object?","info")
        self.ParentObj:RequestClientTargetLocPreview(self.ParentObj, "HouseLoc", self.HouseData.Template, self.HouseData.Rotation, Loc(1,1,1))
    end,

    OnExitState = function(self,root)
        UnregisterEventHandler("", EventType.ClientTargetLocResponse, "HouseLoc")
    end,

}