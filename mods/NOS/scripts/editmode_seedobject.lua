require 'NOS:editmode_seedobject_UI'

customCreateHandlers = 
{
	simple_mob_spawner = function (seedData)
		local template = seedData.Template
		local templateData = GetTemplateData(template)		

		if(seedData.ObjVarOverrides and seedData.ObjVarOverrides["spawnTemplate"]) then
			spawnTemplate = seedData.ObjVarOverrides["spawnTemplate"]						
			spawnTemplateData = GetTemplateData(spawnTemplate)		
			templateData.Name = templateData.Name.." ["..(spawnTemplateData and spawnTemplateData.Name or "None").."]"
		end

		InitializeSeedFromTemplate(template,templateData)

        -- DAB TODO: Show actual mob to be spawned
		--local statTable = GetStatTableFromTemplate(template,templateData)
		--if(statTable ~= nil) then
		--	EquipMobile(statTable.EquipTable,nil,false)		
		--end
	end
}

function InitializeSeedFromTemplate(template,templateData)	
	templateData = templateData or GetTemplateData(template)

	this:SetAppearanceFromTemplate(template)
	this:SetColor(templateData.Hue)
	this:SetName(templateData.Name)	

	this:SetObjVar("ScaleModifier",templateData.ScaleModifier or 1	)	
end

function UpdateTooltip(seedEntry)
	seedEntry = seedEntry or GetSeedEntry(this)

	SetTooltipEntry(this,"seed_template", "Template: "..seedEntry.Template, 99)
	SetTooltipEntry(this,"seed_group", "Group: "..seedEntry.Group,100)
end

RegisterEventHandler(EventType.ModuleAttached,"editmode_seedobject",
	function ()		
		AddUseCase(this,"Edit",true)		
		AddUseCase(this,"Delete")		

		if(initializer.SeedEntry.Group ~= nil) then
			this:SetObjVar("SeedGroup",initializer.SeedEntry.Group)
		end
		if(initializer.SeedEntry.SeedId ~= nil) then
			this:SetObjVar("SeedId",initializer.SeedEntry.SeedId)
		end

		if(customCreateHandlers[initializer.SeedEntry.Template] ~= nil) then
			customCreateHandlers[initializer.SeedEntry.Template](initializer.SeedEntry)
		else
			InitializeSeedFromTemplate(initializer.SeedEntry.Template)
		end

		UpdateTooltip(initializer.SeedEntry)
	end)

RegisterEventHandler(EventType.Message,"UseObject",
	function (user,usedType)
		if(usedType == "Edit") then
			DoEditWindow(user,"Transform")			
		end
	end)

RegisterEventHandler(EventType.ClientObjectCommand, "transform",
	function (user,targetId,identifier,command,...)
		if(command == "confirm") then
			local targetObj = GameObj(tonumber(targetId))
			if(targetObj:IsValid()) then
				local commandArgs = table.pack(...)

				local newPos = Loc(tonumber(commandArgs[1]),tonumber(commandArgs[2]),tonumber(commandArgs[3]))
				local newRot = Loc(tonumber(commandArgs[4]),tonumber(commandArgs[5]),tonumber(commandArgs[6]))
				local newScale = Loc(tonumber(commandArgs[7]),tonumber(commandArgs[8]),tonumber(commandArgs[9]))

				targetObj:SetWorldPosition(newPos)
				targetObj:SetRotation(newRot)
				targetObj:SetScale(newScale)

				DoEditWindow(user)
			end

		end
		DebugMessage("ClientObjectCommand transform",identifier,command,...)		
	end)

RegisterEventHandler(EventType.Message,"UpdateTooltip",
	function ( ... )
		UpdateTooltip()
	end)