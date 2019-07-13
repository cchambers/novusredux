require 'base_mobile_advanced'
require 'incl_player_names'

--module that attaches that opens the character customization window.
mInitializer = initializer

SelectedFaceType = 1
SelectedSkinToneType = 1
SelectedHairType = 1
SelectedFacialHairType = 1
SelectedHairColorType = 1

SelectedShirtType = 1
SelectedShirtColorType = 1
SelectedPantsType = 1
SelectedPantsColorType = 1

SelectedSkill1 = 1
SelectedSkill2 = 1
SelectedSkill3 = 1
SelectedSkill4 = 1
SelectedSkillLevel1 = 0
SelectedSkillLevel2 = 0
SelectedSkillLevel3 = 0
SelectedSkillLevel4 = 0

SelectedTrade = "Warrior"

AppearanceSubstate = ""
GearSubstate = ""
SkillsSubstate = ""

GenderFaceTable = CharacterCustomization.FaceTypesMale
GenderHairTable = CharacterCustomization.HairTypesMale
UniverseCount = 0
ValidUniverses = nil

AllSkillsTable = nil

AllStartingLocations = {}

-- tells us if this user is here for character creation (false if just selecting starting city)
function IsCreate()
	return not(this:HasObjVar("playerInitialized"))
end

function GetAllSkillsTable()
	if not(AllSkillsTable) then
		AllSkillsTable = {}		
		for skillName, skillData in pairs(SkillData.AllSkills) do
			if (skillData.Skip ~= true and CharacterCustomization.ExcludedStartingSkills[skillData.DisplayName] == nil) then
				table.insert(AllSkillsTable,{Name = skillData.DisplayName or skillName, Type=skillName, Tooltip = skillData.Description})
			end
		end

		table.sort(AllSkillsTable,function(a,b) return a.Name < b.Name end)
		table.insert(AllSkillsTable,1,{Name="None",Type="None"})
	end

	return AllSkillsTable
end

function GetRemainingSkillPoints()
	return ServerSettings.CharacterCreation.StartingSkillCap - (SelectedSkillLevel1 + SelectedSkillLevel2 + SelectedSkillLevel3 + SelectedSkillLevel4)
end

function GetSelectedSkillTypes()
	local selectedSkillTypes = {}
	if(SelectedSkill1 ~= 1) then table.insert(selectedSkillTypes,SelectedSkill1) end
	if(SelectedSkill2 ~= 1) then table.insert(selectedSkillTypes,SelectedSkill2) end
	if(SelectedSkill3 ~= 1) then table.insert(selectedSkillTypes,SelectedSkill3) end
	if(SelectedSkill4 ~= 1) then table.insert(selectedSkillTypes,SelectedSkill4) end

	return selectedSkillTypes
end

function GoState(stateName)
	DebugMessage("GoState: "..stateName)
	this:SetObjVar("CharCreateState",stateName)
	if(stateName == "Appearance") then	
		curGender = "Male"
		GenderFaceTable = CharacterCustomization.FaceTypesMale
		GenderHairTable = CharacterCustomization.HairTypesMale
		if(IsFemale(this)) then
			curGender = "Female"
			GenderFaceTable = CharacterCustomization.FaceTypesFemale
			GenderHairTable = CharacterCustomization.HairTypesFemale
		end	
		OpenApppearanceWindow()
	elseif(stateName == "Gear") then
		OpenStartingGearWindow()
	elseif(stateName == "Trades") then
		OpenStartingTradeWindow()
	elseif(stateName == "Skills") then
		OpenStartingSkillsWindow()
	elseif(stateName == "Universe") then
		if not(ServerSettings.CharacterCreation.ShouldSelectUniverse) then
			OpenSelectCityWindow()
		else
			ValidUniverses = GetUniversesWithMap(ServerSettings.CharacterCreation.StartingMap)
			if(#ValidUniverses == 1) then				
				this:SetObjVar("CharCreateUniverse",ValidUniverses[1])
				GoState("City")
			elseif(#ValidUniverses > 1) then
				curUniverse = nil
				OpenSelectUniverseWindow()
			else
				ClientDialog.Show{
				    TargetUser = this,
				    DialogId = "Error",
				    TitleStr = "Error",
				    Button1Str = "Ok",
				    DescStr = "No available starting location. Please try again later.",
				    ResponseFunc = function (user, buttonId)
				    	this:KickUser("Starting location not found")
					end
				}
			end
		end
	elseif(stateName == "City") then
		OpenSelectCityWindow()
	end
end

function GoBack()
	local curState = this:GetObjVar("CharCreateState")
	-- if not in character creation just log out
	if not(curState) then
		this:KickUser("Logged Out")
	elseif(curState == "Appearance") then
		this:KickUser("Logged Out")
	elseif(curState == "Gear") then
		-- clear out gear
		ChangeToTemplate("playertemplate_blank",{KeepAppearance = true, IgnoreBodyParts = true, LoadAbilities = false, SetStats = false, SetName = false, BuildHotbar = false, LoadLoot=false})
		GoState("Appearance")
	elseif(curState == "Trades") then
		GoState("Gear")
	elseif(curState == "Skills") then
		GoState("Trades")
	elseif(curState == "Universe") then		
		if(IsCreate()) then
			GoState("Skills")
		end
	elseif(curState == "City") then
		this:CloseDynamicWindow("CityWindow")
		if(ValidUniverses and #ValidUniverses > 1) then
			GoState("Universe")
		else
			GoState("Skills")
		end
	end
end

function EnterWorld(curCity)
	local universeName = this:GetObjVar("CharCreateUniverse")
	local destRegionAddress = ServerSettings.CharacterCreation.StartingMap
	if(universeName) then
		destRegionAddress = universeName .. "." .. destRegionAddress
	end

	local cityInfo = AllStartingLocations[curCity]	

	if(cityInfo.Subregion) then
		destRegionAddress = destRegionAddress .. "." ..cityInfo.Subregion
	end

	if( not(IsClusterRegionOnline(destRegionAddress)) ) then 
		ClientDialog.Show{
				    TargetUser = this,
				    DialogId = "Error",
				    TitleStr = "Error",
				    Button1Str = "Ok",
				    DescStr = "There was an error during character creation. Try again later. If this issue persists, contact an admin.",
				    ResponseFunc = function (user, buttonId)
				    	this:KickUser("Login region not found")
					end
				}
	end		

	this:DelObjVar("CharCreateState")
	this:DelObjVar("CharCreateUniverse")
	-- this tells the player script we were created using the login scene
	this:SetObjVar("CharCreateNew",true)

	local clusterController = GetClusterController()
	if ( clusterController ) then
		clusterController:SendMessage("UserLogin",this,"Connect")
	end

	TeleportUser(this,this,MapLocations[ServerSettings.CharacterCreation.StartingMap][cityInfo.MapLocation],destRegionAddress)
end

function UpdateFace()
	local currentEquipped = this:GetEquippedObject("BodyPartHead")
	--DebugMessage("currentEquipped is "..tostring(currentEquipped))
	if (currentEquipped ~= nil) then
		currentEquipped:Destroy()
	end
	--create the new body type
	if (GenderFaceTable[SelectedFaceType].Template ~= nil) then
		CreateEquippedObj(GenderFaceTable[SelectedFaceType].Template, this, "created_body_type")--set the equipped object to the template in the index
		RegisterSingleEventHandler(EventType.CreatedObject,"created_body_type",function() UpdateSkinTone() end)
	end
end

function UpdateHair()
	local currentEquipped = this:GetEquippedObject("BodyPartHair")
	if (currentEquipped ~= nil) then
		currentEquipped:Destroy()
	end
	--create the new hair type
	if (GenderHairTable[SelectedHairType].Template ~= nil) then
		CreateEquippedObj(GenderHairTable[SelectedHairType].Template, this, "created_hair")--set the equipped object to the template in the index
		RegisterSingleEventHandler(EventType.CreatedObject,"created_hair",function() UpdateHairColor() end)
	end
end

function UpdateSkinTone()
	this:SetHue(CharacterCustomization.SkinToneTypes[SelectedSkinToneType].Hue)
end

function UpdateFacialHair()
	local currentEquipped = this:GetEquippedObject("BodyPartFacialHair")
	if (currentEquipped ~= nil) then
		currentEquipped:Destroy()
	end

	if(curGender == "Male" and CharacterCustomization.FacialHairTypesMale[SelectedFacialHairType].Template ~= nil) then
		CreateEquippedObj(CharacterCustomization.FacialHairTypesMale[SelectedFacialHairType].Template, this, "created_facial_hair")--set the equipped object to the template in the index
		RegisterSingleEventHandler(EventType.CreatedObject,"created_facial_hair",function() UpdateHairColor() end)
	end
end

function UpdateHairColor()
	local currentEquipped = this:GetEquippedObject("BodyPartHair")
	if(currentEquipped) then
		currentEquipped:SetHue(CharacterCustomization.HairColorTypes[SelectedHairColorType].Hue)
	end

	currentEquipped = this:GetEquippedObject("BodyPartFacialHair")
	if(currentEquipped) then
		currentEquipped:SetHue(CharacterCustomization.HairColorTypes[SelectedHairColorType].Hue)		
	end
end		

function UpdateShirt()
	local currentEquipped = this:GetEquippedObject("Chest")
	--DebugMessage("currentEquipped is "..tostring(currentEquipped))
	if (currentEquipped ~= nil) then
		currentEquipped:Destroy()
	end
	--create the new body type
	if (CharacterCustomization.ShirtTypes[SelectedShirtType].Template ~= nil) then
		CreateEquippedObj(CharacterCustomization.ShirtTypes[SelectedShirtType].Template, this, "created_shirt_type")--set the equipped object to the template in the index
		RegisterSingleEventHandler(EventType.CreatedObject,"created_shirt_type",function() UpdateShirtColor() end)
	end
end

function UpdateShirtColor()
	local currentEquipped = this:GetEquippedObject("Chest")
	if(currentEquipped) then
		currentEquipped:SetHue(CharacterCustomization.ClothingColorTypes[SelectedShirtColorType].Hue)
	end
end		

function UpdatePants()
	local currentEquipped = this:GetEquippedObject("Legs")
	--DebugMessage("currentEquipped is "..tostring(currentEquipped))
	if (currentEquipped ~= nil) then
		currentEquipped:Destroy()
	end
	--create the new body type
	if (CharacterCustomization.PantsTypes[SelectedPantsType].Template ~= nil) then
		CreateEquippedObj(CharacterCustomization.PantsTypes[SelectedPantsType].Template, this, "created_pants_type")--set the equipped object to the template in the index
		RegisterSingleEventHandler(EventType.CreatedObject,"created_pants_type",function() UpdatePantsColor() end)
	end
end

function UpdatePantsColor()
	local currentEquipped = this:GetEquippedObject("Legs")
	if(currentEquipped) then
		currentEquipped:SetHue(CharacterCustomization.ClothingColorTypes[SelectedPantsColorType].Hue)
	end
end		

function ChangeGender(newGender)
	SelectedFaceType = 1
	SelectedSkinToneType = 1
	SelectedHairType = 1
	SelectedFacialHairType = 1
	SelectedHairColorType = 1

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
	UpdateFace()
	UpdateHair()
	UpdateFacialHair()
end

function SetSkills()
	ClearSkills()
	for i, typeInfo in pairs(GetAllSkillsTable()) do
		-- skip "None"
		if(i ~= 1) then
			if(i == SelectedSkill1 and SelectedSkillLevel1 > 0) then
				SetSkillLevel(this,typeInfo.Type,SelectedSkillLevel1)
			elseif(i == SelectedSkill2 and SelectedSkillLevel2 > 0) then
				SetSkillLevel(this,typeInfo.Type,SelectedSkillLevel2)
			elseif(i == SelectedSkill3 and SelectedSkillLevel3 > 0) then
				SetSkillLevel(this,typeInfo.Type,SelectedSkillLevel3)
			elseif(i == SelectedSkill4 and SelectedSkillLevel4 > 0) then
				SetSkillLevel(this,typeInfo.Type,SelectedSkillLevel4)
			elseif(GetSkillLevel(this,typeInfo.Type) > 0) then
				SetSkillLevel(this,0)
			end
		end
	end
end

function ClearSkills()
	for i, typeInfo in pairs(GetAllSkillsTable()) do
		-- skip "None"
		if(i ~= 1) then
			SetSkillLevel(this,typeInfo.Type,0)
		end
	end
end

function AddTradeSelection(dynWindow,buttonId,selectedType)
	local curY = 40

	for i, profession in pairs(CharacterCustomization.StartingTrades) do
		local state = ""
		if(selectedType == profession.Name) then
			state = "pressed"
		end

		local name = "[F3F781]"..profession.Name.."[-]"
		
		dynWindow:AddButton(25,curY,buttonId.."|"..profession.Name.."|"..tostring(i), name,250,45,"","",false,"List",state)
		curY = curY + 45
	end
end

function SetSelectedSkill(index, skillname, skillvalue)
	local skillTableIndex = 1

	if(skillname ~= "None") then
		for i, skills in pairs(GetAllSkillsTable()) do
			local name = skills.Name
			if(name == GetSkillDisplayName(skillname)) then
				skillTableIndex = tonumber(i)
				break
			end
		end
	end

	if(index == 1) then
		SelectedSkill1 = skillTableIndex
		SelectedSkillLevel1 = skillvalue
	elseif(index == 2) then 
		SelectedSkill2 = skillTableIndex
		SelectedSkillLevel2 = skillvalue
	elseif(index == 3) then 
		SelectedSkill3 = skillTableIndex
		SelectedSkillLevel3 = skillvalue
	elseif(index == 4) then 
		SelectedSkill4 = skillTableIndex
		SelectedSkillLevel4 = skillvalue
	end
end

function PopulateSkillPresets()
	for i, trades in pairs(CharacterCustomization.StartingTrades) do
		if(trades.Name == SelectedTrade) then
			for j, skills in pairs(trades.Skills) do
				SetSelectedSkill(j, skills[1], skills[2])
			end
		end
	end
end

function AddTypeSelection(dynWindow,typeTable,buttonId,selectedType)
	local curY = 52
    
	for i,typeInfo in pairs(typeTable) do
		local state = ""
		if(selectedType == i) then
			state = "pressed"
		end
		dynWindow:AddButton(25,curY,buttonId.."|"..tostring(i),typeInfo.Name,250,22,"","",false,"List",state)
		curY = curY + 23
	end

	dynWindow:AddButton(126,curY+16,"ExitSubstate","OK",0,22,"","",false)
end

function AddSkillTypeSelection(dynWindow,typeTable,buttonId,selectedType,disabledTypes)
	local curY = 52

	local scrollWindow = ScrollWindow(25,curY,240,276,23)
	for i,typeInfo in pairs(typeTable) do
		local scrollElement = ScrollElement()
		local state = ""
		if(selectedType == i) then
			state = "pressed"
		elseif(disabledTypes and IsInTableArray(disabledTypes,i)) then
			state = "disabled"
		end
		local name = typeInfo.Name
		if(state ~= "" and i ~= 1) then
			name = "[2CAC21]"..typeInfo.Name
		end
		scrollElement:AddButton(0,0,buttonId.."|"..tostring(i),name,230,22,typeInfo.Tooltip,"",false,"List",state)
		scrollWindow:Add(scrollElement)
	end
	curY = curY + (12*23)

	dynWindow:AddScrollWindow(scrollWindow)
	dynWindow:AddButton(126,curY+16,"ExitSubstate","OK",0,22,"","",false)
end

function AddColorSelection(dynWindow,typeTable,buttonId,selectedType)
	local curX = 25
    local curY = 58
    local rowCount = 4
    
	for i,typeInfo in pairs(typeTable) do
		local rowIndex =  ((i-1) % rowCount)
		local columnIndex = math.floor((i-1) / rowCount)
		
		local state = ""
		if(selectedType == i) then
			state = "pressed"
		end

		dynWindow:AddButton((curX) + (rowIndex * 62), (curY) + (columnIndex * 62),buttonId.."|"..tostring(i),"",64,64,"","",false,"OutlineButton",state)
		dynWindow:AddImage(curX + (rowIndex * 62) + 6, curY + (columnIndex * 62) + 6, "HueSwatch",52,52,"",nil,typeInfo.Hue)		
	end

	local numColumns = math.floor((#typeTable-1) / rowCount) + 1
	dynWindow:AddButton(126,curY+(numColumns*62)+16,"ExitSubstate","OK",0,22,"","",false)
end

curGender = "Male"
function OpenApppearanceWindow()	
	if (GenderHairTable == nil or GenderFaceTable == nil) then
		DebugMessage("[custom_char_window|charCustomWindow] ERROR: Player has unsupported gender/face type.")
		return
	end

	local dynWindow = DynamicWindow("CharCreateWindow","",320,300,200,-150,"Transparent","Left")	

	if(AppearanceSubstate == "SelectFace") then
		dynWindow:AddLabel(155,10,"Select Face",323,0,26,"center")
		AddTypeSelection(dynWindow,GenderFaceTable,"Face",SelectedFaceType)
	elseif(AppearanceSubstate == "SelectSkinTone") then
		dynWindow:AddLabel(155,10,"Select Skin Tone",323,0,26,"center")
		AddColorSelection(dynWindow,CharacterCustomization.SkinToneTypes,"SkinTone",SelectedSkinToneType)
	elseif(AppearanceSubstate == "SelectHair") then
		dynWindow:AddLabel(155,10,"Select Hair",323,0,26,"center")
		AddTypeSelection(dynWindow,GenderHairTable,"Hair",SelectedHairType)
	elseif(AppearanceSubstate == "SelectFacialHair") then
		dynWindow:AddLabel(155,10,"Select Facial Hair",323,0,26,"center")
		AddTypeSelection(dynWindow,CharacterCustomization.FacialHairTypesMale,"FacialHair",SelectedFacialHairType)
	elseif(AppearanceSubstate == "SelectHairColor") then
		dynWindow:AddLabel(155,10,"Select Hair Color",323,0,26,"center")
		AddColorSelection(dynWindow,CharacterCustomization.HairColorTypes,"HairColor",SelectedHairColorType)
	else
		dynWindow:AddLabel(155,10,"Select Appearance",323,0,26,"center")

		local maleState = ""
		local femaleState = ""
		if(curGender == "Male") then
			maleState = "pressed"
		else
			femaleState = "pressed"
		end

		dynWindow:AddButton(85, 40, "Gender|Male", "", 51, 60, "Male", "", false,"MaleButton",maleState)
		dynWindow:AddButton(170, 40, "Gender|Female", "", 51, 60, "Female", "", false,"FemaleButton",femaleState)

		local nextY = 110
		dynWindow:AddButton(25,nextY,"SelectFace","",250,45,"","",false,"List")
		dynWindow:AddLabel(150,nextY+6,"[F3F781]Face[-]",323,0,20,"center")	
		dynWindow:AddLabel(150,nextY+27,GenderFaceTable[SelectedFaceType].Name,323,0,18,"center")

		nextY = nextY + 45
		
		dynWindow:AddButton(25,nextY,"SelectSkinTone","",250,45,"","",false,"List")
		dynWindow:AddLabel(150,nextY+6,"[F3F781]Skin Tone[-]",323,0,20,"center")	
		dynWindow:AddLabel(150,nextY+27,CharacterCustomization.SkinToneTypes[SelectedSkinToneType].Name,323,0,18,"center")

		nextY = nextY + 45

		--hair tab
		dynWindow:AddButton(25,nextY,"SelectHair","",250,45,"","",false,"List")
		dynWindow:AddLabel(150,nextY+6,"[F3F781]Hair[-]",323,0,20,"center")	
		dynWindow:AddLabel(150,nextY+27,GenderHairTable[SelectedHairType].Name,323,0,18,"center")

		nextY = nextY + 45

		if(curGender == "Male") then
			dynWindow:AddButton(25,nextY,"SelectFacialHair","",250,45,"","",false,"List")
			dynWindow:AddLabel(150,nextY+6,"[F3F781]Facial Hair[-]",323,0,20,"center")	
			dynWindow:AddLabel(150,nextY+27,CharacterCustomization.FacialHairTypesMale[SelectedFacialHairType].Name,323,0,18,"center")
			nextY = nextY + 45
		end

		dynWindow:AddButton(25,nextY,"SelectHairColor","",250,45,"","",false,"List")
		dynWindow:AddLabel(150,nextY+6,"[F3F781]Hair Color[-]",323,0,20,"center")	
		dynWindow:AddLabel(150,nextY+27,CharacterCustomization.HairColorTypes[SelectedHairColorType].Name,323,0,18,"center")
	end

	local state = ""
	if(AppearanceSubstate ~= "") then
		state = "disabled"
	end
	dynWindow:AddButton(88, 410, "ChangeAppearance", "Next", 122, 32, "", "", true,"",state)
	dynWindow:AddButton(88, 452, "Back", "Back", 122, 32, "", "", true,"",state)
			
	this:OpenDynamicWindow(dynWindow)
end

function OpenStartingGearWindow()
	local dynWindow = DynamicWindow("CharCreateWindow","",320,300,200,-150,"Transparent","Left")

	if(GearSubstate == "SelectShirt") then
		dynWindow:AddLabel(155,10,"Select Shirt",323,0,26,"center")
		AddTypeSelection(dynWindow,CharacterCustomization.ShirtTypes,"Shirt",SelectedShirtType)
	elseif(GearSubstate == "SelectShirtColor") then
		dynWindow:AddLabel(155,10,"Select Shirt Color",323,0,26,"center")
		AddColorSelection(dynWindow,CharacterCustomization.ClothingColorTypes,"ShirtColor",SelectedShirtColorType)
	elseif(GearSubstate == "SelectPants") then
		dynWindow:AddLabel(155,10,"Select Pants",323,0,26,"center")
		AddTypeSelection(dynWindow,CharacterCustomization.PantsTypes,"Pants",SelectedPantsType)
	elseif(GearSubstate == "SelectPantsColor") then
		dynWindow:AddLabel(155,10,"Select Pants Color",323,0,26,"center")
		AddColorSelection(dynWindow,CharacterCustomization.ClothingColorTypes,"PantsColor",SelectedPantsColorType)	
	else
		dynWindow:AddLabel(155,10,"Select Clothing",323,0,26,"center")

		local nextY = 40
		dynWindow:AddButton(25,nextY,"SelectShirt","",250,45,"","",false,"List")
		dynWindow:AddLabel(150,nextY+6,"[F3F781]Shirt[-]",323,0,20,"center")	
		dynWindow:AddLabel(150,nextY+27,CharacterCustomization.ShirtTypes[SelectedShirtType].Name,323,0,18,"center")

		nextY = nextY + 45
		
		dynWindow:AddButton(25,nextY,"SelectShirtColor","",250,45,"","",false,"List")
		dynWindow:AddLabel(150,nextY+6,"[F3F781]Shirt Color[-]",323,0,20,"center")	
		dynWindow:AddLabel(150,nextY+27,CharacterCustomization.ClothingColorTypes[SelectedShirtColorType].Name,323,0,18,"center")

		nextY = nextY + 45

		--hair tab
		dynWindow:AddButton(25,nextY,"SelectPants","",250,45,"","",false,"List")
		dynWindow:AddLabel(150,nextY+6,"[F3F781]Pants[-]",323,0,20,"center")	
		dynWindow:AddLabel(150,nextY+27,CharacterCustomization.PantsTypes[SelectedPantsType].Name,323,0,18,"center")

		nextY = nextY + 45

		dynWindow:AddButton(25,nextY,"SelectPantsColor","",250,45,"","",false,"List")
		dynWindow:AddLabel(150,nextY+6,"[F3F781]Pants Color[-]",323,0,20,"center")	
		dynWindow:AddLabel(150,nextY+27,CharacterCustomization.ClothingColorTypes[SelectedPantsColorType].Name,323,0,18,"center")
	end

	local state = ""
	if(GearSubstate ~= "") then
		state = "disabled"
	end

	dynWindow:AddButton(88, 410, "ChangeGear", "Next", 122, 32, "", "", true,"",nextState)
	dynWindow:AddButton(88, 452, "Back", "Back", 122, 32, "", "", true,"")

	this:OpenDynamicWindow(dynWindow)
end

function OpenStartingTradeWindow()
	local dynWindow = DynamicWindow("CharCreateWindow","",320,300,200,-150,"Transparent","Left")

	dynWindow:AddLabel(155,10,"Who am I?",323,0,26,"center")

	AddTradeSelection(dynWindow, "Trade", SelectedTrade)

	dynWindow:AddButton(88, 410, "ChangeTrade", "Next", 122, 32, "", "", true,"",nextState)
	dynWindow:AddButton(88, 452, "Back", "Back", 122, 32, "", "", true,"")

	dynWindow:AddLabel(150,300,"Pick a path to set your characters's starting skills. Skills may be customized fully in the next step." ,250,80,18,"center")

	this:OpenDynamicWindow(dynWindow)
end

function OpenStartingSkillsWindow()
	local dynWindow = DynamicWindow("CharCreateWindow","",320,500,200,-150,"Transparent","Left")

	if(SkillsSubstate == "SelectSkill1") then
		dynWindow:AddLabel(155,10,"Select Skill",323,0,26,"center")
		AddSkillTypeSelection(dynWindow,GetAllSkillsTable(),"Skill1",SelectedSkill1,GetSelectedSkillTypes())
	elseif(SkillsSubstate == "SelectSkill2") then
		dynWindow:AddLabel(155,10,"Select Skill",323,0,26,"center")
		AddSkillTypeSelection(dynWindow,GetAllSkillsTable(),"Skill2",SelectedSkill2,GetSelectedSkillTypes())
	elseif(SkillsSubstate == "SelectSkill3") then
		dynWindow:AddLabel(155,10,"Select Skill",323,0,26,"center")
		AddSkillTypeSelection(dynWindow,GetAllSkillsTable(),"Skill3",SelectedSkill3,GetSelectedSkillTypes())
	elseif(SkillsSubstate == "SelectSkill4") then
		dynWindow:AddLabel(155,10,"Select Skill",323,0,26,"center")
		AddSkillTypeSelection(dynWindow,GetAllSkillsTable(),"Skill4",SelectedSkill4,GetSelectedSkillTypes())
	else
		dynWindow:AddLabel(155,10,"Select Skills",323,0,26,"center")

		local nextY = 40
		dynWindow:AddImage(25,nextY,"DropHeaderBackground",250,64,"Sliced")
		local skillName = GetAllSkillsTable()[SelectedSkill1].Name
		-- DAB TODO: Show starting items in tooltip as well
		--dynWindow:AddButton(30,nextY+5,"SelectSkill1",GetAllSkillsTable()[SelectedSkill1].Name,240,22,GetAllSkillsTable()[SelectedSkill1].Tooltip,"",false,"List")
		if(SelectedSkill1 ~= 1) then
			SelectedSkillLevel1 = math.clamp(SelectedSkillLevel1,0,ServerSettings.CharacterCreation.StartingSkillCap - (SelectedSkillLevel2 + SelectedSkillLevel3 + SelectedSkillLevel4))
			SelectedSkillLevel1 = math.min(SelectedSkillLevel1,ServerSettings.CharacterCreation.MaxStartingSkillValue)

			dynWindow:AddButton(30,nextY+5,"SelectSkill1",GetAllSkillsTable()[SelectedSkill1].Name,240,22,GetAllSkillsTable()[SelectedSkill1].Tooltip,"",false,"List")
			dynWindow:AddButton(100,nextY+37,"Skill1Left","",10,16,"","",false,"Previous")			
			dynWindow:AddLabel(150,nextY+34,tostring(SelectedSkillLevel1),323,0,28,"center")
			dynWindow:AddButton(190,nextY+37,"Skill1Right","",10,16,"","",false,"Next")
		else

			SelectedSkillLevel1 = 0

			dynWindow:AddButton(30,nextY+5,"SelectSkill1","[9E9E9E]None",240,22,"","",false,"List")
			dynWindow:AddButton(100,nextY+37,"","",10,16,"","",false,"Previous","disabled")			
			dynWindow:AddLabel(150,nextY+34,"[9E9E9E]"..tostring(SelectedSkillLevel1),323,0,28,"center")
			dynWindow:AddButton(190,nextY+37,"","",10,16,"","",false,"Next","disabled")
		end

		nextY = nextY + 67	

		dynWindow:AddImage(25,nextY,"DropHeaderBackground",250,64,"Sliced")		
		if(SelectedSkill2 ~= 1) then
			SelectedSkillLevel2 = math.clamp(SelectedSkillLevel2,0,ServerSettings.CharacterCreation.StartingSkillCap - (SelectedSkillLevel1 + SelectedSkillLevel3 + SelectedSkillLevel4))
			SelectedSkillLevel2 = math.min(SelectedSkillLevel2,ServerSettings.CharacterCreation.MaxStartingSkillValue)

			dynWindow:AddButton(30,nextY+5,"SelectSkill2",GetAllSkillsTable()[SelectedSkill2].Name,240,22,GetAllSkillsTable()[SelectedSkill2].Tooltip,"",false,"List")
			dynWindow:AddButton(100,nextY+37,"Skill2Left","",10,16,"","",false,"Previous")			
			dynWindow:AddLabel(150,nextY+34,tostring(SelectedSkillLevel2),323,0,28,"center")
			dynWindow:AddButton(190,nextY+37,"Skill2Right","",10,16,"","",false,"Next")
		else

			SelectedSkillLevel2 = 0
			dynWindow:AddButton(30,nextY+5,"SelectSkill2","[9E9E9E]None",240,22,"","",false,"List")
			dynWindow:AddButton(100,nextY+37,"","",10,16,"","",false,"Previous","disabled")			
			dynWindow:AddLabel(150,nextY+34,"[9E9E9E]"..tostring(SelectedSkillLevel2),323,0,28,"center")
			dynWindow:AddButton(190,nextY+37,"","",10,16,"","",false,"Next","disabled")
		end

		nextY = nextY + 67

		dynWindow:AddImage(25,nextY,"DropHeaderBackground",250,64,"Sliced")		
		if(SelectedSkill3 ~= 1) then
			SelectedSkillLevel3 = math.clamp(SelectedSkillLevel3,0,ServerSettings.CharacterCreation.StartingSkillCap - (SelectedSkillLevel1 + SelectedSkillLevel2 + SelectedSkillLevel4))
			SelectedSkillLevel3 = math.min(SelectedSkillLevel3,ServerSettings.CharacterCreation.MaxStartingSkillValue)

			dynWindow:AddButton(30,nextY+5,"SelectSkill3",GetAllSkillsTable()[SelectedSkill3].Name,240,22,GetAllSkillsTable()[SelectedSkill3].Tooltip,"",false,"List")
			dynWindow:AddButton(100,nextY+37,"Skill3Left","",10,16,"","",false,"Previous")			
			dynWindow:AddLabel(150,nextY+34,tostring(SelectedSkillLevel3),323,0,28,"center")
			dynWindow:AddButton(190,nextY+37,"Skill3Right","",10,16,"","",false,"Next")
		else

			SelectedSkillLevel3 = 0

			dynWindow:AddButton(30,nextY+5,"SelectSkill3","[9E9E9E]None",240,22,"","",false,"List")
			dynWindow:AddButton(100,nextY+37,"","",10,16,"","",false,"Previous","disabled")			
			dynWindow:AddLabel(150,nextY+34,"[9E9E9E]"..tostring(SelectedSkillLevel3),323,0,28,"center")
			dynWindow:AddButton(190,nextY+37,"","",10,16,"","",false,"Next","disabled")
		end

		nextY = nextY + 67	

		dynWindow:AddImage(25,nextY,"DropHeaderBackground",250,64,"Sliced")		
		if(SelectedSkill4 ~= 1) then
			SelectedSkillLevel4 = math.clamp(SelectedSkillLevel4,0,ServerSettings.CharacterCreation.StartingSkillCap - (SelectedSkillLevel1 + SelectedSkillLevel2 + SelectedSkillLevel3))
			SelectedSkillLevel4 = math.min(SelectedSkillLevel4,ServerSettings.CharacterCreation.MaxStartingSkillValue)

			dynWindow:AddButton(30,nextY+5,"SelectSkill4",GetAllSkillsTable()[SelectedSkill4].Name,240,22,GetAllSkillsTable()[SelectedSkill4].Tooltip,"",false,"List")
			dynWindow:AddButton(100,nextY+37,"Skill4Left","",10,16,"","",false,"Previous")			
			dynWindow:AddLabel(150,nextY+34,tostring(SelectedSkillLevel4),323,0,28,"center")
			dynWindow:AddButton(190,nextY+37,"Skill4Right","",10,16,"","",false,"Next")
		else

			SelectedSkillLevel4 = 0
			dynWindow:AddButton(30,nextY+5,"SelectSkill4","[9E9E9E]None",240,22,"","",false,"List")
			dynWindow:AddButton(100,nextY+37,"","",10,16,"","",false,"Previous","disabled")			
			dynWindow:AddLabel(150,nextY+34,"[9E9E9E]"..tostring(SelectedSkillLevel4),323,0,28,"center")
			dynWindow:AddButton(190,nextY+37,"","",10,16,"","",false,"Next","disabled")
		end

		dynWindow:AddLabel(150,340,"Remaining Skill Points: " .. tostring(GetRemainingSkillPoints()) .. " / ".. ServerSettings.CharacterCreation.StartingSkillCap,323,0,22,"center")
	end

	local state = ""
	if(SkillsSubstate ~= "") then
		state = "disabled"
	end

	dynWindow:AddButton(88, 410, "ChangeSkills", "Next", 122, 32, "", "", true,"",state)
	dynWindow:AddButton(88, 452, "Back", "Back", 122, 32, "", "", true,"",state)

	this:OpenDynamicWindow(dynWindow)
end

curUniverse = nil
function OpenSelectUniverseWindow()	
	local dynWindow = DynamicWindow("CharCreateWindow","",320,300,200,-150,"Transparent","Left")

	dynWindow:AddLabel(155,10,"Choose Universe",323,0,26,"center")

	local curY = 52
	for i,universeName in pairs(ValidUniverses) do
		local state = ""
		if(curUniverse == universeName) then
			state = "pressed"
		end
		dynWindow:AddButton(25,curY,"Universe|"..universeName,universeName,250,22,"","",false,"List",state)
		curY = curY + 23
	end

	local nextState = ""
	if not(curUniverse) then
		nextState = "disabled"
	end

	local backState = ""
	if not(IsCreate()) then
		backState = "disabled"
	end

	dynWindow:AddButton(88, 410, "ChangeUniverse", "Next", 122, 32, "", "", true,"",nextState)
	dynWindow:AddButton(88, 452, "Back", "Back", 122, 32, "", "", true,"",backState)

	this:OpenDynamicWindow(dynWindow)
end

curCity = nil
function OpenSelectCityWindow()
	local dynWindow = DynamicWindow("CharCreateWindow","",320,300,200,-150,"Transparent","Left")

	dynWindow:AddLabel(155,10,"Choose Starting Town",323,0,26,"center")
	
	AllStartingLocations = ServerSettings.CharacterCreation.StartingLocations
	-- if existing character then add the alternate locations
	if not(IsCreate()) then
		AllStartingLocations = {}
		for i,k in pairs(ServerSettings.CharacterCreation.StartingLocations) do
			table.insert(AllStartingLocations,k)
		end
		for i,k in pairs(ServerSettings.CharacterCreation.AlternateStartingLocations) do
			table.insert(AllStartingLocations,k)
		end
	end

	local curY = 52
	for i,cityInfo in pairs(AllStartingLocations) do
		local state = ""
		if(curCity == i) then
			state = "pressed"
		end
		dynWindow:AddButton(25,curY,"City|"..tostring(i),cityInfo.Name,250,22,cityInfo.Description,"",false,"List",state)
		curY = curY + 23
	end

	local nextState = ""
	if not(curCity) then
		nextState = "disabled"
	end

	local backState = ""
	if not(IsCreate()) then
		backState = "disabled"
	end

	dynWindow:AddButton(88, 410, "ChangeCity", "Enter World", 122, 32, "", "", true,"",nextState)
	dynWindow:AddButton(88, 452, "Back", "Back", 122, 32, "", "", true,"",backState)

	this:OpenDynamicWindow(dynWindow)
	
	local dynWindow = DynamicWindow("CityWindow","",1024,1024,-1224,-512,"Transparent","Right")

	local mapName = ServerSettings.CharacterCreation.StartingMap
	local mapIcons = {}

	for i,cityInfo in pairs(AllStartingLocations) do
		local icon = "location_town"
		if(curCity == i) then
			icon = "location_town_selected"
		end
		
		table.insert(mapIcons,
			{Icon=icon, Id=cityInfo.Name, Location=MapLocations[mapName][cityInfo.MapLocation], Tooltip=cityInfo.Name.."\n\n"..cityInfo.Description, Width=94, Height=94})
	end

	mapName = mapName.."_full"
	dynWindow:AddMap(0,0,1024,1024,mapName,false,false,mapIcons)
	dynWindow:AddButton(451, 980, "ChangeCity", "Enter World", 122, 32, "", "", true,"",nextState)

	this:OpenDynamicWindow(dynWindow)
end

function SpawnCharacterAppearance()
	UpdateShirt()
	UpdateShirtColor()
	UpdatePants()
	UpdatePantsColor()
end

function ConfirmSkillPointsLeft(user)
	ClientDialog.Show{
		TargetUser = user,
		ResponseObj = this,
		DialogId = "ConfirmSkillPoints",
		TitleStr = "Are you sure?",
		DescStr = "You currently have unassigned skill points available, continue without allocating?",
		Button1Str = "Ok.",
		Button2Str = "Cancel."
	}
end

RegisterEventHandler(EventType.DynamicWindowResponse, "ConfirmSkillPoints", function(user,buttonId)
	local buttonId = tonumber(buttonId)
	if (user == nil) then return end
	if (buttonId == nil) then return end

	if ( buttonId == 0 ) then
		GoState("Universe")
	end
end)

RegisterEventHandler(EventType.DynamicWindowResponse, "CharCreateWindow",
	function (user,buttonId)

		--DebugMessage("SelectedFaceType is "..tostring(SelectedFaceType))
		--DebugMessage("SelectedHairType is "..tostring(SelectedHairType))
		--DebugMessage("SelectedHairColorType is "..tostring(SelectedHairColorType))		

		if (GenderHairTable == nil or GenderFaceTable == nil) then
			DebugMessage("[custom_char_window|charCustomWindow] ERROR: Player has unsupported gender/face type.")
			return
		end

		if (buttonId == "SelectFace" or buttonId == "SelectSkinTone" or buttonId == "SelectHair" or buttonId == "SelectFacialHair" or buttonId == "SelectHairColor") then
			AppearanceSubstate = buttonId
			OpenApppearanceWindow()
		elseif (buttonId == "SelectShirt" or buttonId == "SelectShirtColor" or buttonId == "SelectPants" or buttonId == "SelectPantsColor") then
			GearSubstate = buttonId
			OpenStartingGearWindow()
		elseif (buttonId:match("SelectSkill")) then
			SkillsSubstate = buttonId
			OpenStartingSkillsWindow()
		elseif(buttonId == "ExitSubstate") then			
			local curState = this:GetObjVar("CharCreateState")
			if(curState == "Appearance") then
				AppearanceSubstate = ""
				OpenApppearanceWindow()
			elseif(curState == "Gear") then
				GearSubstate = ""
				OpenStartingGearWindow()				
			elseif(curState == "Skills") then
				SkillsSubstate = ""
				OpenStartingSkillsWindow()		
			end
		elseif (buttonId == "ChangeAppearance") then
			SpawnCharacterAppearance()
			GoState("Gear")
		elseif(buttonId == "ChangeUniverse") then
			if(curUniverse) then 				
				this:SetObjVar("CharCreateUniverse",curUniverse)
				GoState("City")
			end
		elseif(buttonId == "ChangeGear") then
			GoState("Trades")
		elseif(buttonId == "ChangeTrade") then
			PopulateSkillPresets()
			GoState("Skills")
		elseif(buttonId == "ChangeSkills") then
			SetSkills()
			if(GetRemainingSkillPoints() > 0) then
				OpenStartingSkillsWindow()
				ConfirmSkillPointsLeft(user)
			else
				GoState("Universe")
			end
		elseif(buttonId == "ChangeCity") then
			if(curCity) then 
				EnterWorld(curCity)
			end
		elseif(buttonId == "Back") then
			GoBack()
		elseif(buttonId == "Skill1Left") then
			if(SelectedSkillLevel1 > 0) then
				SelectedSkillLevel1 = SelectedSkillLevel1 - 1			
				OpenStartingSkillsWindow()
			end
		elseif(buttonId == "Skill1Right") then
			if(SelectedSkillLevel1 < ServerSettings.CharacterCreation.MaxStartingSkillValue and GetRemainingSkillPoints() > 0) then
				SelectedSkillLevel1 = SelectedSkillLevel1 + 1
				OpenStartingSkillsWindow()
			end
		elseif(buttonId == "Skill2Left") then
			if(SelectedSkillLevel2 > 0) then
				SelectedSkillLevel2 = SelectedSkillLevel2 - 1
				OpenStartingSkillsWindow()
			end
		elseif(buttonId == "Skill2Right") then
			if(SelectedSkillLevel2 < ServerSettings.CharacterCreation.MaxStartingSkillValue and GetRemainingSkillPoints() > 0) then
				SelectedSkillLevel2 = SelectedSkillLevel2 + 1
				OpenStartingSkillsWindow()
			end
		elseif(buttonId == "Skill3Left") then
			if(SelectedSkillLevel3 > 0) then
				SelectedSkillLevel3 = SelectedSkillLevel3 - 1
				OpenStartingSkillsWindow()
			end
		elseif(buttonId == "Skill3Right") then
			if(SelectedSkillLevel3 < ServerSettings.CharacterCreation.MaxStartingSkillValue and GetRemainingSkillPoints() > 0) then
				SelectedSkillLevel3 = SelectedSkillLevel3 + 1
				OpenStartingSkillsWindow()
			end
		elseif(buttonId == "Skill4Left") then
			if(SelectedSkillLevel4 > 0) then
				SelectedSkillLevel4 = SelectedSkillLevel4 - 1
				OpenStartingSkillsWindow()
			end
		elseif(buttonId == "Skill4Right") then
			if(SelectedSkillLevel4 < ServerSettings.CharacterCreation.MaxStartingSkillValue and GetRemainingSkillPoints() > 0) then
				SelectedSkillLevel4 = SelectedSkillLevel4 + 1
				OpenStartingSkillsWindow()
			end
		else
			local result = StringSplit(buttonId,"|")
    		local action = result[1]
    		local arg = result[2]
    		if(action == "Face") then
    			SelectedFaceType = tonumber(arg)
    			UpdateFace()
    			OpenApppearanceWindow()
    		elseif(action == "SkinTone") then
    			SelectedSkinToneType = tonumber(arg)
    			UpdateSkinTone()
    			OpenApppearanceWindow()
    		elseif(action == "Hair") then
    			SelectedHairType = tonumber(arg)
    			UpdateHair()
    			OpenApppearanceWindow()
    		elseif(action == "FacialHair") then
    			SelectedFacialHairType = tonumber(arg)
    			UpdateFacialHair()
    			OpenApppearanceWindow()
    		elseif(action == "HairColor") then
    			SelectedHairColorType = tonumber(arg)
    			UpdateHairColor()
    			OpenApppearanceWindow()
    		elseif(action == "Shirt") then
    			SelectedShirtType = tonumber(arg)
    			UpdateShirt()
    			OpenStartingGearWindow()
    		elseif(action == "ShirtColor") then
    			SelectedShirtColorType = tonumber(arg)
    			UpdateShirtColor()
    			OpenStartingGearWindow()
    		elseif(action == "Pants") then
    			SelectedPantsType = tonumber(arg)
    			UpdatePants()
    			OpenStartingGearWindow()
    		elseif(action == "PantsColor") then
    			SelectedPantsColorType = tonumber(arg)
    			UpdatePantsColor()
    			OpenStartingGearWindow()
    		elseif(action == "Skill1") then
    			local oldSkill = SelectedSkill1
    			SelectedSkill1 = tonumber(arg)
    			if(SelectedSkill1 ~= 1 and oldSkill == 1 ) then
    				SelectedSkillLevel1 = 10
    			end

    			OpenStartingSkillsWindow()
    		elseif(action == "Skill2") then
    			local oldSkill = SelectedSkill2
    			SelectedSkill2 = tonumber(arg)
    			if(SelectedSkill2 ~= 1 and oldSkill == 1 ) then
    				SelectedSkillLevel2 = 10
    			end

    			OpenStartingSkillsWindow()
    		elseif(action == "Skill3") then
    			local oldSkill = SelectedSkill3
    			SelectedSkill3 = tonumber(arg)
    			if(SelectedSkill3 ~= 1 and oldSkill == 1 ) then
    				SelectedSkillLevel3 = 10
    			end

    			OpenStartingSkillsWindow()
    		elseif(action == "Skill4") then
    			local oldSkill = SelectedSkill4
    			SelectedSkill4 = tonumber(arg)
    			if(SelectedSkill4 ~= 1 and oldSkill == 1 ) then
    				SelectedSkillLevel4 = 10
    			end

    			OpenStartingSkillsWindow()
    		elseif(action == "Gender") then
    			if(curGender ~= arg) then
	    			curGender = arg 
	    			ChangeGender(arg)
    				OpenApppearanceWindow()
    			end
    		elseif(action == "Universe") then
    			local universeName = arg
    			if(universeName ~= nil) then
    				curUniverse = universeName
    				OpenSelectUniverseWindow()
				end
    		elseif(action == "City") then
    			local cityIndex = tonumber(arg)
    			if(cityIndex ~= curCity) then
	    			curCity = cityIndex
    				OpenSelectCityWindow()    				
    			end
    		elseif(action == "Trade") then
    			if(SelectedTrade ~=  arg) then
    				SelectedTrade = arg
    				ClearSkills();
    				OpenStartingTradeWindow()
    			end
    		end
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "CityWindow",
	function (user,buttonId)
		if(buttonId == "ChangeCity") then
			if(curCity) then 
				EnterWorld(curCity)
			end
		elseif(buttonId ~= nil and buttonId ~= "") then
			for i,cityInfo in pairs(AllStartingLocations) do
				if(cityInfo.Name == buttonId) then
					curCity = i
					OpenSelectCityWindow()
					return
				end
			end
		end
	end)

function LoginInit()
	this:SetObjectTag("AttachedUser")
	-- this prevents the server from sending updates from other players in the login region
	this:SetUpdateRange(0)
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ( ... )
		LoginInit()

		GoState("Appearance")
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ( ... )
		LoginInit()
				
		if not(IsCreate()) then
			-- region is not running give them a choice of new starting region
			ClientDialog.Show{
				    TargetUser = this,
				    DialogId = "Error",
				    TitleStr = "Error",
				    Button1Str = "Ok",
				    DescStr = "The region your character logged out in is not online. Please select a starting town.",
				    ResponseFunc = function (user, buttonId)				    	
					end
				}
			GoState("Universe")
		else
			local createState = this:GetObjVar("CharCreateState")
			--DebugMessage("CREATE STATE: "..tostring(createState))
			if not(createState) then
				DebugMessage("ERROR: Player entered world without createState.")
				ChangeToTemplate("playertemplate_blank",{KeepAppearance = true, LoadAbilities = false, SetStats = false, SetName = false, BuildHotbar = false, LoadLoot=false})
				GoState("Appearance")
			else
				ChangeToTemplate("playertemplate_blank",{KeepAppearance = false, LoadAbilities = false, SetStats = false, SetName = false, BuildHotbar = false, LoadLoot=false})
				GoState("Appearance")
			end
		end
	end)

RegisterEventHandler(EventType.UserLogout,"", 
	function ( ... )
		this:CompleteLogout()
	end)