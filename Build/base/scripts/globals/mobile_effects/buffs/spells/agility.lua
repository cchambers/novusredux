MobileEffectLibrary.Agility = 
{
	OnEnterState = function(self,root,target,args)
		self.ParentObj:PlayEffect("BuffEffect_E")
		local skillLevel = GetSkillLevel(self.ParentObj,"ManifestationSkill")
		mConversionRate = ((skillLevel / 100) * .5)  + .25
		local curMana = GetCurMana(self.ParentObj)
		if(curMana < 5) then
			self.ParentObj:SystemMessage("Not enough mana", "info")
			EndMobileEffect(root)
			return
		end
		local maxMana = GetMaxMana(self.ParentObj)
		local manaTake = math.min(curMana,(maxMana * .2))
		local curStam = GetCurStamina(self.ParentObj)
		local stamBonus = math.floor(manaTake * mConversionRate)
		SetCurStamina(self.ParentObj,math.min((curStam + stamBonus),GetMaxStamina(self.ParentObj)))
		SetCurMana(self.ParentObj,math.max((curMana - manaTake),0))
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
}
