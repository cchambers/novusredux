MobileEffectLibrary.TelecrookMove =
{
    ShouldStack = false,

    OnEnterState = function(self, root, target, args)
        if (not IsImmortal(self.ParentObj)) then
            -- They shouldn't have this.
            self.DestroyCrook(self)
        elseif (not target and not args.TargetLoc:Equals(Loc(0, 0, 0))) then
            -- We targeted a location, teleport there.
            self.TeleportTarget(self, self.ParentObj, args.TargetLoc)
        elseif (target) then
            -- We targeted an object, where do we want to move it?
            RegisterSingleEventHandler(EventType.ClientTargetLocResponse, "Telecrook.Move",
                function (success, targetLoc, targetObj, user)
                    if (success) then
                        local location = targetLoc
                        if (targetObj) then
                            local container = targetObj:TopmostContainer()
                            if (container) then
                                location = container:GetLoc()
                            else
                                location = targetObj:GetLoc()
                            end
                        end
                        if (location) then
                            self.TeleportTarget(self, target, location)
                        end
                    end
                    EndMobileEffect(root)
                end)
            self.ParentObj:SystemMessage("Where do you want to move that?", "info")
            self.ParentObj:RequestClientTargetLoc(self.ParentObj, "Telecrook.Move")
            return
        end
        EndMobileEffect(root)
    end,
    TeleportTarget = function(self, target, location)
        if (not target or not location) then return end
        target:SetWorldPosition(location)
        self.ParentObj:SystemMessage(string.format(
            "Object moved to (%s, %s, %s).", location.X, location.Y, location.Z))
        if (not target:IsMobile()) then
            local template = target:GetCreationTemplateId()
            if (template) then
                target:SetCollisionBoundsFromTemplate(template)
            end
        end
    end,

    DestroyCrook = function(self)
        local crook = self.ParentObj:GetEquippedObject("RightHand")
        if (crook and crook:GetObjVar("WeaponType") == "Telecrook") then
            self.ParentObj:SystemMessage("You shouldn't have that.", "info")
            crook:Destroy()
        end
    end,

    OnExitState = function(self, root)
        UnregisterEventHandler(GetCurrentModule(), EventType.ClientTargetLocResponse, "Telecrook.Move")
    end,
}

MobileEffectLibrary.TelecrookRes =
{
    ShouldStack = false,

    OnEnterState = function(self, root, target, args)
        if (not IsImmortal(self.ParentObj)) then
            -- They shouldn't have this.
            self.DestroyCrook(self)
        elseif (target) then
            target:SendMessage("Resurrect",1.0,nil,true)
        end
        EndMobileEffect(root)
    end,
 
    DestroyCrook = function(self)
        local crook = self.ParentObj:GetEquippedObject("RightHand")
        if (crook and crook:GetObjVar("WeaponType") == "Telecrook") then
            self.ParentObj:SystemMessage("You shouldn't have that.", "info")
            crook:Destroy()
            EndMobileEffect(root)
        end
    end,

    OnExitState = function(self, root)
        UnregisterEventHandler(GetCurrentModule(), EventType.ClientTargetLocResponse, "Telecrook.Res")
    end,
}