require 'NOS:incl_keyhelpers'


RegisterSingleEventHandler(EventType.ModuleAttached,"create_key",
	function()
		local hasDestination = this:GetObjVar("keyDestinationContainer")
		local keyContainer = hasDestination or this

		--DebugMessage("Key is in " .. keyContainer:GetName())

		local dropPos = GetRandomDropPosition(keyContainer)
	   	CreateObjInContainer("key", keyContainer, dropPos, "key")	

	   	-- if the key holder is a mob, put the protection script on him
	   	local keyholder = keyContainer:TopmostContainer() or keyContainer
	   	if(keyholder:IsMobile() and not(keyholder:IsPlayer())) then
		   	this:SetObjVar("keyHolder" , keyholder)
		   	this:AddModule("lock_pick_protector")
		end

		if(hasDestination) then
	   		this:SendMessage("Lock")
	   	end
	end)

RegisterEventHandler(EventType.CreatedObject,"key",
	function(success,objRef)
		if( success ) then

			local keyId = uuid()
			objRef:SetObjVar("lockUniqueId",keyId)
			this:SetObjVar("lockUniqueId",keyId)

		   	if (this:HasObjVar("OneTimeKey")) then
		   		objRef:SetObjVar("OneTimeKey",true)
		   	end

		   	local strippedName, color = StripColorFromString(this:GetName())
		   	local newName = strippedName.." Key"
		   	if not(color) then
			   	objRef:SetName(newName)
			else
				objRef:SetName(color .. newName .. "[-]")
			end

		end

		-- this module is done
		this:DelModule("create_key")
	end)