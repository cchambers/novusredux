--attach and detach debuffs for holders
RegisterEventHandler(EventType.Timer,"checkHolder",
function ()
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"checkHolder")
	local holder = this:TopmostContainer() 
	if (holder == nil or not holder:IsValid() or not holder:IsMobile()) then 
		return
	end
	local backpack = holder:GetEquippedObject("Backpack")
	if (backpack ~= nil and backpack:IsValid()) then
		local idol = FindItemInContainerRecursive(backpack,
		function(item)
			return item:GetCreationTemplateId() == this:GetCreationTemplateId()
		end)
		local lastHolder = this:GetObjVar("LastHolder")
		if (idol ~= nil and idol:IsValid()) then
			this:SetObjVar("LastHolder",holder)
			if (holder:IsMobile() and not holder:HasModule(this:GetObjVar("IdolScript"))) then
				holder:AddModule(this:GetObjVar("IdolScript"))
				holder:SystemMessage("[$1847]","info")
				holder:SetObjVar("IdolDebuff",this:GetCreationTemplateId())
			end
		end
	end
end)

--Give them a little warning
RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Use" and usedType ~= "Examine") then return end
		
		user:SystemMessage("[$1848]","info")
	end)

this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"checkHolder")

RegisterSingleEventHandler(EventType.ModuleAttached, "idol", 
    function ()
         SetTooltipEntry(this,"idol", "Perhaps you should inspect this item further.")
         AddUseCase(this,"Examine",true)
    end)