MobileEffectLibrary.Reclaim = {
    ShouldStack = false,
    OnEnterState = function(self, root, target, args)
        local user = self.ParentObj
        if (target) then
            self.Target = target
            if not (IsInBackpack(target, user)) then
                user:SystemMessage("That is not in your pack.", "info")
                EndMobileEffect(root)
                return false
            end

            self.Forge =
                FindObjects(
                SearchMulti(
                    {
                        SearchObjectInRange(5), --in 10 units
                        SearchObjVar("GuideEventId", "NearForge") -- this is from NPE but serves our purpose...
                    }
                )
            )

            if (#self.Forge == 0) then
                user:SystemMessage("You need a forge to do that.", "info")
                EndMobileEffect(root)
                return false
            else
                self.ReclaimTarget(self, target, root)
            end
        end
        return
    end,
    ReclaimTarget = function(self, target, root)
        local user = self.ParentObj
        local skillLevel = GetSkillLevel(user, "MetalsmithSkill")

        local repair = {0, 100}
        if (skillLevel < 30) then
            repair = {5, 20}
        elseif (skillLevel < 65) then
            repair = {35, 65}
        elseif (skillLevel < 85) then
            repair = {75, 90}
        elseif (skillLevel <= 100) then
            repair = {90, 100}
        end

        local percent = math.random(repair[1], repair[2]) * 0.01
        self.RepairTo = math.round(bestAmount * percent)
        return
    end,
    StartProgressBar = function(self, root)
        ProgressBar.Show(
            {
                TargetUser = self.ParentObj,
                Label = "Reclaiming...",
                Duration = self.Duration,
                PresetLocation = "AboveHotbar",
                DialogId = "Reclaiming",
                CanCancel = true,
                CancelFunc = function()
                    EndMobileEffect(root)
                end
            }
        )
    end,
    DoReclaim = function(self, root)
        -- destroy item
        -- create ingots
        EndMobileEffect(root)
        return
    end,
    OnExitState = function(self, root)
        UnregisterEventHandler("", EventType.Timer, "Blacksmith.Repair")
    end,

    Forge = {},
    Target = nil,
    Durability = 0,
    Duration = TimeSpan.FromSeconds(3)
}
