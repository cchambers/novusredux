MobileEffectLibrary.CrookCalm =
{
    ShouldStack = false,

    OnEnterState = function(self, root, target, args)
        if (target) then
            local hp = target:GetStatValue("Health")
            local maxhp = GetMaxHealth(target)
            local percent = hp / maxhp
            self.ParentObj:SystemMessage("HP " .. hp .. " .. " .. percent .. "%")
        end
        EndMobileEffect(root)
    end,

    OnExitState = function(self, root)
        UnregisterEventHandler(GetCurrentModule(), EventType.ClientTargetLocResponse, "Telecrook.Move")
    end,
}
 