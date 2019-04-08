MobileEffectLibrary.Taunt = {
	Quotes = {
		"You are impossible to underestimate.",
		"Who wants to die?",
		"F@#K YOUR COUCH!",
		"You look like I need a drink!",
		"I just won the lottery. My prize? I never get to see your face again.",
	},

	ActualEnemies = function (self) 
		local enemyObjects = FindObjects(SearchMobileInRange(20))
		local actualEnemies = {}
		if (enemyObjects ~= nil) then
			for i,enemyObj in pairs(enemyObjects) do
				if (not(IsPlayerCharacter(enemyObj))) then
					self.Count = self.Count + 1
					table.insert(actualEnemies,enemyObj)
				end
			end
		end
		return actualEnemies
	end,

	OnEnterState = function(self, root, caster)
		local enemies = self.ActualEnemies(self)
		for i,enemyObj in pairs(enemies) do
			enemyObj:SendMessage("StartMobileEffect", "BeingTaunted", self.ParentObj)
		end

		if (self.Count == 0) then
			self.ParentObj:SystemMessage("There is nothing here you can taunt.", "info")
			EndMobileEffect(root)
			return
		end

		if (self.Count > 3) then
			self.ParentObj:NpcSpeech(self.Quotes[math.random(1,#self.Quotes)])
		end

		self.ParentObj:PlayAnimation("block")
		self.ParentObj:PlayEffectWithArgs("LaughingSkullEffect", 20, "Bone=Head")
	end,

	OnExitState = function(self, root)

	end,

	GetPulseFrequency = function(self, root)
		return self.Duration
	end,
	
	AiPulse = function(self, root)
		EndMobileEffect(root)
	end,

	Count = 0,
	Caster = nil,
	Duration = TimeSpan.FromSeconds(2)
}
