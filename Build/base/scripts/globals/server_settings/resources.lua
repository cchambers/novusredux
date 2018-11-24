ServerSettings.Resources = {
	Fish = {
		-- the world is broken up into a X by X grid with each element containing Y fish
		GridElementSize = 32,
		GridElementCount = 20,
		-- the amount of time it takes the grid element to regenerate (become fishable again) after being fully depleted
		GridElementRegenRate = TimeSpan.FromMinutes(10),

		-- chance in percent of hooking this size fish
		SizeChance = {
			[1] = 98.39,
			[2] = 1.0,  -- Large (1 in 100)
			[3] = 0.5,  -- Huge (1 in 200)
			[4] = 0.1,  -- Gigantic (1 in 1000)
			[5] = 0.01, -- Legendary (1 in 10,000)
		},

		-- weight of fish based on size
		SizeWeights = {
			[1] = 1.0,
			[2] = 2.0,  -- Large (1 in 100)
			[3] = 5.0,  -- Huge (1 in 200)
			[4] = 10.0, -- Gigantic (1 in 1000)
			[5] = 30.0, -- Legendary (1 in 10,000)
		},

		-- scale of fish based on size
		SizeScales = {
			[1] = 1.0,
			[2] = 1.1,  -- Large (1 in 100)
			[3] = 1.3,  -- Huge (1 in 200)
			[4] = 1.5, -- Gigantic (1 in 1000)
			[5] = 2.0, -- Legendary (1 in 10,000)
		},
	},
	
	-- Resource Pool is the number of this resource that can spawn in a given resource region. If ResourcePoolMultiplier is specified	
	-- As the resource controller spawns rare resources, it takes them from the pool. When the pool is empty, it will stop spawning
	-- new rare resource nodes of that type until the pool regenerates (ResourcePoolRegenTime)
	--
	-- This allows resource regions to sometimes become inactive for a given type of resource for a period of time. Adds to the
	-- immersion and also discourages macroers from staying in the same location
	--
	-- The pool will be equal to the number of resource nodes * the AvailablityPct for that resource * the multiplier
	-- Example:
	--    a mine has 1000 rocks
	--    obsidian AvailablityPct is 3 thats 30 obsidian nodes
	--    multiplier is 3 so the pool will contain 90 obsidian rocks
	IronOre = {
	},
	CopperOre = {
		ResourcePoolMultiplier = 3,
		ResourcePoolRegenTime = TimeSpan.FromMinutes(30)
	},
	GoldOre = {
		ResourcePoolMultiplier = 3,
		ResourcePoolRegenTime = TimeSpan.FromMinutes(30)
	},
	CobaltOre = {
		ResourcePoolMultiplier = 3,
		ResourcePoolRegenTime = TimeSpan.FromMinutes(30)
	},
	ObsidianOre = {
		ResourcePoolMultiplier = 3,
		ResourcePoolRegenTime = TimeSpan.FromMinutes(30)
	},
	Ash = {		
	},
	Blightwood = {		
	},
}