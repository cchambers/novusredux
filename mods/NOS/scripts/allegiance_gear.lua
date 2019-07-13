
RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ( ... )
		local god = this:GetObjVar("PatronGod")
		if(god) then
			local godName = PlayerGuildFactions[god].PatronGodFullName
			SetTooltipEntry(this,"allegiance","[$1607]"..godName,-200)
		end
	end)

RegisterEventHandler(EventType.Message,"WasEquipped",
	function ( ... )
		local wearer = this:ContainedBy()
		--if(wearer ~= nil and not(IsImmortal(wearer))) then
		if(wearer ~= nil) then
			local guild = GuildHelpers.Get(wearer)
			if( not(guild) or not(guild.PatronGod) or guild.PatronGod ~= this:GetObjVar("PatronGod") ) then 
				wearer:SystemMessage("You are zapped by the "..StripColorFromString(this:GetName()).." and it instantly falls to the ground.","info")
				this:SetWorldPosition(wearer:GetLoc())
			end
		end
	end)