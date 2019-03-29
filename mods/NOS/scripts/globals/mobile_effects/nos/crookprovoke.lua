MobileEffectLibrary.CrookProvoke =
{
    ShouldStack = false,

    OnEnterState = function(self, root, target, args)
        local skillLevel = GetSkillLevel(self.ParentObj, "AnimalLoreSkill")
        if (skillLevel < 90) then
            self.ParentObj:SystemMessage("You lack the Animal Lore (90) to do this.", "info")
            EndMobileEffect(root)
            return false
        end
        if (target:HasModule("guard_protect")) then
            self.ParentObj:SystemMessage("That's a really bad idea.", "info")
            EndMobileEffect(root)
            return false
        end

        if (target:IsPlayer()) then
            self.ParentObj:SystemMessage("You cannot provoke players.", "info")
            EndMobileEffect(root)
            return false
        end
        
        if (target:HasObjVar("Karma") and target:GetObjVar("Karma") > 0) then
            self.ParentObj:SystemMessage("You will have a hard time provoking something with positive karma.", "info")
            EndMobileEffect(root)
            return false
        end

        if (target:HasObjVar("controller")) then
            local master = target:GetObjVar("controller")
            if (master ~= self.ParentObj) then
                self.ParentObj:SystemMessage("That's someone else's pet though... nice try.", "info")
                EndMobileEffect(root)
                return false
            end
        end

        local destLoc = self.ParentObj:GetLoc()
        local protected = GetGuardProtectionForLoc(destLoc)
        if (protected == "Town" or protected == "Protection") then
            self.ParentObj:SystemMessage("The guards would definitely whack you for that one.", "info")
            EndMobileEffect(root)
            return false
        end

        if (target ~= nil) then
            local mobint = target:GetStatValue("Int")
            local tamerint = self.ParentObj:GetStatValue("Int")
            local formula = ((tamerint - mobint) > 2)
            local crookObj = self.ParentObj:GetEquippedObject("RightHand")
            local isCrook = crookObj and
				 (GetWeaponType(crookObj) == "Crook" or
				 GetWeaponType(crookObj) == "CrookAsh" or
				 GetWeaponType(crookObj) == "CrookBlight")

            if (formula and crookObj and not(target:IsPlayer())) then
                self.ParentObj:SystemMessage("It just might work!", "info")
                self.ParentObj:PlayAnimation("fistpump")
                if ( Success(ServerSettings.Durability.Chance.OnToolUse) ) then
                    AdjustDurability(crookObj, -1)
                end
                target:SendMessage("StartMobileEffect", "BeingProvoked", self.ParentObj)
            else
                self.ParentObj:SystemMessage("It probably won't work...", "info")
                self.ParentObj:PlayAnimation("sad")
            end
        end
        EndMobileEffect(root)
    end,

    OnExitState = function(self, root)
        return
    end,
}
 