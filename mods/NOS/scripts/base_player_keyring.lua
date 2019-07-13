require 'NOS:incl_keyhelpers'

keyRingWindowOpen = false

local selectedKey = nil

RegisterEventHandler(EventType.CreatedObject,"keyring_created",
	function (success,objRef)
		if(success) then
			objRef:SetObjVar("KeyRingOwner",this)
			objRef:AddModule("keyring")
			objRef:SetSharedObjectProperty("Weight",-1)
			this:SetObjVar("KeyRing",objRef)
			objRef:SetName("Key Ring")
		end
	end)

-- make sure the player has a key ring
function CheckKeyRing(tempPack)
	local keyRingCont = this:GetObjVar("KeyRing")
	if(keyRingCont == nil or not(keyRingCont:IsValid())) then
		-- DAB TODO: If the obj var got removed somehow, we could search the temp pack for the keyring
		tempPack = tempPack or this:GetEquippedObject("TempPack")
		if(tempPack ~= nil) then
			CreateObjInContainer("pouch", tempPack, Loc(0,0,0), "keyring_created")
		end
	end
end

function HandleKeyRingOptionsResponse(user, buttonStr)
	if not(selectedKey:IsValid()) then
		return
	end
	if (not selectedKey:HasModule("key")) then
		return
	end

	if(buttonStr == "Use") then
		selectedKey:SendMessage("UseObject",this,"Use")
	elseif(buttonStr == "Remove") then
		PickupKeyFromKeyRing(this,selectedKey)
	elseif(buttonStr == "Copy") then
		MakeCopy(this,selectedKey)
	elseif(buttonStr == "Rename") then
		RenameKey(this,selectedKey)
	end
end

RegisterEventHandler(EventType.DynamicWindowResponse,"KeyRing",
	function(user,buttonId)
		if(buttonId and buttonId ~= "") then 
			local carriedObject = user:CarriedObject()
			if(carriedObject ~= nil and carriedObject:HasModule("key")) then
				AddKeyToKeyRing(user,carriedObject)
			else
				local keyObj = GameObj(tonumber(buttonId))
				if not(keyObj:IsValid()) then
					return
				end
				
				selectedKey = keyObj
				this:OpenCustomContextMenu("KeyRingOptions",keyObj:GetName(),{"Use","Remove","Copy","Rename"})
				RegisterSingleEventHandler(EventType.ContextMenuResponse,"KeyRingOptions",HandleKeyRingOptionsResponse)
			end
		else
			keyRingWindowOpen = false
		end
	end)

function UpdateKeyRingWindow()
	local keyRing = GetKeyRing(this)
	
    if(keyRing == nil or not(keyRing:IsValid())) then
    	DebugMessage("ERROR: No player should be without a key ring! "..tostring(this))
    	return
    end

	local myKeys = keyRing:GetContainedObjects()
	if(#myKeys == 0) then
		if (keyRingWindowOpen) then
			-- if we get an update and the window is open, we dont need a dialog just close it
			this:CloseDynamicWindow("KeyRing")
		else
			ClientDialog.Show{
			    TargetUser = this,
		    	DialogId = "NoKeysDialog",
		    	TitleStr = "Key Ring",
		    	DescStr = "[$1704]",
			    Button1Str = "Ok",
			}
		end
		return
	end

	local maxVisibleEntries = 5
	local entryHeight = 26
	local numEntries = #myKeys
	local windowHeight = 240
	if(numEntries < maxVisibleEntries) then
		windowHeight = 50 + numEntries * entryHeight
	end
	
	local dynWindow = DynamicWindow("KeyRing","Key Ring",350,windowHeight,-150,-200,"","Center")

	local keyHint = "[$1705]"

	local elementRoot = dynWindow
	if(numEntries > maxVisibleEntries) then
		local scrollWindow = ScrollWindow(10,10,300,130,entryHeight)
		for i,keyObj in pairs(myKeys) do 
			local scrollElement = ScrollElement()
			scrollElement:AddButton(0,0,tostring(keyObj.Id),"",285,26,keyObj:GetName().."\n\n"..keyHint,"",false,"List")
			scrollElement:AddImage(10,0,tostring(keyObj:GetIconId()),32,32,"Object",keyObj:GetColor())
			scrollElement:AddLabel(60,8,ShortenColoredString(keyObj:GetName(),20),215,0,18)
			scrollWindow:Add(scrollElement)
		end	

		dynWindow:AddScrollWindow(scrollWindow)
	else
		local y = 4
		for i,keyObj in pairs(myKeys) do 
			dynWindow:AddButton(10,y,tostring(keyObj.Id),"",310,26,keyObj:GetName().."\n\n"..keyHint,"",false,"List")
			dynWindow:AddImage(10,y,tostring(keyObj:GetIconId()),32,32,"Object",keyObj:GetColor())
			dynWindow:AddLabel(10+60,y+8,ShortenColoredString(keyObj:GetName(),20),285,0,18)
			y = y + entryHeight
		end	
	end

	this:OpenDynamicWindow(dynWindow)

	keyRingWindowOpen = true
end

RegisterEventHandler(EventType.ClientUserCommand,"keyring",
	function()
		if(keyRingWindowOpen) then			
			this:CloseDynamicWindow("KeyRing")
			keyRingWindowOpen = false
		else
			UpdateKeyRingWindow()
		end
	end)

RegisterEventHandler(EventType.Message,"OpenKeyRing",
	function()		
		UpdateKeyRingWindow()
	end)

RegisterEventHandler(EventType.Message,"UpdateKeyRingWindow",
	function ()
		if(keyRingWindowOpen) then
			UpdateKeyRingWindow()
		end
	end)