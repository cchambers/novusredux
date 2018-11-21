require 'incl_magic_sys'
require 'incl_combat_abilities'

actionTypeOrder = {
	CombatAbility=1,
	Spell=2,
	SkillAbility=3
}
--incl_player_window
function GetSkillRequirement(userAction)
	if(userAction.Requirements ~= nil and #userAction.Requirements > 0) then		
		for i,requirement in pairs(userAction.Requirements) do
			local name = requirement[1]
			local minValue = requirement[2]

			if(SkillData.AllSkills[name] ~= nil) then        	
	            return name,minValue
			end        
		end
	end

	return "",0
end
function GetPrimaryAbilitiesAction()
	return {
			ID="Primary",
			ActionType="CombatAbility",
			DisplayName="Primary Weapon Ability",
			Icon="primaryability",
			Tooltip="[$1898]",
			Enabled=true,
			ServerCommand="SelectAbility ".."PrimaryAbility".. " ".."Other",
			Requirements = {}
		}	
end

function GetSecondaryAbilitiesAction()
	return {
			ID="Secondary",
			ActionType="CombatAbility",
			DisplayName="Secondary Weapon Ability",
			Icon="secondaryability",
			Tooltip="[$1899]",
			Enabled=true,
			ServerCommand="SelectAbility ".."SecondaryAbility".. " ".."Other",
			Requirements = {}
		}	
end

function GetStanceAbilitiesAction()
	return {
			ID="Stance",
			ActionType="CombatAbility",
			DisplayName="Combat Stance Ability",
			Icon="stanceability",
			Tooltip="[$1900]",
			Enabled=true ,
			ServerCommand="SelectAbility ".."StanceAbility".. " ".."Other",
			-- DAB TODO: THIS IS HACKY
			Requirements = {{"MeleeSkill", 15}}
		}	
end
function MeetsRequirements(userAction)	
	if(userAction.Requirements == nil or #userAction.Requirements == 0) then
		return true
	end

	for i,requirement in pairs(userAction.Requirements) do
		local name = requirement[1]
		local minValue = requirement[2]

		if(name == "Stamina" and GetMaxStamina(this) < minValue) then
			return false
		elseif(name == "Mana" and GetMaxMana(this) < minValue) then
			return false
        elseif(SkillData.AllSkills[name] ~= nil and GetSkillLevel(this,name) < minValue) then        	
            return false
        elseif (IsInTableArray(allStatsTable,name) and this:GetStatValue(StatName) < minValue) then
            return false
        end
	end

	return true
end