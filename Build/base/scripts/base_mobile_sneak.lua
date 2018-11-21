

function BeginSneak(force)
	if ( IsDead(this) ) then return end

	if ( force ~= true and HasMobileEffect(this, "Hide") ) then return end

	if ( force ~= true and IsMobileDisabled(this) ) then
		this:SystemMessage("Cannot hide right now.", "info")
		EndSneak()
		return
	end

	if ( force ~= true ) then
		local nearbyMobs = FindObjects(SearchMobileInRange(ServerSettings.Combat.NoHideRange))
		for i,mob in pairs(nearbyMobs) do
			if not((ShareGroup(this,mob) or IsController(this,mob))) and mob:HasLineOfSightToObj(this,ServerSettings.Combat.LOSEyeLevel) then
				this:SystemMessage("Cannot hide with others nearby.", "info")
				EndSneak()
				return
			end
		end
	end

	local mountObj = GetMount(this)
	if ( mountObj ) then
		DismountMobile(this, mountObj)
	end

	-- disallow combat
	this:SendMessage("EndCombatMessage")
	this:SetSharedObjectProperty("IsSneaking", true)
	-- make them walk slower
	HandleMobileMod("MoveSpeedTimes", "Sneak", -0.80) -- 80% slower
	-- attempt to hide. (or force hide)
	StartMobileEffect(this, "Hide", nil, {
		Force = force
	})
end

function EndSneak()
	this:SetSharedObjectProperty("IsSneaking", false)
	HandleMobileMod("MoveSpeedTimes", "Sneak", nil)
end

RegisterEventHandler(EventType.Message, "EndSneak", EndSneak)
RegisterEventHandler(EventType.Message, "BeginSneak", BeginSneak)