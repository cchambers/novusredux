BOSS_SPIDER_RESPAWN_TIME = 10*60

myNests = FindObjects
				(SearchMulti({
                SearchModule("spider_nest"),
                SearchRange(this:GetLoc(), 30),
                })) --find my spider nests

this:SetObjVar("myNests",myNests)

RegisterEventHandler(EventType.Message,"NestDestroyed",
	function(nest)
		local isMyNest = false
		myNests = this:GetObjVar("myNests")
		for i,j in pairs(myNests) do 
			if (j == nest) then
				table.remove(myNests,i)
				isMyNest = true
				--DebugMessage("Nest Destroyed")
			end
		end
		--DebugMessage("Size of my nests is "..#myNests)
		if ((#myNests) == 0 and isMyNest) then
			--DebugMessage("Creating boss spider")
			CreateObj("spider_boss",this:GetLoc(),"spider_boss_created")
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(BOSS_SPIDER_RESPAWN_TIME),"RespawnBoss")
		end
		this:SetObjVar("myNests",myNests)
	end)

RegisterEventHandler(EventType.Timer,"RespawnBoss",
	function()
		myNests = FindObjects
				(SearchMulti({
                SearchModule("spider_nest"),
                SearchRange(this:GetLoc(), 30),
                })) --find my spider nests
		for i,j in pairs(myNests) do
    		j:SetSharedObjectProperty("IsDestroyed",false)
    		j:SetName("Spider Nest")
		end
	end)