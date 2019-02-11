MobileEffectLibrary.HuntingKnife = 
{

    OnEnterState = function(self,root,target,args)
        
        if not( self.VerifyTarget(self,root,target) ) then return false end

        if ( type(args) == "table" ) then
            args = self.ParentObj:GetEquippedObject("RightHand")
        end

        self.Object = args
        self.Backpack = self.ParentObj:GetEquippedObject("Backpack")

        if ( self.Backpack == nil ) then
            self.ParentObj:SystemMessage("A backpack is required.", "info")
            EndMobileEffect(root)
            return false
        end

        self.Target = target

        SetMobileMod(self.ParentObj, "Busy", "HuntingKnife", true)
        RegisterEventHandler(EventType.Message, "BreakInvisEffect", function(what)
            if ( what ~= "Pickup" ) then
                self.Interrupted(self, root)
            end
        end)
        RegisterEventHandler(EventType.StartMoving, "", function()
            self.Interrupted(self, root)
        end)
        self.ParentObj:StopMoving()

        self.Label = ""

        if ( self.CutToBandage ) then
            self.Label = "Cutting bandages"
            self.ParentObj:PlayAnimation("forage")
        elseif ( self.CutToFillet ) then
            self.Label = "Cutting fish"
            self.ParentObj:PlayAnimation("carve")
        end

        self.StartProgressBar(self,root)
    end,

    StartProgressBar = function(self,root)
        ProgressBar.Show(
        {
            TargetUser = self.ParentObj,
            Label = self.Label,
            Duration = self.PulseFrequency,
            PresetLocation = "AboveHotbar",
            DialogId = "HuntingKnife",
        })
        self.ParentObj:PlayObjectSound("event:/character/skills/crafting_skills/fabrication/fabrication", false, self.PulseFrequency.TotalSeconds)
    end,
    
    VerifyTarget = function(self,root,target)
        if ( not target or not target:IsValid() or target:IsPermanent() ) then
            self.ParentObj:SystemMessage("Invalid target.", "info")
            EndMobileEffect(root)
            return false
        end
        self.CutToBandage = target:HasObjVar("CutToBandage")

        -- are we cutting bandages?
        if ( self.CutToBandage ) then
            self.Name = "Bandages"
        else
            -- so no. are we cutting fish?
            self.CutToFillet = target:GetObjVar("FilletType")
            if ( self.CutToFillet ) then
                -- we are cutting fish, cache the template data
                self.TemplateData = GetTemplateData(self.CutToFillet)
                self.Name = StripColorFromString(self.TemplateData.Name)
            else
                self.ParentObj:SystemMessage("Invalid target.", "info")
                EndMobileEffect(root)
                return false
            end
        end

        if ( self.CutToBandage or self.CutToFillet ) then
            if ( target:TopmostContainer() ~= self.ParentObj ) then
                self.ParentObj:SystemMessage("Cannot reach that.", "info")
                EndMobileEffect(root)
                return false
            end
            self.ResourceType = target:GetObjVar("ResourceType")
        end
        return true
    end,

    VerifyInBackpack = function(self,root)
        -- item was destroyed or something?
        if ( not self.Object or not self.Object:IsValid() or self.Object:TopmostContainer() ~= self.ParentObj ) then
            self.ParentObj:SystemMessage("Cannot locate hunting knife.", "info")
            EndMobileEffect(root)
            return false
        end
        return true
    end,

	Interrupted = function(self, root)
        self.ParentObj:StopObjectSound("event:/character/skills/crafting_skills/fabrication/fabrication")
        self.ParentObj:SystemMessage(self.Label .. " interrupted.", "info")
		EndMobileEffect(root)
	end,

    OnExitState = function(self,root)
        if ( self.Target ) then
            SetMobileMod(self.ParentObj, "Busy", "HuntingKnife", nil)
            UnregisterEventHandler("", EventType.Message, "BreakInvisEffect")
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
        -- resource effects will verify in backpack the first use, but not on continued use.
        if ( not self.VerifyTarget(self,root,self.Target) or not self.VerifyInBackpack(self,root) ) then return end

        -- durability hit to the hunting knife
        if ( Success(ServerSettings.Durability.Chance.OnToolUse) ) then
            AdjustDurability(self.Object, -1)
        end

        -- did tools break?
        if ( not self.Object or not self.Object:IsValid() ) then
            EndMobileEffect(root)
            return
        end

        local stackCount = GetStackCount(self.Target)
        if ( ConsumeResourceBackpack(self.ParentObj, self.ResourceType, 1) ) then

            if ( self.CutToBandage ) then
                self.CreateBandages(self, root, 5)
            elseif( self.CutToFillet ) then
                self.CreateFillet(self, root, 1)
                self.CreateBlackpearl(self, root)
            end

            if ( (stackCount - 1) >= 1 ) then
                self.StartProgressBar(self,root)
                return -- stop from ending the effect
            end
        else
            self.ParentObj:SystemMessage("Failed to consume resource.", "info")
        end

		EndMobileEffect(root)
    end,

    CreateBandages = function(self,root,amount)
        local added, addtostackreason = TryAddToStack("Bandage", self.Backpack, amount)
        if ( added ) then
            self.OnSuccess(self, amount)
        else
            if ( addtostackreason == "Weight" ) then
                self.ParentObj:SystemMessage("Backpack cannot hold anymore.", "info")
                Create.Stack.AtLoc("bandage", amount, self.ParentObj:GetLoc(), function(obj)
                    if ( obj ) then self.OnSuccess(self, amount) end
                end)
            else
                Create.Stack.InBackpack("bandage", self.ParentObj, amount, nil, function(obj)
                    if ( obj ) then self.OnSuccess(self, amount) end
                end)
            end
        end
    end,

    CreateFillet = function(self,root,amount)
        local localAmount = self.CheckFilletAmount(self.ParentObj, amount)
        local added, addtostackreason = TryAddToStack(self.TemplateData.ObjectVariables.ResourceType or "FishFillet", self.Backpack, localAmount)
        if ( added ) then
            self.OnSuccess(self, localAmount)
        else
            if ( addtostackreason == "Weight" ) then
                self.ParentObj:SystemMessage("Backpack cannot hold anymore.", "info")
                Create.Stack.AtLoc(self.CutToFillet, localAmount, self.ParentObj:GetLoc(), function(obj)
                    if ( obj ) then self.OnSuccess(self, localAmount) end
                end)
            else
                Create.Stack.InBackpack(self.CutToFillet, self.ParentObj, localAmount, nil, function(obj)
                    if ( obj ) then self.OnSuccess(self, localAmount) end
                end)
            end
        end
    end,

    CheckFilletAmount = function(user, amount)
        -- Chance to get 1 extra fillet out of fish level 75 and above.
        local harvestingSkill = GetSkillLevel(user, "HarvestingSkill")
        if ( harvestingSkill > 75 ) then
            local maxBonus = math.floor((harvestingSkill / 75) * amount)
            local additional = math.random(0, maxBonus)
            return amount + additional
        end
        return amount
    end,

    CreateBlackpearl = function(self,root)
        local blackpearlChance = math.random(0,10)

        -- approx 50% chance to get blackpearls from 1 to 3.
        if(blackpearlChance > 5) then
            local backpackObj = self.Backpack
            local resourceType = "Blackpearl"
            if( backpackObj ~= nil ) then		
                local harvestingSkill = GetSkillLevel(self.ParentObj, "HarvestingSkill")
                
                -- Max number of goods per harvesting skill:
                -- Skill:   0   20  40  60  80  100
                -- # Goods: 1   1   2   2   3   3
                local maxAmount = math.floor((harvestingSkill / 40) + 1)
                local stackAmount = math.random(1, maxAmount)
                
                -- Yes still doing this the rough way, but it's nice to have that extra number.
                -- No I'm not being vindictive here >.>
                if(blackpearlChance >= 6 and harvestingSkill < 40) then
                    CheckSkillChance(self.ParentObj,"HarvestingSkill")
                end

                -- try to add to the stack in the players pack		
                if( not( TryAddToStack(resourceType,backpackObj,stackAmount)) and ResourceData.ResourceInfo[resourceType] ~= nil ) then
                    -- no stack in players pack so create an object in the pack
                    local templateId = ResourceData.ResourceInfo[resourceType].Template
                    CreateObjInBackpackOrAtLocation(self.ParentObj, templateId, "create_foraging_harvest", stackAmount)
                end
        
                --local displayName = GetResourceDisplayName(resourceType)
                self.ParentObj:SystemMessage("You harvest some "..resourceType..".","info")
                mUser = self
                self.ParentObj:NpcSpeech("[F4FA58]+1 "..resourceType.."[-]","combat")
            end	
        end
    end,

    OnSuccess = function(self, amount)
        self.ParentObj:SystemMessage(string.format("Created %d %s", amount, self.Name), "info")
    end,
    
    PulseFrequency = TimeSpan.FromSeconds(3),

    CutToBandage = false,
    CutToFillet = false,

    Name = "",
}