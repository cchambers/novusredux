TIME_TO_RESPAWN = 60*15

function Destroy(user)
        if (this:GetSharedObjectProperty("IsDestroyed") == true) then return end 
        local nearbyDragon = FindObject(SearchTemplate("fire_dragon")) 
        if (nearbyDragon ~= nil and not IsDead(nearbyDragon)) then return end
        if (this:HasSharedObjectProperty("IsDestroyed") ) then
            this:SetSharedObjectProperty("IsDestroyed",true)
        end
        if (spiderController ~= nil) then
            spiderController:SendMessage("NestDestroyed",this)
        end
        this:ClearCollisionBounds()
        CreateObj("fire_dragon_young",this:GetLoc(),"dragonSpawned")
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(TIME_TO_RESPAWN),"respawn")
    end

RegisterEventHandler(EventType.Message, "UseObject", 
    function (user,usedType)
        --DebugMessage(1)
        if(usedType ~= "Break") then return end
        --DebugMessage(2)
        local nearbyDragon = FindObject(SearchTemplate("fire_dragon")) 
        if (nearbyDragon ~= nil and not IsDead(nearbyDragon)) then 
            user:SystemMessage("Something is moving inside it...","info")
            return
        end
        
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
RegisterEventHandler(EventType.CreatedObject,"dragonSpawned",
    function(success,objRef,newAge)
        objRef:SendMessage("AttackEnemy",target)
        --DebugMessage("Changing age to "..newAge.." in "..objRef:GetName())
    end)

--AddView("ProximityView", SearchPlayerInRange(2.5,true))
--RegisterEventHandler(EventType.EnterView,"ProximityView",function (user)
--    Destroy(user)
--end)

RegisterEventHandler(EventType.Timer,"respawn", function()
    this:SetName("Dragon Egg")
    this:SetCollisionBoundsFromTemplate(this:GetCreationTemplateId())
    this:SetSharedObjectProperty("IsDestroyed",false)
    end)

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function()
        AddUseCase(this,"Break",true)        
    end)