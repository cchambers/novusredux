
mOpen = false
mScrollCount = 5
mScrollMax = 40

function AddRune(runeName)
	if ( runeName == nil ) then
		DebugMessage("[runebook|AddRune] ERROR: runeName is nil")
		return
	end
	local found = false
	for k,v in pairs(RuneData.AllRunes) do
		if ( k == runeName ) then
			found = true
		end
	end
	if not( found ) then
		DebugMessage("[runebook|AddRune] ERROR: invalid rune '"..runeName.."' provided")
		return
	end
	local runeList = this:GetObjVar("RuneList") or {}
	runeList[runeName] = true
	SetRuneList(runeList)
end

function AddAllRunes()
	runeList = {}
	for runeName,runeData in pairs(RuneData.AllRunes) do
		if(runeData.RuneEnabled) then
			runeList[runeName] = true
		end
	end

	SetRuneList(runeList)
end

function SetRuneList(runeList)
	this:SetObjVar("RuneList", runeList);
	this:SetObjVar("RuneCount", CountTable(runeList))
	UpdateTooltip()
end

function UpdateTooltip()
	SetTooltipEntry(this,"rune_count", "Contains "..(this:GetObjVar("RuneCount") or 0).." runes")
end

UpdateTooltip()

RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
	function()
		AddUseCase(this,"Open", true)
		if ( initializer ~= nil and initializer.Runes ~= nil ) then
			if ( initializer.Runes == "All" ) then
				AddAllRunes()
			else
				SetRuneList(initializer.Runes)
			end
		end
		this:SetObjVar("HandlesDrop",true)
	end)

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if ( usedType == "Open" or usedType == "Use" ) then
			this:PlayObjectSound("Use", true)
			OpenRuneBook(user,this)
		end
	end)


RegisterEventHandler(EventType.Message, "AddRune", 
	function(runeName, user)
		AddRune(runeName)
		if ( user ) then
			user:SystemMessage("Rune "..runeName.." added to runebook.","info")
		end
	end)

RegisterEventHandler(EventType.Message, "AddRuneScroll", 
	function(scroll, user)
		local runeName = scroll:GetObjVar("Rune")
		if ( runeName ) then
			AddRune(runeName)
			scroll:SendMessage("AdjustStack", -1)
			if ( user ) then
				user:SystemMessage("Rune "..runeName.." added to runebook.","info")
				local castingSkill = RuneData.AllRunes[runeName].Skill
				local mPageType = castingSkill == "ManifestationSkill" and "ManifestationIndex" or "EvocationIndex"
				OpenRuneBook(user,this,mPageType)
			end
		else
			if ( user ) then
				user:SystemMessage("Failed to add scroll to runebook, scroll does not have a rune.","info")
			end
		end
	end)

RegisterEventHandler(EventType.Message, "LoadRunes", 
	function()
		AddAllRunes()
	end)

RegisterEventHandler(EventType.Message,"HandleDrop", 
	function (user,obj)
		if(obj:HasObjVar("Destination")) then
			TryAddRuneToRunebook(this,obj,user)
		end

		if(obj:HasObjVar("ResourceType") and obj:GetObjVar("ResourceType") == "Recall") then

		end
	end)