require 'incl_combat_abilities'
require 'incl_player_window'
require 'incl_player_names'

charWindowData = {}

function GetEquipSlotUserAction(equipSlot,targetObj,displayName)
	-- no need to send the target obj option if its for the local player	
	local id = equipSlot
	local serverCommand = "equipSlotClicked " .. equipSlot
	if(targetObj ~= nil and targetObj ~= this) then
		id = targetObj.Id.."|"..equipSlot
		serverCommand = "equipSlotClicked " .. equipSlot .. " " .. targetObj.Id
	end
	--DebugMessage("displayName is "..tostring(displayName))
	return {
		ID=id,
		ActionType="EquipSlot",
		DisplayName=displayName,
		Tooltip=displayName,
		Enabled=true,
		ServerCommand=serverCommand,
	}
end

function CanSeeStats(targetObj)
	if(targetObj == this or IsDemiGod(this)) then return true end	
	
	return IsController(this, targetObj)
end

function OnClose(targetObj)
	charWindowData[targetObj] = nil
	UnregisterEventHandler("",EventType.DynamicWindowResponse,"Character"..targetObj.Id)
end

function AddStatEntry(subwindow,curY,targetObj,statName,fullStatName,tooltip,statGainStatus)
	if(statGainStatus) then
		subwindow:AddButton(174,curY,"Toggle"..fullStatName,"",0,0,"","",false,"UpDownLock",GetStatGainState(statGainStatus,fullStatName))
	end

	local labelStr
	if ( targetObj == this ) then
		local base = GetBaseStatValue(targetObj, statName)
		local val = targetObj:GetStatValue(statName)
		local diff = val - base
		if ( base > 0 and ( diff < 0 or diff > 0 ) ) then
			if ( diff > 0 ) then
				labelStr = string.format("(+%d) [STAT:%s]", diff, statName)
			else
				labelStr = string.format("(%d) [STAT:%s]", diff, statName)
			end
		else
			labelStr = string.format("[STAT:%s]", statName)
		end
	else
		labelStr = tostring(math.round(targetObj:GetStatValue(statName), 2))
	end
	subwindow:AddLabel(166,curY,"[412A08]"..labelStr.."[-]",100,0,16,"right");
	subwindow:AddButton(0,curY,"","",170,14,tooltip,"",false,"Invisible")
end

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
		local buttonState = (charWindowData[targetObj].StatTab == "Weapon") and "pressed" or ""
		leftSubwindow:AddButton(90,52,"WeaponTab","",0,0,"","",false,"Radio",buttonState)			
		buttonState = (charWindowData[targetObj].StatTab == "Spell") and "pressed" or ""
		leftSubwindow:AddButton(104,52,"SpellTab","",0,0,"","",false,"Radio",buttonState)	

		if(charWindowData[targetObj].StatTab == "Weapon") then
			leftSubwindow:AddLabel(50,10,"[412A08]Attack[-]",150,0,20,"center",false,false,"SpectralSC-SemiBold")
			local statLabel = (targetObj == this) and "[STAT:Attack]" or tostring(math.round(targetObj:GetStatValue("Attack"),1))
			leftSubwindow:AddLabel(50,30,"[412A08]"..statLabel.."[-]",150,0,22,"center",false,false,"")
			leftSubwindow:AddButton(20,10,"","",60,36,"[$3354]","",false,"Invisible")
			leftSubwindow:AddLabel(140,10,"[412A08]Critical[-]",150,0,20,"center",false,false,"SpectralSC-SemiBold")
			local statLabel = (targetObj == this) and "[STAT:CritChance]" or tostring(math.round(targetObj:GetStatValue("CritChance"),1))
			leftSubwindow:AddLabel(140,30,"[412A08]"..statLabel.."%[-]",150,0,22,"center",false,false,"")	
			leftSubwindow:AddButton(110,10,"","",60,36,"[$3355]","",false,"Invisible")		
		else
			leftSubwindow:AddLabel(50,10,"[412A08]Power[-]",150,0,20,"center",false,false,"SpectralSC-SemiBold")
			local statLabel = (targetObj == this) and "[STAT:Power]" or tostring(math.round(targetObj:GetStatValue("Power"),1))
			leftSubwindow:AddLabel(50,30,"[412A08]"..statLabel.."[-]",150,0,22,"center",false,false,"")
			leftSubwindow:AddButton(20,10,"","",60,36,"[$3352]","",false,"Invisible")
			leftSubwindow:AddLabel(140,10,"[412A08]Affinity[-]",150,0,20,"center",false,false,"SpectralSC-SemiBold")
			local statLabel = (targetObj == this) and "[STAT:ManaRegen]" or tostring(math.round(GetManaRegen(targetObj),1))
			leftSubwindow:AddLabel(140,30,"[412A08]"..statLabel.."[-]",150,0,22,"center",false,false,"")
			leftSubwindow:AddButton(110,10,"","",60,36,"[$3353]","",false,"Invisible")		
		end

		leftSubwindow:AddLabel(10,68,"[412A08][$1677][-]",150,0,16,"",false,false,"SpectralSC-SemiBold")
		curY = 68		
		AddStatEntry(leftSubwindow,curY,targetObj,"AttackSpeed","[$3356]")
		curY = curY + 16
		AddStatEntry(leftSubwindow,curY,targetObj,"Accuracy","[$3357]")
		curY = curY + 16
		AddStatEntry(leftSubwindow,curY,targetObj,"Defense","[$3358]")
		curY = curY + 16
		AddStatEntry(leftSubwindow,curY,targetObj,"Evasion","[$3359]")

		leftSubwindow:AddImage(10,136,"Scroll_Divider",174,0,"Sliced")
		leftSubwindow:AddLabel(10,146,"[412A08][$1676][-]",150,0,16,"",false,false,"SpectralSC-SemiBold")
		local curY = 146
		local statGainStatus = GetStatGainStatus(targetObj)
		AddStatEntry(leftSubwindow,curY,targetObj,"Str","Strength","[$3360]",statGainStatus)
		curY = curY + 16
		AddStatEntry(leftSubwindow,curY,targetObj,"Agi","Agility","[$3361]",statGainStatus)
		curY = curY + 16
		AddStatEntry(leftSubwindow,curY,targetObj,"Int","Intelligence","[$3362]",statGainStatus)
		curY = curY + 16
		AddStatEntry(leftSubwindow,curY,targetObj,"Con","Constitution","[$3363]",statGainStatus)
		curY = curY + 16
		AddStatEntry(leftSubwindow,curY,targetObj,"Wis","Wisdom","[$3364]",statGainStatus)
		curY = curY + 16
		AddStatEntry(leftSubwindow,curY,targetObj,"Will","Will","[$3365]",statGainStatus)

		if(targetObj == this) then
			leftSubwindow:AddLabel(100,244,"[412A08][STAT:Str+Agi+Int+Con+Wis+Will] / "..ServerSettings.Stats.TotalPlayerStatsCap.."[-]",150,0,16,"center",false,false,"")
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
	rightSubwindow:AddButton(10,10,"ToggleGuild","Guild|"..(Guild.GetName(targetObj) or "No Guild"),160,40,"","",false,"ScrollTitleText")

	rightSubwindow:AddButton(10,60,"ToggleAllegiance","Allegiance|"..(GetPlayerAllegianceName(targetObj) or "No Allegiance"),160,40,"","",false,"ScrollTitleText")
	
	local title = StripColorFromString(targetObj:GetSharedObjectProperty("Title"))
	if(title == "") then
		title = "No Title"
	end
	rightSubwindow:AddButton(10,110,"ToggleTitle","Title|"..title,160,40,"","",false,"ScrollTitleText")

	local bio = targetObj:GetObjVar("BioString") or "No Bio"
	rightSubwindow:AddButton(10,160,"EditBio","Bio|"..bio,186,100,"","",false,"ScrollTitleText")
	
	--[[
	local karmaLevel = GetKarmaLevel(GetKarma(targetObj))
	local title = string.format(karmaLevel.Title, StripColorFromString(targetObj:GetName()))
	rightSubwindow:AddLabel(10,160,title,190,40,14,"left",false,false,"SpectralSC-SemiBold")
	]]
	
	dynWindow:AddSubwindow(rightSubwindow)

	dynWindow:AddPortrait(-90,70,180,270,targetObj,"full")	

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

	local name = ColorizePlayerName(targetObj, StripColorFromString(targetObj:GetName()))
	dynWindow:AddLabel(0,361,name,0,0,22,"center",false,false,"SpectralSC-SemiBold")

	this:OpenDynamicWindow(dynWindow)	

	RegisterEventHandler(EventType.DynamicWindowResponse,"Character"..targetObj.Id, function(...) HandleCharacterWindowResponse(targetObj,...) end)
end

function OpenWriteBioDialog()
	local newWindow = DynamicWindow("WriteBioWindow","Write Bio",400,240,200,200,"Default","TopLeft")

	local currentContents = this:GetObjVar("BioString")

	newWindow:AddTextField(30, 15, 320,120, "contents", currentContents)
	
	newWindow:AddButton(30, 150, "Write", "Write", 150, 0, "", "", false)
	newWindow:AddButton(200, 150, "Cancel", "Cancel", 150, 0, "", "", true)
	--newWindow:AddButton(x, y, "CancelImprovement", "Cancel", 200, 0, "Stop Attempting to Improve the item.", "", false)
	this:OpenDynamicWindow(newWindow)

	RegisterEventHandler(EventType.DynamicWindowResponse,"WriteBioWindow",HandleBioWindowResponse)
end

function HandleCharacterWindowResponse(targetObj,user,buttonId)
	if(buttonId == "ToggleGuild") then
		if(targetObj == this) then
			GuildInfo()
		end
	elseif(buttonId == "ToggleAllegiance" ) then
		if(targetObj == this) then
			AllegianceInfo()
		end
	elseif(buttonId == "ToggleTitle") then
		if(targetObj == this) then
			ToggleTitleWindow(this)
		end
	elseif(buttonId == "EditBio") then
		if(targetObj == this) then
			OpenWriteBioDialog()
		end
	elseif(buttonId == "WeaponTab") then
		if(charWindowData[targetObj].StatTab ~= "Weapon") then
			charWindowData[targetObj].StatTab = "Weapon"
			UpdateCharacterWindow(targetObj)
		end
	elseif(buttonId == "SpellTab") then
		if(charWindowData[targetObj].StatTab ~= "Spell") then
			charWindowData[targetObj].StatTab = "Spell"
			UpdateCharacterWindow(targetObj)
		end
	elseif(buttonId == "ToggleSkills") then
		if(targetObj == this) then
			ToggleSkillWindow()
		end
	elseif(buttonId == "TogglePrestige") then
		if(targetObj == this) then
			TogglePrestigeWindow()
		end
	elseif(buttonId == "ToggleKeyRing") then
		if(targetObj == this) then
			UpdateKeyRingWindow()
		end
	elseif(buttonId:match("Toggle")) then
		local statName = buttonId:sub(7)
		if(statName and targetObj == this) then
			ToggleStatGainState(this,statName)		
		end
	elseif(buttonId == "") then
		OnClose(targetObj)
	end
end

function HandleBioWindowResponse(user,buttonId,fields)
	if(buttonId == "Write" and fields.contents ~= nil and fields.contents ~= "") then
		-- dont allow colors in guild names
		newBio = StripColorFromString(fields.contents)

		if (string.len(fields.contents) > 150) then
	 		this:SystemMessage("Your bio must be shorter than 150 characters.")
	 		return
	 	end

	 	if (fields.contents:match("[^ a-zA-Z0-9.,?!']")) then
		    this:SystemMessage("Your bio can not contain any special characters.")
	 		return
		end

		if(ServerSettings.Misc.EnforceBadWordFilter and HasBadWords(fields.contents)) then
	 		this:SystemMessage("You bio can not contain foul language.")
	 		return
	 	end

    	this:SetObjVar("BioString",newBio)
    	UpdateCharacterWindow()    	
    end	        

    this:CloseDynamicWindow("WriteBioWindow")
    UnregisterEventHandler("",EventType.DynamicWindowResponse,"WriteBioWindow")
end

function OpenInspectWindow(targetObj)
	if not(charWindowData[targetObj]) then
		UpdateCharacterWindow(targetObj)
	end
end

RegisterEventHandler(EventType.Message,"UpdateCharacterWindow",function ()
	if(charWindowData[this] and charWindowData[this].Open) then
		UpdateCharacterWindow()
	end
end)

RegisterEventHandler(EventType.Message,"OpenCharacterWindow",function ()
	if not(charWindowData[this] and charWindowData[this].Open) then
		UpdateCharacterWindow()
	end
end)

RegisterEventHandler(EventType.ClientUserCommand,"ToggleCharacterWindow",
	function()
		if not(charWindowData[this] and charWindowData[this].Open) then
			UpdateCharacterWindow()
		else
			this:CloseDynamicWindow("Character"..this.Id)
			OnClose(this)			
		end
	end)