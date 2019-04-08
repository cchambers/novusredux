
RegisterEventHandler(EventType.Message, "HasDiedMessage",
function(killer)
	if (math.random(1,2) == 1) then
		-- create random parts
		-- CreateObj("resource_spectral_ore",this:GetLoc(),"Spectral.CreatedOre")
	end
	CallFunctionDelayed(TimeSpan.FromSeconds(2), function ()
		this:Destroy()
	end)
end)