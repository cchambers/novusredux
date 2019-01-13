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
    local spidersilkChance = math.random(0,10)

    -- approx 50% chance to get spidersilk from 1 to 8.
    if(spidersilkChance > 5) then
        local backpackObj = user:GetEquippedObject("Backpack")  
        local resourceType = "Spidersilk"
        if( backpackObj ~= nil ) then		
            -- TODO - VERLORENS - Add in difficulty to harvesting checks, requires adding difficulty to each plant.. necessary?
            --if ( CheckSkill(self.ParentObj, "HarvestingSkill", self._Difficulty) ) then
            local harvestingSkill = GetSkillLevel(user, "HarvestingSkill")

            -- Max number of goods per harvesting skill:
            -- Skill:   0   20  40  60  80  100
            -- # Goods: 1   2   3   5   6   8
            local maxAmount = math.floor((harvestingSkill / 14) + 1)
            local stackAmount = math.random(1, maxAmount)

            CheckSkillChance(user,"HarvestingSkill")

            -- try to add to the stack in the players pack		
            if( not( TryAddToStack(resourceType,backpackObj,stackAmount)) and ResourceData.ResourceInfo[resourceType] ~= nil ) then
                -- no stack in players pack so create an object in the pack    	
                local templateId = ResourceData.ResourceInfo[resourceType].Template
                CreateObjInBackpackOrAtLocation(user, templateId, "create_foraging_harvest", stackAmount)
            end

            user:SystemMessage("You harvest some "..resourceType..".","info")
            mUser = user
            user:NpcSpeech("[F4FA58]+1 "..resourceType.."[-]","combat")
        end	
    end
end