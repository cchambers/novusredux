MobileEffectLibrary.Repair = {
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

            if (target:HasObjVar("WasImbued")) then
                user:SystemMessage("This was damaged by magic and cannot be repaired.", "info")
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
                self.RepairTarget(self, target, root)
            end
        end
        return
    end,
    RepairTarget = function(self, target, root)
        local user = self.ParentObj
        local maxDurability = target:GetObjVar("MaxDurability")
        self.Durability = target:GetObjVar("Durability") or maxDurability
        local damage = maxDurability - self.Durability
        self.PermanentDamage = target:GetObjVar("PermanentDamage") or 0

        if (self.Durability >= maxDurability - self.PermanentDamage) then
            user:SystemMessage("That is already fully repaired.", "info")
            EndMobileEffect(root)
            return false
        else
            if (CheckSkillChance(user, "MetalsmithSkill")) then
                local skillLevel = GetSkillLevel(user, "MetalsmithSkill")
                self.StartProgressBar(self, root)
                FaceObject(user,self.Forge[1])
                user:PlayAnimation("blacksmith")
                user:ScheduleTimerDelay(self.Duration, "Blacksmith.Repair")
                local bestAmount = maxDurability - self.PermanentDamage

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
                
                -- user:NpcSpeech(tostring(percent .. " of " .. bestAmount .. " is " .. self.RepairTo))
                self.PermanentDamage = maxDurability - self.RepairTo

                RegisterEventHandler(
                    EventType.Timer,
                    "Blacksmith.Repair",
                    function()
                        user:NpcSpeechToUser("*repaired*", user)
                        user:PlayAnimation("idle")
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
                EndMobileEffect(root)
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
        AdjustDurability(self.Target, self.RepairTo - self.Durability)
        EndMobileEffect(root)
        return
    end,
    OnExitState = function(self, root)
        UnregisterEventHandler("", EventType.Timer, "Blacksmith.Repair")
    end,

    Forge = {},
    Target = nil,
    Durability = 0,
    RepairTo = 0,
    PermanentDamage = 0,
    Duration = TimeSpan.FromSeconds(3)
}
