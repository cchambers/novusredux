local doDestroy = this:GetObjVar("DoDestroy")

if(this:HasModule('player')) then
	for i,equipObj in pairs(this:GetAllEquippedObjects()) do
		local equipSlot = GetEquipSlot(equipObj)
		if(equipSlot == "Bank" or equipSlot == "Backpack" or equipSlot == "TempPack") then
			local contObjects = equipObj:GetContainedObjects()
         	for index, contObj in pairs(contObjects) do
         		DebugMessage("Destroying container object "..contObj:GetCreationTemplateId())
         		if(doDestroy) then
	         		contObj:Destroy()
	         	end
         	end	
		elseif not(equipSlot:match("BodyPart")) then
			DebugMessage("Destroying equipment object "..equipObj:GetCreationTemplateId())
     		if(doDestroy) then
         		equipObj:Destroy()
         	end
		end
	end
elseif(this:GetObjVar('ResourceType') == 'PlotController') then
	Plot.ForeachLockdown(this,
		function (item)
			DebugMessage("Destroying house object "..item:GetCreationTemplateId())
     		if(doDestroy) then
         		item:Destroy()
         	end
		end)
end