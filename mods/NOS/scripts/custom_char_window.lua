require 'NOS:incl_player_names'
--module that attaches that opens the character customization window.
mInitializer = initializer

IndexSelectedFaceType = 1
IndexSelectedSkinTone = 2
IndexSelectedHairType = 3
IndexSelectedFacialHairType = 4
IndexSelectedHairColorType = 5

CustomizationIndexes = {1,1,1,1,1}

FullBody = false
CurGender = "Male"
ShowGear = false

local buttonYInc = 55

charTarget = this
editGear = false
gearOption = "Head"
gearHueIndex = 1
gearHues = { {Name="Default", Hue=0},
		     {Name="None", Hue=0},
			 {Name="Iron", Hue=22},
			 {Name="Bronze", Hue=808},
			 {Name="Copper", Hue=667},
			 {Name="Cobalt", Hue = 913},
			 {Name="Steel", Hue = 871},
			 {Name="Spectral", Hue = 947},
			 {Name="Obsidian", Hue = 893},
			 {Name="Cloth", Hue = 139},
			 {Name="Quilted Cloth", Hue = 934},
			 {Name="Silk Cloth", Hue = 872},
		     {Name="Leather", Hue = 800},
			 {Name="Beast Leather", Hue = 893},
			 {Name="Vile Leather", Hue = 941},
			 {Name="Boards", Hue= 775},
			 {Name="Ash Boards",Hue = 866},
			 {Name="Blightwood Boards", Hue = 865 },
			 {Name="Broodwood Boards", Hue = 851 },
			 {Name="Dye: Crimson", Hue = 865 },
			 {Name="Dye: Ice", Hue = 819 },
			 {Name="Dye: Shade", Hue = 893 },
			 {Name="Dye: Vile", Hue = 941 },
			 {Name="Dye: Blaze", Hue = 826 },
			 {Name="Dye: Trailer Guild", Hue = 940 }  }
saveTemplateCategory = "mobiles"
saveTemplateName = ""

function GetTemplatesForSlot(slot)
	local results = {"None"}
	for i,templateName in pairs(GetAllTemplateNames("equipment")) do
		local equipSlot = GetTemplateObjectProperty(templateName,"EquipSlot")
		if(equipSlot == slot) then
			table.insert(results,templateName)
		end
	end

	return results
end

function AddCharacterOption(dynWindow, title, eventleft, eventright, data, index, yoffset)
	dynWindow:AddImage(25,306+6+yoffset,"SkillTracker_BG",250,55,"Sliced")
	dynWindow:AddLabel(150,310+10+yoffset, "[F3F781]"..title.."[-]",323,0,23,"center")
	dynWindow:AddButton(35,335-2+yoffset, eventleft,"",0,0,"","",false,"Previous")
	dynWindow:AddLabel(150,335+10+yoffset, data[index].Name,323,0,18,"center")
	dynWindow:AddButton(255,335-2+yoffset, eventright,"",0,0,"","",false,"Next")
	return yoffset + buttonYInc
end

function NextOption(direction, data, currentIndex, equipedType, createType)
	if(direction == "left") then
		CustomizationIndexes[currentIndex] = CustomizationIndexes[currentIndex] - 1--deincrement by one
		if (CustomizationIndexes[currentIndex] < 1) then CustomizationIndexes[currentIndex] = #data end--if less than 1 then set to length
	elseif(direction == "right") then
		CustomizationIndexes[currentIndex] = CustomizationIndexes[currentIndex] + 1--deincrement by one
		if (CustomizationIndexes[currentIndex] > #data) then CustomizationIndexes[currentIndex] = 1 end--if over the length set to 1
	end

	if(equipedType ~= "") then
		local currentEquipped = charTarget:GetEquippedObject(equipedType)

		if (currentEquipped ~= nil) then
			currentEquipped:Destroy()
		end
	
		if (data[CustomizationIndexes[currentIndex]].Template ~= nil) then
			CreateEquippedObj(data[CustomizationIndexes[currentIndex]].Template, charTarget, createType)--set the equipped object to the template in the index
		end
	end
	
	OpenCharacterWindow()
end

function OpenCharacterWindow()
	if (IsMale(charTarget)) then
		GenderBodyTable = CharacterCustomization.FaceTypesMale
		GenderHairTable = CharacterCustomization.HairTypesMale
		CurGender = "Male"
	end
	if (IsFemale(charTarget)) then
		GenderBodyTable = CharacterCustomization.FaceTypesFemale
		GenderHairTable = CharacterCustomization.HairTypesFemale
		CurGender = "Female"
	end

	local windowHeight = 762
	local backgroundHeight = 396
	if(CurGender == "Female") then
		windowHeight = 701
		backgroundHeight = 335
	end

	local windowYOffset = (windowHeight / 2)

	if (GenderHairTable == nil or GenderBodyTable == nil) then
		DebugMessage("[custom_char_window|charCustomWindow] ERROR: Player has unsupported gender/body type.")
		return
	end

	local windowWidth = 320
	if(editGear) then
		windowWidth = 640
	end
	local dynWindow = DynamicWindow("charCustomWindow","Appearance",windowWidth,windowHeight,-160,-windowYOffset,"Default","Center")

	if (FullBody == false) then
		dynWindow:AddImage(27-5,13,"SkillTracker_BG",255,255,"Sliced")
		dynWindow:AddPortrait(27,18,245,245,charTarget,"head",false)		
		dynWindow:AddButton(61, 276, "FullBody", "Zoom Out", 180, 22, "Switch to seeing the full body.", "", false,"")
	else
		dynWindow:AddPortrait(60,0,180,270,charTarget,"full",ShowGear)	
		dynWindow:AddButton(61, 276, "FullBody", "Zoom In", 180, 22, "Switch to zoom in on your head.", "", false,"")
	end

	dynWindow:AddImage(8,308,"BasicWindow_Panel",284,backgroundHeight,"Sliced")

	dynWindow:AddButton(70, 312, "Gender|Male", "", 51, 60, "Male", "", false,"MaleButton",GetButtonState(CurGender,"Male"))
	dynWindow:AddButton(180, 312, "Gender|Female", "", 51, 60, "Female", "", false,"FemaleButton",GetButtonState(CurGender,"Female"))
	 
	local btnYOffset = AddCharacterOption(dynWindow, "Face", "FaceLeft", "FaceRight", GenderBodyTable, CustomizationIndexes[IndexSelectedFaceType], 56)

	btnYOffset = AddCharacterOption(dynWindow, "Skin Tone", "SkinLeft", "SkinRight", CharacterCustomization.SkinToneTypes, CustomizationIndexes[IndexSelectedSkinTone], btnYOffset)

	btnYOffset = AddCharacterOption(dynWindow, "Hair", "HairLeft", "HairRight", GenderHairTable, CustomizationIndexes[IndexSelectedHairType], btnYOffset)

	if(CurGender == "Male") then
		btnYOffset = AddCharacterOption(dynWindow, "Facial Hair", "FacialHairLeft", "FacialHairRight", CharacterCustomization.FacialHairTypesMale, CustomizationIndexes[IndexSelectedFacialHairType], btnYOffset)
	end
	
	btnYOffset = AddCharacterOption(dynWindow, "Hair Color", "HairColorLeft", "HairColorRight", CharacterCustomization.HairColorTypes, CustomizationIndexes[IndexSelectedHairColorType], btnYOffset)
	
	dynWindow:AddButton(61, btnYOffset + 326, "ChangeApperance", "Accept", 180, 30, "Change the apperance of your character.", "", true,"")
			
	if(editGear) then
		dynWindow:AddButton(320, 10, "Gear|Head", "Head", 0, 23, "", "", false,"Selection",GetButtonState(gearOption,"Head"))
		dynWindow:AddButton(420, 10, "Gear|Chest", "Chest", 0, 23, "", "", false,"Selection",GetButtonState(gearOption,"Chest"))
		dynWindow:AddButton(520, 10, "Gear|Legs", "Legs", 0, 23, "", "", false,"Selection",GetButtonState(gearOption,"Legs"))
		dynWindow:AddButton(320, 40, "Gear|RightHand", "R Hand", 0, 23, "", "", false,"Selection",GetButtonState(gearOption,"RightHand"))
		dynWindow:AddButton(420, 40, "Gear|LeftHand", "L Hand", 0, 23, "", "", false,"Selection",GetButtonState(gearOption,"LeftHand"))
		dynWindow:AddButton(520, 40, "Gear|Cloak", "Cloak", 0, 23, "", "", false,"Selection",GetButtonState(gearOption,"Cloak"))

		if(gearOption) then
			local scrollWindow = ScrollWindow(320,80,280,207,23)
			for i,templateName in pairs(GetTemplatesForSlot(gearOption)) do 
				local scrollElement = ScrollElement()
				scrollElement:AddButton(0, 0, "GearTemplate|"..templateName, templateName, 270, 23, "", "", false,"List")
				scrollWindow:Add(scrollElement)
			end

			dynWindow:AddScrollWindow(scrollWindow)
		end

		if(gearHueIndex) then
			local scrollWindow = ScrollWindow(320,300,280,207,23)
			for i,hueData in pairs(gearHues) do 
				local scrollElement = ScrollElement()
				scrollElement:AddButton(0, 0, "GearHue|"..i, hueData.Name, 270, 23, "", "", false,"List")
				scrollWindow:Add(scrollElement)
			end

			dynWindow:AddScrollWindow(scrollWindow)
		end
		local xoffset = 305
		local yoffset = 220

		dynWindow:AddTextField(320, 540, 270,23, "category", saveTemplateCategory)
		dynWindow:AddTextField(320, 570, 270,23, "name", saveTemplateName)
		dynWindow:AddButton(320, 600, "SaveTemplate", "Save Template", 280, 23, "", "", false)
	end

	this:OpenDynamicWindow(dynWindow)
end

function ChangeGender(newGender)
	CurGender = newGender

	CustomizationIndexes[IndexSelectedFaceType] = 1
	CustomizationIndexes[IndexSelectedSkinTone] = 1
	CustomizationIndexes[IndexSelectedHairType] = 1
	CustomizationIndexes[IndexSelectedFacialHairType] = 1
	CustomizationIndexes[IndexSelectedHairColorType] = 1

	if(newGender == "Male") then
		this:SetAppearanceFromTemplate("playertemplate_male")
		GenderFaceTable = CharacterCustomization.FaceTypesMale
		GenderHairTable = CharacterCustomization.HairTypesMale
	else
		this:SetAppearanceFromTemplate("playertemplate_female")
		GenderFaceTable = CharacterCustomization.FaceTypesFemale
		GenderHairTable = CharacterCustomization.HairTypesFemale
	end

	-- reset body and hair
	NextOption("", GenderFaceTable, IndexSelectedFaceType, "BodyPartHead", "created_body_type")
	NextOption("", GenderHairTable, IndexSelectedHairType, "BodyPartHair", "created_hair")
	if(newGender == "Male") then
		NextOption("", CharacterCustomization.FacialHairTypesMale, IndexSelectedFacialHairType, "BodyPartFacialHair", "created_hair")
	else
		local currentEquipped = this:GetEquippedObject("BodyPartFacialHair")
		if (currentEquipped ~= nil) then
			currentEquipped:Destroy()
		end
	end
end

RegisterEventHandler(EventType.DynamicWindowResponse, "charCustomWindow",
	function (user,buttonId,textFields)

		if (IsMale(charTarget)) then
			GenderBodyTable = CharacterCustomization.FaceTypesMale
			GenderHairTable = CharacterCustomization.HairTypesMale
		end
		if (IsFemale(charTarget)) then
			GenderBodyTable = CharacterCustomization.FaceTypesFemale
			GenderHairTable = CharacterCustomization.HairTypesFemale
		end

		if (GenderHairTable == nil or GenderBodyTable == nil) then
			DebugMessage("[custom_char_window|charCustomWindow] ERROR: Player has unsupported gender/body type.")
			return
		end

		if (buttonId == "FullBody") then
			FullBody = not FullBody
			OpenCharacterWindow()
		end
		if (buttonId == "FaceLeft") then
			NextOption("left", GenderBodyTable, IndexSelectedFaceType, "BodyPartHead", "created_body_type")
		elseif (buttonId == "FaceRight") then
			NextOption("right", GenderBodyTable, IndexSelectedFaceType, "BodyPartHead", "created_body_type")
		elseif (buttonId == "SkinLeft") then
			NextOption("left", CharacterCustomization.SkinToneTypes, IndexSelectedSkinTone, "", "")
			UpdateSkinTone()
		elseif (buttonId == "SkinRight") then
			NextOption("right", CharacterCustomization.SkinToneTypes, IndexSelectedSkinTone, "", "")
			UpdateSkinTone()
		elseif (buttonId == "FacialHairLeft") then
			NextOption("left", CharacterCustomization.FacialHairTypesMale, IndexSelectedFacialHairType, "BodyPartFacialHair", "created_hair")
		elseif (buttonId == "FacialHairRight") then
			NextOption("right", CharacterCustomization.FacialHairTypesMale, IndexSelectedFacialHairType, "BodyPartFacialHair", "created_hair")
		elseif (buttonId == "HairLeft") then
			NextOption("left", GenderHairTable, IndexSelectedHairType, "BodyPartHair", "created_hair")
		elseif (buttonId == "HairRight") then
			NextOption("right", GenderHairTable, IndexSelectedHairType, "BodyPartHair", "created_hair")
		elseif (buttonId == "HairColorLeft") then
			NextOption("left", CharacterCustomization.HairColorTypes, IndexSelectedHairColorType, "", "")
			UpdateHairColor()
		elseif (buttonId == "HairColorRight") then
			NextOption("right", CharacterCustomization.HairColorTypes, IndexSelectedHairColorType, "", "")
			UpdateHairColor()		
		elseif(buttonId == "SaveTemplate") then
			SaveNpcToTemplate(charTarget,textFields.category,textFields.name)
		elseif (buttonId == "ChangeApperance" or buttonId == "") then
			--just close the window
			this:CloseDynamicWindow("charCustomWindow")
			this:DelModule("custom_char_window")
			local wasCommit = (buttonId == "ChangeApperance")
			this:SendMessage("ClosedCustomCharWindow",wasCommit)
		else
			local command,arg = string.match(buttonId, "(%a+)|(.+)")
			if(command == "Gear") then
				gearOption = arg
				OpenCharacterWindow()				
			elseif(command == "GearTemplate") then
				local currentEquipped = charTarget:GetEquippedObject(gearOption)
				if(currentEquipped) then
					currentEquipped:Destroy()
				end
				if(arg ~= "None") then
					CreateEquippedObj(arg, charTarget, "gear_created")--set the equipped object to the template in the index
				end
			elseif(command == "GearHue") then
				gearHueIndex = tonumber(arg)
				local currentEquipped = charTarget:GetEquippedObject(gearOption)
				if(currentEquipped) then
					local hue = gearHues[gearHueIndex].Hue
					if(gearHues[gearHueIndex].Name == "Default") then						
						local templateData = GetTemplateData(currentEquipped:GetCreationTemplateId())
						hue = templateData.Hue
					end

					currentEquipped:SetHue(hue)
				end
			elseif(command == "Gender") then	
    			if(arg ~= CurGender) then
	    			ChangeGender(arg)
    				OpenCharacterWindow()
    			end
			end
		end
	end)

-- DAB NOTE: This only updates the gear / appearance of an existing human template. Needs much more expanding to be used more generally
function SaveNpcToTemplate(targetObj,category,name)
	local templateData = GetTemplateData(targetObj:GetCreationTemplateId())
	if(templateData) then
		saveSlots = {
			"BodyPartHead",
			"BodyPartHair",
			"Head",
			"Chest",
			"Legs",
			"RightHand",
			"LeftHand",
			"Cloak",
			"Familiar",
		}

		local aiModuleName = GetAIModuleName(targetObj)
		if(aiModuleName) then
			if not(templateData.LuaModules[aiModuleName].EquipTable) then
				templateData.LuaModules[aiModuleName].EquipTable = {}
			end
			local equipTable = templateData.LuaModules[aiModuleName].EquipTable
			for i,slotName in pairs(saveSlots) do
				local equipObj = targetObj:GetEquippedObject(slotName)
				if(equipObj) then
					equipTable[slotName] = { { equipObj:GetCreationTemplateId(), equipObj:GetHue() } }
				else
					equipTable[slotName] = nil 
				end
			end

			SaveTemplateData(templateData,category,name)
		else
			this:SystemMessage("Target requires an AI module","info")
		end
	end
end

function UpdateSkinTone()
	charTarget:SetHue(CharacterCustomization.SkinToneTypes[CustomizationIndexes[IndexSelectedSkinTone]].Hue)
end

function UpdateHairColor()
	local currentEquipped = charTarget:GetEquippedObject("BodyPartHair")
	if(currentEquipped) then
		currentEquipped:SetHue(CharacterCustomization.HairColorTypes[CustomizationIndexes[IndexSelectedHairColorType]].Hue)
	end

	currentEquipped = charTarget:GetEquippedObject("BodyPartFacialHair")
	if(currentEquipped) then
		currentEquipped:SetHue(CharacterCustomization.HairColorTypes[CustomizationIndexes[IndexSelectedHairColorType]].Hue)		
	end
end

RegisterEventHandler(EventType.CreatedObject,"created_hair",
	function(user)
		UpdateHairColor()
	end)

RegisterEventHandler(EventType.CreatedObject,"gear_created",
	function(success,objRef)
		local hue = gearHues[gearHueIndex].Hue
		if(gearHues[gearHueIndex].Name == "Default") then						
			local templateData = GetTemplateData(objRef:GetCreationTemplateId())
			hue = templateData.Hue
		end

		objRef:SetHue(hue)
	end)

RegisterEventHandler(EventType.ModuleAttached,"custom_char_window",
	function()	
		if(initializer) then
			charTarget = initializer.Target or this
			editGear = initializer.EditGear
			if(editGear) then
				FullBody = true
				ShowGear = true
			end
			saveTemplateName = charTarget:GetCreationTemplateId()
		end
		OpenCharacterWindow()
	end)

RegisterEventHandler(EventType.StartMoving, "" , 
	function ()
		this:CloseDynamicWindow("charCustomWindow")
		this:DelModule(GetCurrentModule())
		this:SendMessage("ClosedCustomCharWindow")
	end)

RegisterEventHandler(EventType.Message,"OpenCustomCharWindow",
	function ( ... )
		OpenCharacterWindow()
	end)