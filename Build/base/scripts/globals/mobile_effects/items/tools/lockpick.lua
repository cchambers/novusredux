MobileEffectLibrary.Lockpick = 
{

    OnEnterState = function(self,root,target,args)
        
        if not( self.VerifyTarget(self,root,target) ) then return false end

        -- the used object is passed as the args
        self.Object = args

        self.Backpack = self.ParentObj:GetEquippedObject("Backpack")

        if ( self.Backpack == nil ) then
            self.ParentObj:SystemMessage("A Backpack Is Required.", "info")
            EndMobileEffect(root)
            return false
        end

        self.Target = target

        SetMobileMod(self.ParentObj, "Busy", "Lockpick", true)
        RegisterEventHandler(EventType.Message, "DamageInflicted", function() EndMobileEffect(root) end)
        RegisterEventHandler(EventType.LeaveView, "LockpickRange", function() EndMobileEffect(root) end)
        RegisterEventHandler(EventType.StartMoving, "", function()
            self.ParentObj:StopObjectSound("event:/character/skills/crafting_skills/fabrication/fabrication")
            EndMobileEffect(root)
        end)
        self.ParentObj:StopMoving()
        AddView("LockpickRange", SearchMobileInRange(5))

        self.StartProgressBar(self,root)

        self.ParentObj:PlayAnimation("forage")

    end,

    StartProgressBar = function(self,root)
        ProgressBar.Show(
        {
            TargetUser = self.ParentObj,
            Label = "Picking Lock",
            Duration = self.PulseFrequency,
            PresetLocation = "AboveHotbar",
            DialogId = "Lockpick",
            CanCancel = true,
            CancelFunc = function()
                EndMobileEffect(root)
            end,
        })
        self.ParentObj:PlayObjectSound("event:/character/skills/crafting_skills/fabrication/fabrication", false, self.PulseFrequency.TotalSeconds)
    end,
    
    VerifyTarget = function(self,root,target)
        if ( not target or not target:IsValid() or target:IsPermanent() ) then
            self.ParentObj:SystemMessage("Invalid Target.", "info")
            EndMobileEffect(root)
            return false
        end
        if ( self.ParentObj:DistanceFrom(target) > 3 ) then
            self.ParentObj:SystemMessage("Cannot Reach That.", "info")
            EndMobileEffect(root)
            return false
        end
        local difficulty = target:GetObjVar("LockpickingDifficulty")
        if ( difficulty ) then
            -- prevent trying to pick the lock of a chest that's already been picked
            if not( target:HasObjVar("locked") ) then
                self.ParentObj:SystemMessage("That is already unlocked.", "info")
                EndMobileEffect(root)
                return false
            end
        else
            if ( target:IsContainer() ) then
                if ( target:HasObjVar("locked") ) then
                    self.ParentObj:SystemMessage("Cannot pick that lock.", "info")
                else
                    self.ParentObj:SystemMessage("That is already unlocked.", "info")
                end
            else
                self.ParentObj:SystemMessage("Invalid Target.", "info")
            end
            EndMobileEffect(root)
            return false
        end
        self._Difficulty = difficulty
        LookAt(self.ParentObj, target)
        return true
    end,

    VerifyHolding = function(self,root)
        -- item was destroyed or something?
        if ( not self.Object or not self.Object:IsValid() or self.Object:TopmostContainer() ~= self.ParentObj ) then
            self.ParentObj:SystemMessage("Cannot Find Lockpick.", "info")
            EndMobileEffect(root)
            return false
        end
        return true
    end,

    OnExitState = function(self,root)
        if ( self.Target ) then
            SetMobileMod(self.ParentObj, "Busy", "Lockpick", nil)
            DelView("LockpickRange")
			UnregisterEventHandler("", EventType.LeaveView, "LockpickRange")
            UnregisterEventHandler("", EventType.Message, "DamageInflicted")
            UnregisterEventHandler("", EventType.StartMoving, "")
			if ( self.ParentObj:HasTimer("LockpickClose") ) then
				self.ParentObj:FireTimer("LockpickClose") -- close progress bar
            end
            self.ParentObj:PlayAnimation("idle")
        end
	end,

	GetPulseFrequency = function(self,root)
		return self.PulseFrequency
    end,
    
    AiPulse = function(self,root)
        -- resource effects will verify in backpack the first use, but not on continued use.
        if ( not self.VerifyTarget(self,root,self.Target) or not self.VerifyHolding(self,root) ) then return end
 
        if ( Success(ServerSettings.Durability.Chance.OnToolUse) ) then
            AdjustDurability(self.Object, -1)
        end

        -- did tools break?
        if ( not self.Object or not self.Object:IsValid() ) then
            EndMobileEffect(root)
            return
        end

        local skillLevel = GetSkillLevel(self.ParentObj, "LockpickingSkill")
        local chance = SkillValueMinMax( skillLevel, self._Difficulty - 25, self._Difficulty + 25 )
        if ( CheckSkillChance(self.ParentObj, "LockpickingSkill", skillLevel, chance) ) then
            self.Target:PlayObjectSound("event:/objects/doors/door/door_lock_pick")
            self.Target:DelObjVar("locked")
            --RemoveTooltipEntry(self.Target,"lock")
            self.Target:SendMessage("Lockpicked", self.ParentObj)
            self.ParentObj:SystemMessage("Unlocked.", "info")
            if not (self.Target:HasObjVar("NoDecay")) then
                Decay(self.Target, 300)
            end
            EndMobileEffect(root)
        else
            if ( chance <= 0 ) then
                self.ParentObj:SystemMessage("No chance to pick this lock.", "info")
                EndMobileEffect(root)
                return
            elseif ( chance < 0.075 ) then
                self.ParentObj:SystemMessage("Almost no chance to pick this lock.", "info")
            else
                self.ParentObj:SystemMessage("Failed to pick lock.", "info")
            end
            self.StartProgressBar(self,root)
        end
    end,
    
    PulseFrequency = TimeSpan.FromSeconds(5),

    _Difficulty = 100,
} 