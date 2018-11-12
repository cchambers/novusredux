require 'incl_loottables'

RegisterSingleEventHandler(EventType.ModuleAttached, "fill_random_loot", 
	function ()
		if( this:IsContainer() and initializer.LootTables ~= nil ) then
			LootTables.SpawnLoot(initializer.LootTables,this)
		end
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1000), "removeLoot")
	end)

RegisterEventHandler(EventType.Timer,"removeLoot", function()
		this:DelModule("fill_random_loot")
	end)