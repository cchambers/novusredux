RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		user:SetStatValue("Str", 100)
		user:SetStatValue("Agi", 100)
		user:SetStatValue("Int", 100)
		user:SetStatValue("Con", 100)
		user:SetStatValue("Wis", 100)
		user:SetStatValue("Will", 100)
		user:SetStatValue("Health", 1000)
		user:SetStatValue("Mana", 1000)
		user:SetStatValue("Stamina", 1000)
		AdjustCurVitality(user, 100)
		
		local skillDictionary = {}
		for name,data in pairs(SkillData.AllSkills) do
			skillDictionary[name] = {
				SkillLevel = 100
			}
		end
		SetSkillDictionary(myTarg, skillDictionary)

		user:SystemMessage("Boom, max stats.")
	end
)
