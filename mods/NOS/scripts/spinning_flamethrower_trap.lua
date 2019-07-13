require 'NOS:destroyable_object'

this:SetObjVar("IsTrap",true)

ROTATION_SPEED = 30
DAMAGE_AMOUNT = this:GetObjVar("DamageAmount") or 10

RegisterEventHandler(EventType.Timer,"FlameTic",function()
		local tickNum = (ServerTimeMs() % (500 * 12)) / 500

		local bounds = Box(-2.0,0,-7.5,3,1,14):Rotate(tickNum*30):Add(this:GetLoc()):Flatten()

		local objects = FindObjects(SearchMulti({SearchRect(bounds),SearchMobileInRange(5,true)}))
		this:SetSharedObjectProperty("AnimationParamater",tickNum*30)

		for i,obj in pairs(objects) do

			if (not obj:HasObjVar("ImmuneToTraps") and not IsDead(obj)) then
				if (obj:IsPlayer()) then
					obj:SendMessage("ProcessTrueDamage", this, DAMAGE_AMOUNT)
				else
					--obj:SendMessage("ProcessTrueDamage", this, 10)
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

RegisterEventHandler(EventType.Message,"ObjectDestroyed",
	function()
		this:RemoveTimer("FlameTic")
		this:PlayObjectSound("event:/magic/fire/magic_fire_fireball_impact")
	end) 

RegisterEventHandler(EventType.Timer,"RespawnTimer",
	function()
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.25),"FlameTic")
	end)