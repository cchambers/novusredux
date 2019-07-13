--attach and detach debuffs for holders
RegisterEventHandler(EventType.Timer,"checkHolder",
function ()
	if not(this:IsMobile()) then		
		local name,color = StripColorFromString(this:GetName())
		this:SetName(color.."Faulty "..name.."[-]")
		this:DelModule(GetCurrentModule())
		return
	end

	local backpack = this:GetEquippedObject("Backpack")
	local idol = FindItemInContainerRecursive(backpackUser,function (item)
		return item:HasObjVar("IdolScript")
	end)
	if (idol == nil) then
		DetachDebuff()
		this:SystemMessage("[$1644]")
		this:DelModule(GetCurrentModule())
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"checkHolder")
end)

--attach the debuff on loading
this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"checkHolder")