-- DAB TODO EDIT MODE: HACK UNTIL WE GET THE CREATION CUSTOMIZE FOR EDIT MODE
if(ServerSettings.EditMode == false) then
	this:DelModule("editmode_player")	
	this:AddModule("player")
else
	this:DelModule("newbie_player")
	this:DelModule("guard_protect")
	this:DelModule("combat")
	this:RemoveTimer("PlayerProtectionCheck")
end

require 'editmode_scriptcommands'

function OpenToolbar()
	local newWindow = DynamicWindow("editmode_toolbar","",0,0,50,50,"Transparent","TopLeft")
	newWindow:AddImage(0,0,"SectionBackground",220,90,"Sliced")
	newWindow:AddButton(10, 10, "Manage", "Manage", 200, 0, "", "", false)

	local disableState = (DEFAULT_READONLY and GetModName()=="Default") and "disabled" or ""
	local tooltip = (DEFAULT_READONLY and GetModName()=="Default") and "[$1784]" or "Create new seed object."

	newWindow:AddButton(10, 45, "Create", "Create", 200, 0, tooltip, "", false, "",disableState)

	this:OpenDynamicWindow(newWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"editmode_toolbar",
	function(user,buttonId)
		if(buttonId == "Manage") then
			DoManageWindow()
		elseif(buttonId == "Create") then
			this:RequestClientTargetLocPreview(this, "seed_create_loc", "empty",Loc(0,0,0),Loc(1,1,1))
		end
	end)

RegisterEventHandler(EventType.ClientUserCommand, "use",
	function (usedObjectId,...)
		local usedObject = GameObj(tonumber(usedObjectId))
		if(usedObject ~= nil) then
			-- the use type can contain spaces so combine it since its the last argument
			local usedType = CombineArgs(...)
			usedObject:SendMessage("UseObject",this,usedType)
		end
	end)

RegisterEventHandler(EventType.ClientTargetLocResponse, "seed_create_loc",
	function(success,targetLoc)
		if(success) then
			CreateObj("empty",targetLoc,"new_seed")
		end
	end)

RegisterEventHandler(EventType.CreatedObject,"new_seed",
	function (success,objRef)
		if(success) then
			local seedGroup = this:GetObjVar("SelectedSeedGroup")
			objRef:AddModule("editmode_seedobject")
			objRef:SendMessage("Initialize",{Template="empty",Name="New Seed"},seedGroup)
			objRef:SendMessage("UseObject",this,"Edit")
		end
	end)

OpenToolbar()
this:SendClientMessage("TimeUpdate", {0, 1, 0})
CallFunctionDelayed(TimeSpan.FromSeconds(1),function() this:SetUpdateRange(1000) end)

this:DelObjVar("SelectedSeedGroup")