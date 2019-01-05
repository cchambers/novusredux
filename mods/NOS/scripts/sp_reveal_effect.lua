mLoc = nil

RegisterEventHandler(
	EventType.Message,
	"CompletionEffectsp_reveal_effect",
	function()
		if(mLoc == nil) then 
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
			TimeSpan.FromSeconds(1),
			function()
				this:DelModule("sp_reveal_effect")
			end
		)
	end
)
