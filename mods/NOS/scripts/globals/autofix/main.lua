
AutoFixes = {}


function DoPlayerAutoFix(player)
    return
end

function DoWorldAutoFix(clusterController)
   return
end

function AutoFixReplaceItem(item, template, cb)
    local containedBy = item:ContainedBy()
    local loc = item:GetLoc()
    if ( containedBy ) then
        -- replace in container, easy peasy.
        Create.InContainer(template, containedBy, loc, cb)
    else
        -- replace when locked down, little more difficult.
        local controller = Plot.GetAtLoc(loc)
        if ( controller and controller:IsValid() ) then
            Create.AtLoc(template, loc, function(itm)
                itm:SetObjVar("LockedDown",true)
                itm:SetObjVar("NoReset",true)
                itm:SetObjVar("PlotController", controller)
                SetTooltipEntry(itm,"locked_down","Locked Down",98)
                
                local house = Plot.GetHouseAt(controller, loc, false, true) -- checking roof bounds
                if ( house ) then
                    itm:SetObjVar("PlotHouse", house)
                end
                
                if ( itm:DecayScheduled() ) then
                    itm:RemoveDecay()
                end
                if ( cb ) then cb(itm) end
            end)
        else
            if ( cb ) then cb(nil) end
        end
    end
    item:Destroy()
end