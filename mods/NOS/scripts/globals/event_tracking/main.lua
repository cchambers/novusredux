--[[ 
	key: UserId.PlayerId.Info
	playerRecord = {
		Name = nil,
		DisplyName = nil,
		Skills = 
		{
			{ Name = nil, SkillLevel = nil }
		},
		Prestige = 
		{
			Class = nil,
			Level = nil,
		}
		Equipment = {
			Chest = { Name = nil, Tooltip = nil, ClientId = nil, TemplateId = nil },
			...
		}
		GuildId = nil,
		HouseLocation = { Region = nil, Loc = nil }

	}

	key: UserId.PlayerId.DeathEvents
	deathEventLookup = {
		... list of death event ids ...
	}

	key: GuildId
	guildRecord = {
		Name = nil,
		Tag = nil,
		Allegiance = nil,
		Roster = {
			{PlayerKey=UserId.ObjectId,Rank="Emissary"}
		}
	}

	key: RegionAddress.Date.Time
	deathEventRecord = {
		Location = nil,
		ObjectId = nil,   
		MobName = nil,
		UserId = nil, (if player)
		CreationTemplateId = nil (if mob)
		ItemsDropped = {
			{ Name = nil, Tooltip = nil, ClientId = nil, TemplateId = nil },
			{ Name = nil, Tooltip = nil, ClientId = nil, TemplateId = nil },
		}
		PlayerAssists = {
			{
				AssistType = nil, (Damage/Healing)
				AssistAmount = nil,
				PlayerId = nil,
			}
			...
		}
	}

	
]]

EventTracking = {
	TrackingEnabled = (json ~= nil),

	GetPlayerRecord = function(playerObj)
		local skillList = {}
		local skillDict = playerObj:GetObjVar("SkillDictionary") or {}
		for skillName, skillInfo in pairs(skillDict) do
			skillList[skillName] = skillInfo.SkillLevel
		end

		local equipList = {}
		for i,slotName in pairs(ITEM_SLOTS) do 
			local equipObj = playerObj:GetEquippedObject(slotName)
			if(equipObj ~= nil) then
				equipList[slotName] = EventTracking.GetItemTable(equipObj)
			end
		end

		local housingRecordId = playerObj:GetAttachedUserId() .. ".Housing"
	 	local housingRecord = GlobalVarRead(housingRecordId)
	 	local houseTable = nil
	 	if(housingRecord ~= nil and housingRecord.Owned ~= nil and #housingRecord.Owned > 0) then
	 		houseTable = { housingRecord.Owned[1].Region }
			if ( housingRecord.Owned[1].HouseObj and housingRecord.Owned[1].HouseObj:IsValid() ) then
		 		local loc = housingRecord.Owned[1].HouseObj:GetLoc()
				houseTable.Location = { loc.X or 0, loc.Z or 0 }
			end
	 	end

		return {
			Name = playerObj:GetName(),
			DisplayName = playerObj:GetSharedObjectProperty("DisplayName"),
			GuildId =  playerObj:GetObjVar("Guild"),
			Karma = playerObj:GetObjVar("Karma"),
			Skills = skillList,
			Equipment = equipList,
			House = houseTable,
			Time = DateTime.UtcNow:ToString() -- so we have a 'last updated at'
		}
	end,

	GetPlayerKey = function (playerObj)
		local attachedUserId = playerObj:GetAttachedUserId()
		if ( attachedUserId ) then
			return attachedUserId .. "." .. playerObj.Id		
		end
	end,

	UpdatePlayerRecord = function (playerObj)		
		-- We check here to avoid the work of building the record
		if(EventTracking.TrackingEnabled) then
			local playerKey = EventTracking.GetPlayerKey(playerObj)
			if(playerKey) then
				EventTracking.UpdateRecord("Player:"..playerKey,EventTracking.GetPlayerRecord(playerObj))
			end
		end
	end,

	GetGuildRecord = function (guildData)
		local roster = {}
		for id,entry in pairs(guildData.Members) do
			table.insert(roster,{
				PlayerKey = "Player."..entry.UserId .. "." .. id,
				Rank = entry.AccessLevel
			})
		end
		return { Name=guildData.Name, Tag=guildData.Tag, Roster=roster }
	end,

	UpdateGuildRecord = function (guildData)
		-- We check here to avoid the work of building the record
		if(EventTracking.TrackingEnabled) then
			local guildKey = "Guild."..guildData.Id
			EventTracking.UpdateRecord(guildKey,EventTracking.GetGuildRecord(guildData))
		end
	end,	

	RecordDeathEvent = function(deadMob,killer)
		-- We check here to avoid the work of building the record
		if not(EventTracking.TrackingEnabled) then
			return
		end

		local deathTime = DateTime.UtcNow:ToString()
		local deathLoc = deadMob:GetLoc()
		local deathTable = {
			Location = {deathLoc.X,deathLoc.Z},
			WorldName = ServerSettings.WorldName,
			SubRegion = ServerSettings.SubregionName or "",
			RegionAddress = ServerSettings.RegionAddress,
			ObjectId = deadMob.Id,
			Time = deathTime,
		}

		local isPlayer = IsPlayerCharacter(deadMob)

		if( isPlayer ) then
			deathTable.UserId = deadMob:GetAttachedUserId()
		else
			deathTable.MobName = deadMob:GetName()
			deathTable.CreationTemplateId = deadMob:GetCreationTemplateId()
			deathTable.MobKind = deadMob:GetObjVar("MobileKind")
			if ( deadMob:GetSharedObjectProperty("IsBoss") ) then
				deathTable.Heroic = true
			end
		end

		-- only care what players are wearing
		if( isPlayer ) then
			deathTable.Equipment = {}
			for i,slotName in pairs(ITEM_SLOTS) do 
				local equipObj = deadMob:GetEquippedObject(slotName)
				if(equipObj ~= nil) then
					deathTable.Equipment[slotName] = EventTracking.GetItemTable(equipObj)
				end
			end
		end

		local dropList = {}
		local backpackObj = deadMob:GetEquippedObject("Backpack")
		if(backpackObj) then
			for i,contObj in pairs(backpackObj:GetContainedObjects()) do 
				table.insert(dropList,EventTracking.GetItemTable(contObj))
			end
		end
		deathTable.ItemsDropped = dropList

		local assists = {}
		local damagers = deadMob:GetObjVar("Damagers")
		if(damagers) then 
			for damagerObj,damagerEntry in pairs(damagers) do 
				if(damagerObj:IsValid()) then 
					local assistType = "Damage"
					if(killer == damagerObj) then
						assistType = "Kill"
					end

					local assist = {
						AssistType = assistType,
						AssistAmount = damagerEntry.Amount,
					}

					if( IsPlayerCharacter(damagerObj) ) then
						local playerKey = EventTracking.GetPlayerKey(damagerObj)
						if(playerKey) then
							assist.PlayerId = playerKey
						end
					else
						assist.MobName = StripFromString(damagerObj:GetName()," Corpse") -- prevent storing name of the mob as a corpse.
						assist.CreationTemplateId = damagerObj:GetCreationTemplateId()
					end
					table.insert(assists,assist)
				end
			end
		end

		local healers = deadMob:GetObjVar("Healers")
		if(healers) then 
			for healerObj,healerEntry in pairs(healers) do 
				if(healerObj:IsValid()) then 
					local assist = {
						AssistType = "Heal",
						AssistAmount = healerEntry.Amount,
					}

					-- dont bother with mob heals
					if( IsPlayerCharacter(healerObj) ) then
						local playerKey = EventTracking.GetPlayerKey(healerObj)
						if(playerKey) then
							assist.PlayerId = playerKey
							table.insert(assists,assist)
						end
					end
				end
			end
		end
		deathTable.Assists = assists

		EventTracking.AddToListRecord("DeathEventDetails",deathTable)
	end,

	GetItemTable = function(item)
		if not(item) then
			LuaDebugCallStack("ERROR EventTracking.GetItemTable")
			return
		end

		local tooltipStr = item:GetSharedObjectProperty("TooltipString") or ""
		return {Name=item:GetName(),Value=GetItemValue(item),Tooltip=tooltipStr,IconId=item:GetIconId(),Template=item:GetCreationTemplateId()}
	end,

	-- These functions are the actual hooks into the statistics database

	-- This function sends the record data to the event tracking database. If the record already exist it replaces otherwise it creates
	UpdateRecord = function (key,recordData)
		if not(recordData) then
			LuaDebugCallStack("[EventTracking.UpdateRecord] recordData not provided.")
			return
		end
		-- Call C# function to update the record
		do return SetEvent(key, json.encode(recordData)) end
		
		
		local fileName = "EventDetails.log"
		local regionAddress = ServerSettings.RegionAddress
		if(regionAddress) then
			fileName = regionAddress.."."..fileName
		end
		file = io.output(fileName,"a+")
		io.write("r "..key.." "..jsonData)
		file:close()
	end,

	-- This function sends the record data to the event tracking database. If the record already exist it appends to the list otherwise it creates a new record with one entry
	AddToListRecord = function(key,recordData)
		if not(recordData) then
			LuaDebugCallStack("ERROR EventTracking.AddToListRecord")
			return
		end
		do return SortedSetEvent(key, json.encode(recordData)) end
		

		local fileName = "EventDetails.log"
		local regionAddress = ServerSettings.RegionAddress
		if(regionAddress) then
			fileName = regionAddress.."."..fileName
		end
		file = io.output(fileName,"a+")
		io.write("l "..key.." "..jsonData)
		file:close()
	end,
}