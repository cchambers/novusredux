
function ValidateUse(user)
    if( user == nil or not(user:IsValid()) ) then
        return false
    end

    if( this:TopmostContainer() ~= user ) then
        user:SystemMessage("[$2521]")
        return false
    end

    return true
end

RegisterSingleEventHandler(EventType.ModuleAttached, "shovel", 
    function()
        SetTooltipEntry(this,"shovel_use", "[$2522]")
        AddUseCase(this,"Dig",true,"HasObject")
    end)

shovelUser = nil

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Dig") then return end

        if not( ValidateUse(user) ) then return end

        user:SystemMessage("Where do you wish to dig?")
        user:RequestClientTargetLoc(this, "dig")
        shovelUser = user
    end)

RegisterEventHandler(EventType.ClientTargetLocResponse, "dig", 
    function(success,targetLoc)        
        if not( ValidateUse(shovelUser) ) then return end

        if( shovelUser:GetLoc():Distance(targetLoc) >= OBJECT_INTERACTION_RANGE ) then
            shovelUser:SystemMessage("That location is too far away.")
            return
        end

        shovelUser:SetFacing(shovelUser:GetLoc():YAngleTo(targetLoc))
        shovelUser:PlayAnimation("kneel")
        PlayEffectAtLoc("DigDirtParticle",targetLoc) 
        this:PlayObjectSound("Digging",false,0.2) 

        this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"digTimer",targetLoc)  
        ProgressBar.Show{TargetUser=shovelUser,Label="Digging",Duration=1.0}
    end)

function IsTMapLocationAlreadyDug(targetLoc,dugLocations)
    for i,dugLoc in pairs(dugLocations) do
        if(targetLoc:Distance(dugLoc) < 2) then
            return true
        end
    end

    return false
end

RegisterEventHandler(EventType.Timer,"digTimer",
    function(targetLoc)
        if not( ValidateUse(shovelUser) ) then return end

        local mobNearby = FindObject(SearchMulti({SearchRange(targetLoc, 1),SearchMobile()}))
        if(mobNearby) then
            shovelUser:SystemMessage("You cannot dig where someone is standing.","info")
            return
        end
            
        if ( Success(ServerSettings.Durability.Chance.OnToolUse) ) then
            AdjustDurability(this, -1)
        end

        local backpackObj = shovelUser:GetEquippedObject("Backpack")
        if( backpackObj == nil ) then return end

        local packObjects = backpackObj:GetContainedObjects()            
        for index, packObj in pairs(packObjects) do 
            if( packObj:HasModule("treasure_map") ) then
                local mapLocation = packObj:GetObjVar("MapLocation")
                local accuracyDist = packObj:GetObjVar("Accuracy") or 5
                if( mapLocation ~= nil and mapLocation:Distance(targetLoc) < accuracyDist ) then
                    local dugLocations = packObj:GetObjVar("DugLocations") or {}
                    if(IsTMapLocationAlreadyDug(targetLoc,dugLocations)) then
                        shovelUser:SystemMessage("That location has already been excavated.","info")
                        return
                    else
                        CreateTempObj("shovel_dirt",targetLoc)                          

                        local difficulty = packObj:GetObjVar("Difficulty") or 0
                        if not(packObj:HasObjVar("Precise") or CheckSkill(shovelUser,"TreasureHuntingSkill", difficulty)) then
                            shovelUser:SystemMessage("Your digging fails to uncover any treasure. Keep digging!","info")
                        elseif(mapLocation:Distance(targetLoc) < 3) then
                            packObj:SendMessage("FoundTreasure",shovelUser)
                            return
                        else
                            shovelUser:SystemMessage("The treasure is not buried here.","info")
                            table.insert(dugLocations,targetLoc)
                            packObj:SetObjVar("DugLocations",dugLocations)
                        end
                    end
                    return
                end
            end
        end

        local digSites = FindObjects(SearchMulti(
            {
                SearchRange(shovelUser:GetLoc(), 4), --in 2 units
                SearchModule("diggable_object"), --find diggable objects
            }))

        --if you dig near a groundskeeper he'll attack you
        local gravekeeper = FindObject(SearchMulti(
            {
                SearchRange(shovelUser:GetLoc(), 13), --in 13 units
                SearchModule("npc_groundskeeper"), --find groundskeeper
            }))
        if (gravekeeper ~= nil) then 
            gravekeeper:SendMessage("AttackEnemy",shovelUser)
            gravekeeper:NpcSpeech("QUIT ROBBIN' ME GRAVES!!!")
            shovelUser:SetObjVar("WilliesOpinion","ScrewYou")
        end

        --dig up a buried item in the digsite.
        for index, digSite in pairs(digSites) do 
            if( digSite:HasModule("diggable_object") ) then
                digSite:SendMessage("DigItem",shovelUser,targetLoc)
                return
            end
        end

        if( shovelUser:IsInRegion("Beach") ) then
            local backpackObj = shovelUser:GetEquippedObject("Backpack")  
            if( backpackObj ~= nil ) then
                -- try to add to the stack in the players pack      
                if not( TryAddToStack("Sand",backpackObj,1) ) then
                    -- no stack in players pack so create an object in the pack
                    local templateId = "resource_sand"
                    local dropLocation = GetRandomDropPosition(backpackObj)
                    CreateObjInContainer(templateId, backpackObj, dropLocation)
                end

                shovelUser:SystemMessage("You collect some sand.","info")
            end 
        else
            shovelUser:SystemMessage("You find nothing of interest there.","info")
        end
    end)