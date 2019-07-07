
mLoadedWorld = nil
mLoadedSeedObjects = {}

mCurrentGroup = nil

mFolder = "D:/citadel/game/rundir/"


function GetFilePath(world)
	if ( world == nil and mLoadedWorld ~= nil ) then
		world = mLoadedWorld
	end
	return "mapdata/"..world.."/SeedObjects.xml"
end

function LoadRegionSeedObject()
	local currentWorld = ServerSettings.WorldName
	if ( currentWorld ~= mLoadedWorld ) then
		this:SystemMessage("Loading SeedObjects.xml from mapdata for '"..currentWorld.."'")
		mLoadedSeedObjects = xml.load(mFolder .. GetFilePath(currentWorld))
		mLoadedWorld = currentWorld
	end
end

function HandleCommand(cmd, param)
	if ( cmd == nil or cmd == "" or cmd == "help" ) then
		local message = "/seedobjects /seedobject /so\n"
		message = message .. "[$2516]"
		message = message .. "[$2517]"
		message = message .. "[$2518]"
		this:SystemMessage(message)
		return
	end
	LoadRegionSeedObject()
	if ( cmd == "add" or cmd == "save" ) then
		if ( mCurrentGroup == nil or mCurrentGroup == "" ) then
			this:SystemMessage("[$2519]")
			return
		end
		this:SystemMessage("Please target the object you'd like to save to "..GetFilePath());
		this:RequestClientTargetGameObj(this, "target_add_object")
	end
	if ( cmd == "del" or cmd == "rem" or cmd == "remove" or cmd == "delete" ) then
		if ( param ~= nil ) then
			ConfirmRemoveObject(GameObj(tonumber(param)), this)
		else
			this:SystemMessage("[$2520]"..GetFilePath());
			this:RequestClientTargetGameObj(this, "target_del_object")
		end
	end
	if ( cmd == "group" ) then
		if ( param ~= nil ) then
			mCurrentGroup = param
			this:SystemMessage("SeedObjects group set to '"..param.."'")
		else
			this:SystemMessage("Usage: /seedobjects group GroupName")
		end
	end
end

RegisterEventHandler(EventType.ClientUserCommand, "seedobjects", function(cmd, param)
		HandleCommand(cmd, param)
	end)
RegisterEventHandler(EventType.ClientUserCommand, "seedobject", function(cmd, param)
		HandleCommand(cmd, param)
	end)
RegisterEventHandler(EventType.ClientUserCommand, "so", function(cmd, param)
		HandleCommand(cmd, param)
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "target_add_object",
	function (target, user)
		if ( target ~= nil and target:IsValid() and mCurrentGroup ~= nil ) then
			ClientDialog.Show{
			    TargetUser = this,
			    DialogId = "AddSeedObjectDialog",
			    TitleStr = "Save target as SeedObject?",
			    DescStr = "Would you like to save '"..target:GetName().."' to group '"..mCurrentGroup.."' in '"..GetFilePath().."'?",
			    Button1Str = "Yes",
			    Button2Str = "Cancel",
			    ResponseFunc = function (user, buttonId)
					buttonId = tonumber(buttonId)
					if( buttonId == 0) then
						SaveObject(target)
					end
				end
			}
		end
	end)

function CreateGroup(name)
	local data = {
		Name = name,
		Exclude = "False"
	}
	data[0] = "Group"
	local nxt = #mLoadedSeedObjects + 1
	mLoadedSeedObjects[nxt] = xml.new(data)
	this:SystemMessage("Created Group '"..name.."'")
	return nxt
end

function GetGroupIndex(name)
	for i,v in ipairs(mLoadedSeedObjects) do
		if mLoadedSeedObjects[i].Name == name then
			return i
		end
	end
	return -1
end

function FindExistingObjectIndex(objectCreationParams)
	for i,v in ipairs(mLoadedSeedObjects) do
		for ii,vv in ipairs(mLoadedSeedObjects[i]) do
			for iii,vvv in pairs(mLoadedSeedObjects[i][ii]) do
				if ( mLoadedSeedObjects[i][ii][iii][0] == "ObjectCreationParams" and mLoadedSeedObjects[i][ii][iii][1] == objectCreationParams ) then
					return i, ii
				end
			end
		end
	end
	return nil, nil
end

function GetObjectCreationParams(object)
	if ( object:IsMobile() ) then
		local spawner = object:GetObjVar("Spawner")
		if ( spawner ~= nil ) then
			object = spawner
		end
	end
	return BuildObjectCreationParams(object)
end

function SaveObject(object)
	if ( mLoadedSeedObjects ~= {} and mCurrentGroup ~= nil ) then

		-- look for existing entry
		local ei, eii = FindExistingObjectIndex(GetObjectCreationParams(object))
		if ( ei ~= nil and eii ~= nil ) then
			this:SystemMessage("That object already exists in SeedObjects.xml")
			return
		end

		local groupIndex = GetGroupIndex(mCurrentGroup)

		if ( groupIndex == -1 ) then
			-- group not found, create it
			groupIndex = CreateGroup(mCurrentGroup)
		end

		-- add the object
		local nxt = #mLoadedSeedObjects[groupIndex] + 1
		mLoadedSeedObjects[groupIndex][nxt] = BuildDynamicObjectXML(object, nxt)

		-- save the file
		xml.save(mLoadedSeedObjects, mFolder..GetFilePath())

		this:SystemMessage("Object Saved in "..GetFilePath())

	end
end

function RoundToDecimal(val, place)
	local shift = 10 ^ place
	return math.floor( val * shift + 0.5 ) / shift
end

function xyzStr(xyz)
	return " "..RoundToDecimal(xyz.X, 3).." "..RoundToDecimal(xyz.Y, 3).." "..RoundToDecimal(xyz.Z, 3)
end

function BuildObjectCreationParams(object, template)
	if ( template == nil ) then template = object:GetCreationTemplateId() end
	return template..xyzStr(object:GetLoc())..xyzStr(object:GetRotation())..xyzStr(object:GetScale())
end

function BuildDynamicObjectXML(object, id)
	local creationTemplate = object:GetCreationTemplateId()
	local objectCreationParamsTemplate = creationTemplate
	local objVarOverrides = nil
	if ( object:IsMobile() ) then
		objectCreationParamsTemplate = "simple_mob_spawner"
		objVarOverrides = {
			StringVariable = {
				Name = "spawnTemplate",
				creationTemplate
			}

		}

	end

	local data = {
		ObjectCreationParams = { BuildObjectCreationParams(object, objectCreationParamsTemplate) },
		Id = { id },
		Name = { creationTemplate },
	}

	if ( objVarOverrides ~= nil ) then
		data.ObjVarOverrides = objVarOverrides
	end
	
	data[0] = "DynamicObject"

	return xml.new(data)
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "target_del_object",
	function (target, user)
		ConfirmRemoveObject(target, user)
	end)

function ConfirmRemoveObject(object, user)
	if ( object ~= nil and object:IsValid() ) then
		-- TODO check for existance
		local existance = true
		if ( existance ) then
			ClientDialog.Show{
			    TargetUser = this,
			    DialogId = "RemoveSeedObjectDialog",
			    TitleStr = "Remove SeedObject?",
			    DescStr = "Are sure you want to REMOVE '"..object:GetName().."'("..object.Id..") from '"..GetFilePath().."'?\n\nThis action cannot be undone.",
			    Button1Str = "Yes",
			    Button2Str = "Cancel",
			    ResponseFunc = function (user, buttonId)
					buttonId = tonumber(buttonId)
					if( buttonId == 0) then
						RemoveObject(object)
					end
				end
			}
		end
	end
end

function RemoveObject(object)
	local creationParams = GetObjectCreationParams(object)
	local i,ii = FindExistingObjectIndex(creationParams)
	if ( i ~= nil and ii ~= nil ) then
		-- renumber the ids
		local id = 1
		for k,v in ipairs(mLoadedSeedObjects[i]) do
			if ( k ~= ii ) then
				for kk,vv in ipairs(mLoadedSeedObjects[i][k]) do
					if ( mLoadedSeedObjects[i][k][kk][0] == "Id" ) then
						mLoadedSeedObjects[i][k][kk][1] = id
						id = id + 1
					end
				end
			end
		end
		table.remove(mLoadedSeedObjects[i], ii)
		this:SystemMessage("Removed")
	else
		this:SystemMessage("Object not found in "..GetFilePath())
	end
	-- save the file
	xml.save(mLoadedSeedObjects, mFolder..GetFilePath())
end