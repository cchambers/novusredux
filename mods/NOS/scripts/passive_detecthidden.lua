function DoRevealStuff()
	mLoc = this:GetLoc()

	local mobiles =
		FindObjects(
		SearchMulti(
			{
				SearchRange(mLoc, 3),
				SearchMobile()
			}
		),
		GameObj(0)
	)
	for i, v in pairs(mobiles) do
		if (not IsDead(v) and (v ~= this) and not(ShareKarmaGroup(v, this))) then
			-- IF NOT IN GROUP
			if (HasMobileEffect(v, "Hide")) then
				v:SendMessage("StartMobileEffect", "Revealed")
			end
		end
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"GMDetectHidden")
end

RegisterEventHandler(EventType.Timer, "GMDetectHidden", DoRevealStuff)
this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"GMDetectHidden")