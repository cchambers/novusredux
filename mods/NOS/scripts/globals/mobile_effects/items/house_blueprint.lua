MobileEffectLibrary.HouseBlueprint = 
{
    QTarget = true,

    OnEnterState = function(self,root,target,args)

        if ( not target or not target:IsValid() ) then
            EndMobileEffect(root)
            return
        end

        self.Target = target
        local houseType = target:GetObjVar("HouseType")
        self.HouseData = Plot.GetHouseData(houseType, args.Direction or 2)
        if ( self.HouseData == nil ) then
            EndMobileEffect(root)
            return
        end

        local nearbyPlots = Plot.GetNearby(self.ParentObj:GetLoc())
        local controller
        for i=1,#nearbyPlots do
            if ( Plot.IsOwner(self.ParentObj, nearbyPlots[i]) ) then
                controller = nearbyPlots[i]
                break
            end
        end

        if ( controller ) then
            self._ShownBoundPreview = true
            self.ShowBoundPreview(self.ParentObj, controller)
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
                        local template = self.Target:GetCreationTemplateId()
                        if ( template ) then house:SetObjVar("Blueprint", template) end
                        self.Target:Destroy()
                    end
                    EndMobileEffect(root)
                end, true)
             else
                self.ReqLoc(self,root)
            end
            
        end)

        self.ReqLoc(self,root)
    end,

    ShowBoundPreview = function(player, controller)
        if ( player and controller ) then
            -- L shape support update required here
            local bound = controller:GetObjVar("PlotBounds")[1]
            bound = Plot.CalculateBound(bound)
            player:SendClientMessage("UpdateLocalLandPreview",{
                "plot_preview_blueprint", -- id (string)
                "0FB900", -- Color (string)
                bound.Top, -- Top (float)
                bound.Left, -- Left (float)
                bound.Bottom, -- Bottom (float)
                bound.Right, -- Right (float)
                8 -- Height (float)
            })
        end
    end,

    ClearBoundPreview = function(player)
        player:SendClientMessage("ClearLocalLandPreview","plot_preview_blueprint")
    end,
    
    ReqLoc = function(self,root)
        --self.ParentObj:SystemMessage("Where do you wish to place this object?","info")
        self.ParentObj:RequestClientTargetLocPreview(self.ParentObj, "HouseLoc", self.HouseData.Template, self.HouseData.Rotation, Loc(1,1,1))
    end,

    OnExitState = function(self,root)
        if ( self._ShownBoundPreview ) then
            self.ClearBoundPreview(self.ParentObj)
        end
        UnregisterEventHandler("", EventType.ClientTargetLocResponse, "HouseLoc")
    end,

    _ShownBoundPreview = false,
}