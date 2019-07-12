
-- --- Mounts used to allow anyone that owned it to dismiss it into a statue, not anymore.
-- -- this will cause all current mounts to act as pet statues
-- local index = #AutoFixes + 1
-- local totalItems = 0
-- local containers = 0

-- AutoFixes[index] = {
--     DoFix = function(object)
--         if ( not object or not object:IsValid() ) then return end

--         local resourceType = object:GetObjVar("ResourceType")
--         if ( resourceType ~= nil ) then
--             if ( resourceType == "MountStatue" ) then
--                 if ( object:HasObjVar("Blessed") ) then
--                     -- Purpousely breaking any that were created from a statue first so we can find and fix later.
--                     object:SetObjVar("ResourceType", "TEMPREALHORSESTATUE")
--                 else
--                     object:SetObjVar("ResourceType", "PetStatue")
--                     object:SetName("[FF9500]Pet Statue[-]")
--                 end
--                 totalItems = totalItems + 1
--                 object:DelObjVar("TooltipInfo")
--                 SetItemTooltip(object)
--             end
--         end

--         -- recurse
--         if ( object:IsContainer() ) then
--             containers = containers + 1
--             local items = object:GetContainedObjects() or {}
--             for i=1,#items do
--                 if ( items[i] and items[i]:IsValid() ) then
--                     AutoFixes[index].DoFix(items[i])
--                 end
--             end
--         end
        
--     end,
-- }

-- AutoFixes[index].Player = function(player)
--     ForeachMobileAndPet(player, AutoFixes[index].DoFix)
-- end

-- AutoFixes[index].World = function(clusterController)
--     local worldObjects = FindObjects(SearchObjectsInWorld(),clusterController)
--     local before = DateTime.UtcNow
--     DebugMessage("[AutoFix] "..#worldObjects.." World Objects found.")
--     for i=1,#worldObjects do
--         AutoFixes[index].DoFix(worldObjects[i])
--     end
--     DebugMessage("[AutoFix] World Objects Done. TotalMS: "..DateTime.UtcNow:Subtract(before).TotalMilliseconds)
--     DebugMessage("[AutoFix] "..totalItems.." Total item tooltips Updated.")
--     DebugMessage("[AutoFix] "..containers.." Total containers.")
-- end