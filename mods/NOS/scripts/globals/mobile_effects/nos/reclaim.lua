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
                -- self.ReclaimTarget(self, target, root)
                EndMobileEffect(root)
                return false
            end
        end
        return
    end,
    ReclaimTarget = function(self, target, root)
        local user = self.ParentObj
        local skillLevel = GetSkillLevel(user, "MetalsmithSkill")

        local reclaim = {0, 100}
        if (skillLevel < 30) then
            reclaim = {10, 30}
        elseif (skillLevel < 65) then
            reclaim = {30, 50}
        elseif (skillLevel < 85) then
            reclaim = {50, 60}
        elseif (skillLevel <= 100) then
            reclaim = {60, 80}
        end
        local percent = math.random(reclaim[1], reclaim[2]) * 0.01

        local weaponType = target:GetObjVar("WeaponType")
            local material = target:GetObjVar("Material") or "Iron"
            user:NpcSpeech(tostring("is " ..material.." "..weaponType))
             
            local table = GetRecipeTableFromSkill("MetalsmithSkill")
            -- ULTIMATELY, run through all materials it takes... right now it only takes 1 mat but it could be multiple
            local resources = table[weaponType].Resources[material]
            for k, v in pairs(resources) do
                user:NpcSpeech(tostring(k .. " " .. v))
            end

        self.reclaim = math.round(bestAmount * percent)
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
