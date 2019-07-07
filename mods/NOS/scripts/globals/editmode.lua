DEFAULT_READONLY = true

function GetSeedEntry(seedObj)
	return GetSeedEntryById(seedObj:GetObjVar("SeedGroup"),seedObj:SetObjVar("SeedId"))
end

function GetSeedEntryById(groupName,seedId)
	local workspace = GetEditModeController():GetObjVar("Workspace")
	if(workspace.Groups.Default[groupName] ~= nil) then
		return workspace.Groups.Default[groupName][seedId]
	end

	if(workspace.Groups.Mod[groupName] ~= nil) then
		return workspace.Groups.Mod[groupName][seedId]
	end
end

function GetEditModeWorkspace()
	return GetEditModeController():GetObjVar("Workspace")
end

local editmodeController = nil
function GetEditModeController()
	if(editmodeController == nil) then
		editmodeController = FindObject(SearchTemplate("cluster_controller"),GameObj(0))
	end

	return editmodeController
end