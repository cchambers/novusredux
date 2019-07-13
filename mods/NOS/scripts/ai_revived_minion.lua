require 'NOS:ai_follower'

REVIVED_LIFETIME = 30

REVIVED_MINION_TEMPLATE = "revived_minion"
RegisterEventHandler(EventType.ModuleAttached,"ai_revived_minion",function ( ... )
	for i,moduleName in pairs(this:GetAllModules()) do
		if (moduleName ~= "combat" and moduleName ~= "ai_revived_minion") then
			this:DelModule(moduleName)
			--DebugMessage("detaching "..tostring(moduleName))
		end
	end
	this:SendMessage("EndCombatMessage")
	this:PlayEffect("VoidAuraEffect",30)
			--Delete all the old AIs from the object
	this:AddModule("slay_decay")
	this:SetObjVar("SlayDecayTime",REVIVED_LIFETIME)
	local isCreationTemplate = template == nil
	local statTable = GetInitializerFromTemplate(REVIVED_MINION_TEMPLATE,"ai_revived_minion")
	local template = template or this:GetCreationTemplateId()

	-- begin with base stats
	local initialStats = statTable.Stats or { Str=40, Agi=40, Int=40, Wis=40, Will=40, Con=40 }
	SetStr(this,initialStats.Str)
	SetAgi(this,initialStats.Agi)
	SetInt(this,initialStats.Int)	
	SetCon(this,initialStats.Con)
	SetWis(this,initialStats.Wis)
	SetWill(this,initialStats.Will)	
	SetCurHealth(this,GetMaxHealth(this))
	SetCurMana(this,GetMaxMana(this))
	SetCurStamina(this,GetMaxStamina(this))

	-- set skills
	if( statTable.Skills ~= nil ) then
		for name, value in pairs(statTable.Skills) do
			this:SendMessage("SetSkillLevel",this, name .. "Skill", value, false)
		end
	end
	this:SendMessage("EquipMobile",statTable.EquipTable, statTable.LootTables,true)
	-- dynamic combat abilities
	if(statTable.CombatAbilities ~= nil) then
		SetInitializerCombatAbilities(this, statTable.CombatAbilities)
	end
	-- dynamic weapon abilities
	if ( statTable.WeaponAbilities ~= nil ) then
		this:SetObjVar("WeaponAbilities", statTable.WeaponAbilities)
	end
	
			-- update our name
	this:SetName("Reanimated "..this:GetName().." Corpse")
	this:SendMessage("UpdateName")
	this:SetColor("0xFF2F2F2F")
	this:DelObjVar("StatMods")
	this:SetObjVar("ControllingSkill","NecromancySkill")
	this:SetMobileType("Friendly")
	this:SetObjVar("BaseHealth",120)
	this:SendMessage("RecalculateStats")
	this:SetObjVar("NaturalArmor","Medium")
	this:SetObjVar("AI-CanFlee",false)
	this:SetObjVar("AI-CanUseCombatAbilities",true)
	this:SetObjVar("HasSkillCap",true)
	this:SetObjVar("OnlyEquipWeapons",true)
	this:SetObjVar("AutoUnstable",true)
	this:SetObjVar("DoesNotBleed",true)
	this:SetObjVar("EquipmentDamageOnDeathMultiplier",1.2)
end)

