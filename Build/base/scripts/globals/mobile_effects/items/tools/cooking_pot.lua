MobileEffectLibrary.CookingPot = 
{

    OnEnterState = function(self,root,target,args)
        self.Target = target
        if (self.Target == nil) then
            EndMobileEffect(root)
            return
        end

        if (self.CanCook(self,root)) then

            RegisterEventHandler(EventType.Message, "CreateCookedItems", function(user, resourceType, amount)
            local createId = "cooking_"..uuid()
            RegisterSingleEventHandler(EventType.CreatedObject, createId,
            function(success, objRef, amount)
                if success then
                    if amount > 1 then
                        RequestSetStack(objRef,amount)
                    end
                    SetItemTooltip(objRef)
                end
            end)
            local canCreateInBag, reason = CreateObjInBackpackOrAtLocation(user, FoodStats.BaseFoodStats[resourceType].Template, createId, amount)
            end)

            RegisterEventHandler(EventType.Message, "BreakInvisEffect", function(what)
                if ( what ~= "Pickup" ) then
                    self.Interrupted(self, root)
                end
            end)

            RegisterEventHandler(EventType.StartMoving, "", function()
                self.Interrupted(self, root)
            end)
            self.ParentObj:StopMoving()

            SetMobileMod(self.ParentObj, "Busy", "CookingPot", true)

            self.ParentObj:PlayAnimation("carve")
            self.StartProgressBar(self, root)
        else
            EndMobileEffect(root)
            return false
        end
    end,


    OnExitState = function(self,root)
        self.Target = nil
        self.ParentObj:PlayAnimation("idle")
        UnregisterEventHandler("", EventType.Message, "CreateCookedItems")
        SetMobileMod(self.ParentObj, "Busy", "CookingPot", nil)
        UnregisterEventHandler("", EventType.Message, "BreakInvisEffect")
        UnregisterEventHandler("", EventType.StartMoving, "")

        ProgressBar.Cancel("CookingPot", self.ParentObj)
	end,

	GetPulseFrequency = function(self,root)
		return self.PulseFrequency
    end,

    StartProgressBar = function(self,root)
        ProgressBar.Show(
        {
            TargetUser = self.ParentObj,
            Label = "Cooking",
            Duration = self.PulseFrequency,
            PresetLocation = "AboveHotbar",
            DialogId = "CookingPot",
            CanCancel = true,
            CancelFunc = function()
                self.Interrupted(self, root)
            end,
        })
        --self.ParentObj:PlayObjectSound("event:/character/skills/crafting_skills/fabrication/fabrication", false, self.PulseFrequency.TotalSeconds)
    end,

    CanCook = function(self, root)

        if (self.Target == nil) then EndMobileEffect(root) end

        local heatSource = FindObject(SearchHasObjVar("HeatSource",OBJECT_INTERACTION_RANGE),self.ParentObj)
        
        if (heatSource == nil) then 
            self.ParentObj:SystemMessage("[$1779]")
            EndMobileEffect(root)
            return false
        end

        local conts = self.Target:GetContainedObjects()
        if(conts == nil or (#conts < 1)) then 
            self.ParentObj:SystemMessage("There is nothing in the pot.","info")
            EndMobileEffect(root)
            return false
        end
        return true

    end,

    VerifyInBackpack = function(self,root)
        -- item was destroyed or something?
        if ( not self.Target or not self.Target:IsValid() or self.Target:TopmostContainer() ~= self.ParentObj ) then
            self.ParentObj:SystemMessage("Cooking pot must be in backpack to cook.", "info")
            EndMobileEffect(root)
            return false
        end
        return true
    end,

    Interrupted = function(self, root)
        self.ParentObj:SystemMessage("Cooking interrupted.", "info")
        EndMobileEffect(root)
    end,

    AiPulse = function(self,root)
        -- resource effects will verify in backpack the first use, but not on continued use.
        --if ( not self.VerifyTarget(self,root,self.Target) or not self.VerifyInBackpack(self,root) ) then return end
        if not(self.VerifyInBackpack(self, root)) then return end
        if not(self.CanCook(self, root)) then
            EndMobileEffect(root)
            return false
        end

        -- durability hit to the hunting knife
        if ( Success(ServerSettings.Durability.Chance.OnToolUse) ) then
            AdjustDurability(self.Target, -1)
        end

        -- did tools break?
        if ( not self.Target or not self.Target:IsValid() ) then
            EndMobileEffect(root)
            return false
        end

        CookFood(self.ParentObj, self.Target)

        EndMobileEffect(root)
    end,

    PulseFrequency = TimeSpan.FromSeconds(5),

    _Difficulty = 100,
} 