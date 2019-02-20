MobileEffectLibrary.Identify = {
    ShouldStack = false,
    OnEnterState = function(self, root, target, args)
        self.RequestInitialTarget(self,root,target,args)
	end,

    RequestInitialTarget = function(self,root,target,args)
        
        if (target:IsPlayer()) then
            self.ParentObj:SystemMessage("That is not equipment.")
            EndMobileEffect(root)
            return false
        end
		-- handle a new target
		RegisterSingleEventHandler(EventType.ClientTargetLocResponse, "ArmsLore.InitialTarget",
			function (success,targetLoc,targetObj,user)
				if ( success ) then
                    self.Target = targetObj
                    local doIdentify = false

                    if (targetObj:HasObjVar("WeaponType")) then doIdentify = true end
                    if (targetObj:HasObjVar("ArmorType")) then doIdentify = true end
                    if (targetObj:HasObjVar("JewelryType")) then doIdentify = true end

                    if (doIdentify ~= false) then 
                        self.IdentifyTarget(self, targetObj, root) 
                    else
                        self.ParentObj:SystemMessage("Idenfity is for user on weapons, armor, and jewelry.", "info")
					    EndMobileEffect(root)
                    end
				else
					EndMobileEffect(root)
				end
			end)
		self.ParentObj:RequestClientTargetLoc(self.ParentObj, "ArmsLore.InitialTarget")
	end,

    IdentifyTarget = function(self, target, root)
        local user = self.ParentObj
        local success = false
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

        local MaxDurability = item:GetObjVar("MaxDurability")
        local Durability = item:GetObjVar("Durability") or MaxDurability
        local levels = #self.Durabilities
        local level = (levels + 1) - math.ceil((Durability/MaxDurability) * levels)
        local name = item:GetName()
        local message = string.format(self.Durabilities[level], name)
        
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

        local weaponType = item:GetObjVar("WeaponType")
        if (weaponType) then
            -- ArmorLevels
            local weaponLevel = EquipmentStats.BaseWeaponStats[weaponType].Attack
            local weaponLevels = #self.WeaponLevels
            weaponLevel = (weaponLevels + 1) - math.ceil((weaponLevel/40) * weaponLevels)
            if (weaponLevel > weaponLevels) then 
                weaponLevel = weaponLevels
            end
            message = message .. self.WeaponLevels[weaponLevel]
        end
        
        local executionerLevel = item:GetObjVar("ExecutionerLevel")
        if (executionerLevel) then
            message = tostring(message .. " '" .. ServerSettings.Executioner.LevelString[executionerLevel] ..  "' means that this weapon does " .. ServerSettings.Executioner.LevelModifier[executionerLevel] .. "x damage.")
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
    Duration = TimeSpan.FromSeconds(1)
}
