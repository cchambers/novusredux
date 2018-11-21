--[[
	Taunt all npcs around and give an armor boost
]]
MobileEffectLibrary.Heroism = 
{

	OnEnterState = function(self,root,opponent,args)
		self.Duration = args.Duration or self.Duration
		self.Radius = args.Radius or self.Radius
		self.Bonus = args.Bonus or self.Bonus

		AddBuffIcon(self.ParentObj, "HeroismBuff", "Heroism", "Martial Arts 03", "Defense increased by "..self.Bonus..".", true)
        SetMobileMod(self.ParentObj, "DefensePlus", "Heroism", self.Bonus)

		local nearbyMobiles = FindObjects(SearchMobileInRange(self.Radius))
        for i,mobile in pairs (nearbyMobiles) do
        	if ( ValidCombatTarget(mobile, self.ParentObj, true) ) then
        		mobile:SendMessage("AddThreat", self.ParentObj, 10)
        		mobile:SendMessage("AttackEnemy", self.ParentObj, true)
        	end
        end

        self.ParentObj:PlayEffect("ShoutEffect")
		self.ParentObj:PlayObjectSound("Charge")
		self.ParentObj:PlayAnimation("roar")
	end,

	OnExitState = function(self,root)
        SetMobileMod(self.ParentObj, "DefensePlus", "Heroism", nil)
		RemoveBuffIcon(self.ParentObj, "HeroismBuff")
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),
	Radius = 1,
	Bonus = 0
}