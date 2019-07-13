MobileEffectLibrary.HouseController = 
{

    OnEnterState = function(self,root,target,args)

        -- target is the house sign.
        
        if not( self.ParentObj:HasModule("plot_control_window") ) then
            self.ParentObj:AddModule("plot_control_window")
        end

        -- target is the house sign
        local plotHouse = target:GetObjVar("PlotHouse")
        self.ParentObj:SendMessage("InitControlWindow", plotHouse, plotHouse:GetObjVar("PlotController"))

        EndMobileEffect(root)
    end,

}


MobileEffectLibrary.HouseAddCoOwner = 
{
    QTarget = true,

    OnEnterState = function(self,root,target,args)
        -- target parametere is the house
        self.ParentObj:SystemMessage("Select player.", "info")
        RegisterEventHandler(EventType.ClientTargetGameObjResponse, "AddCoOwner", function(targetObj)
            Plot.AddHouseCoOwner(self.ParentObj, targetObj, target)
            EndMobileEffect(root)
        end)
        self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "AddCoOwner")
	end,

}

MobileEffectLibrary.HouseAddFriend = 
{
    QTarget = true,

    OnEnterState = function(self,root,target,args)
        -- target parametere is the house
        self.ParentObj:SystemMessage("Select player.", "info")
        RegisterEventHandler(EventType.ClientTargetGameObjResponse, "AddFriend", function(targetObj)
            Plot.AddHouseFriend(self.ParentObj, targetObj, target)
            EndMobileEffect(root)
        end)
        self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "AddFriend")
	end,

}


MobileEffectLibrary.HouseDestroy = 
{

    OnEnterState = function(self,root,target,args)
        -- target parametere is the house
        
        -- Are you sure?
        ClientDialog.Show{
            TargetUser = self.ParentObj,
            DialogId = "DestroyHouse",
            TitleStr = "Destroy House",
            DescStr = "[FF0000]No blueprint or resources or will be refunded.[-]\nThe house must be empty of all locked down objects.\n\nConfirm Destroy House?",
            Button1Str = "Destroy House",
            Button2Str = "Cancel",
	        ResponseObj = self.ParentObj,
            ResponseFunc = function( user, buttonId )
                buttonId = tonumber(buttonId)
                if ( buttonId == 0 ) then
                    local house = target
                    Plot.DestroyHouse(user, house)
                    Plot.CloseControlWindow(user)
                end
                EndMobileEffect(root)
            end,
        }
	end,

}

MobileEffectLibrary.HouseRename = 
{

    OnEnterState = function(self,root,target,args)
        -- target parameter is the house

        if ( target == nil or not target:IsValid() ) then
            return EndMobileEffect(root)
        end

        local houseSign = target:GetObjVar("HouseSign")
        if ( houseSign == nil ) then
            return EndMobileEffect(root)
        end

        TextFieldDialog.Show{
            TargetUser = self.ParentObj,
            ResponseObj = self.ParentObj,
            Title = "Rename House",
            Description = "Maximum 20 characters",
            ResponseFunc = function(user,newName)
                if(newName == nil) then
                    self.ParentObj:SystemMessage("House rename cancelled.", "info")
                    return
                end

                if ( user ~= self.ParentObj or newName == "" or newName == nil ) then
                    self.ParentObj:SystemMessage("Invalid house name. Try again.", "info")
                    StartMobileEffect(self.ParentObj, "HouseRename", target)
                    return
                end
                
                newName = StripColorFromString(newName)

                local valid, error = ValidatePlayerInput(newName, 3, 20)
                if not( valid ) then
                    self.ParentObj:SystemMessage("House name "..error, "info")
                    StartMobileEffect(self.ParentObj, "HouseRename", target)
                    return
                end
    
                houseSign:SetName(newName)

                if ( self.ParentObj:HasModule("plot_control_window") ) then
                    self.ParentObj:SendMessage("UpdatePlotControlWindow")
                else
                    StartMobileEffect(self.ParentObj, "HouseController", houseSign)
                end

                -- tell them about it.
                ClientDialog.Show{
                    TargetUser = self.ParentObj,
                    DialogId = "RenameHouseConfirm",
                    TitleStr = "House Name Changed",
                    DescStr = string.format("This house has been renamed to %s.", newName),
                    Button1Str = "Ok",
                }
            end
        }

        EndMobileEffect(root)

	end,

}