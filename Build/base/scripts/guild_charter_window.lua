local numFoundingMembers = 4
local scrollTarget = nil
local guildMaster = nil

function ValidateForm()
	if(guildMaster ~= this) then
		return
	end

	if not(ValidateScrollTarget()) then
		CloseGuildCharterWindow()
		return
	end

	if(Guild.IsInGuild(this)) then 
		this:SystemMessage("Cannot form. You are already in a guild.","info")
		return
	end

	local signers = scrollTarget:GetObjVar("Signers") or {}
	local foundingMembers = {}
	for i,guildMember in pairs(signers) do
		if(not(guildMember.ObjRef:IsValid()) or this:DistanceFrom(guildMember.ObjRef) > 30) then
			this:SystemMessage("Cannot form. ".. guildMember.Name .. " is not here.","info")
			return
		end
		if(Guild.IsInGuild(guildMember.ObjRef)) then 
			this:SystemMessage("Cannot form. ".. guildMember.Name .. " is already in a guild.","info")
			return
		end
		table.insert(foundingMembers,guildMember.ObjRef)
	end

	return foundingMembers
end

function FormGuild()
	local guildName = scrollTarget:GetObjVar("GuildName")
	local guildTag = scrollTarget:GetObjVar("GuildTag")
	if( not(guildName) or guildName == "" or not(guildTag) or guildTag == "") then
		this:SystemMessage("Cannot form. Guild name is invalid.","info")
		return
	end

	ClientDialog.Show{
        TargetUser = this,
        TitleStr = "Form Guild",
        DialogId = "FormGuild",
        DescStr = "Are you sure you wish to form the guild "..guildName.."?",
        ResponseFunc= function(user,buttonId)
			local buttonId = tonumber(buttonId)
			if(buttonId == 0) then
				local foundingMembers = ValidateForm()
				if(foundingMembers) then	
					Guild.TryCreate(this,guildName,guildTag,foundingMembers)
					scrollTarget:SetObjVar("Memorial",true)
					scrollTarget:SetObjVar("FoundingDate",DateTime.UtcNow)
					UpdateCharter()
				end
			end
        end
    } 
end

function ValidateScrollTarget()
	if not(scrollTarget) or not(scrollTarget:IsValid()) then
		return false
	end

	if not(guildMaster) or not(guildMaster:IsValid()) then
		return false
	end

	if( scrollTarget:TopmostContainer() ~= guildMaster) then
		user:SystemMessage("The guild charter must be in the guildmaster's backpack.","info")
		return false
	end

	if(guildMaster ~= this and this:DistanceFrom(guildMaster) > 30) then
		return false
	end

	return true
end

function CloseGuildCharterWindow()
	this:CloseDynamicWindow("GuildCharter")
	this:DelModule("guild_charter_window")
end
RegisterEventHandler(EventType.Message,"CloseGuildCharter",CloseGuildCharterWindow)

function UpdateCharter(bcastMessage)
	ShowGuildCharterWindow()

	local nearbyCharterUsers = FindObjects(SearchModule("guild_charter_window",30))
	for i,nearbyCharterUser in pairs(nearbyCharterUsers) do
		nearbyCharterUser:SendMessage("UpdateGuildCharter",bcastMessage)
	end
end
RegisterEventHandler(EventType.Message,"UpdateGuildCharter",function(bcastMessage)
		if(bcastMessage) then
			this:SystemMessage(bcastMessage,"info")
		end
		ShowGuildCharterWindow()
	end)

function ShowGuildName()
	if(guildMaster ~= this) then
		return
	end

	if not(ValidateScrollTarget()) then
		CloseGuildCharterWindow()
		return
	end

	TextFieldDialog.Show{
        TargetUser = this,
        Title = "Guild Name",
        DialogId = "GuildName",
        Description = "Enter the guild name.",
        ResponseFunc = function(user,newName)
    		if(guildMaster ~= this) then
				return
			end

			if not(ValidateScrollTarget()) then
				CloseGuildCharterWindow()
				return
			end

        	if(newName ~= nil and newName ~= "") then
        		-- dont allow colors in guild names
        		newName = StripColorFromString(newName)

        		-- DAB TODO: VALIDATE GUILD NAME!
        		if (string.len(newName) < 4) then
			 		this:SystemMessage("The guild name must longer than 3 characters.","info")
			 		return
			 	end

        		if (string.len(newName) > 35) then
			 		this:SystemMessage("The guild name must be less than 36 characters.","info")
			 		return
			 	end

			 	if(#newName:gsub("[%a ]","") ~= 0) then
				    this:SystemMessage("[$1696]","info")
			 		return
				end

        		if(ServerSettings.Misc.EnforceBadWordFilter and HasBadWords(newName)) then
    		 		this:SystemMessage("[$1697]","info")
    		 		return
    		 	end

				--TODO GW hack to use same window id for sub window. Should re-work into proper dynamic window state system.
				CallFunctionDelayed(TimeSpan.FromSeconds(0.25), function()
					ShowGuildTag(newName)
					end)
	        end
        end
    }            
end

function ShowGuildTag(newName)
	if(guildMaster ~= this) then
		return
	end

	if not(ValidateScrollTarget()) then
		CloseGuildCharterWindow()
		return
	end

	TextFieldDialog.Show{
        TargetUser = this,
        Title = "Guild Tag",
        DialogId = "GuildTag",
        Description = "[$1698]",
        ResponseFunc = function(user,tag)
			if(guildMaster ~= this) then
				return
			end

			if not(ValidateScrollTarget()) then
				CloseGuildCharterWindow()
				return
			end

        	if(tag ~= nil and tag ~= "") then
        		-- dont allow colors in guild names
        		tag = StripColorFromString(tag)

        		-- DAB TODO: VALIDATE GUILD NAME!
        		if (string.len(tag) < 2) then
			 		this:SystemMessage("The guild tag must be more than 1 character.","info")
			 		return
			 	end

        		if (string.len(tag) > 4) then
			 		this:SystemMessage("The guild tag must be less than 4 characters.","info")
			 		return
			 	end

			 	if(tag:match("%A")) then
				    this:SystemMessage("The guild tag can only contain letters.","info")
			 		return
				end

        		if(ServerSettings.Misc.EnforceBadWordFilter and HasBadWords(tag)) then
    		 		this:SystemMessage("[$1699]","info")
    		 		return
    		 	end

				if(Guild.IsTagUnique(tag) == false) then
					user:SystemMessage("This guild tag is already in use","info")
					return
				end

				scrollTarget:SetObjVar("GuildName",newName)
				scrollTarget:SetObjVar("GuildTag",tag)

				UpdateCharter()
	        end
        end
    }      
end

function ShowGuildCharterWindow()	
	if not(ValidateScrollTarget()) then
		CloseGuildCharterWindow()
		return
	end

	local isMemorial = scrollTarget:GetObjVar("Memorial")

	local window = DynamicWindow("GuildCharter","",545,751,-300,-300,"TransparentDraggable","Center")
	window:AddButton(498,28,"","",46,28,"","",true,"ScrollClose")
	window:AddImage(-60,-60,"ScrollParchmentUIWindow",0,0)

	window:AddLabel(250,70,"[43240f]Guild Charter[-]",150,0,60,"center",false,false,"Kingthings_Dynamic")

	local guildName = scrollTarget:GetObjVar("GuildName")
	local guildTag = scrollTarget:GetObjVar("GuildTag")
	if not(guildName) then
		window:AddLabel(60,150,"[43240f]Guild Name:[-]",150,0,32,"left",false,false,"Kingthings_Dynamic")
	else
		window:AddLabel(60,150,"[43240f]Guild Name: "..guildName.." |"..guildTag.."|[-]",150,0,32,"left",false,false,"Kingthings_Dynamic")
	end	

	local guildMasterName = StripColorFromString(guildMaster:GetName())
	window:AddLabel(60,190,"[43240f]Guildmaster: "..guildMasterName.."[-]",150,0,32,"left",false,false,"Kingthings_Dynamic")

	window:AddLabel(60,230,"[43240f]Founding Members:[-]",150,0,32,"left",false,false,"Kingthings_Dynamic")

	local curY = 270
	local signers = scrollTarget:GetObjVar("Signers") or {}
	
	for i,guildMember in pairs(signers) do
		window:AddLabel(100,curY,"[43240f]"..guildMember.Name.."[-]",150,0,32,"left",false,false,"Kingthings_Dynamic")
		if(guildMaster == this and not(isMemorial)) then
			window:AddButton(70,curY+4,"Remove|"..tostring(i),"",18,18,"","",false,"Minus")
		end
		curY = curY + 40
	end
	
	if not(isMemorial) then
		if(guildMaster == this) then
			window:AddButton(70,470,"Rename","Edit Guild Name",160,22,"","",false,"List")
			
			if(#signers < numFoundingMembers) then
				window:AddButton(250,470,"Add","Invite Founder",160,22,"","",false,"List")			
			else
				window:AddButton(250,470,"Form","Form Guild",160,22,"","",false,"List")
			end
		else
			local signed = false
			for i,guildMember in pairs(signers) do
				if(guildMember.ObjRef == this) then
					signed = true
					break
				end
			end

			if not(signed) then
				window:AddButton(70,470,"Sign","Sign Guild Charter",340,22,"","",false,"List")
			end
		end
	end

	if not(isMemorial) then
		window:AddLabel(40,520,"[43240f]All four founding members must be present when the guildmaster chooses to ratify the guild charter.[-]",390,120,26,"left",false,false,"Kingthings_Dynamic")
	else
		local foundingDate = scrollTarget:GetObjVar("FoundingDate")
		if(foundingDate) then
			window:AddLabel(40,520,"[43240f]"..guildName.." was founded on ".. foundingDate:ToString("dddd, dd MMMM yyyy") .."[-]",390,120,26,"left",false,false,"Kingthings_Dynamic")		
		end
	end

	this:OpenDynamicWindow(window)
end

function HandleGuildCharterWindowResponse(user,buttonId,helpReportField)	
	--DebugMessage("HandleGuildCharterWindowResponse",tostring(buttonId))

	local isMemorial = scrollTarget:GetObjVar("Memorial")
	if(isMemorial) then
		CloseGuildCharterWindow()
		return
	end

	if ( buttonId == "Rename" ) then
		ShowGuildName()
	elseif( buttonId == "Add") then
		if(guildMaster ~= this) then
			return
		end

		if not(ValidateScrollTarget()) then
			CloseGuildCharterWindow()
			return
		end

		local signers = scrollTarget:GetObjVar("Signers") or {}
		if(#signers < 4) then
			this:RequestClientTargetGameObj(this, "select_founder")
		else
			this:SystemMessage("The charter already has 4 founding members.","info")
		end
	elseif(buttonId == "Sign" ) then
		if not(ValidateScrollTarget()) then
			CloseGuildCharterWindow()
			return
		end

		local signers = scrollTarget:GetObjVar("Signers") or {}
		local signed = false
		for i,guildMember in pairs(signers) do
			if(guildMember == this) then
				signed = true
				break
			end
		end

		if( not(signed) and #signers < 4 ) then
			table.insert(signers,{Name=StripColorFromString(this:GetName()),ObjRef=this})
			scrollTarget:SetObjVar("Signers",signers)
			this:SystemMessage("You have signed the charter.","info")
			UpdateCharter(StripColorFromString(this:GetName()).." has signed the charter.")
		else
			this:SystemMessage("The charter already has 4 founding members.","info")
		end
	elseif(buttonId:match("Remove")) then
		if(guildMaster ~= this) then
			return
		end

		if not(ValidateScrollTarget()) then
			CloseGuildCharterWindow()
			return
		end

		local memberIndex = tonumber(buttonId:sub(8))
		local signers = scrollTarget:GetObjVar("Signers") or {}
		local memberInfo = signers[memberIndex]
		if(memberInfo) then
			table.remove(signers,memberIndex)
			scrollTarget:SetObjVar("Signers",signers)		

			memberInfo.ObjRef:SendMessage("CloseGuildCharter")
			UpdateCharter()
		end
	elseif(buttonId == "Form") then
		FormGuild()
	else
		CloseGuildCharterWindow()
		return
	end
end

RegisterEventHandler(EventType.DynamicWindowResponse,"GuildCharter",HandleGuildCharterWindowResponse)
RegisterEventHandler(EventType.ClientTargetGameObjResponse, "select_founder", 
	function (target)
		if(target:IsPlayer()) then
			if(guildMaster ~= this) then
				return
			end

			if not(ValidateScrollTarget()) then
				CloseGuildCharterWindow()
				return
			end

			if(Guild.IsInGuild(target)) then 
				this:SystemMessage("That person is already in a guild.","info")
				return
			end

			if(target:HasModule("guild_charter_window")) then
				this:SystemMessage("That person is already considering signing a guild charter.","info")
				return
			end

			local guildMasterName = StripColorFromString(this:GetName())

			ClientDialog.Show{
		        TargetUser = target,
		        TitleStr = "Sign Guild Charter",
		        DialogId = "SignCharter",
		        DescStr = guildMasterName.." is inviting you to sign a guild charter.",
		        ResponseObj = this,
		        ResponseFunc= function(user,buttonId)
					local buttonId = tonumber(buttonId)
					if(buttonId == 0) then
						if(guildMaster ~= this) then
							return
						end

						if not(ValidateScrollTarget()) then
							CloseGuildCharterWindow()
							return
						end

						if not(target:HasModule("guild_charter_window")) then
							target:AddModule("guild_charter_window",{ScrollTarget=scrollTarget,Guildmaster=this})
						end
					end
		        end
		    }   
		end
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ()
		this:DelModule("guild_charter_window")
	end)

RegisterEventHandler(EventType.ModuleAttached,"guild_charter_window",
	function ( ... )
		scrollTarget = initializer.ScrollTarget
		guildMaster = initializer.Guildmaster or this

		local isMemorial = scrollTarget:GetObjVar("Memorial")
		-- make sure the guildmaster is not a signer
		if(not(isMemorial) and guildMaster == this) then
			local signers = scrollTarget:GetObjVar("Signers") or {}
			for i,memberInfo in pairs(signers) do
				if(memberInfo.ObjRef == guildMaster) then
					scrollTarget:DelObjVar("Signers")		
				end
			end
		end

		ShowGuildCharterWindow()
	end)