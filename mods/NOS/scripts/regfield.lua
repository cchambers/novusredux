mPlants = {
    "plant_ginseng",
    "plant_nightshade",
    "plant_bloodmoss",
    "plant_mandrake",
    "plant_spidersilk",
    "plant_sulfurousash",
    "plant_blackpearl",
    "plant_garlic",
} -- haha


this:ScheduleTimerDelay(TimeSpan.FromSeconds(1), "Regfield.Spawn");
	
RegisterEventHandler(EventType.Timer, "Regfield.Spawn", function()
    local spawnRadius = this:GetObjVar("spawnRadius")
    local spawnDelay = this:GetObjVar("spawnDelay") or 5
    local what = mPlants[math.random(1, #mPlants)]
    local where = GetRandomPassableLocationInRadius(this:GetLoc(),spawnRadius,true)
    CreateTempObj(what, where, "Regfield.Item");
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(spawnDelay), "Regfield.Spawn");
end)

RegisterEventHandler(EventType.CreatedObject,"Regfield.Item",function (success,objRef)
    if (success) then
        local spawnDecay = this:GetObjVar("spawnDecay") or 60
        Decay(objRef, spawnDecay)
    end
end)