MobileEffectLibrary.CrookCalm =
{
    ShouldStack = false,
    
    OnEnterState = function(self, root, target, args)
        local skillLevel = GetSkillLevel(self.ParentObj, "AnimalLoreSkill")
        if (skillLevel < 80) then
            self.ParentObj:SystemMessage("You lack the Animal Lore (80) to do this.")
            EndMobileEffect(root)
            return false
        end
        if (target) then
            local hp = target:GetStatValue("Health")
            local maxhp = GetMaxHealth(target)
            local percent = (hp / maxhp) * 100
            local formula = (percent < 20)
            local crookObj = self.ParentObj:GetEquippedObject("RightHand")
            local isCrook = crookObj and
				 (GetWeaponType(crookObj) == "Crook" or
				 GetWeaponType(crookObj) == "CrookAsh" or
				 GetWeaponType(crookObj) == "CrookBlight")

            if (formula and crookObj and not(target:IsPlayer())) then
                self.ParentObj:SystemMessage("It might work!")
                self.ParentObj:PlayAnimation("fistpump")
                if ( Success(ServerSettings.Durability.Chance.OnToolUse) ) then
                    AdjustDurability(crookObj, -1)
                end
                target:SendMessage("StartMobileEffect", "BeingCalmed", self.ParentObj)
            else
                self.ParentObj:SystemMessage("It probably won't work!")
                self.ParentObj:PlayAnimation("sad")
            end
        end
        EndMobileEffect(root)
    end,

    OnExitState = function(self, root)
        return
    end,
}
 