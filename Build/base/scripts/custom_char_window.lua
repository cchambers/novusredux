require 'incl_player_names'
--module that attaches that opens the character customization window.
mInitializer = initializer

IndexSelectedFaceType = 1
IndexSelectedSkinTone = 2
IndexSelectedHairType = 3
IndexSelectedFacialHairType = 4
IndexSelectedHairColorType = 5

CustomizationIndexes = {1,1,1,1,1}

FullBody = false
CharIsMale = true

local buttonYInc = 55

function AddCharacterOption(dynWindow, title, eventleft, eventright, data, index, yoffset)
	dynWindow:AddImage(25,306+6+yoffset,"SkillTracker_BG",250,55,"Sliced")
	dynWindow:AddLabel(155,310+10+yoffset, "[F3F781]"..title.."[-]",323,0,23,"center")
	dynWindow:AddButton(35,335-2+yoffset, eventleft,"",0,0,"","",false,"Previous")
	dynWindow:AddLabel(155,335+10+yoffset, data[index].Name,323,0,18,"center")
	dynWindow:AddButton(255,335-2+yoffset, eventright,"",0,0,"","",false,"Next")
	return yoffset + buttonYInc
end

function NextOption(direction, data, currentIndex, equipedType, createType)
	if(direction == "left") then
		CustomizationIndexes[currentIndex] = CustomizationIndexes[currentIndex] - 1--deincrement by one
		if (CustomizationIndexes[currentIndex] < 1) then CustomizationIndexes[currentIndex] = #data end--if less than 1 then set to length
	else
		CustomizationIndexes[currentIndex] = CustomizationIndexes[currentIndex] + 1--deincrement by one
		if (CustomizationIndexes[currentIndex] > #data) then CustomizationIndexes[currentIndex] = 1 end--if over the length set to 1
	end

	if(equipedType ~= "") then
		local currentEquipped = this:GetEquippedObject(equipedType)

		if (currentEquipped ~= nil) then
			currentEquipped:Destroy()
		end
	
		if (data[CustomizationIndexes[currentIndex]].Template ~= nil) then
			CreateEquippedObj(data[CustomizationIndexes[currentIndex]].Template, this, createType)--set the equipped object to the template in the index
		end
	end
	
	OpenCharacterWindow()
end

function OpenCharacterWindow()
	if (IsMale(this)) then
		GenderBodyTable = CharacterCustomization.FaceTypesMale
		GenderHairTable = CharacterCustomization.HairTypesMale
	end
	if (IsFemale(this)) then
		GenderBodyTable = CharacterCustomization.FaceTypesFemale
		GenderHairTable = CharacterCustomization.HairTypesFemale
		CharIsMale = false
	end

	local windowHeight = 722
	local backgroundHeight = 346
	if(CharIsMale == false) then
		windowHeight = 661
		backgroundHeight = 285
	end

	local windowYOffset = (windowHeight / 2)

	if (GenderHairTable == nil or GenderBodyTable == nil) then
		DebugMessage("[custom_char_window|charCustomWindow] ERROR: Player has unsupported gender/body type.")
		return
	end

	local dynWindow = DynamicWindow("charCustomWindow","Appearance",320,windowHeight,-160,-windowYOffset,"Default","Center")

	if (FullBody == false) then
		dynWindow:AddImage(27-5,25-5+13,"SkillTracker_BG",255,255,"Sliced")
		dynWindow:AddPortrait(27,25+13,245,245,this,"head",false)		
		dynWindow:AddButton(61, 0, "FullBody", "Zoom Out", 180, 20, "Switch to seeing the full body.", "", false,"")
	else
		dynWindow:AddPortrait(60,20,180,270,this,"full",false)	
		dynWindow:AddButton(61, 0, "FullBody", "Zoom In", 180, 20, "Switch to zoom in on your head.", "", false,"")
	end

	dynWindow:AddImage(8,302,"BasicWindow_Panel",284,backgroundHeight,"Sliced")
	 
	local btnYOffset = AddCharacterOption(dynWindow, "Face", "FaceLeft", "FaceRight", GenderBodyTable, CustomizationIndexes[IndexSelectedFaceType], 0)

	btnYOffset = AddCharacterOption(dynWindow, "Skin Tone", "SkinLeft", "SkinRight", CharacterCustomization.SkinToneTypes, CustomizationIndexes[IndexSelectedSkinTone], btnYOffset)

	btnYOffset = AddCharacterOption(dynWindow, "Hair", "HairLeft", "HairRight", GenderHairTable, CustomizationIndexes[IndexSelectedHairType], btnYOffset)

	if(CharIsMale) then
		btnYOffset = AddCharacterOption(dynWindow, "Facial Hair", "FacialHairLeft", "FacialHairRight", CharacterCustomization.FacialHairTypesMale, CustomizationIndexes[IndexSelectedFacialHairType], btnYOffset)
	end
	
	btnYOffset = AddCharacterOption(dynWindow, "Hair Color", "HairColorLeft", "HairColorRight", CharacterCustomization.HairColorTypes, CustomizationIndexes[IndexSelectedHairColorType], btnYOffset)
	
	dynWindow:AddButton(61, btnYOffset + 326, "ChangeApperance", "Accept", 180, 30, "Change the apperance of your character.", "", true,"")
			
	this:OpenDynamicWindow(dynWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse, "charCustomWindow",
	function (user,buttonId)

		if (IsMale(this)) then
			GenderBodyTable = CharacterCustomization.FaceTypesMale
			GenderHairTable = CharacterCustomization.HairTypesMale
		end
		if (IsFemale(this)) then
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
		elseif (buttonId == "ChangeApperance" or buttonId == "") then
			--just close the window
			this:CloseDynamicWindow("charCustomWindow")
			this:DelModule("custom_char_window")
			this:SendMessage("ClosedCustomCharWindow")
		end
	end)

function UpdateSkinTone()
	this:SetHue(CharacterCustomization.SkinToneTypes[CustomizationIndexes[IndexSelectedSkinTone]].Hue)
end

function UpdateHairColor()
	local currentEquipped = this:GetEquippedObject("BodyPartHair")
	if(currentEquipped) then
		currentEquipped:SetHue(CharacterCustomization.HairColorTypes[CustomizationIndexes[IndexSelectedHairColorType]].Hue)
	end

	currentEquipped = this:GetEquippedObject("BodyPartFacialHair")
	if(currentEquipped) then
		currentEquipped:SetHue(CharacterCustomization.HairColorTypes[CustomizationIndexes[IndexSelectedHairColorType]].Hue)		
	end
end

RegisterEventHandler(EventType.CreatedObject,"created_hair",
	function(user)
		UpdateHairColor()
	end)

RegisterEventHandler(EventType.ModuleAttached,"custom_char_window",
function()	
	OpenCharacterWindow()
end)

RegisterEventHandler(EventType.StartMoving, "" , 
	function ()
		this:CloseDynamicWindow("charCustomWindow")
		this:DelModule(GetCurrentModule())
		this:SendMessage("ClosedCustomCharWindow")
	end)