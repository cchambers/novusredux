-- This script was written to allow you to view every armor set in game. Unfortunately it still has some bugs with automatically matching up armor sets

suits = {}
misc = {}
weapons = {}
tools = {}
uniqueClientIds = {}

function CreateAllSuits(playerObj)
	local startLoc = playerObj
	local xInc = 1

	local weaponIndex = 1
	local curLoc = playerObj:GetLoc()
	for suitName,suit in pairs(suits) do
		local templateData = GetTemplateData("npc_blank")
		templateData.Name = "Suit : " .. suitName
		suit.RightHand = { weapons[weaponIndex] }
		templateData.LuaModules.base_mobile_advanced = {
			EquipTable = suit,			
		}

		CreateCustomTempObj("Suit : " .. suitName,templateData,curLoc)
		curLoc = Loc(curLoc.X + xInc, 0, curLoc.Z)
		weaponIndex = weaponIndex + 1
	end

	curLoc = playerObj:GetLoc()
	for miscName,miscItem in pairs(misc) do
		local templateData = GetTemplateData("npc_blank")
		templateData.Name = "Misc : " .. miscName
		if(weaponIndex < #weapons) then
			suit.RightHand = { weapons[weaponIndex] }
		end
		templateData.LuaModules.base_mobile_advanced = {
			EquipTable = miscItem,			
		}

		CreateCustomTempObj("Misc : " .. miscName,templateData,curLoc)
		curLoc = Loc(curLoc.X + xInc, 0, playerObj:GetLoc().Z + 2)
		weaponIndex = weaponIndex + 1
	end
end

function BuildSuit(category,templateName)
	local parts = StringSplit(templateName,"_")
	if(category == "armor" or category == "clothing") then
		table.remove(parts,1)
	end

	-- do this piece
	local objectType = GetTemplateIconId(templateName)
	local slot = GetTemplateObjectProperty(templateName,"EquipSlot")

	local slots = { }
	slots[slot] = { templateName }
	--DebugMessage("FIRST: "..slot)

	local identifier = templateName

	-- find the other parts of the suit
	for i,subTemplateName in pairs(GetAllTemplateNames("equipment")) do
		local subObjectType = GetTemplateIconId(subTemplateName)
		local subSlot = GetTemplateObjectProperty(subTemplateName,"EquipSlot")
		--DebugMessage("TESTING: "..tostring(subTemplateName).." : " .. tostring(subSlot).." IS "..tostring(slots[subSlot]))
		if IsArmorSlot(subSlot) and not(uniqueClientIds[subObjectType]) and not(slots[subSlot]) and (subTemplateName:match("armor") or subTemplateName:match("clothing")) then
			local subParts = StringSplit(subTemplateName,"_")
			table.remove(subParts,1)

			for i,partName in pairs(parts) do
				for i, subPartName in pairs(subParts) do
					if(partName == subPartName) then	
						--DebugMessage("MATCH "..partName)					
						slots[subSlot] = { subTemplateName }
						identifier = subPartName
						uniqueClientIds[subObjectType] = true
					end
				end			
			end
		end
	end

	suits[identifier] = slots
end

function LoadSuits()
	for i,templateName in pairs(GetAllTemplateNames("equipment")) do
		local objectType = GetTemplateIconId(templateName)
		if curSuit == nil and not(uniqueClientIds[objectType]) then
			uniqueClientIds[objectType] = true
			
			if(templateName:match("armor")) then
				BuildSuit("armor",templateName)
			elseif(templateName:match("clothing")) then
				BuildSuit("clothing",templateName)
			elseif(templateName:match("weapon")) then
				table.insert(weapons,templateName)
			elseif(templateName:match("tool")) then
				table.insert(tools,templateName)
			else
				local slot = GetTemplateObjectProperty(templateName,"EquipSlot")
				if(slot == "RightHand") then					
					table.insert(weapons,templateName)
				elseif(slot ~= nil and IsArmorSlot(slot)) then
					misc[templateName] = {slot={templateName}}
				end
			end
		end
	end

	local index = 1
	for suitName,suit in pairs(suits) do
		DebugMessage("Suit"..index..": "..suitName..": \n"..DumpTable(suit))
		index = index + 1
	end

	index = 1
	for i,weaponName in pairs(weapons) do 
		DebugMessage("Weapon"..index..": "..weaponName)
		index = index + 1
	end
end
LoadSuits()