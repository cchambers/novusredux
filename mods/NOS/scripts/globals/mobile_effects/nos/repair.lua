MobileEffectLibrary.Repair = {
    ShouldStack = false,
    OnEnterState = function(self, root, target, args)
        if (target) then
            -- IS THERE A FORGE NEARBY?
            local forge =
                FindObjects(
                SearchMulti(
                    {
                        SearchMobileInRange(5), --in 10 units
                        SearchObjVar("GuideEventId", "NearForge") -- this is from NPE but serves our purpose...
                    }
                )
            )

            if (forge == nil) then
                self.ParentObj:SystemMessage("You need a forge to do that.","info")
            else
                RegisterSingleEventHandler(
                    EventType.ClientTargetGameOjResponse,
                    "Blacksmith.Repair",
                    function(target, user)
                        if (success) then
                            self.RepairTarget(self, target)
                        end
                        EndMobileEffect(root)
                    end
                )
                self.ParentObj:SystemMessage("Target the item for repair.", "info")
                self.ParentObj:RequestClientTargetGameOj(self.ParentObj, "Blacksmith.Repair")
                return
            end
        end
        EndMobileEffect(root)
    end,
    RepairTarget = function(self, target)
        -- check item durability, maxdurability, permanentdamage
        -- play animation
        -- do skill check
        --
    end,
    OnExitState = function(self, root)
        UnregisterEventHandler(GetCurrentModule(), EventType.ClientTargetLocResponse, "Telecrook.Move")
    end
}

MobileEffectLibrary.TelecrookRes = {
    ShouldStack = false,
    OnEnterState = function(self, root, target, args)
        if (not IsImmortal(self.ParentObj)) then
            -- They shouldn't have this.
            self.DestroyCrook(self)
        elseif (target) then
            if (IsDead(target)) then
                target:SendMessage("Resurrect", 1.0, nil, true)
            else
                target:NpcSpeech("*restored*")
                target:SetStatValue("Health", GetMaxHealth(target))
                target:SetStatValue("Mana", 250)
                target:SetStatValue("Stamina", 250)
            end
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
    end
}
