EditmodeWorkspace = { Dirty = false, Groups = { Default = {}, Mod = {} } }

-- INITIALIZATION

RegisterEventHandler(EventType.CreatedObject,"seed_create",
	function (success,objRef,seedGroup,seedEntry)		
		objRef:AddModule("editmode_seedobject",{SeedEntry=seedEntry})
	end)

function LoadEditorSeeds(groupTable)	
	for groupName,groupEntry in pairs(groupTable) do
		for i,seedEntry in pairs(groupEntry.SeedData) do				
			local templateData = GetTemplateData(seedEntry.Template)

			local scale = seedEntry.Scale or Loc(1,1,1)
			if(templateData ~= nil and templateData.ScaleModifier) then
				scale = Loc(scale.X * templateData.ScaleModifier,scale.Y * templateData.ScaleModifier,scale.Z * templateData.ScaleModifier)
			end

			-- DAB TODO: Get a proper way to hide these
			local objPos = seedEntry.Position
			if not(groupEntry.Visible) then
				objPos = Loc(512,512,512)
			end

			CreateObjExtended("empty", nil, objPos, seedEntry.Rotation, scale, "seed_create", groupName, seedEntry)
		end
	end
end

function InitializeWorkspace()	
	-- clear workspace
	local seedsToDelete = FindObjects(SearchHasObjVar("SeedGroup"))
	for i,seedObj in pairs(seedsToDelete) do
		seedObj:Destroy()
	end
	
	-- DAB TODO: THIS IS MESSY WE NEED A WAY TO GET ALL GROUPS REGARDLESS OF EXCLUSION
	local defaultGroups = GetAllSeedGroups("DefaultOnly", true)
	local defaultInitialGroups = GetAllSeedGroups("DefaultOnly", false)

	EditmodeWorkspace.Groups.Default = {}
	for i,groupName in pairs(defaultGroups) do
		local isInitial = IsInTableArray(defaultInitialGroups,groupName)
		EditmodeWorkspace.Groups.Default[groupName] = 
		{ 
			Excluded = not(isInitial),
			Visible = isInitial,
			SeedData = GetSeedGroupData(groupName)
		}
	end

	local curMod = GetModName()	
	local isModRunning = curMod ~= "Default"
	if(isModRunning) then
		local modGroups = GetAllSeedGroups("ModOnly", true)
		local modInitialGroups = GetAllSeedGroups("ModOnly", false)
		for i,groupName in pairs(modGroups) do
			local isInitial = IsInTableArray(defaultInitialGroups,groupName)
			EditmodeWorkspace.Groups.Mod[groupName] = 
			{ 
				Excluded = not(isInitial),
				Visible = isInitial,
				SeedData = GetSeedGroupData(groupName)
			}
		end
	end

	LoadEditorSeeds(EditmodeWorkspace.Groups.Default)	
	if(GetModName() ~= "Default") then
		LoadEditorSeeds(EditmodeWorkspace.Groups.Mod)	
	end

	this:SetObjVar("Workspace",EditmodeWorkspace)
end

InitializeWorkspace()	

-- SEED GROUP MANAGEMENT

RegisterEventHandler(EventType.Message,"ShowGroup",
	function (groupName)
		
	end)