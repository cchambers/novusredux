MobileEffectLibrary.HuntingKnife = 
{

    OnEnterState = function(self,root,target,args)
        
        if not( self.VerifyTarget(self,root,target) ) then return false end

        self.Backpack = self.ParentObj:GetEquippedObject("Backpack")

        if ( self.Backpack == nil ) then
            self.ParentObj:SystemMessage("A Backpack is required ")
            EndMobileEffect(root)
            return false
        end

        self.Target = target

        SetMobileMod(self.ParentObj, "Busy", "HuntingKnife", true)
        RegisterEventHandler(EventType.Message, "DamageInflicted", function() EndMobileEffect(root) end)
        RegisterEventHandler(EventType.LeaveView, "HuntingKnifeRange", function() EndMobileEffect(root) end)
        RegisterEventHandler(EventType.StartMoving, "", function()
            self.ParentObj:StopObjectSound("Fabrication")
            EndMobileEffect(root)
        end)
        self.ParentObj:StopMoving()
        AddView("HuntingKnifeRange", SearchMobileInRange(5))

        self.Label = ""

        if ( self.CutToBandage ) then
            self.Label = "Cutting Bandages"
        end

        self.StartProgressBar(self,root)

        self.ParentObj:PlayAnimation("forage")

    end,

    StartProgressBar = function(self,root)
        ProgressBar.Show(
        {
            TargetUser = self.ParentObj,
            Label = self.Label,
            Duration = self.PulseFrequency,
            PresetLocation = "AboveHotbar",
            DialogId = "HuntingKnife",
            CanCancel = true,
            CancelFunc = function()
                EndMobileEffect(root)
            end,
        })
        self.ParentObj:PlayObjectSound("Fabrication", false, self.PulseFrequency.TotalSeconds)
    end,
    
    VerifyTarget = function(self,root,target)
        if ( not target or not target:IsValid() ) then
            self.ParentObj:SystemMessage("Invalid Target.", "info")
            EndMobileEffect(root)
            return false
        end
        self.CutToBandage = target:HasObjVar("CutToBandage")
        if ( self.CutToBandage ) then
            self.ResourceType = target:GetObjVar("ResourceType")
        else
            self.ParentObj:SystemMessage("Invalid Target.", "info")
            EndMobileEffect(root)
            return false
        end
        if ( self.CutToBandage and target:TopmostContainer() ~= self.ParentObj ) then
            self.ParentObj:SystemMessage("Cannot Reach That.", "info")
            EndMobileEffect(root)
            return false
        end
        return true
    end,

    OnExitState = function(self,root)
        if ( self.Target ) then
            SetMobileMod(self.ParentObj, "Busy", "HuntingKnife", nil)
            DelView("EffectRange")
			UnregisterEventHandler("", EventType.LeaveView, "HuntingKnifeRange")
            UnregisterEventHandler("", EventType.Message, "DamageInflicted")
            UnregisterEventHandler("", EventType.StartMoving, "")
			if ( self.ParentObj:HasTimer("HuntingKnifeClose") ) then
				self.ParentObj:FireTimer("HuntingKnifeClose") -- close progress bar
            end
            self.ParentObj:PlayAnimation("idle")
        end
	end,

	GetPulseFrequency = function(self,root)
		return self.PulseFrequency
    end,
    
	AiPulse = function(self,root)
        if not( self.VerifyTarget(self,root,self.Target) ) then return end

        if ( self.CutToBandage ) then
            if ( ConsumeResourceBackpack(self.ParentObj, self.ResourceType, 1) ) then

                self.CreateBandages(self,root,5)

                if ( GetStackCount(self.Target) > 1 ) then
                    self.StartProgressBar(self,root)
                    return -- stop from ending the effect
                end
            else
                self.ParentObj:SystemMessage("Failed to consume resource.", "info")
            end
        end

		EndMobileEffect(root)
    end,

    CreateBandages = function(self,root,amount)
        local added, addtostackreason = TryAddToStack("Bandage", self.Backpack, amount)
        if ( added ) then
            self.ParentObj:SystemMessage(string.format("Created %d Bandages", amount), "info")
            return
        end

        local createId = "cut_bandages_"..uuid()
        RegisterSingleEventHandler(EventType.CreatedObject, createId, function(success, objRef)
            if not( success ) then return end
            RequestSetStack(objRef,amount)
            SetItemTooltip(objRef)
            self.ParentObj:SystemMessage(string.format("Created %d Bandages", amount), "info")
        end)
		self.Backpack:SendOpenContainer(self.ParentObj)
		CreateObjInContainer("bandage", self.Backpack, GetRandomDropPosition(self.Backpack), createId)
    end,
    
    PulseFrequency = TimeSpan.FromSeconds(3),

    CutToBandage = false,
} 