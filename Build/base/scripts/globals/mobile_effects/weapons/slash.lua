MobileEffectLibrary.Slash = 
{

	OnEnterState = function(self,root,target,args)
		-- set args
		self.AttackModifier = args.AttackModifier or self.AttackModifier
		
		-- TRAILER BUILD
		CallFunctionDelayed(TimeSpan.FromSeconds(0.1),function ( ... )			
			if(HasHumanAnimations(self.ParentObj)) then
				self.ParentObj:PlayAnimation("attack_jump")
				if (IsMale(self.ParentObj)) then
					self.ParentObj:PlayObjectSound("event:/character/human_male/human_male_attack")
				else
					self.ParentObj:PlayObjectSound("event:/character/human_female/human_female_attack")
				end
			else
				-- impale is the "heavy attack for mobs"
				self.ParentObj:PlayAnimation("impale")
			end
		end)

		target:PlayEffect("BuffEffect_A")

		-- TRAILER BUILD
		CallFunctionDelayed(TimeSpan.FromSeconds(0.6),function ( ... )			
			SetCombatMod(self.ParentObj, "AttackTimes", "Slash", self.AttackModifier)
			self.ParentObj:SendMessage("ExecuteHitAction", target, "RightHand", false)
			SetCombatMod(self.ParentObj, "AttackTimes", "Slash", nil)
		end)

		EndMobileEffect(root)
	end,

	GetPulseFrequency = nil,
	Range = 1,
}