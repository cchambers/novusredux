MobileEffectLibrary.Identify = {
    ShouldStack = false,
    OnEnterState = function(self, root, target, args)
        self.RequestInitialTarget(self,root,target,args)
	end,

    RequestInitialTarget = function(self,root,target,args)
		RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse, "ArmsLore.InitialTarget",
			function (target,user)
                self.Target = target
                local doIdentify = false

                if (self.Target:HasObjVar("WeaponType")) then 
                    local weaponType = self.Target:GetObjVar("WeaponType")
                    if (EquipmentStats.BaseWeaponStats[weaponType].NoCombat) then
                        -- still false
                    else
                        doIdentify = true 
                    end
                end
                if (self.Target:HasObjVar("ArmorType")) then doIdentify = true end
                if (self.Target:HasObjVar("ShieldType")) then doIdentify = true end
                if (self.Target:HasObjVar("JewelryType")) then doIdentify = true end

                if (doIdentify ~= false) then 
                    self.IdentifyTarget(self, root) 
                else
                    self.ParentObj:SystemMessage("Identify is for user on weapons, armor, and jewelry.", "info")
                    EndMobileEffect(root)
                end
			end)
		self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "ArmsLore.InitialTarget")
	end,

    IdentifyTarget = function(self, root)
        local user = self.ParentObj
        local success = false
        local target = self.Target

        if(target:HasObjVar("Identified")) then
            self.DoIdentify(self, root)
            return
        else
            success = CheckSkill(user, "ArmsLoreSkill")
        end

        if (success) then
            local skillLevel = GetSkillLevel(user, "ArmsLoreSkill")
            self.StartProgressBar(self, root)
            user:PlayAnimation("forage")
            user:ScheduleTimerDelay(self.Duration, "ArmsLore.ID")

            RegisterEventHandler(
                EventType.Timer,
                "ArmsLore.ID",
                function()
                    user:PlayAnimation("idle")
                    self.DoIdentify(self, root)
                    EndMobileEffect(root)
                end
            )
        else
            user:SystemMessage("You are not certain...", "info")
            EndMobileEffect(root)
        end
        return
    end,
    StartProgressBar = function(self, root)
        ProgressBar.Show(
            {
                TargetUser = self.ParentObj,
                Label = "Identifying...",
                Duration = self.Duration,
                PresetLocation = "AboveHotbar",
                DialogId = "Identifying",
                CanCancel = true,
                CancelFunc = function()
                    EndMobileEffect(root)
                end
            }
        )
    end,
    
    DoIdentify = function(self, root)
        local user = self.ParentObj
        user:SystemMessage("You study the item in an attempt to learn more about its craftsmanship and use.", "info")
        local item = self.Target
        local message = ""
        local MaxDurability = item:GetObjVar("MaxDurability") 
        if (MaxDurability ~= nil) then
            local Durability = item:GetObjVar("Durability") or MaxDurability
            local levels = #self.Durabilities
            local level = (levels + 1) - math.ceil((Durability/MaxDurability) * levels)
            local name = item:GetName()
            message = message .. string.format(self.Durabilities[level], name)
        end
        -- Shield Type

        local armorType = item:GetObjVar("ArmorType")
        if (armorType) then
            -- ArmorLevels
            local armorLevel = EquipmentStats.BaseArmorStats[armorType].Chest.ArmorRating
            local armorLevels = #self.ArmorLevels
            armorLevel = (armorLevels + 1) - math.ceil((armorLevel/60) * armorLevels)
            if (armorLevel > armorLevels) then
                armorLevel = armorLevels
            end
            message = message .. self.ArmorLevels[armorLevel]
        end

        local shieldType = item:GetObjVar("ShieldType")
        if (shieldType) then
            if (EquipmentStats.BaseShieldStats[shieldType] ~= nil) then
                local shieldLevel = EquipmentStats.BaseShieldStats[shieldType].ArmorRating
                if (shieldLevel == nil or ) then
                    user:SystemMessage("This item is bugged. Please send a /page to log the time/location and we will check it out!", "info")
                    EndMobileEffect(root)
                    return false
                end
                local shieldLevels = #self.ArmorLevels
                shieldLevel = (shieldLevels + 1) - math.ceil((shieldLevel/60) * shieldLevels)
                if (shieldLevel > shieldLevels) then 
                    shieldLevel = shieldLevels
                end
                message = message .. self.ArmorLevels[shieldLevel]
            else
                user:SystemMessage("This item is bugged. Please send a /page to log the time/location and we will check it out!", "info")
                EndMobileEffect(root)
                return false
            end
        end
        

        local weaponType = item:GetObjVar("WeaponType")
        if (weaponType) then
            local weaponLevel = EquipmentStats.BaseWeaponStats[weaponType].Attack
            if (weaponLevel == nil) then
                user:SystemMessage("This item is bugged. Please send a /page to log the time/location and we will check it out!", "info")
                EndMobileEffect(root)
                return false
            end
            local weaponLevels = #self.WeaponLevels
            weaponLevel = (weaponLevels + 1) - math.ceil((weaponLevel/40) * weaponLevels)
            if (weaponLevel > weaponLevels) then 
                weaponLevel = weaponLevels
            end
            message = message .. self.WeaponLevels[weaponLevel]
        end
        
        local executionerLevel = item:GetObjVar("ExecutionerLevel")
        if (executionerLevel) then
            message = tostring(message .. " '" .. ServerSettings.Executioner.LevelString[executionerLevel] ..  "' means that this weapon does " .. tostring(ServerSettings.Executioner.LevelModifier[executionerLevel] * 100) .. "% damage.")
        end

        if (item:GetObjVar("WasImbued")) then
            if (item:GetObjVar("ImbuedWeapon")) then
                message = message .. " It is magically enhanced."
            else
                message = message .. " It has been magically enhanced in the past and cannot be repaired."
            end
        end

        if (item:HasObjVar("PoisonLevel")) then
              message = message .. " There is a thick acrid liquid on the edge of the blade -- definitely poison."
        end

        self.ParentObj:SystemMessage("[bada55]Identified: [-]" .. message)
        
        local tooltipInfo = SetItemTooltip(item)
        item:SetObjVar("Identified", true)
        EndMobileEffect(root)
        return
    end,

    OnExitState = function(self, root)
        UnregisterEventHandler("", EventType.Timer, "ArmsLore.ID")
    end,
    
	GetPulseFrequency = function(self, root)
		return self.EndAfter
    end,
    
    
	AiPulse = function(self, root)
		EndMobileEffect(root)
	end,

    Durabilities = {
        "This %s is brand new ",
        "This %s is almost new ",
        "This %s is barely used, with a few nicks and scrapes ",
        "This %s is fairly good condition ",
        "This %s has suffered some wear and tear ",
        "This %s is well used ",
        "This %s is rather battered ",
        "This %s is somewhat badly damaged ",
        "This %s is flimsy and not trustworthy ",
        "This %s is falling apart "
    },

    ArmorLevels = {
        "and is superbly crafted to provide maximum protection.",
        "and offers excellent protection.",
        "and is a superior defense against attack.",
        "and serves as sturdy protection.",
        "and offers some protection against blows.",
        "and provides very little protection.",
        "and provides almost no protection.",
        "and offers no defense against attackers."
    },

    WeaponLevels = {
        "and is extraordinarily deadly.",
        "and is a superior weapon.",
        "and will inflict serious damage and pain.",
        "and will likely hurt opponent a fair amount.",
        "and will do some damage.",
        "and will do minimal damage.",
        "and will scratch your opponent... slightly."
    },

    Target = nil,
    Duration = TimeSpan.FromSeconds(1),
    EndAfter = TimeSpan.FromSeconds(6)
}
