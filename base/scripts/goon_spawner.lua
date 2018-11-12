require 'base_ai_settings'

--Spawns an obj var specified unit that acts as a goon/henchman and sets it's superior to the object this module is attached to
--In the script the MySuperior should be utilized as the superior of the goon

GOON_CHANCE = 0.3
MAX_GOONS = 1
MIN_GOONS = 0

if (initializer ~= nil) then
	this:SetObjVar("GoonTemplates",initializer.GoonTemplates)
	--DebugMessage("GoonTemplates specified")
elseif (not this:HasObjVar("GoonTemplates")) then
	if (this:HasObjVar("GoonTemplate")) then
		this:SetObjVar("GoonTemplates",{this:GetObjVar("GoonTemplate")})
	else
		DebugMessage("[goon_spawner] ERROR: No goon templates specified!")
		this:DelModule("goon_spawner")
	end
end

function HandleCreated(success,objRef,cubIndex)
	if( success ) then
		objRef:SetObjVar("controller",this)
	end
end

function Spawn()
	if( math.random() <= GOON_CHANCE) then
		local spawnCount = math.random(MIN_GOONS,MAX_GOONS)
		for i=1,spawnCount do
			local goonTemplates = this:GetObjVar("GoonTemplates")
			local spawnLoc = this:GetLoc():Project(math.random(0,360), math.random(2,5))
			if(IsPassable(spawnLoc)) then
				local goonTemplate = goonTemplates[math.random(1,#goonTemplates)]
				CreateObj(goonTemplate, spawnLoc, "goon_created", i)
			end
		end
	end
end

this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1000), "goon_spawner")

RegisterEventHandler(EventType.Timer, "goon_spawner", Spawn)
RegisterEventHandler(EventType.CreatedObject, "goon_created", HandleCreated)
