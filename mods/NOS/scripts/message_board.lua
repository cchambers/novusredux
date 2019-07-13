MESSAGE_BOARD_DISABLED = true

function ShowMessageBoard(user)
	local sections = nil
	if (this:HasObjVar("Sections")) then
		sections = this:GetObjVar("Sections")
	end
	if (not user:HasModule("message_board_controller")) then
		user:AddModule("message_board_controller")--{Board = this,Sections = Sections})
	end
	--DebugMessage("Sections is "..tostring(sections),", sending this")
	user:SendMessage("StartMessageBoard",this,sections)
end

function CanUseMessageBoard(user)
	--DFB HACK: Disable this until we can find a way to give players printed notes.
	if (MESSAGE_BOARD_DISABLED) then
		user:SystemMessage("Message boards disabled for now.")
		return false
	end

	if (user:DistanceFrom(this) > OBJECT_INTERACTION_RANGE) then
		return false
	end
	return true
end

if (initializer ~= nil and initializer.Sections ~= nil) then
	Sections = initializer.Sections
	this:SetObjVar("Sections",Sections)
end

RegisterEventHandler(EventType.Message,"UseObject",
function (user,usedType)
	if( usedType == nil or usedType ~= "Read") then
		return
	end

	if (not CanUseMessageBoard(user)) then
		return
	end
	
	ShowMessageBoard(user)
end)

AddUseCase(this,"Read",true)