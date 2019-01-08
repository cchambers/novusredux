require 'default:globals.helpers.pets'

function MaxActivePetSlots(master)
    local slots = GetSkillLevel(master, "BeastmasterySkill")/10 or 1
    if (slots < 4) then slots = 4 end
    -- master:SystemMessage(tostring("You can control " .. slots .. " slots worth of pets."))
	return slots
end

function MaxStabledPetSlots(master)
	return 30 -- all pets count as 1
end

function CorrectPetStats(localPet)
    if(localPet ~= nil) then
        -- DebugMessage(IsPet(localPet))
        -- DebugMessage(localPet)
        --DebugMessage(localPet:GetObjVar("TemplateId"))
        
        local templateId = localPet:GetCreationTemplateId()
        local petPetSlots = GetTemplateObjVar(templateId, "PetSlots")
        if(petPetSlots ~= nil) then localPet:SetObjVar("PetSlots", petPetSlots) end
        
        local petBaseHealth = GetTemplateObjVar(templateId, "BaseHealth")
        if(petBaseHealth ~= nil) then localPet:SetObjVar("BaseHealth", petBaseHealth) end
        
        local petArmor = GetTemplateObjVar(templateId, "Armor")
        if(petArmor ~= nil) then localPet:SetObjVar("Armor", petArmor) end

        local petAttack = GetTemplateObjVar(templateId, "Attack")
        if(petAttack ~= nil) then localPet:SetObjVar("Attack", petAttack) end
        
        local petPower = GetTemplateObjVar(templateId, "Power")
        if(petPower ~= nil) then localPet:SetObjVar("Power", petPower) end
        
        local templateData = GetTemplateData(templateId)
        -- DebugMessage(" --- templateData:")
        -- if(templateData ~= nil) then
        --     for i, v in pairs(templateData) do
        --         DebugMessage(i.." : "..tostring(v))
        --     end
        -- end

        -- Disabled updating Name because of choice.
        --local petName = templateData.Name
        --if(petName ~= nil) then localPet:SetObjVar("Name", petName) end
        
        local petSpeed = templateData.BaseSpeed
        -- BRYCE, CHECK THIS
        -- if(petSpeed ~= nil) then localPet:SetBaseMoveSpeed(petSpeed) end
        
        -- Disabled updating Scale because of choice.
        --local petScale = GetTemplateObjectScale(templateId)
        --if(petScale ~= nil) then localPet:SetScale(petScale) end
        
        --DebugMessage(" --- LuaModules:")
        if(templateData.LuaModules ~= nil) then
            for i, v in pairs(templateData.LuaModules) do
                --DebugMessage(i.." : "..tostring(v))
                if(string.find(i, "ai_")) then
                    --DebugMessage("    AI MODULE FOUND:")
                    if (v.Stats) then
                    --DebugMessage("    Stats:")
                        for statName, statValue in pairs(v.Stats) do
                            if(statValue ~= nil and statName ~= nil) then 
                                --DebugMessage(statName.." : "..tostring(statValue))
                                SetStatByName(localPet, statName, statValue)	
                            end
                        end
                    else
                    
                    -- DebugMessage("    Skills:")
                    -- for ii, vv in pairs(v.Skills) do
                    --     DebugMessage(ii.." : "..tostring(vv))
                    -- end
                end
            end
        end
        
        --SendMobileDataToDebugMessage(localPet)

        -- We might be able to use the below to correctly update Character Info screen data..  But there is a scope issue it may not be accessible.
        -- dirtyTable = {
        --     Strength = true,
        --     Agility = true,
        --     Intelligence = true,
        --     Constitution = true,
        --     Wisdom = true,
        --     Will = true,
        --     Accuracy = true,
        --     Evasion = true,
        --     Attack = true,
        --     Power = true,
        --     Force = true,
        --     Defense = true,
        --     AttackSpeed = true,
        --     CritChance = true,
        --     CritChanceReduction = true,
        --     MoveSpeed = true,
        --     MountMoveSpeed = true,
        -- }
        -- MarkStatsDirty(dirtyTable)
    end
end

function SendMobileDataToDebugMessage(localMobile)
    -- This method is used to pump a lot of gameobject and template data into the console.

    if(localMobile == nil) then
        DebugMessage("The mobile provided is nil, not possible to get any data off of it.")
    else
        DebugMessage(" ========================================= ")
        DebugMessage(" === Start SendMobilDataToDebugMessage === ")
        local templateId2 = localMobile:GetCreationTemplateId()
        if(templateId2 ~= nil) then 
            DebugMessage(" --- templateId2: ")
            DebugMessage(templateId2)
        end
        local test = localMobile:GetObjVar("TemplateName")
        if(test ~= nil) then
            DebugMessage(" --- test: ")
            DebugMessage(test)
        end
        local test2 = GetTemplateObjectName(templateId2)
        if(test2 ~= nil) then
            DebugMessage(" --- test2: ")
            DebugMessage(test2)
        end
        local petScale = GetTemplateObjectScale(templateId2)
        if(petScale ~= nil) then 
            DebugMessage(" --- Template Scale:")
            DebugMessage(petScale) 
        end
        local petScale2 = localMobile:GetScale()
        if(petScale2 ~= nil) then 
            DebugMessage(" --- GameObject Scale:")
            DebugMessage(petScale2) 
        end
        local test3 = GetUserdataType(localMobile)
        if(test3 ~= nil) then
            DebugMessage(" --- test3: ")
            DebugMessage(test3)
        end

    DebugMessage(" --- localMobile:GetAllObjVars:")
        if(localMobile ~= nil) then
            for i, v in pairs(localMobile:GetAllObjVars()) do
                DebugMessage(i.." : "..tostring(v))
            end
        end

        -- DebugMessage(" --- localMobile:GetObjectTags:")
        -- if(localMobile ~= nil) then
        --     for i, v in pairs(localMobile:GetObjectTags()) do
        --         DebugMessage(i.." : "..tostring(v))
        --     end
        -- end

        -- DebugMessage(" --- localMobile:GetAllSharedObjectProperties:")
        -- if(localMobile ~= nil) then
        --     for i, v in pairs(localMobile:GetAllSharedObjectProperties()) do
        --         DebugMessage(i.." : "..tostring(v))
        --     end
        -- end

        -- DebugMessage(" --- localMobile:GetAllEquippedObjects:")
        -- if(localMobile ~= nil) then
        --     for i, v in pairs(localMobile:GetAllEquippedObjects()) do
        --         DebugMessage(i.." : "..tostring(v))
        --     end
        -- end

        -- DebugMessage(" --- localMobile:GetAllStats:")
        -- if(localMobile ~= nil) then
        --     for i, v in pairs(localMobile:GetAllStats()) do
        --         DebugMessage(i.." : "..tostring(v))
        --     end
        -- end

        -- Used to get the Initializer table from the template file for the provided module_name.
        -- GetInitializerFromTemplate(templateId2, module_name)

        --DebugMessage(ass(templateData.BaseHealth).." : "..ass(templateData.Armor).." : "..ass(templateData.Attack).." : "..ass(templateData.Power).." : "..ass(templatedata.ScaleModifier).." : "..ass(templateData.BaseRunSpeed))
        --local statTable = GetStatTableFromTemplate(template,templateData)

        -- petSpeed = templateData.BaseRunSpeed 
        -- petScale = templateData.ScaleModifier

        DebugMessage(" ==== End SendMobilDataToDebugMessage ==== ")
        DebugMessage(" ========================================= ")
    end
end