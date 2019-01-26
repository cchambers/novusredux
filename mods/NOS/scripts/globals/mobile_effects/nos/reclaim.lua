MobileEffectLibrary.Reclaim = {
    ShouldStack = false,
    OnEnterState = function(self, root, target, args)
        local user = self.ParentObj
        if (target) then
            self.Target = target
            if not (IsInBackpack(target, user)) then
                user:SystemMessage("That is not in your pack.", "info")
                return false
            end

            local forge =
                FindObjects(
                SearchMulti(
                    {
                        SearchObjectInRange(5), --in 10 units
                        SearchObjVar("GuideEventId", "NearForge") -- this is from NPE but serves our purpose...
                    }
                )
            )

            if (#forge == 0) then
                user:SystemMessage("You need a forge to do that.", "info")
                return false
            else
                self.PermanentDamage = target:GetObjVar("PermanentDamage") or 0
                self.RepairTarget(self, target, root)
            end
        end
        return
    end,
    RepairTarget = function(self, target, root)
        local user = self.ParentObj
        local maxDurability = target:GetObjVar("MaxDurability")
        local durability = target:GetObjVar("Durability") or maxDurability
        local damage = maxDurability - durability

        if (durability >= maxDurability - self.PermanentDamage) then
            user:SystemMessage("That is already fully repaired.", "info")
            return false
        end
        if (CheckSkillChance(user, "MetalsmithSkill")) then
            local skillLevel = GetSkillLevel(user, "MetalsmithSkill")
            self.StartProgressBar(self, root)
            user:ScheduleTimerDelay(self.Duration, "Blacksmith.Repair")
            local bestAmount = maxDurability - self.PermanentDamage
            local damageDuringRepair = math.round(bestAmount * 0.01)
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

            local percent = math.random(repair[1], repair[2])
            local repairAmount = math.round(damage * (percent * 0.01))
            self.RepairTo = repairAmount
            self.PermanentDamage = maxDurability - repairAmount

            RegisterEventHandler(
                EventType.Timer,
                "Blacksmith.Repair",
                function()
                    self.DoRepair(self, root)
                end
            )
        else
            local destroy = math.random(1, 20) == 1
            if (destroy) then
                user:NpcSpeech("[ff0000]*break*[-]")
                user:SystemMessage("You fail to repair the item and destroy it in the process.", "info")
                target:Destroy()
            else
                user:SystemMessage("You fail to repair the item.", "info")
            end
        end
        return
    end,
    StartProgressBar = function(self, root)
        ProgressBar.Show(
            {
                TargetUser = self.ParentObj,
                Label = "Repairing...",
                Duration = self.Duration,
                PresetLocation = "AboveHotbar",
                DialogId = "Repairing",
                CanCancel = true,
                CancelFunc = function()
                    EndMobileEffect(root)
                end
            }
        )
    end,
    DoRepair = function(self, root)
        self.Target:SetObjVar("PermanentDamage", self.PermanentDamage)
        self.Target:SetObjVar("Durability", self.RepairTo)
    end,
    OnExitState = function(self, root)
        UnregisterEventHandler("", EventType.Timer, "Blacksmith.Repair")
    end,
    Target = nil,
    RepairTo = 0,
    PermanentDamage = 0,
    Duration = TimeSpan.FromSeconds(5)
}
