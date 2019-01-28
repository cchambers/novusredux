MobileEffectLibrary.Reclaim = {
    ShouldStack = false,
    ResourceTypes = {
        Iron = "resource_iron",
        Copper = "resource_copper",
        Gold = "resource_gold",
        Cobalt = "resource_cobalt",
        Obsidian = "resource_obsidian"
    },
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
                EndMobileEffect(root)
            end
        end
        return
    end,
    ReclaimTarget = function(self, target, root)
        local user = self.ParentObj
        FaceObject(user,self.Forge[1])
        user:PlayAnimation("blacksmith")
        SetMobileModExpire(user, "Disable", "Crafting", true, self.Duration)
        user:ScheduleTimerDelay(self.Duration, "Blacksmith.Reclaim")
        RegisterEventHandler(
            EventType.Timer,
            "Blacksmith.Reclaim",
            function()
                user:PlayAnimation("idle")
                self.DoReclaim(self, root)
            end
        )
        
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
        local user = self.ParentObj
        local target = self.Target
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

        local material = target:GetObjVar("Material") or "Iron"
        local templateName = target:GetCreationTemplateId()
        local recipe = GetRecipeForBaseTemplate(templateName)
        local resources = recipe.Resources

        if (resources == nil) then
            user:SystemMessage("That's not reclaimable.")
            EndMobileEffect(root)
            return false
        else 
            resources = resources[material]
        end
        
        if (resources == nil) then
            user:SystemMessage("That's not reclaimable.")
            EndMobileEffect(root)
            return false
        end 

		local backpackObj = user:GetEquippedObject("Backpack")
        for k, v in pairs(resources) do
            local template = self.ResourceTypes[k]
            local amount = v * percent
            if (amount < 1) then 
                if (template ~= nil) then
                    local oreAmount = 2;
                    template = template .. "_ore"
                    local type = k .. "Ore"
                    if( not( TryAddToStack(type,backpackObj,oreAmount))) then
                        CreateObjInBackpack(user, template)
                    end
                end
            else
                if (template ~= nil) then
                    amount = math.round(amount)
                    if( not( TryAddToStack(k,backpackObj,amount))) then
                        CreateObjInBackpack(user, template)
                    end
                end
            end
        end

        user:NpcSpeechToUser("*reclaimed*", user)
        target:Destroy()
        EndMobileEffect(root)
        return
    end,
    OnExitState = function(self, root)
        UnregisterEventHandler("", EventType.Timer, "Blacksmith.Repair")
    end,

    Forge = {},
    Target = nil,
    Durability = 0,
    Duration = TimeSpan.FromSeconds(2)
}
