
this:SetObjVar("HolyWaterTarget",true)
if not(this:HasModule("god_negate_damage")) then
	this:AddModule("god_negate_damage")
end
AddView("questView", SearchMobileInRange(15))

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Use" and usedType ~= "Examine") then return end
		
		user:SystemMessage("[$1818]")
	end)

RegisterEventHandler(EventType.Message,"HolyWaterPour",
	function (user)		
		QuickDialogMessage(this,user,"[$1819]",20)
	end)
 
RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function()
        AddUseCase(this,"Examine",true)        
        SetTooltipEntry(this,"examine","Perhaps you should inspect this object closer.\n")		
    end)