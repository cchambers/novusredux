function UpdateName(paName)
	paName = paName or this:GetObjVar("PrestigeAbility")

	local oldName,color = StripColorFromString(this:GetName())
	this:SetName(color..paName.." Ability Training Book[-]")
end

function UpdateTooltip(paName)
	paName = paName or this:GetObjVar("PrestigeAbility") or "Blank"

	local paData = GetPrestigeAbility(nil,paName)
	local tooltip = GetPrestigeAbilityTooltip(paData)
	if(tooltip) then
		local prereq = BuildPrestigePrerequisitesString(paData)

		SetTooltipEntry(this,"ability",tooltip.."\n\nRequires:\n"..prereq)
	end
end

function SetBook(paName)
	if(paName) then
		this:SetObjVar("PrestigeAbility",paName)
		UpdateName(paName)
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

			newWindow:AddLabel(30,10,"Set Ability ",0,0,16)
			newWindow:AddTextField(20,30,400,20,"ability")
		    newWindow:AddButton(430, 25, "Enter", "Enter")  

		    user:OpenDynamicWindow(newWindow,this)
		    
	    	RegisterSingleEventHandler(EventType.DynamicWindowResponse,"SetAbility",
				function(user,buttonId,fieldData)
					if(buttonId == "Enter") then
						local name = "Blank"
						local tooltip = ""
						if(fieldData.ability and fieldData.ability ~= "") then							
							name = fieldData.ability
						end

						SetBook(name)						
					end
				end)
		end
	end)

RegisterEventHandler(EventType.Message,"SetBook",
	function (name)
		SetBook(name)
	end)