MobileEffectLibrary.Intellect = 
{
	OnEnterState = function(self,root,target,args)
		self.ParentObj:PlayEffect("BuffEffect_F")
		self.Duration = args.Duration or self.Duration
		local skillLevel = GetSkillLevel(self.ParentObj,"MagerySkill")
		mConversionRate = ((skillLevel / 100) * .5)  + .25
		local curStam = GetCurStamina(self.ParentObj)
		if(curStam < 5) then
			self.ParentObj:SystemMessage("Not enough stamina", "info")
			EndMobileEffect(root)
			return
		end
		local maxStam = GetMaxStamina(self.ParentObj)
		local curMana = GetCurMana(self.ParentObj)
		local staminaTake = math.min(curStam,(maxStam * .2))
		local manaBonus = math.floor(staminaTake * mConversionRate)
		SetCurStamina(self.ParentObj,math.max((curStam - staminaTake),0))
		SetCurMana(self.ParentObj,math.min((curMana + manaBonus),GetMaxMana(self.ParentObj)))
		EndMobileEffect(root)
	end,

	OnExitState = function(self,root)
		--self.ParentObj:PlayAnimation("kneel_standup")
	end,

	GetPulseFrequency = function(self,root)
		return TimeSpan.FromSeconds(1)
	end,

	AiPulse = function(self,root)
			EndMobileEffect(root)
	end,
	
	Duration = TimeSpan.FromSeconds(1),
	PlayEffect = true,
}