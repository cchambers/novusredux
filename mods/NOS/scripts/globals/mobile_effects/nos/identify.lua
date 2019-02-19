MobileEffectLibrary.Identify = {
    ShouldStack = false,
    OnEnterState = function(self, root, target, args)
        self.RequestInitialTarget(self,root,target,args)
	end,

	RequestInitialTarget = function(self,root,target,args)
		-- handle a new target
		RegisterSingleEventHandler(EventType.ClientTargetLocResponse, "ArmsLore.InitialTarget",
			function (success,targetLoc,targetObj,user)
				if ( success ) then
                    self.Target = targetObj
                    self.IdentifyTarget(self, targetObj, root)
				else
					EndMobileEffect(root)
				end
			end)
		self.ParentObj:RequestClientTargetLoc(self.ParentObj, "ArmsLore.InitialTarget")
	end,

    IdentifyTarget = function(self, target, root)
        local user = self.ParentObj
        local skipGains = false
        if(not(target:HasObjVar("Identified"))) then
            skipGains = true
        end

        if (CheckSkillChance(user, "ArmsLoreSkill", nil, nil, skipGains)) then
            local skillLevel = GetSkillLevel(user, "ArmsLoreSkill")
            self.StartProgressBar(self, root)
            user:PlayAnimation("forage")
            user:ScheduleTimerDelay(self.Duration, "ArmsLore.ID")

            RegisterEventHandler(
                EventType.Timer,
                "ArmsLore.ID",
                function()
                    user:NpcSpeechToUser("*ID'd*", user)
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
        if (item:HasObjVar("PoisonLevel")) then
            SetTooltipEntry(target,"poisoned","[00ff00]POISONED[-]", 999)
        end

        local MaxDurability = item:GetObjVar("MaxDurability")
        local Durability = item:GetObjVar("Durability") or 0

        if (MaxDurability ~= nil) then
            
        end

        -- Durability
        -- Effectiveness of Armor
        -- Effectiveness of Weapon
        
        local tooltipInfo = SetItemTooltip(item)
        item:SetObjVar("Identified", true)
        EndMobileEffect(root)
        return
    end,
    OnExitState = function(self, root)
        UnregisterEventHandler("", EventType.Timer, "ArmsLore.ID")
    end,

    Durabilities = {
        "Brand new",
        "Almost new",
        "Barely used, with a few nicks and scrapes",
        "Fairly good condition",
        "Suffered some wear and tear",
        "Well used",
        "Rather battered",
        "Somewhat badly damaged",
        "Flimsy and not trustworthy",
        "Falling apart"
    },

    ArmorLevels = {
        "Is superbly crafted to provide maximum protection",
        "Offers excellent protection",
        "Is a superior defense against attack",
        "Serves as sturdy protection",
        "Offers some protection against blows",
        "Provides very little protection",
        "Provides almost no protection",
        "Offers no defense against attackers"
    },

    WeaponLevels = {
        "Would be extraordinarily deadly",
        "Would be a superior weapon",
        "Would inflict serious damage and pain",
        "Would likely hurt opponent a fair amount",
        "Would do some damage",
        "Would do minimal damage",
        "Might scratch their opponent slightly"
    },

    Target = nil,
    Duration = TimeSpan.FromSeconds(1)
}
