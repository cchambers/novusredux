


enhancementTable = {
			Hone = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_hone",
				EnhancementItemClass = { WeaponClass = true},
				EnhancementItemSubClass = { BladedEquipment = true},
				EnhancementDescription = "",
				EnhancementDisplayEffect = "[$1855]",
				EnhancementSpace= 1,
				EnhancementMaxInstances = 3,
				SkillRequired = { 
					MetalsmithSkill = 10,
				},
				SkillGainPerInstance = {
					MetalsmithSkill = 5,
				},
				

				EnhancementSlot = { WeaponHeadSlot = true},
				ResourcesRequired = {
					WormExtract = 4,
				},
			},

			Balance = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_balance",
				EnhancementItemClass = { WeaponClass = true},
				EnhancementDescription = "",
				EnhancementSpace= 1,
				EnhancementDisplayEffect = "[$1856]",
				EnhancementMaxInstances = 2,
				EnhancementSlot = { WeaponHeadSlot = true},
				ResourcesRequired = {
					Feather = 5,
				},
			},


			Padding = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_padding",
				EnhancementItemClass = { ArmorClass = true},
				EnhancementDescription = "",
				EnhancementDisplayEffect = "[$1857]",
				EnhancementSpace= 2,
				EnhancementMaxInstances = 2,
				ResourcesRequired = {
					RatEar = 5,
				},
			},

			Plating = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_plating",
				EnhancementItemClass = { ArmorClass = true},
				EnhancementDescription = "",
				EnhancementDisplayEffect = "[$1858]",
				EnhancementSpace= 2,
				EnhancementMaxInstances = 2,
				ResourcesRequired = {
					AncientBearFang = 2,
				},
			},
			Reinforcement = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_reinforcement",
				EnhancementItemClass = { ArmorClass = true},
				EnhancementDescription = "",
				EnhancementDisplayEffect = "[$1859]",
				EnhancementSpace= 2,
				EnhancementMaxInstances = 2,
				ResourcesRequired = {
					PlagueRatEar = 3,
				},
			},
			Hardening = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_hardening",
				EnhancementItemClass = { ArmorClass = true},
				EnhancementDescription = "",
				EnhancementDisplayEffect = "[$1860]",
				EnhancementSpace= 2,
				EnhancementMaxInstances = 2,
				ResourcesRequired = {
					AncientBearClaw = 2,
				},
			},			
			Fitting = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_fitting",
				EnhancementItemClass = { ArmorClass = true},
				EnhancementDescription = "",
				EnhancementDisplayEffect = "[$1861]",
				EnhancementSpace= 2,
				EnhancementMaxInstances = 2,
				ResourcesRequired = {
					GossamerSilk = 2,
				},
			},

			Serration = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_serration",
				EnhancementItemClass = { WeaponClass = true},
				EnhancementItemSubClass = { BladedEquipment = true},
				EnhancementDescription = "",
				EnhancementDisplayEffect = "[$1862]",
				EnhancementSpace= 2,
				EnhancementMaxInstances = 1,
				EnhancementSlot = { WeaponHeadSlot = true},
				ResourcesRequired = {
					DireWolfFang = 3,
				},
			},

			PoisonVein = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_poisonvein",
				EnhancementItemClass = { 
					WeaponClass = true,
					SpikedEquipment = true,
							},
				EnhancementItemSubClass = { BladedEquipment = true},
				EnhancementDescription = "",
				EnhancementDisplayEffect = "[$1863]",
				EnhancementSpace= 1,
				EnhancementMaxInstances = 1,
				EnhancementSlot = { WeaponHeadSlot = true},
			},

			Weight = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_weight",
				EnhancementItemClass = { WeaponClass = true},
				EnhancementDisplayEffect = "[$1864]",
				EnhancementDescription = "",
				EnhancementSpace= 1,
				EnhancementMaxInstances = 2,
				EnhancementSlot = { WeaponHeadSlot = true},
				ResourcesRequired = {
					Stone = 5,
				},
			},

			EnhanceGuard = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_enhanceguard",
				EnhancementItemClass = { WeaponClass = true},
				EnhancementDisplayEffect = "+1% to Parry Chance(weapons)",
				EnhancementDescription = "",
				EnhancementSpace= 1,
				EnhancementMaxInstances = 2,
				EnhancementSlot = { WeaponHandleSlot = true},
				ResourcesRequired = {
					SpiderEye = 5,
				},

			},
			SpikeHandle = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_spikehandle",
				EnhancementItemClass = { WeaponClass = true},
				EnhancementDescription = "",
				EnhancementDisplayEffect = "[$1865]",
				EnhancementSpace= 1,
				EnhancementMaxInstances = 1,
				EnhancementSlot = { WeaponHandleSlot = true},
				ResourcesRequired = {
					WolfFang = 5,
				},
			},

			SpikeHead = {
				EnhancementType = "EnhancementModification",
				EnhancementScript = "en_spikedhead",
				EnhancementItemClass = { WeaponClass = true},
				EnhancementItemSubClass = { BluntEquipment = true},
				EnhancementDescription = "",
				EnhancementDisplayEffect = "+1% to Crit chance (Bashing Weapons)",
				EnhancementSpace= 1,
				EnhancementMaxInstances = 1,
				EnhancementSlot = { WeaponHeadSlot = true},
				ResourcesRequired = {
					BearClaw = 5,
				},
			},

			Animate = {
				EnhancementType = "EnhancementEnchantment",
				EnhancementScript = "en_animate",
				EnhancementItemClass = { ArmorClass = true},
				EnhancementDescription = "",
				EnhancementDisplayEffect = "10% Reduction in Stamina Cost Penalty (Armor)",
				EnhancementSpace= 1,
				EnhancementMaxInstances = 0,
			},


}

function GetEnhancementName(enName)
	--Todo Name enhancements
	local myEnName = enName
	return myEnName
end

function IsValidForItem(targetItem, enhancementName)
	--DebugMessage("Check EN:" .. enhancementName)
	if (targetItem == nil ) then 
		--DebugMessage("Enhance Fail: Nil Item")
		return false 
	end
	
	local itemClass = GetEquipmentClass(targetItem)
	if (itemClass == nil ) then 
		--DebugMessage("Enhance Fail: Nil Item Class")
		return false 
	end
	local enTable = enhancementTable[enhancementName]
	if(enTable == nil) then 
		--DebugMessage("Enhance Fail: Nil Table Return")
		return false 
	end
	
	local classTable = enTable.EnhancementItemClass
	if (classTable == nil) then
	 	--DebugMessage("Enhance Fail: Enhancement Item Class Nil")
		return false 
	end
	

	local specTable = classTable[itemClass]
	if not(specTable == true) then 
		--DebugMessage("Enhance Fail: Invalid Class")
		return false 
	end
	return true
end
function AddEnhancement(targetItem, enhancementName, enhancementTool, enhancementUser)
	--DebugMessage(tostring(targetItem) .. " " .. enhancementName)
	if not(IsValidForItem(targetItem,enhancementName)) then return false end

	local enTable = enhancementTable[enhancementName]
	if(enTable == nil) then 
		--DebugMessage("Enhance Fail: Nil Table Return")
		return false 
	end
	
	local reqSpace = enTable.EnhancementSpace
	if(reqSpace == nil) then 	
		--DebugMessage("Enhance Fail: Invalid Space Requirement")
		return false 
	end
	
	local availSpace = GetAvailableSlots(targetItem)
	if(availSpace == nil) or (availSpace <= 0) or ((availSpace - reqSpace) < 0 ) then 
		enhancementUser:SystemMessage("[$1866]")
		return false
	end
	--DebugMessage(" Space: " .. tostring(availSpace) .. " Required: " ..tostring(reqSpace))
	local enInstances = GetEnhancementInstances(targetItem, enhancementName)

	if not(enInstances < enTable.EnhancementMaxInstances) then
		enhancementUser:SystemMessage("[$1867]")
		return false
	end
		local enhanceScript = enTable.EnhancementScript
		if(enhanceScript == nil) then
		--DebugMessage("Enhance Fail: Nil Script")
		return false 
	end
	local enhanceIngredients = enTable.ResourcesRequired or {}
	if not(IsTableEmpty(enhanceIngredients)) then
		if not(HasResources(enhanceIngredients, enhancementUser)) then
			enhancementUser:SystemMessage("[$1868]")
			return false
		end
		ConsumeResources(enhanceIngredients, enhancementUser, "enhancement_consumption")
	end
	--BBTodo Fix enhancement to apply on consume
	AddEnhancementToDict(targetItem, enhancementName)
	targetItem:AddModule(enhanceScript)		
	targetItem:SendMessage("PerformEnhancementMessage", enhancementName, enhancementUser)
	enhancementUser:SystemMessage("[$1869]")
	return true
end


function GetMaxSlots(targetItem)
	local mySlots = GetBaseNumSlots(targetItem)
	if (mySlots == nil) then return 0 end
	return mySlots
end

function AddEnhancementToDict(targetItem, enName)
	local myEnDict = {}
	local curVal = 0
	if(targetItem:HasObjVar("EnhancementDictObjvar")) then
		myEnDict = targetItem:GetObjVar("EnhancementDictObjvar")
		curVal = myEnDict[enName]
	end
		
	if(curVal == nil) then curVal = 0 end
	curVal = curVal + 1
	myEnDict[enName] = curVal
	targetItem:SetObjVar("EnhancementDictObjvar", myEnDict)
end

function GetAvailableSlots(targetItem)
	local myEnDict = nil
	if(targetItem:HasObjVar("EnhancementDictObjvar")) then
		myEnDict = targetItem:GetObjVar("EnhancementDictObjvar")
	else
		return GetMaxSlots(targetItem)
	end
	local usedSlots = 0
	if(myEnDict ~= nil) then
		for k, v in pairs(myEnDict) do
			usedSlots = usedSlots + v
		end
	end
	if (usedSlots == nil) then return GetMaxSlots(targetItem) end
	local maxSlots = GetMaxSlots(targetItem)
	return maxSlots - usedSlots
end

function GetEnhancementInstances(targetItem, enhancementName)
	local myEnDict = nil
	if(targetItem:HasObjVar("EnhancementDictObjvar")) then
		myEnDict = targetItem:GetObjVar("EnhancementDictObjvar")
	else
		return 0
	end
	 if IsTableEmpty(myEnDict) then return 0 end	 
	 local enInst = 0
	 for k,v in pairs(myEnDict) do 
	 	if(k == enhancementName) then enInst = enInst + 1 end
	 end

	 return enInst
end


function GetEnhancementEffectDescription(enhancementName)
	local myRetTab = enhancementTable[enhancementName]
	if (myRetTab == nil) then return "" end
	local myRet = myRetTab.EnhancementDisplayEffect
	if(myRet == nil) then return "" end
	return myRet
end
