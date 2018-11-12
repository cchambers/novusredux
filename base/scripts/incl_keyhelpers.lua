require 'incl_container'

function IsBlankKey(item)
	return item:HasModule("key") and not(item:HasObjVar("lockUniqueId"))
end

function GetBlankKey(user)
	local backpackObj = user:GetEquippedObject("Backpack")

	return FindItemInContainerRecursive(backpackObj,IsBlankKey)
end

function RegisterKeyCreatedHandler(keyName,lockUniqueId, oneTimeKey)
	RegisterSingleEventHandler(EventType.CreatedObject,"keyhelpers_key_created",
		function(success,objRef)
			if( lockUniqueId ~= nil ) then
				objRef:SetObjVar("lockUniqueId",lockUniqueId)
			end
			if (oneTimeKey ~= nil) then
				if (oneTimeKey == true) then
					objRef:SetObjVar("OneTimeKey", true)
				end
			end
			objRef:SetName(keyName)
		end)
end

function CreateKey(user,keyName,lockUniqueId)
	if(user:CarriedObject()) then
		user:SystemMessage("You are already carrying something.")
		return
	end

	-- to put something in a players carry slot you create the object in their body
	CreateObjInContainer("key", user, Loc(0,0,0), "keyhelpers_key_created")
	RegisterKeyCreatedHandler(keyName,lockUniqueId)
end

function CreateKeyInBackpack(user,keyName,lockUniqueId, oneTimeKey)
	CreateObjInBackpackOrAtLocation(user,"key","keyhelpers_key_created")
	RegisterKeyCreatedHandler(keyName,lockUniqueId, oneTimeKey)
end

function RenameKey(user,keyObj)
    TextFieldDialog.Show{
        TargetUser = user,
        ResponseObj = this,
        Title = "Name Key",
        Description = "Maximum 20 characters",
        ResponseFunc = function(user,newName)
            if( not(newName) or newName == "" ) then
                user:SystemMessage("[$1875]")
                RenameKey(user,keyObj)
            else
                keyObj:SetName(newName)
                user:SendMessage("UpdateKeyRingWindow")
            end
        end
    }
end

function MakeCopy(user,keyObj)
	if(keyObj == nil  or not(keyObj:IsValid())) then
		return
	end

	if IsBlankKey(keyObj) then
		user:SystemMessage("Why would you want to make a copy of a blank key?")
		return
	end

	if ( keyObj:HasObjVar("lockObject") ) then
		user:SystemMessage("This key cannot be copied.")
		return
	end

	local blankKey = GetBlankKey(user)
	if not(blankKey) then
		user:SystemMessage("[$1876]")
		return
	end

	if(user:CarriedObject()) then
		user:SystemMessage("You are already carrying something.")
		return
	end

	if( keyObj:HasObjVar("lockUniqueId") ) then
		blankKey:SetObjVar("lockUniqueId", keyObj:GetObjVar("lockUniqueId"))
	end

	if( keyObj:HasObjVar("IsHouseKey") ) then
		blankKey:SetObjVar("IsHouseKey", true)
	end
	
	blankKey:SetName(keyObj:GetName())
	blankKey:MoveToContainer(user,Loc(0,0,0))
end

function AddKeyToKeyRing(user,keyObj)
	if(KeyRingAlreadyHasKey(user,keyObj)) then
        user:SystemMessage("You already have that key in your keyring.")
        return false
    end

	local keyRing = GetKeyRing(user)
	if(keyRing ~= nil and keyObj ~= nil and keyRing:IsValid() and keyObj:IsValid()) then
		keyObj:MoveToContainer(keyRing,Loc(0,0,0))	

		return true
	end
end

function PickupKeyFromKeyRing(user,keyObj)
	if(user:CarriedObject()) then
	end

	local backpackObj = user:GetEquippedObject("Backpack")
	if ( backpackObj == nil ) then
		user:SystemMessage("You need a backpack to put this in.")
		return
	end
	-- moving to user 'holding' wasn't updating the client correctly causing a relog, so just put it in the backpack.
	keyObj:MoveToContainer(backpackObj,Loc(0,0,0))
	user:SystemMessage("The key '".. keyObj:GetName() .."' has been placed in your backpack.")

end

function KeyRingAlreadyHasKey(user,keyObj)
    local keyRing = GetKeyRing(user)
    if(keyRing ~= nil and keyObj ~= nil and keyRing:IsValid() and keyObj:IsValid()) then
    	local lockUniqueId = keyObj:GetObjVar("lockUniqueId")

    	-- DAB TODO: If the object matchs but the key does not do something
		return FindItemInContainerRecursive(keyRing,function(item)
    			return KeyMatches(item,lockUniqueId)
			end) ~= nil
	end
end

function CountKeysInKeyRing(user)
	local keyRing = GetKeyRing(user)
    if(keyRing ~= nil and keyRing:IsValid()) then
    	return #keyRing:GetContainedObjects()
    end

    return 0
end