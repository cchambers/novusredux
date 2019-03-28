
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
		Name = tostring(rune:GetName()),
		Rune = rune
	}

	table.insert(runeList, RuneData)
	user:SystemMessage("Rune copied to Rune Book!","info")
	user:SendMessage("OpenRuneBook", this)
	rune:MoveToContainer(this,Loc())
	SetRuneList(runeList)
	OpenRuneBook(user)
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
	local count = CountTable(runeList)
	this:SetObjVar("RuneCount", count)
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

function TryAddRuneToRuneBook(rune, user)
	local runename = rune:GetName()
	if ( runename ~= nil ) then
		if ( HasRuneNamed(runename) ) then
			user:SystemMessage("This Rune Book already has a rune with that name.","info")
		else
			AddRune(rune, user)
		end
	else
		user:SystemMessage("Name this rune (double-click) before adding to the book.", "info")
		return
	end
end

function TryAddRecallScrollToRuneBook(scroll, user)
	local charges = this:GetObjVar("Charges") or 0
	local stack = scroll:GetObjVar("StackCount") or 1
	if ((stack + mScrollCount) > mScrollMax) then
		user:SystemMessage("You have filled this Rune Book's Recall charges.", "info")
		stack = stack - (mScrollMax - mScrollCount)
		this:SetObjVar("Charges", mScrollMax)
		scroll:SetObjVar("StackCount", stack)
		CallFunctionDelayed(TimeSpan.FromSeconds(0.5), function ()
			SetItemTooltip(scroll)
		end)
	else 
		local total = charges + stack
		this:SetObjVar("Charges", total)
		user:SystemMessage("You have added Recall charges to this Rune Book.", "info")
		scroll:Destroy()
	end
	OpenRuneBook(user)
end

function TryAddPortalScrollToRuneBook(scroll, user)
	local charges = this:GetObjVar("PortalCharges") or 0
	local stack = scroll:GetObjVar("StackCount") or 1
	if ((stack + mScrollCount) > mScrollMax) then
		user:SystemMessage("You have filled this Rune Book's Portal charges.", "info")
		stack = stack - (mScrollMax - mScrollCount)
		this:SetObjVar("PortalCharges", mScrollMax)
		scroll:SetObjVar("StackCount", stack)
		CallFunctionDelayed(TimeSpan.FromSeconds(0.5), function ()
			SetItemTooltip(scroll)
		end)
	else 
		local total = charges + stack
		this:SetObjVar("PortalCharges", total)
		user:SystemMessage("You have added Portal charges to this Rune Book.", "info")
		scroll:Destroy()
	end
	OpenRuneBook(user)
end

function HasRuneNamed(runename)
	local runes = this:GetObjVar("RuneList") or {}
	for k,v in pairs(runes) do
		if (v.Name == runename) then
			return true
		end
	end
	return false
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
			OpenRuneBook(user)
		end
	end)


RegisterEventHandler(EventType.Message, "AddRune", 
	function(runeName, user)
		AddRune(runeName, user)
		if ( user ) then
			user:SystemMessage("Rune "..runeName.." added to runebook.","info")
		end
	end)

RegisterEventHandler(EventType.Message, "AddRuneScroll", 
	function(scroll, user)
		local runeName = scroll:GetObjVar("Rune")
		if ( runeName ) then
			AddRune(runeName, user)
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

RegisterEventHandler(EventType.Message, "HandleDrop", 
	function (user,obj)
		if(obj:HasObjVar("Destination")) then
			TryAddRuneToRuneBook(obj,user)
		end

		if(obj:HasObjVar("ResourceType")) then
			if (obj:GetObjVar("ResourceType") == "Recall") then
				TryAddRecallScrollToRuneBook(obj,user) 
			elseif (obj:GetObjVar("ResourceType") == "Portal") then
				TryAddPortalScrollToRuneBook(obj,user) 
			end
		end
	end)
