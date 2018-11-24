MobileEffectLibrary.PlotController = 
{

    OnEnterState = function(self,root,target,args)
        if ( target:HasModule("plot_bid_window") ) then
            target:SendMessage("ShowBidWindow", self.ParentObj)
        elseif ( target:HasModule("plot_bid_controller") ) then
            local window = target:GetObjVar("BidWindow")
            if ( window ) then window:SendMessage("ShowBidWindow", self.ParentObj) end
        elseif ( Plot.HasControl(self.ParentObj,target) ) then
            Plot.ShowControlWindow(self.ParentObj,target)
        elseif not( self.ParentObj:HasModule("plot_tax_window") ) then
            -- anyone can pay taxes
            self.ParentObj:AddModule("plot_tax_window")
            self.ParentObj:SendMessage("InitTaxWindow", target)
        end
        
        EndMobileEffect(root)
    end,

}

MobileEffectLibrary.PlotDestroy = 
{

    OnEnterState = function(self,root,target,args)
        if ( args.GodDestroy == true and IsGod(self.ParentObj) ) then
            -- Are you sure?
            ClientDialog.Show{
                TargetUser = self.ParentObj,
                DialogId = "GodDestroyPlot",
                TitleStr = "Destroy Plot",
                DescStr = "As a God of this Realm, you have the power to NUKE entire plots. WARNING!!!! This will destroy ALL ITEMS AND HOUSES on the plot. Continue?",
                Button1Str = "DESTROY PLOT AND EVERYTHING ON IT",
                Button2Str = "Cancel",
                ResponseObj = self.ParentObj,
                ResponseFunc = function( user, buttonId )
                    buttonId = tonumber(buttonId)
                    if ( user == self.ParentObj and buttonId == 0 ) then
                        Plot.Destroy(target)
                        Plot.CloseControlWindow(self.ParentObj)
                    end
                end,
            }
        else
            if ( target:HasObjVar("LockCount") or Plot.HasHouse(target) ) then
                self.ParentObj:SystemMessage("Plot must be cleared of all houses and locked down items to relenquish.", "info")
            else
                -- Are you sure?
                ClientDialog.Show{
                    TargetUser = self.ParentObj,
                    DialogId = "DestroyPlot",
                    TitleStr = "Relinquish Plot",
                    DescStr = "Relinquish control of the land and remove this plot. A land deed will be refunded. Continue?",
                    Button1Str = "Relinquish",
                    Button2Str = "Cancel",
                    ResponseObj = self.ParentObj,
                    ResponseFunc = function( user, buttonId )
                        buttonId = tonumber(buttonId)
                        if ( user == self.ParentObj and buttonId == 0 ) then
                            Plot.Destroy(target, function(success)
                                if ( success ) then
                                    CreateObjInBackpack(self.ParentObj, "land_deed", "RefundPlotDeed")
                                    Plot.CloseControlWindow(self.ParentObj)
                                end
                            end)
                        end
                    end,
                }
            end
        end
        EndMobileEffect(root)
	end,

}

MobileEffectLibrary.PlotAdjust = 
{

    OnEnterState = function(self,root,target,args)
        Plot.Adjust(self.ParentObj, target, args)
        EndMobileEffect(root)
	end,

}

MobileEffectLibrary.PlotLockdown = 
{

    OnEnterState = function(self,root,target,args)
        self.ParentObj:SystemMessage("Select an object on your plot to lock down.","info")
        RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse, "LockdownTarget", function(gameObj)
            if ( gameObj ) then
                Plot.Lockdown(self.ParentObj, target, gameObj)
            end

            Plot.UpdateUI(self.ParentObj)

            EndMobileEffect(root)
        end)
        self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "LockdownTarget")
	end,

}

MobileEffectLibrary.PlotRelease = 
{    
    OnEnterState = function(self,root,target,args)
        self.ParentObj:SystemMessage("Select a locked down object to release.","info")
        RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse, "ReleaseTarget", function(gameObj)
            if ( gameObj ) then
                Plot.Release(self.ParentObj, target, gameObj)
            end

            Plot.UpdateUI(self.ParentObj)

            EndMobileEffect(root)
        end)
        self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "ReleaseTarget")
	end,

}

MobileEffectLibrary.PlotMoveObject =
{
    OnEnterState = function(self,root,target,args)
        self.ParentObj:SystemMessage("Select a locked down object.","info")
        RegisterEventHandler(EventType.ClientTargetGameObjResponse, "PlotMoveObject", function(targetObj)
            if ( targetObj and targetObj:IsValid() ) then
                if not( self.ParentObj:HasModule("plot_decorate_window") ) then
                    self.ParentObj:AddModule("plot_decorate_window")
                end
                self.ParentObj:SendMessage("InitDecorate", targetObj)
            end
            EndMobileEffect(root)
        end)

        self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "PlotMoveObject")
    end,

    OnExitState = function(self,root)
        UnregisterEventHandler("", EventType.ClientTargetGameObjResponse, "PlotMoveObject")
    end,
}

--- uses the 'push' command
MobileEffectLibrary.PlotMoveObjectPush =
{
    OnEnterState = function(self,root,target,args)

        RegisterEventHandler(EventType.ClientTargetGameObjResponse, "PlotMoveObject", function(targetObj)
            if ( targetObj and targetObj:IsValid() and Plot.TryMove(self.ParentObj, targetObj) ) then
                self._RegisteredTransform = true

                RegisterEventHandler(EventType.ClientObjectCommand, "transform", function(user,targetId,identifier,command,...)
                    if ( user == self.ParentObj and identifier == "plot_move_object" and command == "confirm" ) then
                        local targetObj = GameObj(tonumber(targetId))
                        if ( targetObj:IsValid() ) then
                            local commandArgs = table.pack(...)
                            local newPos = Loc(tonumber(commandArgs[1]),math.min(5,tonumber(commandArgs[2])),tonumber(commandArgs[3]))
                            if ( Plot.TryMoveTo(self.ParentObj, targetObj, newPos) ) then
                                local rotation = targetObj:GetRotation()
                                local newRot = Loc(rotation.X,tonumber(commandArgs[5]),rotation.Z)
                                targetObj:SetWorldPosition(newPos)
                                targetObj:SetRotation(newRot)
                                targetObj:SetScale(targetObj:GetScale()) -- hack to force client not to keep a scale user set.
                            end
                        end
                    else
                        self.ParentObj:SystemMessage("Cancelled.", "info")
                    end
                    EndMobileEffect(root)
                end)

                self.ParentObj:SendClientMessage("EditObjectTransform",{targetObj,self.ParentObj,"plot_move_object"})
            else
                EndMobileEffect(root)
            end
        end)

        self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "PlotMoveObject")
    end,

    OnExitState = function(self,root)
        UnregisterEventHandler("", EventType.ClientTargetGameObjResponse, "PlotMoveObject")
        if ( self._RegisteredTransform ) then
            UnregisterEventHandler("", EventType.ClientObjectCommand, "transform")
        end
    end,

    _RegisteredTransform = false,
}

MobileEffectLibrary.PlotTransferOwnership =
{
    OnEnterState = function(self,root,target,args)

        if ( not target or not Plot.IsOwner(self.ParentObj, target) ) then
            EndMobileEffect(root)
            return false
        end

        self.ParentObj:SystemMessage("Who do you want to trade this plot to?", "info")
        RegisterEventHandler(EventType.ClientTargetGameObjResponse, "PlotTransfer", function(targetObj)
            if ( IsPlayerCharacter(targetObj) ) then
                -- gods can transfer houses to themselves
                if ( targetObj == self.ParentObj and IsGod(self.ParentObj) ) then
                    Plot.TransferOwnership(self.ParentObj,target,self.ParentObj, function()
                        EndMobileEffect(root)
                    end)
                    return
                elseif(self.ParentObj:HasModule("trading_controller")) then
                    self.ParentObj:SystemMessage("You already have an active trade in progress.","info")
                else
                    self.ParentObj:AddModule("trading_controller",{TradeTarget=targetObj,PlotTarget=target})
                end
            end
            EndMobileEffect(root)
        end)
        self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "PlotTransfer")

        return false --prevent system from registering unneccessary event handles
    end,
}

MobileEffectLibrary.PlotRename = 
{

    OnEnterState = function(self,root,target,args)
        -- target parameter is the plot controller

        if ( target == nil or not target:IsValid() ) then
            return EndMobileEffect(root)
        end

        TextFieldDialog.Show{
            TargetUser = self.ParentObj,
            ResponseObj = self.ParentObj,
            Title = "Rename Plot",
            Description = "Maximum 20 characters.",
            ResponseFunc = function(user,newName)
                if ( newName == nil or newName == "" ) then
                    self.ParentObj:SystemMessage("Plot rename cancelled.", "info")
                else
                    if not( Plot.Rename(self.ParentObj, target, newName) ) then
                        StartMobileEffect(self.ParentObj, "PlotRename", target)
                    end
                end
            end
        }

        return EndMobileEffect(root)
	end,

}


MobileEffectLibrary.PlotKick = 
{

    OnEnterState = function(self,root,target,args)
        -- target parametere is the plot controller, args is the house (if any)
        if not( Plot.HasHouseControl(self.ParentObj, target, args) ) then
            EndMobileEffect(root)
            return false
        end

        self.ParentObj:SystemMessage("Select target.", "info")
        RegisterEventHandler(EventType.ClientTargetGameObjResponse, "PlotKick", function(targetObj)
            if ( targetObj ) then
                if ( not targetObj:IsPermanent() and targetObj:IsMobile() ) then
                    if ( targetObj ~= self.ParentObj ) then
                        if not( Plot.IsOwner(targetObj, target) ) then
                            if ( Plot.GetAtLoc(targetObj:GetLoc()) == target ) then
                                Plot.KickMobile(target, targetObj)
                            else
                                self.ParentObj:SystemMessage("They are not in a place you can kick them from.", "info")
                            end
                        else
                            self.ParentObj:SystemMessage("Cannot kick plot owner from their own plot.", "info")
                        end
                    else
                        self.ParentObj:SystemMessage("Cannot kick yourself.", "info")
                    end
                else
                    self.ParentObj:SystemMessage("Invalid target.", "info")
                end
            end
            EndMobileEffect(root)
        end)
        self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "PlotKick")

        return false
	end,

}