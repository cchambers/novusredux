fireworkMax = 1
fireworkCenter = nil
fireworkCount = 0
DEFAULT_FIREWORK_DURATION = 30

inUse = false

function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		return false
	end
	--Make sure it's in the backpack
	if( this:TopmostContainer() ~= user ) then
		user:SystemMessage("[$1810]")
		return false
	end

	return true
end

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)	
		if(usedType ~= "Use") then return end
		
		if( inUse ) then
			user:SystemMessage("This fireworks display has already been started.")
			return
		end
		--always make sure that that's it's in the backpack
		if not( ValidateUse(user) ) then return end
		--this makes sure there's a certain amount of fireworks allowed
		fireworkMax = 1
		fireworkCount = 0
		fireworkCenter = user:GetLoc()
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"dofireworks",user)		
		inUse = true
	end
)

RegisterEventHandler(
	EventType.Timer, "dofireworks",
	function(user)			
		local fireworkCount = math.random(1,fireworkMax)
		--Spawn some effects
		for index=1, fireworkCount do
			local fireworkType = math.random(1,3)
			if( fireworkType == 1 ) then
				local angle = math.random(1,360)
				local distance = math.random(1,10)
				PlayEffectAtLoc("LightningCloudEffect",fireworkCenter:Project(angle,distance))
				user:PlayObjectSound("Lightning")
			elseif( fireworkType == 2 ) then
				local angle = math.random(1,360)
				local distance = math.random(1,10)
				PlayEffectAtLoc("TeleportToEffect",fireworkCenter:Project(angle,distance))
				user:PlayObjectSound("Teleport")
			else
				local angle = math.random(1,360)
				local distance = math.random(1,10)
				PlayEffectAtLoc("FireballExplosionEffect",fireworkCenter:Project(angle,distance))
				user:PlayObjectSound("FireballImpact")
			end
		end
		--make it an even number of fireworks
		fireworkCount = fireworkCount + 1
		if( fireworkCount % 2 == 0 ) then
			fireworkMax = fireworkMax + 1
		end
		--spawn every second
		if( fireworkCount < DEFAULT_FIREWORK_DURATION ) then
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"dofireworks",user)
		else
			this:Destroy()
		end
	end
)