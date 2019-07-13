require 'incl_loottables'

RegisterSingleEventHandler(EventType.ModuleAttached, "fill_random_loot", 
	function ()
		--NoRemove is true if the container can be refilled. Loot gets spawned on lockpick instead of spawn in this case
		if (initializer.NoRemove == true) then
			return
		end

		if( this:IsContainer() and initializer.LootTables ~= nil ) then
			LootTables.SpawnLoot(initializer.LootTables,this, initializer.ObjVar)
		end

	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1000), "removeLoot")
	end)

RegisterEventHandler(EventType.Timer,"removeLoot", function()
		this:DelModule("fill_random_loot")
	end)

RegisterEventHandler(EventType.Message,"refill_random_loot",
	function ()
		local initializer = initializer or GetInitializerFromTemplate(this:GetCreationTemplateId(), "fill_random_loot")
		if (this:IsContainer() and initializer.LootTables ~= nil) then
			LootTables.SpawnLoot(initializer.LootTables,this, initializer.ObjVar)
		end
	end)