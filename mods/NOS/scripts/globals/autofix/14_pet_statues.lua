
-- --- Mounts used to allow anyone that owned it to dismiss it into a statue, not anymore.
-- -- this will cause all current mounts to act as pet statues
-- local index = #AutoFixes + 1
-- local totalItems = 0
-- local containers = 0

-- AutoFixes[index] = {
--     DoFix = function(object)
--         if ( not object or not object:IsValid() ) then return end
        
--         if ( object:GetCreationTemplateId() == "item_statue_mount_horse" and object:GetObjVar("StatueMountTemplate") == "ethereal_horse" ) then
--             object:SetObjVar("ResourceType", "MountStatue")
--             object:SetName("[FF9500]Ethereal Horse Statue[-]")
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