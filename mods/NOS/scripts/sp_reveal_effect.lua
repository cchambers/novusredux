mLoc = nil
mDist = 15

if (initializer ~= nil) then
	if (initializer.Skill ~= nil) then
		local skill = initializer.Skill
		mDist = mDist + (skill/10)
		-- add one meter for every 10 skill points
	end
end

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
			local canSee = this:HasLineOfSightToLoc(v:GetLoc(),ServerSettings.Combat.LOSEyeLevel)
			if (HasMobileEffect(v, "Hide") and canSee) then
				v:SendMessage("StartMobileEffect", "Revealed")
				CheckSkillChance(this, "DetectHiddenSkill")
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
