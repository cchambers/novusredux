
--- Adding new 'Secure: Owners/Secure: Friends' context menu option to secure containers.
local index = #AutoFixes + 1
local totalSecure = 0
AutoFixes[index] = {}
AutoFixes[index].World = function(clusterController)
    local worldObjects = FindObjects(SearchObjVar("SecureContainer", true))
    local before = DateTime.UtcNow
    DebugMessage("[AutoFix] "..#worldObjects.." World Objects found via NoReset ObjVar.")
    for i=1,#worldObjects do
        AddUseCase(worldObjects[i], "Secure: Friends", false, "HasHouseControl")
        totalSecure = totalSecure + 1
    end
    DebugMessage("[AutoFix] World Objects Done. TotalMS: "..DateTime.UtcNow:Subtract(before).TotalMilliseconds)
    DebugMessage("[AutoFix] "..totalSecure.." Total Secure Chests Updated With 'Secure: Friends' Tooltip.")
end