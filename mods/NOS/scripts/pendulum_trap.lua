--objvars
--CreateObj("spike",this:GetLoc(),"blah")
--CreateObj("spike",this:GetLoc(),"blah")
--CreateObj("spike",this:GetLoc(),"blah")
--CreateObj("spike",this:GetLoc(),"blah")

this:SetObjVar("IsTrap",true)
this:SetObjVar("CannotDisable",true)
--NOTE: this trap cannot be disabled.

DAMAGE_AMOUNT =  70
RegisterEventHandler(EventType.Timer,"BladeTic",
function()
	--DebugMessage("Tic numb is "..tostring(ticNum))
	--nasty disgusting function that gets a time value where 1 = 1/4th the animation length.
	local ticNum = (ServerTimeMs() % (1000 * 1.660))/(1000 * 1.66/4) 
	--DebugMessage(ticNum)
	--DebugMessage(ticNum)
	--if the pendulum is mid swing.
	if ((ticNum >= 1.2 and ticNum <= 1.8) or (ticNum >= 3.0 and ticNum <= 3.5)) then
		local bounds = Box(0.5,0,2,-0.75,0,-4):Rotate(this:GetFacing()):Add(this:GetLoc()):Flatten()
		local objects = FindObjects(SearchMulti({SearchRect(bounds),SearchMobileInRange(5,true)}))
		--CreateObj("spike",Loc(bounds.TopLeft),"blah")
		--CreateObj("spike",Loc(bounds.TopRight),"blah")
		--CreateObj("spike",Loc(bounds.BottomLeft),"blah")
		--CreateObj("spike",Loc(bounds.BottomRight),"blah")
		--DebugMessage("Damage!")
		for n,mob in pairs(objects) do
			--DFB HACK: Make traps do less damage to mobs
			if (mob:IsPlayer()) then
				mob:SendMessage("ProcessTrueDamage", this, 30)
			else
				mob:SendMessage("ProcessTrueDamage", this, 10)
			end
		end
	end
	--if the swing number is near the end reset it.
	if ticNum > 3.8  or ticNum < 0.2  then
		--DebugMessage("Resetting")
		if (this:GetSharedObjectProperty("AnimationParamater") == 1) then
			this:SetSharedObjectProperty("AnimationParamater",0)
			--DebugMessage(0)
		else
			this:SetSharedObjectProperty("AnimationParamater",1)
			--DebugMessage(1)
		end
	end
	--This leaves some error due to rounding.
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5),"BladeTic")
end)

if (this:GetObjVar("InitialTimerOffset") ~= 0) then
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("InitialTimerOffset") or 0.5),"BladeTic")
else
	this:FireTimer("BladeTic",0)
end