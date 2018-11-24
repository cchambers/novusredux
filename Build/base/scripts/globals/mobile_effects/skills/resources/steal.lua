MobileEffectLibrary.Steal = 
{

    OnEnterState = function(self,root,target)
    	self.RequestInitialTarget(self, root, target)
    end,

    RequestInitialTarget = function(self,root,target)
		-- handle a new target
		RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse, "StealTarget",
			function (stealTarget)
				if(stealTarget ~= nil) then
					if (stealTarget:HasObjVar("StealingDifficulty")) then
						if not( self.VerifyTarget(self,root,stealTarget) ) then EndMobileEffect(root) return false end
						self.Target = stealTarget
						self.StartStealing(self, root, stealTarget)
						return true
					end
				end
				self.ParentObj:SystemMessage("Steal cancelled.","info")
				EndMobileEffect(root)
				return false
			end)

		self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "StealTarget")
	end,

	StartStealing = function (self, root, target)

    	SetMobileMod(self.ParentObj, "Busy", "Stealing", true)
        RegisterEventHandler(EventType.Message, "DamageInflicted", function() EndMobileEffect(root) end)
        RegisterEventHandler(EventType.StartMoving, "", function()
            EndMobileEffect(root)
        end)
        self.ParentObj:StopMoving()
        self.StartProgressBar(self,root)
        self.ParentObj:PlayAnimation("forage")
	end,

    OnExitState = function(self,root)
        if ( self.Target ) then
            SetMobileMod(self.ParentObj, "Busy", "Stealing", nil)
            UnregisterEventHandler("", EventType.Message, "DamageInflicted")
            UnregisterEventHandler("", EventType.StartMoving, "")
            self.ParentObj:PlayAnimation("idle")
        	ProgressBar.Cancel("Stealing", self.ParentObj)
        end
	end,

    VerifyTarget = function(self,root,target)
        if ( not target or not target:IsValid() or target:IsPermanent() ) then
            self.ParentObj:SystemMessage("Invalid Target.", "info")
            EndMobileEffect(root)
            return false
        end

	    --If item is in a container, check to see if the container is locked
        if (target:IsInContainer()) then

        	if not (self.ParentObj:HasLineOfSightToObj(target:TopmostContainer())) then
        		EndMobileEffect(root)
        		return false
        	end

        	--Do a distance check to the container
	    	if ( self.ParentObj:DistanceFromSquared(target:TopmostContainer()) > self.DistanceSquared ) then
	            self.ParentObj:SystemMessage("Cannot Reach That.", "info")
	            EndMobileEffect(root)
	            return false
	        end

	    	local lockedContainer = nil
		    ForEachParentContainerRecursive(target,false,
		        function (parentObj)
		            if( parentObj:HasObjVar("locked") ) then                
		                lockedContainer = parentObj
		                return false
		            end
		            return true
		        end)

		    if( lockedContainer ~= nil ) then
		    	self.ParentObj:SystemMessage("Container is locked.", "info")
	            EndMobileEffect(root)
	            return false
		    end
		    LookAt(self.ParentObj, target:TopmostContainer())
	    else
			--If the target is not in a container, do a distance check.

			if not (self.ParentObj:HasLineOfSightToObj(target)) then
        		EndMobileEffect(root)
        		return false
        	end

	    	if ( self.ParentObj:DistanceFromSquared(target) > self.DistanceSquared ) then
	            self.ParentObj:SystemMessage("Cannot Reach That.", "info")
	            EndMobileEffect(root)
	            return false
	        end
        	LookAt(self.ParentObj, target)
	    end

        if not ( target:HasObjVar("StealingDifficulty") ) then
            self.ParentObj:SystemMessage("Cannot steal that!", "info")
            EndMobileEffect(root)
            return false
        end
        return true
    end,

    StartProgressBar = function(self,root)
        ProgressBar.Show(
        {
            TargetUser = self.ParentObj,
            Label = "Stealing",
            Duration = self.PulseFrequency,
            PresetLocation = "AboveHotbar",
            DialogId = "Stealing",
            CanCancel = true,
            CancelFunc = function()
                EndMobileEffect(root)
                return false
            end,
        })
    end,

    GetPulseFrequency = function(self,root)
		return self.PulseFrequency
    end,

    AiPulse = function(self,root)
        -- resource effects will verify in backpack the first use, but not on continued use.
        if ( not self.VerifyTarget(self,root,self.Target) ) then return end
        local difficulty = self.Target:GetObjVar("StealingDifficulty") or 100
        if ( CheckSkill(self.ParentObj, "StealingSkill", difficulty) ) then
            self.Backpack = self.ParentObj:GetEquippedObject("Backpack")
	        if ( self.Backpack == nil ) then
	            self.ParentObj:SystemMessage("A Backpack Is Required.", "info")
	            EndMobileEffect(root)
	            return false
	        else
                self.Success,self.Reason =TryPutObjectInContainer(self.Target, self.Backpack, nil, false, true)
                if not (self.Success) then
                	self.ParentObj:SystemMessage(self.Reason, "info")
                else
                	self.Target:DelObjVar("StealingDifficulty")
                end
            end
            EndMobileEffect(root)
            return false
        else
            self.ParentObj:SystemMessage("Failed to steal.", "info")
		    local guardNearby = FindObject(SearchMulti({SearchMobileInRange(20),SearchHasObjVar("IsGuard"),}))
		        if (guardNearby ~= nil) then
		            guardNearby:SendMessage("StealFailure", self.ParentObj)
			    end
            self.StartProgressBar(self,root)
        end
    end,

    PulseFrequency = TimeSpan.FromSeconds(5),
    DistanceSquared = 9,
}