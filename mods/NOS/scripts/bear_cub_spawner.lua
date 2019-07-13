require 'NOS:base_ai_settings'

BEAR_CUB_CHANCE = 0.3
MAX_CUBS = 3
MIN_CUBS = 1
spawnCount = 0

function HandleCreated(success,objRef,cubIndex)
	if( success ) then
		objRef:SetObjVar("cubMother",this)
		objRef:SetObjVar("cubFollowRange",cubIndex)
		objRef:SetObjVar("AI-Age",3+math.random(2))
		objRef:DelModule("bear_cub_spawner")
	end
end

function Spawn()
	--DebugMessageA(this,"Spawn in bear cub spawner with age "..AI.GetSetting("Age"))
	if (AI.GetSetting("Age") ~= nil and AI.GetSetting("Age") >= 6 and math.random() <= BEAR_CUB_CHANCE) then
		spawnCount = math.random(MIN_CUBS,MAX_CUBS)
		for i=1,spawnCount do
			local spawnLoc = this:GetLoc():Project(math.random(0,360), math.random(2,5))
			if(IsPassable(spawnLoc)) then
				CreateObj("bear", spawnLoc, "cub_created", i)
				--DebugMessage("Spawning Cub.")
			end
		end
	else
		this:DelModule("bear_cub_spawner")
	end
end

RegisterEventHandler(EventType.ModuleAttached,"bear_cub_spawner",
	function()		
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1000), "cub_spawner")
	end)

-- this script should never stay on the mob long enough to make it into a backup
RegisterEventHandler(EventType.LoadedFromBackup,"",
	function()		
		this:DelModule("bear_cub_spawner")
	end)

RegisterEventHandler(EventType.Timer, "cub_spawner", 
	function()
		Spawn()
	end)

RegisterEventHandler(EventType.CreatedObject, "cub_created", 
	function(success,objRef,cubIndex)
		HandleCreated(success,objRef,cubIndex)

		spawnCount = spawnCount - 1
		if(spawnCount == 0) then
			this:DelModule("bear_cub_spawner")
		end		
	end)
