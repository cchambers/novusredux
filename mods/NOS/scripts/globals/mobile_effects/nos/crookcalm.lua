MobileEffectLibrary.CrookCalm =
{
    ShouldStack = false,
    
    OnEnterState = function(self, root, target, args)
        local skillLevel = GetSkillLevel(self.ParentObj, "AnimalLoreSkill")
        if (skillLevel < 80) then
            self.ParentObj:SystemMessage("You lack the Animal Lore (80) to do this.", "info")
            EndMobileEffect(root)
            return false
        end

        if (target:HasModule("guard_protect")) then
            EndMobileEffect(root)
            return false
        end

        if (target:IsPlayer()) then
            self.ParentObj:SystemMessage("You cannot calm players.", "info")
            EndMobileEffect(root)
            return false
        end

        if (target~= nil) then
            local hp = target:GetStatValue("Health")
            local maxhp = GetMaxHealth(target)
            local percent = (hp / maxhp) * 100
            local formula = (percent < 25)
            local crookObj = self.ParentObj:GetEquippedObject("RightHand")
            local isCrook = crookObj and
				 (GetWeaponType(crookObj) == "Crook" or
				 GetWeaponType(crookObj) == "CrookAsh" or
				 GetWeaponType(crookObj) == "CrookBlight")

            if (formula and crookObj) then
                self.ParentObj:SystemMessage("It might work!", "info")
                self.ParentObj:PlayAnimation("fistpump")
                if ( Success(ServerSettings.Durability.Chance.OnToolUse) ) then
                    AdjustDurability(crookObj, -1)
                end
                target:SendMessage("StartMobileEffect", "BeingCalmed", self.ParentObj)
            else
                self.ParentObj:SystemMessage("That still has some fight left!", "info")
                self.ParentObj:PlayAnimation("sad")
            end
        end
        EndMobileEffect(root)
    end,

    OnExitState = function(self, root)
        return
    end,
}
 