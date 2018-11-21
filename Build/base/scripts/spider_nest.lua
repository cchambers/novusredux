TIME_TO_RESPAWN = 60*15
MAX_SPIDERS = 2
MIN_SPIDERS = 1

spiderController = FindObject(SearchMulti({
                        SearchModule("spider_nest_controller"),
                        SearchRange(this:GetLoc(), 30),
                    })) --find a spidernest controller 

function Destroy(user)
        if (this:GetSharedObjectProperty("IsDestroyed") == true) then return end 
        this:SetSharedObjectProperty("IsDestroyed",true)
        if (spiderController ~= nil) then
            spiderController:SendMessage("NestDestroyed",this)
        end
        this:SetName("Destroyed Spider Nest")
        local i = 1
        local spawnAmount = math.random(MIN_SPIDERS,MAX_SPIDERS)
        while i <= spawnAmount do 
            target = user
            CreateObj("graveyard_spider",this:GetLoc():Project(math.random(0,360), math.random(1,3)),"MobCustomAge",math.random(5,6))
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