RegisterSingleEventHandler(EventType.ModuleAttached, "lock_pick_protector", 
	function()
		if not(this:HasObjVar("keyHolder")) then
		this:DelModule("lock_pick_protector")
		return
		end
	end)

RegisterEventHandler(EventType.Message, "LockPicked", 
	function()

		if not(this:HasObjVar("keyHolder")) then
		this:DelModule("lock_pick_protector")
		return
		end
		local myHolder = this:GetObjVar("keyHolder")
		if not (myHolder:IsValid()) then return end
		if not (IsDead(myHolder)) then
			if not(myHolder:HasModule("protect_lock")) then
				myHolder:AddModule("protect_lock")
			end
			
			myHolder:SendMessage("PROTECT_LOCK", this)
		end

	end)