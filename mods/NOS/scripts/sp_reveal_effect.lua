mLoc = nil

function DoRevealStuff()
	this:NpcSpeech("TEST")
	if (mLoc == nil) then
		mLoc = this:GetLoc()
	end
	local mobiles =
		FindObjects(
		SearchMulti(
			{
				SearchRange(mLoc, 20),
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

	CallFunctionDelayed(
		TimeSpan.FromSeconds(10),
		function()
			this:DelModule("sp_reveal_effect")
		end
	)
end

RegisterSingleEventHandler(EventType.ModuleAttached, "sp_reveal_effect", DoRevealStuff)
-- RegisterEventHandler(EventType.Message, "CompletionEffectsp_reveal_effect", DoRevealStuff)
