MobileEffectLibrary.CrookCalm =
{
    ShouldStack = false,

    OnEnterState = function(self, root, target, args)
        if (target) then
            local hp = target:GetStatValue("Health")
            local maxhp = GetMaxHealth(target)
            local percent = (hp / maxhp) * 100
            local formula = (percent < 20)
            if (formula) then
                self.ParentObj:SystemMessage("It might work!")
                self.ParentObj:PlayAnimation("fistpump")
                target:SendMessage("StartMobileEffect", "BeingCalmed", self.ParentObj)
            else
                self.ParentObj:SystemMessage("It probably won't work!")
                self.ParentObj:PlayAnimation("sad")
            end
        end
        EndMobileEffect(root)
    end,

    OnExitState = function(self, root)
        self.ParentObj:SystemMessage("EXITING")
    end,
}
 