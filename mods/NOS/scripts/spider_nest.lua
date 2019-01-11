TIME_TO_RESPAWN = 60*10
MAX_SPIDERS = 2
MIN_SPIDERS = 1

spiderController = FindObject(SearchModule("spider_nest_controller",30)) --find a spidernest controller 

function Destroy(user)
        if (this:GetSharedObjectProperty("IsDestroyed") == true) then return end 
        this:SetSharedObjectProperty("IsDestroyed",true)
        if (spiderController ~= nil) then
            spiderController:SendMessage("NestDestroyed",this)
        end
        this:SetName("Destroyed Spider Nest")

        CollectResource(user)

        local i = 1
        local spawnAmount = math.random(MIN_SPIDERS,MAX_SPIDERS)
        while i <= spawnAmount do 
            target = user
            CreateObj("spider_large",this:GetLoc():Project(math.random(0,360), math.random(1,3)),"MobCustomAge",math.random(5,6))
            i = i + 1
        end

        local i = 1
        local spawnAmount = math.random(MIN_SPIDERS,MAX_SPIDERS) + 2
        while i <= spawnAmount do 
            target = user
            CreateObj("spider",this:GetLoc():Project(math.random(0,360), math.random(1,3)),"MobCustomAge",math.random(5,6))
            i = i + 1
        end

        this:ScheduleTimerDelay(TimeSpan.FromSeconds(TIME_TO_RESPAWN),"respawn")
    end

RegisterEventHandler(EventType.Message, "UseObject", 
    function (user,usedType)
        --DebugMessage(1)
        if(usedType ~= "Use" and usedType ~= "Break") then return end
        --DebugMessage(2)
        user:PlayAnimation("attack")
        FaceObject(user,this)
        Destroy(user)
    end)

RegisterEventHandler(EventType.Message,"DamageInflicted",
function(attacker,damageAmt)
    if(damageAmt > 0 and this:GetSharedObjectProperty("IsDestroyed") == false) then
        Destroy(attacker)
    end
end)

--for mobs with custom ages
RegisterEventHandler(EventType.CreatedObject,"MobCustomAge",
    function(success,objRef,newAge)
        objRef:SendMessage("ChangeAge",newAge)
        objRef:SendMessage("AttackEnemy",target)
        --DebugMessage("Changing age to "..newAge.." in "..objRef:GetName())
    end)

RegisterEventHandler(EventType.Timer,"respawn", function()
        this:SetName("Spider Nest")
        this:SetSharedObjectProperty("IsDestroyed",false)
    end)

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function()
        AddUseCase(this,"Break",true)        
    end)

function CollectResource(user) 
    local backpackObj = user:GetEquippedObject("Backpack")  
    local resourceType = "Spidersilk"
    if( backpackObj ~= nil ) then		
		-- DAB TODO: If we want to add a skill back in here we need to grab the code from one of the other tools
		local stackAmount = 2

		-- see if the user gets an upgraded version
		--resourceType = GetHarvestResourceType(user,resourceType)
		if (resourceType == nil) then return end
			--DebugMessage("ResType:" .. resourceType)
    		--DebugTable(ResourceData.ResourceInfo[resourceType])
		-- try to add to the stack in the players pack		
    	if( not( TryAddToStack(resourceType,backpackObj,stackAmount)) and ResourceData.ResourceInfo[resourceType] ~= nil ) then
    		-- no stack in players pack so create an object in the pack    	
        	local templateId = ResourceData.ResourceInfo[resourceType].Template
    		CreateObjInBackpackOrAtLocation(user, templateId, "create_foraging_harvest", stackAmount)
    	end

        --local displayName = GetResourceDisplayName(resourceType)
	    user:SystemMessage("You harvest some "..resourceType..".","info")
		mUser = user
	    user:NpcSpeech("[F4FA58]+1 "..resourceType.."[-]","combat")
	end	
end