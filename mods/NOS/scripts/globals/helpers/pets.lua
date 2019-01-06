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
        -- DebugMessage(templateId)
        
        -- DebugMessage(GetTemplateData(templateId).Name)
        local petPetSlots = GetTemplateObjVar(templateId, "PetSlots")
        local petBaseHealth = GetTemplateObjVar(templateId, "BaseHealth")
        local petArmor = GetTemplateObjVar(templateId, "Armor")
        local petAttack = GetTemplateObjVar(templateId, "Attack")
        local petPower = GetTemplateObjVar(templateId, "Power")
        
        -- TODO Correct BaseRunSpeed and ScaleModifier.  I can't figure out how to access them.
        -- local petSpeed = GetTemplateObjVar(templateId, "BaseRunSpeed")
        -- local petScale = GetTemplateObjVar(templateId, "ScaleModifier")

        -- TODO Redo this method with these things..  I didn't figure out how to get it to access properly.
         --local templateData = GetTemplateData(templateId)	
         --DebugMessage(ass(templateData.BaseHealth).." : "..ass(templateData.Armor).." : "..ass(templateData.Attack).." : "..ass(templateData.Power).." : "..ass(templatedata.ScaleModifier).." : "..ass(templateData.BaseRunSpeed))
         --local statTable = GetStatTableFromTemplate(template,templateData)
        
        -- petSpeed = templateData.BaseRunSpeed 
        -- petScale = templateData.ScaleModifier

        -- TODO Correct Stats (str, agi, con, etc.)  I didn't figure out how to access them properly.
        -- local petAgi = GetAgi(this)
        -- local petStr = GetStr(this)
        -- local petInt = GetInt(this)
        -- local petCon = GetCon(this)
        -- local petWis = GetWis(this)
        -- local petWill = GetWill(this)


        -- DebugMessage(ass(petPetSlots).." : "..ass(petBaseHealth).." : "..ass(petArmor).." : "..ass(petAttack).." : "..ass(petPower).." : "..ass(petSpeed).." : ")
        -- DebugMessage(petAgi," : ",petStr," : ",petInt," : ",petCon," : ",petWis," : ",petWill)

        if(petPetSlots ~= nil) then localPet:SetObjVar("PetSlots", petPetSlots) end
        if(petBaseHealth ~= nil) then localPet:SetObjVar("BaseHealth", petBaseHealth) end
        if(petArmor ~= nil) then localPet:SetObjVar("Armor", petArmor) end
        if(petAttack ~= nil) then localPet:SetObjVar("Attack", petAttack) end
        if(petPower ~= nil) then localPet:SetObjVar("Power", petPower) end
        --if(petSpeed ~= nil) then localPet:SetObjVar("BaseRunSpeed", petSpeed) end
        --if(petScale ~= nil) then localPet:SetObjVar("ScaleModifier", templateData.ScaleModifier) end

        --  Updating stats (agi, str) did not work, and I don't know why.
        -- if(petAgi ~= nil) then SetAgi(localPet,petAgi) end
        -- if(petStr ~= nil) then SetStr(localPet,petStr) end
        -- if(petInt ~= nil) then SetInt(localPet,petInt) end
        -- if(petCon ~= nil) then SetCon(localPet,petCon) end
        -- if(petWis ~= nil) then SetWis(localPet,petWis) end
        -- if(petWil ~= nil) then SetWil(localPet,petWil) end
    end
end

function ass(value)
    if(value ~= nil) then
        return value
    end
    return ""
end
