
mOpen = false
mScrollCount = 5
mScrollMax = 40
mRuneMax = 20

function AddRune(rune, user)
	local runeList = this:GetObjVar("RuneList") or {}
	local count = 0
	for k,v in pairs(runeList) do
		count = count + 1
	end
	if (count >= mRuneMax ) then
		user:SystemMessage("That Rune Book is full.","info")
		return
	end

	local RuneData = {
		Name = this:GetName(),
		Destination = this:GetObjVar("Destination"),
		DestinationFacing = this:GetObjVar("DestinationFacing"),
		Region = this:GetObjVar("RegionAddress"),
	}

	table.insert(runeList, RuneData)
	user:SystemMessage("Rune copied to Rune Book!","info")
	SetRuneList(runeList)
end

-- function AddAllRunes()
-- 	for runeName,runeData in pairs(RuneData.AllRunes) do
-- 		if(runeData.RuneEnabled) then
-- 			runeList[runeName] = true
-- 		end
-- 	end

-- 	SetRuneList(runeList)
-- end

function SetRuneList(runeList)
	this:SetObjVar("RuneList", runeList);
	this:SetObjVar("RuneCount", CountTable(runeList))
	UpdateTooltip()
end

function UpdateTooltip()
	SetTooltipEntry(this,"rune_count", "Contains "..(this:GetObjVar("RuneCount") or 0).." runes")
end

function OpenRuneBook(user) 
	if not( user:HasModule("runebook_dynamic_window") ) then
		user:AddModule("runebook_dynamic_window")
	end
	user:SendMessage("OpenRuneBook", this)
end

function TryAddRuneToRunebook(runebook, rune, user)
	if ( runebook == nil ) then return end
	if ( runebook:HasModule("runebook") ) then
		local runename = rune:GetName()
		if ( runename == nil ) then
			if ( HasRuneNamed(runebook, runeName) ) then
				user:SystemMessage("Runebook already has a rune with that name.","info")
			else
				AddRune(rune)
			end
		else
			user:SystemMessage("Name this rune (double-click) before adding to the book.", "info")
			return
		end
	else
		user:SystemMessage("That is not a runebook.","info")
	end
end


function TryAddScrollToRunebook(runebook, scroll, user)

end

function HasRuneNamed(runebook, runename)
	if ( runebook == nil or runename == nil or runename == "" ) then return false end
	local runes = runebook:GetObjVar("RuneList")

	for k,v in pairs(runes) do

	end
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
				OpenRuneBook(user)
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
			TryAddScrollToRunebook(this,obj,user)
		end
	end)