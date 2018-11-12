
function HandleDeath()
	local controller = this:GetObjVar("pvpController")

	if( controller ~= nil and controller:IsValid() ) then
		controller:SendMessage("PlayerDied",this)
	end
end

RegisterEventHandler(EventType.Message, "HasDiedMessage", HandleDeath)