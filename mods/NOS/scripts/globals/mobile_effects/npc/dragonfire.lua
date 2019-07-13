MobileEffectLibrary.DragonFire = 
{

	OnEnterState = function(self,root,target,args)

	self.MinDamage = args.MinDamage or self.MinDamage
	self.MaxDamage = args.MaxDamage or self.MaxDamage
	self.PulseCount = args.PulseCount or self.PulseCount
	self.PulseFrequency = args.PulseFrequency or self.PulseFrequency
	self.DistanceBuffer = args.DistanceBuffer or self.DistanceBuffer

		CallFunctionDelayed(TimeSpan.FromSeconds(0.75),
			function ()
				self.ParentObj:PlayEffectWithArgs("DragonFireEffect", 5.0, "Bone=mouth_effect_node")
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
		return self.PulseFrequency
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
				if (GetFacingZone(target,self.ParentObj) <= 1 and self.ParentObj:DistanceFrom(target) > self.DistanceBuffer) then
					target:PlayAnimation("was_hit")
			   		target:SendMessage("ProcessTrueDamage", self.ParentObj, math.random(self.MinDamage, self.MaxDamage), true, "Chest")
			   	end
		   	end
		end
	end,

	StartTime = nil,
	CurPulse = 0,

	--args
	PulseFrequency = TimeSpan.FromSeconds(1),
	PulseCount = 7,
	MinDamage = 30,
	MaxDamage = 45,
	DistanceBuffer = 7,
}