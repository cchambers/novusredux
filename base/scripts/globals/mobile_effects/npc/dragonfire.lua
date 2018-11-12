MobileEffectLibrary.DragonFire = 
{

	OnEnterState = function(self,root,target,args)

		CallFunctionDelayed(TimeSpan.FromSeconds(0.75),
			function ()
				self.ParentObj:PlayEffect("DragonFireEffect")
			end)
		
		self.ParentObj:PlayAnimation("flamethrower")
		self.ParentObj:SetObjVar("AI-Disable",true)	
		SetMobileModExpire(self.ParentObj, "Freeze", "DragonFire", true, TimeSpan.FromSeconds(3.9))

		self.StartTime = DateTime.UtcNow
	end,

	OnExitState = function(self,root)
		self.ParentObj:DelObjVar("AI-Disable")
	
	end,

	GetPulseFrequency = function(self,root)
		return TimeSpan.FromSeconds(1)
	end,

	AiPulse = function(self,root)
		self:BurnEffects()

		self.CurPulse = self.CurPulse + 1
		if(self.CurPulse == self.PulseCount) then
			EndMobileEffect(root)
		end
	end,

	BurnEffects = function (self)
		local nearbyTargets = FindObjects(SearchMulti(
          {
               SearchRange(self.ParentObj:GetLoc(), 19),
               SearchModule("combat"),
           }))

		if not( IsTableEmpty(nearbyTargets) ) then
			for i, target in pairs(nearbyTargets) do
				if (GetFacingZone(target,self.ParentObj) <= 1 and self.ParentObj:DistanceFrom(target) > 7) then
					target:PlayAnimation("was_hit")
			   		target:SendMessage("ProcessTrueDamage", self.ParentObj, math.random(30,45), true, "Chest")
			   	end
		   	end
		end
	end,

	StartTime = nil,
	PulseCount = 7,
	CurPulse = 0,
}