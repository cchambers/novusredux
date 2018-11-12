require 'container'

-- NOTE: This only works for equipment that is created on the mob and can never be removed
RegisterSingleEventHandler(EventType.ModuleAttached,"mob_pack",
	function ( ... )
		local equipper = this:ContainedBy()
		if(equipper) then
			equipper:SetObjVar("HasPetPack",true)
			AddUseCase(equipper,"Open Pack")
		end
	end)

RegisterEventHandler(EventType.Message,"OpenPack",
	function (user)
		local equipper = this:ContainedBy()
		if(equipper) then
			-- if the horse is not mounted open the pack
			if not(equipper:IsEquipped()) then
				this:SendOpenContainer(user)
			else
				user:SystemMessage("You can not open that while it is mounted.","info")
			end
		end
	end)