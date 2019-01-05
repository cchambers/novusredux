mLoc = nil

function DoRevealStuff()
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
				CheckSkillChance(this, "DetectHiddenSkill")
			end
		end
	end
	
	CheckSkillChance(this, "DetectHiddenSkill")

	CallFunctionDelayed(
		TimeSpan.FromSeconds(10),
		function()
			this:DelModule("sp_reveal_effect")
		end
	)
end

RegisterSingleEventHandler(EventType.ModuleAttached, "sp_reveal_effect", DoRevealStuff)
-- RegisterEventHandler(EventType.Message, "CompletionEffectsp_reveal_effect", DoRevealStuff)
