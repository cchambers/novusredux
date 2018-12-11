function HandleLoaded()
	if not(this:HasObjVar("sp_cure_effectSource")) then
		EndEffect()
		return
	end
	local myCureSource = this:GetObjVar("sp_cure_effectSource")
	if not(myCureSource:IsValid()) then
		EndEffect()
		return
	end
	local cureSkill = GetSkillLevel(myCureSource,"ChannelingSkill")
	this:SendMessage("EndPoisonEffect")
	EndEffect()
end


RegisterSingleEventHandler(EventType.ModuleAttached, "sp_cure_effect", 
	function ()
		HandleLoaded()
	end)

function EndEffect()
	CallFunctionDelayed(TimeSpan.FromSeconds(0.001), function()
		-- can't be called on same frame as attach
		this:DelModule("sp_cure_effect")
	end)
end