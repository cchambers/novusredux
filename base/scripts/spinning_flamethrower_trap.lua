--objvars
--CreateObj("spike",this:GetLoc(),"blah")
--CreateObj("spike",this:GetLoc(),"blah")
--CreateObj("spike",this:GetLoc(),"blah")
--CreateObj("spike",this:GetLoc(),"blah")

this:SetObjVar("IsTrap",true)
this:SetObjVar("CannotDisable",true)
--NOTE: this trap cannot be disabled.

ROTATION_SPEED = 30
DAMAGE_AMOUNT = this:GetObjVar("DamageAmount") or 10
RegisterEventHandler(EventType.Timer,"FlameTic",function()
	this:SetSharedObjectProperty("IsTriggered",false)
		local tickNum = (ServerTimeMs() % (500 * 12)) / 500
	--DebugMessage(tickNum.." is tick counter")
		local FlameActivationTime = this:GetObjVar("FlameActivationTime")
		--DebugMessage(tickNum*30*2)
		local bounds = Box(-2.0,0,-7.5,3,1,14):Rotate(tickNum*30):Add(this:GetLoc()):Flatten()

		--debug stuff
		--DebugMessage(tostring(bounds))
		--local spikes = FindObjects(SearchTemplate("spike"))
		--spikes[1]:SetWorldPosition(Loc(bounds.TopRight))
		--spikes[2]:SetWorldPosition(Loc(bounds.TopLeft))
		--spikes[3]:SetWorldPosition(Loc(bounds.BottomRight))
		--spikes[4]:SetWorldPosition(Loc(bounds.BottomLeft))
			--DebugMessage(DumpTable(bounds))
			--DebugMessage(tostring(bounds))
		local objects = FindObjects(SearchMulti({SearchRect(bounds),SearchMobileInRange(5,true)}))
		--if (not this:GetSharedObjectProperty("IsTriggered")) then
		this:SetSharedObjectProperty("IsTriggered",true)
		this:SetSharedObjectProperty("AnimationParamater",tickNum*30)
			--DebugMessage("On")
		--end			
		for i,obj in pairs(objects) do
			if (not obj:HasObjVar("ImmuneToTraps") and not IsDead(obj)) then
				if (obj:IsPlayer()) then
					obj:SendMessage("ProcessTrueDamage", this, DAMAGE_AMOUNT)
				else
					obj:SendMessage("ProcessTrueDamage", this, 10)
				end
			end
		end
		--so it doesn't go endlessly
		tickNum = (tickNum*2 % 12) / 2
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.25),"FlameTic")
	end)

if (this:GetObjVar("InitialTimerOffset") ~= 0) then
	--this:ScheduleTimerDelay(TimeSpan.FromSeconds(this:GetObjVar("InitialTimerOffset")),"FlameTic",0)
else
	this:FireTimer("FlameTic",0)
end