function UpdateName(paName,paLevel)
	paName = paName or this:GetObjVar("PrestigeAbility")
	paLevel = paLevel or this:GetObjVar("AbilityLevel")

	local oldName,color = StripColorFromString(this:GetName())
	this:SetName(color..paName.." "..GetLevelText(paLevel).." Ability Training Book[-]")
end

function UpdateTooltip(paName,paLevel)
	paName = paName or this:GetObjVar("PrestigeAbility") or "Blank"
	paLevel = paLevel or this:GetObjVar("AbilityLevel") or 0

	local tooltip = GetPrestigeAbilityTooltip(paName,paLevel)
	if(tooltip) then
		local prereq = BuildPrestigePrerequisitesString(nil,paName,paLevel)	

		SetTooltipEntry(this,"ability",tooltip.."\n\nRequires:\n"..prereq)
	end
end

function SetBook(paName,paLevel)
	if(paName and paLevel) then
		this:SetObjVar("PrestigeAbility",paName)		
		this:SetObjVar("AbilityLevel",paLevel)
		
		UpdateName(paName,paLevel)
		UpdateTooltip(paName)
	end
end

RegisterEventHandler(EventType.ModuleAttached,"prestige_ability_book",
	function ( ... )
		AddUseCase(this,"Examine",true)
		AddUseCase(this,"Set Ability",false,"IsGod")
		UpdateTooltip()
	end)

RegisterEventHandler(EventType.Message,"UseObject",
	function (user,usedType)
		if(usedType == "Examine") then
			local paClass = GetPrestigeAbilityClass(this:GetObjVar("PrestigeAbility"))
			if(paClass) then
				user:SystemMessage("It appears to be a training manual. I should bring this to a "..GetPrestigeDisplayName(paClass).." trainer.","info")
			else
				user:SystemMessage("It appears to be a training manual but the pages are blank.","info")
			end
		elseif(usedType == "Set Ability" and IsGod(user)) then
			local newWindow = DynamicWindow("SetAbility","Set Ability",570,150)

			newWindow:AddLabel(30,10,"Set Ability / Level: ",0,0,16)
			newWindow:AddTextField(20,30,400,20,"ability")
			newWindow:AddTextField(20,60,400,20,"level")
		    newWindow:AddButton(430, 25, "Enter", "Enter")  

		    user:OpenDynamicWindow(newWindow,this)
		    
	    	RegisterSingleEventHandler(EventType.DynamicWindowResponse,"SetAbility",
				function(user,buttonId,fieldData)
					if(buttonId == "Enter") then
						local name = "Blank"
						local level = 1
						local tooltip = ""
						if(fieldData.ability and fieldData.ability ~= "") then							
							name = fieldData.ability
						end
						if(fieldData.level and fieldData.level ~= "") then
							level = fieldData.level
						end

						SetBook(name,level)						
					end
				end)
		end
	end)

RegisterEventHandler(EventType.Message,"SetBook",
	function (name,level)
		SetBook(name,tonumber(level))
	end)