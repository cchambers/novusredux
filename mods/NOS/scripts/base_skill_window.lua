require 'default:base_skill_window'

function AddSkillDetail(dynamicWindow,position,pageTypeIndex)
	--DebugMessage("AddSkillDetail",tostring(position),tostring(pageTypeIndex))
	local curX = (position - 1) * 312

	local skillInfo = GetAllSkills()[pageTypeIndex]
	if(skillInfo) then
		dynamicWindow:AddImage(curX + 188,48,"SkillIconsFrame",102,102)

		local skillIcon = skillInfo.Data.SkillIcon or ("Skill_"..string.sub(skillInfo.Name,1,-6))
		dynamicWindow:AddImage(curX + 206,66,skillIcon,66,66)

		dynamicWindow:AddImage(curX + 146,150,"Prestige_TitleHeader")
		dynamicWindow:AddLabel(curX + 240,153,"[43240f]"..GetSkillDisplayName(skillInfo.Name).."[-]",146,28,28,"center",false,false,"Kingthings_Dynamic")
		dynamicWindow:AddImage(curX + 114,186,"Prestige_Divider",250,0,"Sliced")

		dynamicWindow:AddLabel(curX + 114,204,"[412A08]"..(skillInfo.Data.Description or "").."[-]",250,110,18,"",false,false,"PermianSlabSerif_Dynamic_Bold")

		dynamicWindow:AddImage(curX + 114,308,"Prestige_Divider",250,0,"Sliced")

		-- dynamicWindow:AddSkillSlider(curX + 122,330,skillInfo.Name,GetSkillCap(this,skillInfo.Name),GetSkillMaxAttained(this,skillInfo.Name),372)
		dynamicWindow:AddButton(curX + 114,314,"","",250,100,"[$3371]","",false,"Invisible")

		if(skillInfo.Data.Abilities) then
			local curAbilityX = curX + 120
			for i, abilityName in pairs(skillInfo.Data.Abilities) do
				local curAction = GetPrestigeAbilityUserAction(this, nil,"Skills",abilityName)
				dynamicWindow:AddUserAction(curAbilityX,248,curAction,52)
				curAbilityX = curAbilityX + 40
			end
		end

		local displayString = "Track Skill"
		if ( HasSkillInTracker(skillInfo.Name)) then
			displayString = "Untrack Skill"
		end
		--dynamicWindow:AddButton(curX + 188,352,"ToggleTrackSkill|"..skillInfo.Name,displayString,90,22,"Track/Untrack the progress of this skill.",nil,false,"List")	

		local trackState = ""
		if(HasSkillInTracker(skillInfo.Name)) then
			trackState = "pressed"
		end
		dynamicWindow:AddButton(curX + 307,51,"ToggleTrackSkill|"..skillInfo.Name,"",22,22,"Tracked skills appear on the game HUD.","",false,"Track",trackState)

		local favState = ""
		if(IsFavoriteSkill(skillInfo.Name)) then
			favState = "pressed"
		end
		dynamicWindow:AddButton(curX + 327,50,"ToggleFavorite|"..skillInfo.Name,"",22,22,"Favorite skills are shown on the first page of the skill book.","",false,"Star",favState)
	end
end
