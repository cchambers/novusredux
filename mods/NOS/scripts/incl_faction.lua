require 'incl_player_titles'

--[[
	All of this functionallity needs to be CLEANED UP! -KH 2/3/18
]]

function GetFactionFromName (factionName)
	for i,j in pairs(Factions) do 
		if (j.Name == factionName) then
			return j
		end
	end
end

function GetFactionMinFriendlyLevel(factionName)
	local faction = GetFactionFromInternalName(factionName) or this:GetObjVar("MobileTeamType")
	return faction.MinFriendlyLevel
end

function GetFactionFromInternalName (factionName)
	--DebugMessage("factionName is "..tostring(factionName))
	for i,j in pairs(Factions) do 
		--DebugMessage("j.InternalName is "..tostring(j.InternalName))
		if (j.InternalName == factionName) then
			--DebugMessage("Returning last entry")
			return j
		end
	end
	--DebugMessage("Returning nil")
end

function GetFactionTitle(player,amount,factionName)
	if (player == nil or not player:IsValid()) then return end
	--DebugMessage(1)
	--DebugMessage("Arguments: "..tostring(player)..tostring(amount)..tostring(factionName))
	local faction = GetFactionFromInternalName(factionName)
	local title = ""
	local description = "[88888]This title has no description[-]"
	local handle = ""
	--DebugMessage(2)
	--DebugMessage("This should appear")
	--[[
	if(AllTitles.FactionTitles[factionName] ~= nil) then
		for i,j in pairs(AllTitles.FactionTitles[factionName]) do
				--DebugMessage(2.5)
				--DebugMessage(DumpTable(j))
				if (amount >= j[2] and amount < j[3]) then
					--DebugMessage("HIT ______________________")
					--DebugMessage(DumpTable(j))
					title = j[1]
					description = j[4]
					handle = faction.InternalName
					--DebugMessage(4)
				end
		end
	end]]

	--DebugMessage("RETURNING: "..tostring(title).." "..tostring(description).." "..tostring(handle))
	return title,description,handle
end


function AssignTitle(target,amount,factionName)
	--DebugMessage("Target AssignTitle")
	if (not target:IsPlayer() or amount > 50 or amount < -50) then
		return
	end
	--DebugMessage("Assigning ... "..tostring(target))
	local title,description,handle = GetFactionTitle(target,amount,factionName)
	--DebugMessage("RESULTS: "..tostring(title).." "..tostring(description).." "..tostring(handle))

	--DebugMessage("Adding title")
	--[[if (not PlayerTitles.HasTitle(target,title)) then
		PlayerTitles.Entitle(target,title,false,description,handle)
	end]]
end

function StartFactionDecay(player,factionName)
	if not(player:HasModule("player_faction_decay")) then
    	player:AddModule("player_faction_decay")
    else
    	player:SendMessage("StartFactionDecay",factionName)
    end
end

function ChangeFactionByAmount(player,amount,factionName)
	--[[
	--DebugMessage("player="..tostring(player).." amount="..tostring(amount).." factionName="..tostring(factionName))
	if (factionName == nil) then factionName = this:GetObjVar("MobileTeamType") end
	if (player == nil or not player:IsValid()) then return end
	if (not player:IsPlayer()) then return end
	player:SendMessage("FactionUpdate")

	--DebugMessage("2 "..tostring(factionName))
	local faction = GetFactionFromInternalName(factionName)
	local currentFactionAmount = GetFaction(player,factionName) or 0
	local newFactionAmount = math.min(100,math.max(-50,currentFactionAmount + amount))
	if (faction == nil) then LuaDebugCallStack("ERROR: Invalid faction specified in script!!!") return end
	--if (currentFactionAmount == nil) then SetFactionToAmount(player,newFactionAmount,factionName) return end

	--DebugMessage("Args 1 are"..tostring(player)..tostring(newFactionAmount)..tostring(factionName))
	local title = GetFactionTitle(player,newFactionAmount,factionName)
	AssignTitle(player,newFactionAmount,factionName)
	--DebugMessage("Changing faction by amount")

	if (amount < 0) then
		if (not player:HasObjVar(factionName.."Favorability")) then 
			player:SetObjVar(factionName.."Favorability",amount)
			if (amount > faction.MinFriendlyLevel) then
				player:SystemMessage("You now have a poor repute with the " ..faction.Name.."! ("..title..")" , "event")
	        else
	        	player:SystemMessage("[$1870]" ..faction.Name.."! ("..title..")" , "event")
	        end
	        return
		end

		if (newFactionAmount >= faction.MinFriendlyLevel ) then
	        player:SystemMessage("You have lost repute with the " ..faction.Name.."! ("..title..")" , "event")
		elseif (newFactionAmount < faction.MinFriendlyLevel  and currentFactionAmount > faction.MinFriendlyLevel ) then
	        player:SystemMessage("[$1871]" ..faction.Name.."! ("..title..")[-]" , "event")
	    end

	elseif (amount > faction.MinFriendlyLevel ) then
		if (not player:HasObjVar(factionName.."Favorability")) then 
			player:SetObjVar(factionName.."Favorability",amount)
			player:SystemMessage("You now have repute with the " ..faction.Name.."! ("..title..")" , "event")
	        return
		end

		if (newFactionAmount > faction.AcceptanceLevel and currentFactionAmount < faction.AcceptanceLevel) then
	        player:SystemMessage("You have now been [00F700]accepted[-] by the " ..faction.Name.."! ("..title..")" , "event")
		elseif (newFactionAmount >= faction.MinFriendlyLevel  ) then
	        player:SystemMessage("You have gained repute with the " ..faction.Name.."! ("..title..")" , "event")
		elseif (newFactionAmount < faction.MinFriendlyLevel  ) then
	        player:SystemMessage("[$1872]" ..faction.Name.."! ("..title..")" , "event")
	    end
	end
	--Set bind point to dead gate if you are hostile with that faction and you are binded to their territory.
	CheckBindPoint(player,faction,newFactionAmount)

	player:SetObjVar(factionName.."Favorability",newFactionAmount)

	if(amount < 0 and newFactionAmount < 0) then
		-- start faction decay if the amount is negative
	    StartFactionDecay(player,factionName)
    end]]
end

function CheckBindPoint(user,faction,amount)
	local bindObject = FindObjectWithTag("OutcastSpawnPosition")
	if (amount < faction.MinFriendlyLevel and bindObject ~= nil) then		
		local bindPoint = GetPlayerSpawnPosition(user)
		
		local inRegion = false
		local neutralBindPoint = bindObject:GetLoc()
		for i,j in pairs(faction.Zones) do
			if (IsLocInRegion(bindPoint,j)) then
				inRegion = true
			end
		end
		if (inRegion) then
			user:SystemMessage("[$1873]")
			user:SystemMessage("[$1874]","event")
			user:SendMessage("BindToLocation",neutralBindPoint,true) 			
		end
	end
end

function SetFactionToAmount(player,amount,factionName)
	--[[
	--DebugMessage("Changing Faction")
	if (factionName == nil) then factionName = this:GetObjVar("MobileTeamType") end
	if (player == nil or not player:IsValid()) then return end
	if (not player:IsPlayer()) then return end
	player:SendMessage("FactionUpdate")
	--DebugMessage("1 "..tostring(factionName))
	local title = GetFactionTitle(player,amount,factionName)
	local faction = GetFactionFromInternalName(factionName)
	--DebugMessage("Args 2 are"..tostring(player)..tostring(amount)..tostring(factionName))
	AssignTitle(player,amount,factionName)

	amount = math.min(faction.MaxFaction,math.max(faction.MinFaction,amount))

	if (amount > faction.MinSpecialTitleLevel) then
	    player:SystemMessage("You have now become a "..title.."!" , "event")
	elseif (amount > faction.AcceptanceLevel) then
	    player:SystemMessage(" You are now been [00F700]accepted[-] by the " ..faction.Name.."! ("..title..")" , "event")
	elseif (amount >= faction.MinFriendlyLevel  ) then
	    player:SystemMessage("You are now of some repute with the " ..faction.Name.."! ("..title..")" , "event")
	elseif (amount < faction.MinFriendlyLevel  ) then
	    player:SystemMessage(" You are now [F70000]hostile[-] with the " ..faction.Name.."! ("..title..")" , "event")

	end

	player:SetObjVar(factionName.."Favorability",amount)

	if(amount < 0) then
		StartFactionDecay(player,factionName)
	end]]
end

function GetFaction(player,factionName)
	if (player == nil) then return -1 end
	if (factionName == nil) then factionName = this:GetObjVar("MobileTeamType") end
	if (factionName == nil) then return 0 end
	local faction = player:GetObjVar(factionName.."Favorability") or 0
	return faction
end
