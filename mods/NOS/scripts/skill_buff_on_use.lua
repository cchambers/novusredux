BUFF_TIME_MINUTES = this:GetObjVar("BuffTimeMinutes") or 20
BUFF_INCREASE = 0.2

RegisterEventHandler(EventType.Message,"UseObject",
	function(user,useType)
	if (user ~= nil and user:IsValid()) then
		user:SendMessage("AddSkillBuff",user,"All",BUFF_INCREASE,BUFF_TIME_MINUTES*60,this:GetObjVar("BuffID") or "SkillBuffUnspecified",true)
	end
end)

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function ()
    	SetTooltipEntry(this,"examine", "Perhaps you should inspect this item further.")
    	AddUseCase(this,"Examine",true,"HasObject")
	end)