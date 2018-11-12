-- C# Stubs for LuaEnum, LuaClass, and LuaBuiltin imported functions
-- Allows limited unit testing with the offline scripts
-- Only include if unit testing without a running server

-- Stub Class: all methods/fields return another empty stubclass
function stubclass(table)
  return setmetatable({}, {
    __index = function(t, k) return stubclass {} end,
    __newindex = function(t, k, v) end,
    __call = function(...) return (type(arg) ~= table) and stubclass {} or self end 
  });
end

-- Direct Assignments
-- /src/server/libs/Gameplay/LuaScripting/LuaVM.cs
lua_require = require
shards_require = require

-- Unmarked Enum
-- /src/server/libs/Gameplay/LuaScripting/LuaVM.cs
DateTimeKind = {}
DateTimeKind.Local = {}
DateTimeKind.Unspecified = {}
DateTimeKind.Utc = {}

-- Unmarked Assembly/Class
-- /src/server/libs/Gameplay/LuaScripting/LuaVM.cs
TimeSpan = stubclass {}
DateTime = stubclass {}
Convert = stubclass {}

-- [LuaEnum]
-- /src/shared/CoreUtil/AccessList.cs
AccessLevel = {}
AccessLevel.None = 0
AccessLevel.Mortal = 1
AccessLevel.Immortal = 2
AccessLevel.DemiGod = 3
AccessLevel.God = 4

-- /src/server/libs/Gameplay/LuaScripting/LuaEventType.cs
EventType = {}
EventType.LoadedFromBackup = {}
EventType.DestroyAllComplete = {}
EventType.CreatedObject = {}
EventType.DestroyedObject = {}
EventType.ModuleAttached = {}
EventType.Timer = {}
EventType.Message = {}
EventType.EnterView = {}
EventType.LeaveView = {}
EventType.RequestPickUp = {}
EventType.RequestDrop = {} 
EventType.RequestEquip = {}
EventType.ContainerItemAdded = {}
EventType.ContainerItemRemoved = {}
EventType.ItemEquipped = {}
EventType.ItemUnequipped = {}
EventType.StartMoving = {}
EventType.Arrived = {}
EventType.Use = {}
EventType.PlayerSpeech = {}
EventType.ClientUserCommand = {}
EventType.ClientObjectCommand = {}
EventType.ClientTargetAnyObjResponse = {}
EventType.ClientTargetGameObjResponse = {}
EventType.ClientTargetLocResponse = {}
EventType.ContextMenuResponse = {}
EventType.DynamicWindowResponse = {}
EventType.UserLogout = {}
EventType.GlobalVarUpdateResult = {}

-- /src/server/libs/Gameplay/LuaScripting/LuaScripts.cs
ModuleAction = {}
ModuleAction.PreUnload = {}
ModuleAction.Unload = {}
ModuleAction.PreReload = {}
ModuleAction.Reload = {}
ModuleAction.Load = {}
ModuleAction.PreDelete = {}
ModuleAction.Delete = {}

-- [LuaClass]
-- /src/shared/CoreUtil/ShardEngineMath.cs
Loc2 = stubclass {}
Loc = stubclass {}
Box2 = stubclass {}
AABox2 = stubclass {}
Box = stubclass {}

-- /src/server/libs/Gameplay/LuaScripting/DynamicWindow.cs
DynamicWindow = stubclass {}
ScrollWindow = stubclass {}
ScrollElement = stubclass {}

-- /src/server/libs/Gameplay/LuaScripting/LuaGameObj.cs
GameObj = stubclass {}

-- /src/server/libs/Gameplay/LuaScripting/LuaPermanentObj.cs
PermanentObj = stubclass {}

-- /src/server/libs/Gameplay/Object/ObjectDatabaseSearch.cs
SearchRange = stubclass {}
SearchRect = stubclass {}
SearchUser = stubclass {}
SearchTag = stubclass {}
SearchMobile = stubclass {}
SearchMobileInRange = stubclass {}
SearchRegion = stubclass {}
SearchMobileInRegion = stubclass {}
SearchPlayerInRange = stubclass {}
SearchPlayerInUpdateRange = stubclass {}
SearchObjectInRange = stubclass {}
SearchName = stubclass {}
SearchTemplate = stubclass {}
SearchObjVar = stubclass {}
SearchLuaFunction = stubclass {}
SearchHasObjVar = stubclass {}
SearchSharedObjectProperty = stubclass {}
SearchModule = stubclass {}
SearchObjectsInWorld = stubclass {}
SearchTopmostContainer = stubclass {}
SearchContainer = stubclass {}
SarchMulti = stubclass {}
SearchMultiInclusive = stubclass {}
SearchSingleObject = stubclass {}
PermanentObjSearchSharedStateEntry = stubclass {}
PermanentObjSearchVisualState = stubclass {}
PermanentObjSearchRegion = stubclass {}
PermanentObjSearchHasObjectBounds = stubclass {}
PermanentObjSearchMulti = stubclass {}

-- /src/server/libs/Gameplay/World/WorldDataManager.cs
GameRegion = stubclass {}

-- [LuaBuiltin]
shards_require = stubclass {}
DebugMessage = stubclass {}
RegisterEventHandler = stubclass {}
RegisterSingleEventHandler = stubclass {}
CallFunctionDelayed = stubclass {}
OverrideEventHandler = stubclass {}
UnregisterEventHandler = stubclass {}
CreateObj = stubclass {}
CreateTempObj = stubclass {}
CreateObjExtended = stubclass {}
CreateObjInContainer = stubclass {}
CreateEquippedObj = stubclass {}
CreateCustomObj = stubclass {}
FindObjects = stubclass {}
FindObject = stubclass {}
FindPermanentObjects = stubclass {}
FindObjectWithTag = stubclass {}
FindObjectsWithTag = stubclass {}
ServerTimeMs = stubclass {}
ObjectFrameTimeMs = stubclass {}
ServerTimeSecs = stubclass {}
PlayEffectAtLoc = stubclass {}
IsPassable = stubclass {}
GetCollisionInfoAtLoc = stubclass {}
AddView = stubclass {}
DelView = stubclass {}
RefreshView = stubclass {}
HasView = stubclass {}
GetCurrentModule = stubclass {}
GetTemplateObjVar = stubclass {}
GetTemplateObjectProperty = stubclass {}
GetViewObjects = stubclass {}
GetRegion = stubclass {}
GetAllRegions = stubclass {}
GetRegionAtLoc = stubclass {}
IsLocInRegion = stubclass {}
GetRegionsAtLoc = stubclass {}
GetPath = stubclass {}
GetSpawnPosition = stubclass {}
GetTemplateObjectName = stubclass {}
GetTemplateObjectBounds = stubclass {}
GetTemplateRoofBounds = stubclass {}
GetInitializerFromTemplate = stubclass {}
GetTemplateData = stubclass {}
GetTemplateIconId = stubclass {}
GetAllTemplateNames = stubclass {}
GetTemplateCategories = stubclass {}
GetWorldName = stubclass {}
IsOfficialShard = stubclass {}
SetLuaDebugLevel = stubclass {}
SetLuaProfilingEnabled = stubclass {}
GetLuaProfilingEnabled = stubclass {}
ReloadModule = stubclass {}
ReloadTemplates = stubclass {}
ShutdownServer = stubclass {}
ForceBackup = stubclass {}
ResetPermanentObjectStates = stubclass {}
LoadSeeds = stubclass {}
CreatePrefab = stubclass {}
SaveSeedGroup = stubclass {}
GetAllSeedGroups = stubclass {}
GetSeedGroupData = stubclass {}
GetSeedGroupCount = stubclass {}
LuaDebugCallStack = stubclass {}
GetUserdataType = stubclass {}
GetRegionAddress = stubclass {}
GetModName = stubclass {}
GetClusterRegions = stubclass {}
CanSetAccountProp = stubclass {}
GlobalVarWrite = stubclass {}
GlobalVarDelete = stubclass {}
GlobalVarRead = stubclass {}
GlobalVarListRecords = stubclass {}
SendRemoteMessage = stubclass {}
DestroyAllObjects = stubclass {}
DiceRoll = stubclass {}
DebugGetAvgFrameTime = stubclass {}
GetLuaExtensionsEnabled = stubclass {}
DebugResetUpdateCounts = stubclass {}
DebugDumpUpdateCounts = stubclass {}
