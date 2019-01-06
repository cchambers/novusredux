mLoc = nil
mDist = 4

function DoRevealStuff()
	if (mLoc == nil) then
		mLoc = this:GetLoc()
	end

	local mobiles =
		FindObjects(
		SearchMulti(
			{
				SearchRange(mLoc, mDist),
				SearchMobile()
			}
		),
		GameObj(0)
	)
	for i, v in pairs(mobiles) do
		if (not IsDead(v)) then
			if (HasMobileEffect(v, "Hide")) then
				v:SendMessage("StartMobileEffect", "Revealed")
			end
		end
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"GMDetectHidden")
end

RegisterEventHandler(EventType.Timer, "GMDetectHidden", DoRevealStuff)
this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"GMDetectHidden")