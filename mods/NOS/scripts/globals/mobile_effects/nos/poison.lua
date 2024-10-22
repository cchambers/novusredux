MobileEffectLibrary.Poison = 
{
	--PersistSession = true, TODO: integrate persistence for pulse effects

	Debuff = true,

	-- Can this be resisted by Willpower?
	Resistable = true,

	OnEnterState = function(self,root,caster,args)
		self.Caster = caster
		self.PulseFrequency = args.PulseFrequency or self.PulseFrequency
		self.PulseMax = args.PulseMax or self.PulseMax
		self.MinDamage = args.MinDamage or self.MinDamage
		self.MaxDamage = args.MaxDamage or self.MaxDamage
		self.PoisonLevel = args.PoisonLevel or 1

		-- CONFIGURE DAMAGE --
		if (self.PoisonLevel > 1) then
			self.MinDamage = self.MinDamage * self.PoisonLevel
			self.MaxDamage = self.MaxDamage * self.PoisonLevel
		end
		
		-- KHI TODO: POISON NEEDS TO BE ON A TIMER INSTEAD OF A PULSE, BUT SHOULD TICK FOR PULSES --

		local resistance = GetSkillLevel(self.ParentObj, "PoisoningSkill")
		resistance = (100 - (resistance * 0.2)) * 0.01
		self.MaxDamage = self.MaxDamage * resistance

		SetMobileMod(self.ParentObj, "HealingReceivedTimes", "Poison", -0.50)
		if ( self.ParentObj:IsPlayer() ) then
			AddBuffIcon(self.ParentObj, "PoisonDebuff", "Poisoned", "Poison Cloud", self.MinDamage.."-"..self.MaxDamage.." damage every "..self.PulseFrequency.Seconds.." seconds." .. "\nReduced healing received.", true)
		end

		self.ParentObj:PlayEffect("PoisonSpellEffect")
		self.ParentObj:PlayEffect("StatusEffectPoison")
		self.ParentObj:PlayObjectSound("event:/magic/void/magic_void_grim_aura",false)

		if ( HasHumanAnimations(self.ParentObj) ) then
			self.ParentObj:PlayAnimation("sunder")
		else
			-- impale is the "heavy attack for mobs"
			self.ParentObj:PlayAnimation("impale")
		end

		-- self.ParentObj:SendMessage("ReducePoisonEffect", args.PoisonLevelReduction)

		RegisterEventHandler(EventType.Message, "ReducePoisonEffect", 
			function (amount)
				self.PoisonLevel = self.PoisonLevel - amount
				if (self.PoisonLevel <= 0) then
					self.ParentObj:SendMessage("EndPoisonEffect")
					self.ParentObj:SystemMessage("You are cured!", "info")
				end
		end)	
		
		AdvanceConflictRelation(caster, self.ParentObj)
	end,

	OnExitState = function(self,root)
		SetMobileMod(self.ParentObj, "HealingReceivedTimes", "Poison", nil)
		if ( self.ParentObj:IsPlayer() ) then
			RemoveBuffIcon(self.ParentObj, "PoisonDebuff")
		end
		
		UnregisterEventHandler("", EventType.Message, "ReducePoisonEffect")
		self.ParentObj:StopEffect("PoisonSpellEffect")
		self.ParentObj:StopEffect("StatusEffectPoison")
	end,

	GetPulseFrequency = function(self,root)
		
		-- local resistance = GetSkillLevel(self.ParentObj, "PoisoningSkill")
		-- resistance = (100 - (resistance * 0.2)) * 0.01
		-- self.MaxDamage = self.MaxDamage * resistance

		-- CONFIGURE FREQUENCY -- 
		if (self.PoisonLevel > 1 and self.PoisonLevel <= 5) then -- if 2-4
			self.PulseFrequency = TimeSpan.FromSeconds(self.PoisonLevel + 1)
		elseif (self.PoisonLevel > 5) then
			self.PulseFrequency = TimeSpan.FromSeconds(self.PoisonLevel - 1)
		end
		return self.PulseFrequency
	end,

	AiPulse = function(self,root)
		local minDamage = self.MinDamage * self.PoisonLevel
		local maxDamage = self.MaxDamage * self.PoisonLevel
		if (self.LastPoisonLevel ~= self.PoisonLevel) then
			self.DoMessages(self, root)
			self.LastPoisonLevel = self.PoisonLevel
		end
		-- self.ParentObj:NpcSpeech(tostring(self.PoisonLevel))
		self.CurrentPulse = self.CurrentPulse + 1
		if ( IsDead(self.ParentObj) or self.CurrentPulse > self.PulseMax ) then
			EndMobileEffect(root)
		else
			self.ParentObj:SendMessage("ProcessMagicDamage", self.Caster, math.random(minDamage, maxDamage))
		end
	end,

	DoMessages = function (self, root) 
		self.ParentObj:SystemMessage(self.PoisonMessageVictim[self.PoisonLevel])
		self.ParentObj:NpcSpeech(tostring("[00FF00]" .. self.PoisonMessageAll[self.PoisonLevel] .. "[-]"))
	end,

	PoisonMessageVictim = {
		"You feel a bit nauseous.",
		"You feel disoriented and nauseous.",
		"You begin to feel pain throughout your body.",
		"You feel extremely weak and are in severe pain.",
		"You are in extreme pain, and require immediate aid.",
	},

	PoisonMessageAll = {
		"*looks ill*",
		"*looks extremely ill*",
		"*stumbles around in pain and confusion*",
		"*is wracked with extreme pain*",
		"*begins to spasm uncontrollably*",
	},

	PulseFrequency = TimeSpan.FromSeconds(2),
	PulseMax = 8,
	CurrentPulse = 0,
	MinDamage = 1,
	MaxDamage = 3,
	PoisonLevel = 1,
	LastPoisonLevel = 0
}