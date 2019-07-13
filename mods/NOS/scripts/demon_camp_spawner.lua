require 'NOS:cultist_camp_spawner'
require 'NOS:incl_gametime'

SPAWN_DELAY_SECS = TimeSpan.FromSeconds(45)

if( initializer ~= nil ) then
	campLocations = initializer.campLocations
	if( initializer.maxCamps ~= nil ) then
		campMaxNumber = initializer.maxCamps
	end
	this:SetObjVar("CampLocations",campLocations)
	this:SetObjVar("MaxCamps",campMaxNumber)
	--DebugMessage("Camp Locations are generated")
	--DebugMessage(DumpTable(campLocations))
elseif( this:HasObjVar("CampLocations")) then
	campLocations = this:GetObjVar("CampLocations")
	campMaxNumber = this:GetObjVar("MaxCamps") or 3
	--DebugMessage("Camp Locations are objvars")
	--DebugMessage(DumpTable(campLocations))
else
	campLocations = {}
	DebugMessage("ERROR: Camp Locations are nil")
end

function SpawnCamp(locIndex)
	if (IsDayTime()) then return end
	--DebugMessage("Demon Camp Spawned! at ".. tostring(campLocations[locIndex].Loc))
	CreateObj("demon_camp", campLocations[locIndex].Loc, "camp_created", locIndex)
end

function Initialize()
	--DebugMessage("starting delay")
	this:ScheduleTimerDelay(SPAWN_DELAY_SECS,"spawn_check")
end

RegisterSingleEventHandler(EventType.ModuleAttached,"demon_camp_spawner",OnModuleLoaded)
RegisterSingleEventHandler(EventType.LoadedFromBackup,nil,OnLoadedFromBackup)
RegisterEventHandler(EventType.Timer,"spawn_check",CheckSpawn)
RegisterEventHandler(EventType.CreatedObject, "camp_created", HandleCampCreated)