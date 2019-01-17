require 'default:base_player_charwindow'

-- Defense is hard-baked in at 45.  This was an attempt at making it display 45 lower than it's supposed to..  it worked.
--  However...  this would not correct any of the issues with damage calculations, and it would destroy the balance.
-- function AddDefenseEntry(subwindow,curY,targetObj,statName,fullStatName,tooltip,statGainStatus)
-- 	if(statGainStatus) then
-- 		subwindow:AddButton(174,curY,"Toggle"..fullStatName,"",0,0,"","",false,"UpDownLock",GetStatGainState(statGainStatus,fullStatName))
-- 	end

-- 	local labelStr
-- 	if ( targetObj == this ) then
-- 		local base = GetBaseStatValue(targetObj, statName)
-- 		DebugMessage("Begin")
-- 		DebugMessage(targetObj)
-- 		DebugMessage(base)
-- 		DebugMessage(statName)
-- 		local val = targetObj:GetStatValue(statName)
-- 		DebugMessage(val)
-- 		local diff = val - base - 45
-- 		DebugMessage(diff)
-- 		if ( base > 0 and ( diff < 0 or diff > 0 ) ) then
-- 			if ( diff > 0 ) then
-- 				labelStr = string.format("(+%d) [STAT:%s]", diff, statName)
-- 			else
-- 				labelStr = string.format("(%d) [STAT:%s]", diff, statName)
-- 			end
-- 		else
-- 			labelStr = string.format("[STAT:%s]", diff, statName)
-- 		end
-- 	else
-- 		DebugMessage("2")
-- 		local defVal = targetObj:GetStatValue(statName) - 45
-- 		DebugMessage(defVal)
-- 		labelStr = tostring(math.round(targetObj:GetStatValue(statName) - 45, 2))
-- 	end
-- 	local labelX = 170
-- 	if not(statGainStatus) then
-- 		labelX = 180
-- 	end
-- 	DebugMessage(labelStr)
-- 	subwindow:AddLabel(labelX,curY+2,"[412A08]"..labelStr.."[-]",100,0,18,"right",false,false,"PermianSlabSerif_Dynamic_Bold");
-- 	subwindow:AddButton(0,curY,"","",170,14,tooltip,"",false,"Invisible")
-- end

-- function AddStatEntry(subwindow,curY,targetObj,statName,fullStatName,tooltip,statGainStatus)
-- 	if(statGainStatus) then
-- 		subwindow:AddButton(174,curY,"Toggle"..fullStatName,"",0,0,"","",false,"UpDownLock",GetStatGainState(statGainStatus,fullStatName))
-- 	end

-- 	local labelStr
-- 	if ( targetObj == this ) then
-- 		local base = GetBaseStatValue(targetObj, statName)
-- 		local val = targetObj:GetStatValue(statName)
-- 		DebugMessage(tostring(statName .. " > " .. base .. " x " .. val))
-- 		local diff = val - base
-- 		if ( base > 0 and ( diff < 0 or diff > 0 ) ) then
-- 			if ( diff > 0 ) then
-- 				labelStr = string.format("(+%d) [STAT:%s]", diff, statName)
-- 			else
-- 				labelStr = string.format("(%d) [STAT:%s]", diff, statName)
-- 			end
-- 		else
-- 			labelStr = string.format("[STAT:%s]", statName)
-- 		end
-- 	else
-- 		labelStr = tostring(math.round(targetObj:GetStatValue(statName), 2))
-- 	end
-- 	local labelX = 170
-- 	if not(statGainStatus) then
-- 		labelX = 180
-- 	end
-- 	subwindow:AddLabel(labelX,curY+2,"[412A08]"..labelStr.."[-]",100,0,18,"right",false,false,"PermianSlabSerif_Dynamic_Bold");
-- 	subwindow:AddButton(0,curY,"","",170,14,tooltip,"",false,"Invisible")
-- end

function UpdateCharacterWindow(targetObj)
	targetObj = targetObj or this

	if not(charWindowData[targetObj]) then
		charWindowData[targetObj] = { StatTab = "Weapon" }
	end
	charWindowData[targetObj].Open=true

	local dynWindow = DynamicWindow("Character"..targetObj.Id,"",0,0,0,-200,"Character","Center")

	-- The character window has to have 2 subwindows or the content will not appear correctly
	-- so even if you can't see the stats you still have to add an empty subwindow
	local leftSubwindow = Subwindow(0,0)	
	if(CanSeeStats(targetObj)) then		
		--local buttonState = (charWindowData[targetObj].StatTab == "Weapon") and "pressed" or ""
		--leftSubwindow:AddButton(90,52,"WeaponTab","",0,0,"","",false,"Radio",buttonState)			
		--buttonState = (charWindowData[targetObj].StatTab == "Spell") and "pressed" or ""
		--leftSubwindow:AddButton(104,52,"SpellTab","",0,0,"","",false,"Radio",buttonState)	

		--[[if(charWindowData[targetObj].StatTab == "Weapon") then
			leftSubwindow:AddLabel(50,10,"[412A08]Attack[-]",150,0,20,"center",false,false,"PermianSlabSerif_Dynamic_Bold")
			local statLabel = (targetObj == this) and "[STAT:Attack]" or tostring(math.round(targetObj:GetStatValue("Attack"),1))
			leftSubwindow:AddLabel(50,30,"[412A08]"..statLabel.."[-]",150,0,22,"center",false,false,"")
			leftSubwindow:AddButton(20,10,"","",60,36,"[$3354]","",false,"Invisible")
			leftSubwindow:AddLabel(140,10,"[412A08]Critical[-]",150,0,20,"center",false,false,"PermianSlabSerif_Dynamic_Bold")
			local statLabel = (targetObj == this) and "[STAT:CritChance]" or tostring(math.round(targetObj:GetStatValue("CritChance"),1))
			leftSubwindow:AddLabel(140,30,"[412A08]"..statLabel.."%[-]",150,0,22,"center",false,false,"")	
			leftSubwindow:AddButton(110,10,"","",60,36,"[$3355]","",false,"Invisible")		
		else
			leftSubwindow:AddLabel(50,10,"[412A08]Power[-]",150,0,20,"center",false,false,"PermianSlabSerif_Dynamic_Bold")
			local statLabel = (targetObj == this) and "[STAT:Power]" or tostring(math.round(targetObj:GetStatValue("Power"),1))
			leftSubwindow:AddLabel(50,30,"[412A08]"..statLabel.."[-]",150,0,22,"center",false,false,"")
			leftSubwindow:AddButton(20,10,"","",60,36,"[$3352]","",false,"Invisible")
			leftSubwindow:AddLabel(140,10,"[412A08]Affinity[-]",150,0,20,"center",false,false,"PermianSlabSerif_Dynamic_Bold")
			local statLabel = (targetObj == this) and "[STAT:ManaRegen]" or tostring(math.round(GetManaRegen(targetObj),1))
			leftSubwindow:AddLabel(140,30,"[412A08]"..statLabel.."[-]",150,0,22,"center",false,false,"")
			leftSubwindow:AddButton(110,10,"","",60,36,"[$3353]","",false,"Invisible")		
		end]]--

		leftSubwindow:AddLabel(10,4,"[412A08][$1677][-]",150,0,20,"",false,false,"PermianSlabSerif_Dynamic_Bold")
		curY = 4
		AddStatEntry(leftSubwindow,curY,targetObj,"Attack","[$3354]")		
		curY = curY + 19
		AddStatEntry(leftSubwindow,curY,targetObj,"AttackSpeed","[$3356]")
		curY = curY + 19
		AddStatEntry(leftSubwindow,curY,targetObj,"Power","[$3352]")
		curY = curY + 19
		AddStatEntry(leftSubwindow,curY,targetObj,"Affinity","[$3353]")
		curY = curY + 19
		AddStatEntry(leftSubwindow,curY,targetObj,"Defense","[$3358]")
		curY = curY + 19
		leftSubwindow:AddLabel(180,curY+2,"[412A08]"..GetVitalityDisplayString(GetCurVitality(targetObj)).."[-]",100,0,18,"right",false,false,"PermianSlabSerif_Dynamic_Bold");
		leftSubwindow:AddButton(0,curY,"","",170,14,"Vitality reflects how rested you are. Low vitality will result in penalties to your maximum health.","",false,"Invisible")		

		leftSubwindow:AddImage(10,120,"Scroll_Divider",174,0,"Sliced")
		leftSubwindow:AddLabel(10,132,"[412A08][$1676][-]",150,0,20,"",false,false,"PermianSlabSerif_Dynamic_Bold")
		local curY = 132
		local statGainStatus = GetStatGainStatus(targetObj)
		AddStatEntry(leftSubwindow,curY,targetObj,"Str","Strength","[$3360]",statGainStatus)
		curY = curY + 20
		AddStatEntry(leftSubwindow,curY,targetObj,"Agi","Agility","[$3361]",statGainStatus)
		curY = curY + 20
		AddStatEntry(leftSubwindow,curY,targetObj,"Int","Intelligence","[$3362]",statGainStatus)
		curY = curY + 20
		AddStatEntry(leftSubwindow,curY,targetObj,"Con","Constitution","[$3363]",statGainStatus)
		curY = curY + 20
		--AddStatEntry(leftSubwindow,curY,targetObj,"Wis","Wisdom","[$3364]",statGainStatus)
		AddStatEntry(leftSubwindow,curY,targetObj,"Wis","Wisdom","Determines your wisdom of the world.",statGainStatus)
		curY = curY + 20
		AddStatEntry(leftSubwindow,curY,targetObj,"Will","Will","[$3365]",statGainStatus)

		if(targetObj == this) then
			leftSubwindow:AddLabel(100,244,"[412A08][STAT:BaseStr+BaseAgi+BaseInt+BaseCon+BaseWis+BaseWill] / "..ServerSettings.Stats.TotalPlayerStatsCap.."[-]",150,0,18,"center",false,false,"PermianSlabSerif_Dynamic_Bold")
			leftSubwindow:AddButton(70,240,"","",60,20,"[$3366]","",false,"Invisible")		
		end

		--dynWindow:AddButton(136,166,"ToggleAgility","",0,0,"","",false,"UpDownLock",GetStatGainState(statGainStatus,"Agility"))
		--dynWindow:AddLabel(134,396+offset,tostring(GetAgi(targetObj)),100,0,16,"right");
		--dynWindow:AddButton(136,412+offset,"ToggleIntelligence","",0,0,"","",false,"UpDownLock",GetStatGainState(statGainStatus,"Intelligence"))
		--dynWindow:AddLabel(134,412+offset,tostring(GetInt(targetObj)),100,0,16,"right");
		--dynWindow:AddButton(136,380+offset,"ToggleConstitution","",0,0,"","",false,"UpDownLock",GetStatGainState(statGainStatus,"Constitution"))
		--dynWindow:AddLabel(134,380+offset,tostring(GetCon(targetObj)),100,0,16,"right");
		--dynWindow:AddButton(136,396+offset,"ToggleWisdom","",0,0,"","",false,"UpDownLock",GetStatGainState(statGainStatus,"Wisdom"))
		--dynWindow:AddLabel(134,396+offset,tostring(GetWis(targetObj)),100,0,16,"right");
		--dynWindow:AddButton(136,412+offset,"ToggleWill","",0,0,"","",false,"UpDownLock",GetStatGainState(statGainStatus,"Will"))
		--dynWindow:AddLabel(134,412+offset,tostring(GetWill(targetObj)),100,0,16,"right");
	end		
	dynWindow:AddSubwindow(leftSubwindow)

	local rightSubwindow = Subwindow(0,0)
	rightSubwindow:AddButton(10,10,"","Guild|"..(GuildHelpers.GetName(targetObj) or "No Guild"),160,40,"","guild",false,"ScrollTitleText")

	local karmaStr,karmaVal = GetKarmaTitle(targetObj)
	if(targetObj == this) then
		local karmaValStr = tostring(karmaVal)
		if(karmaVal > 0) then
			karmaValStr = "+"..karmaValStr
		end
		local title = GetTitle(targetObj)
		if (karmaStr ~= nil and title ~= nil) then
			karmaStr = title
		end
	end
	rightSubwindow:AddButton(10,60,"","Reputation|"..karmaStr,180,40,"","karma",false,"ScrollTitleText")
	
	local title = StripColorFromString(targetObj:GetSharedObjectProperty("Title"))
	if(title == "") then
		title = "No Title"
	end
	rightSubwindow:AddButton(10,110,"","Title|"..title,160,40,"","achievement",false,"ScrollTitleText")

	local bio = targetObj:GetObjVar("BioString") or "No Bio"
	rightSubwindow:AddButton(10,160,"EditBio","Bio|"..bio,186,100,"","",false,"ScrollTitleText")

	if(targetObj == this) then 
		local next = targetObj:GetObjVar("NextPowerHour")
		local hasNext = next ~= nil
		local now = DateTime.UtcNow
		if (hasNext) then
			canPowerHour = now > next
		else
			canPowerHour = true
		end
		if (canPowerHour) then
			rightSubwindow:AddLabel(10,220,"[412A08]".."Power Hour is ready!",186,15,17,"",false,false,"PermianSlabSerif_Dynamic_Bold")
		else
			rightSubwindow:AddLabel(10,220,"[412A08]".."You can Power Hour again in ",186,15,17,"",false,false,"PermianSlabSerif_Dynamic_Bold")
			rightSubwindow:AddLabel(10,235,"[7C0A02]"..TimeSpanToWords(next:Subtract(now)),186,15,17,"",false,false,"PermianSlabSerif_Dynamic_Bold")
		end
	end
	
	--[[
	local karmaLevel = GetKarmaLevel(GetKarma(targetObj))
	local title = string.format(karmaLevel.Title, StripColorFromString(targetObj:GetName()))
	rightSubwindow:AddLabel(10,160,title,190,40,14,"left",false,false,"PermianSlabSerif_Dynamic_Bold")
	]]
	
	dynWindow:AddSubwindow(rightSubwindow)

	dynWindow:AddPortrait(-90,70,180,270,targetObj,"full")	

	-- jewelry slots
	--dynWindow:AddImage(-92,126,"ItemSlot",18,18)
	dynWindow:AddUserAction(-96,126,GetEquipSlotUserAction("Necklace",targetObj,"Necklace"),32,32,"Circle")
	dynWindow:AddUserAction(-96,156,GetEquipSlotUserAction("Ring",targetObj,"Ring"),32,32,"Circle")

	-- backpack button state encodes the target id
	if(targetObj:GetEquippedObject("Backpack")) then
		local buttonState = targetObj == this and "" or tostring(targetObj.Id)
		dynWindow:AddButton(62,300,"","",0,0,"","",false,"BackpackButton",buttonState)
	end

	if(targetObj == this) then
		dynWindow:AddButton(-90,246,"ToggleSkills","",46,100,"[$3367]","",false,"SkillBook")
		dynWindow:AddButton(-70,250,"TogglePrestige","",46,95,"[$3368]","",false,"PrestigeBook")
		dynWindow:AddButton(62,312,"ToggleKeyRing","",32,32,"[$3369]","",false,"KeyRing")
	end
	local title = GetTitle(targetObj)


	local name = StripColorFromString(targetObj:GetName())
	
	if (title) then name = tostring(title .. " " .. name) end
	dynWindow:AddLabel(0,362,name,220,20,22,"center",false,false,"SpectralSC-SemiBold")

	this:OpenDynamicWindow(dynWindow)	

	RegisterEventHandler(EventType.DynamicWindowResponse,"Character"..targetObj.Id, function(...) HandleCharacterWindowResponse(targetObj,...) end)
end
