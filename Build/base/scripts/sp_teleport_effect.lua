

function ValidateSpellTeleport(targetLoc)
	--DebugMessage("Debuggery Deh Yah")
	if( not(IsPassable(targetLoc)) ) then
		this:SystemMessage("[FA0C0C]You cannot teleport to that location.[-]")
		return false
	end

	if not(this:HasLineOfSightToLoc(targetLoc,ServerSettings.Combat.LOSEyeLevel)) then
		this:SystemMessage("[$2630]")
		return false
	end

	return true
end

RegisterEventHandler(EventType.Message,"TeleportSpellTargetResult",
	function (targetLoc)
		-- validate teleport
		if not(ValidateSpellTeleport(targetLoc)) then
			this:DelModule("sp_teleport_effect")
			return
		end

		PlayEffectAtLoc("TeleportFromEffect",this:GetLoc())
		PlayEffectAtLoc("TeleportToEffect",targetLoc)
		ignoreView = false
		this:SetWorldPosition(targetLoc)
		this:SendMessage("BreakInvisEffect")
		this:DelModule("sp_teleport_effect")
	end)