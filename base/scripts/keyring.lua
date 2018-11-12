function HandleContentsChanged()
	local owner = this:GetObjVar("KeyRingOwner")
	if(owner and owner:IsValid()) then
		owner:SendMessage("OpenKeyRing")
	end
end

RegisterEventHandler(EventType.ContainerItemRemoved, "", 
    function()
        HandleContentsChanged()
    end)

RegisterEventHandler(EventType.ContainerItemAdded, "", 
    function()
        HandleContentsChanged()
    end)