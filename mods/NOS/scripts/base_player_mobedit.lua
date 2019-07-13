-- DAB TODO: This is a control panel for all the mob editing windows. One day we should combine them all into a single unified UI

mobEditTarget = nil

function DoMobEdit(targetObj)
    local buttons = {"Edit Char","Edit Appearance","Edit Sequence"}

    local newWindow = DynamicWindow("editmob","Edit "..targetObj:GetName(),200+42,70 + (#buttons*26),0,0,"")
    local startY = 5
    for i,buttonData in pairs(buttons) do
        local yVal = startY + (i-1)*26
        
        newWindow:AddButton(10, yVal, buttonData, buttonData, 200, 26, "", "", false,"List")
    end
    this:OpenDynamicWindow(newWindow)

    mobEditTarget = targetObj
end

RegisterEventHandler(EventType.DynamicWindowResponse,"editmob",
    function (user,buttonId)
        if(buttonId ~= nil) then
            if(buttonId == "Edit Char") then
                OpenCharEditWindow(mobEditTarget)
            elseif(buttonId == "Edit Appearance") then
                this:AddModule("custom_char_window",{Target=mobEditTarget, EditGear=true})
            elseif(buttonId == "Edit Sequence") then
                if not(mobEditTarget:HasModule("npc_anim_controller")) then
                    mobEditTarget:AddModule("npc_anim_controller",{User=this})
                else
                    mobEditTarget:SendMessage("OpenAnimEdit",user)
                end
            end
        end
    end)