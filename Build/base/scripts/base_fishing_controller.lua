require 'incl_fishing'
require 'incl_player_titles'
require 'incl_container'

MIN_FISHING_TIME = 6
MAX_FISHING_TIME = 30
MIN_REELING_TIME = 3
MAX_REELING_TIME = 20
FISHING_RANGE = 25
FISH_SCHOOL_DIFFICULTY_BONUS = 20
mTargetLoc = nil

CHANCE_TO_FISH_SOS = { -- percent based
    0.05, --sos_map
    0.04, --sos_map_1
    0.03, --sos_map_2
    0.02, --sos_map_3
    0.01 --sos_map_4
}

-- minimum skill before there's a chance to fish an sos map
SKILL_TO_FISH_SOS = {
    20,
    40,
    50,
    70,
    90
}

-- NOTE: this assumes the fish controller is on the map controller object!
fishController = nil
function GetFishController()
    if( fishController == nil or not fishController:IsValid() ) then
        fishController = FindObjectWithTag("FishController")
    end

    return fishController
end

function RemoveAllTimers()
    this:RemoveTimer("ReelTimer")
    this:RemoveTimer("ReelSuccessTimer")
    this:RemoveTimer("fishingTimer")
    this:RemoveTimer("CheckFishTimer")
end

function CleanUp()
    --DebugMessage("Firing")
    this:PlayAnimation("idle")
    this:StopObjectSound("FishReel")
    RemoveAllTimers()
    this:DelModule(GetCurrentModule())
end

function ValidateUse(user)
    if( user == nil or not(user:IsValid()) ) then
        return false
    end

    local rod = this:GetEquippedObject("RightHand")
    if( not(rod) or rod:GetObjVar("WeaponType") ~= "FishingRod" ) then
        user:SystemMessage("[FA0C0C] You need to equip a fishing rod to fish!")
        return false
    end

    if (user:HasTimer("fishingTimer")) then
        user:SystemMessage("You are already fishing.")
        return false
    end

    if (user:HasTimer("ReelSuccessTimer")) then
        user:SystemMessage("You are reeling in a fish!")
        return false
    end

    return true
end

function GetFishSizeDisplayString(size)
    if (size == 5) then
        return "[$1641]"    
    elseif (size == 4) then
        return "It's gigantic! It's a great catch!"
    elseif (size == 3) then
        return "It's huge! It's a good catch!"
    elseif (size == 2) then
        return "It's healthy looking!"
    elseif (size == 1) then
        return "It's not very big..."    
    end
end

function GetFishTitleString(size,player)
    --DebugMessage(size,this)
    if (size == 5) then
        PlayerTitles.EntitleFromTable(this,AllTitles.ActivityTitles.FishingLegendary)
        return "[D4CC74]Legendary"
    elseif (size == 4) then        
        return "[D68A3E]Gigantic"
    elseif (size == 3) then
        return "[D6623E]Huge"
    elseif (size == 2) then
        return "[8B95E0]Large"
    elseif (size == 1) then
        return "[C8CBE6]Small"
    end
end

function CheckFindSos(player)
    local fishingLevel = GetSkillLevel(player,"FishingSkill")
    local sosRoll = math.random(0, 99999) / 100000 
    for i,chance in ipairs(CHANCE_TO_FISH_SOS) do
        if ( fishingLevel >= SKILL_TO_FISH_SOS[i] and chance > sosRoll ) then            
            return i
        end
    end
    return false
end

function CheckFindSosTreasure(player)
    local backpackObj = player:GetEquippedObject("Backpack")
    if( backpackObj == nil ) then return false end

    local packObjects = backpackObj:GetContainedObjects()  
    for index, packObj in pairs(packObjects) do 
        if( packObj:HasModule("sos_map") ) then
            local mapLocation = packObj:GetObjVar("MapLocation")
            if( mapLocation ~= nil and mapLocation:Distance(mTargetLoc) < 80 ) then
                packObj:SendMessage("FoundSosTreasure", player)
                return true
            end
        end
    end
    return false
end

function DoFish(targetLoc)        
    if(targetLoc == nil) then CleanUp() return end

    if not( ValidateUse(this) ) then CleanUp() return end

    local wellItem = FindItemInContainerRecursive(backpackObj,
        function(item)            
            return item:GetObjVar("UnpackedTemplate") == "well"
        end)

    if( this:GetLoc():Distance(targetLoc) >= FISHING_RANGE ) then
        this:SystemMessage("That location is too far away.","info")
        CleanUp()
        return
    end

    --if (not this:HasLineOfSightToLoc(targetLoc,ServerSettings.Combat.LOSEyeLevel)) then
    --    this:SystemMessage("You can't see that location.")
     --   return
    --end

    if (not IsLocInRegion(targetLoc,"Water")) then
        this:SystemMessage("[FF0000]You need to cast into water to fish![-]","info")
        CleanUp()
        return
    end    

    mTargetLoc = targetLoc
    this:SetFacing(this:GetLoc():YAngleTo(targetLoc))
    this:PlayAnimation("fishcast")
    this:PlayObjectSound("FishCast")
    CallFunctionDelayed(TimeSpan.FromSeconds(2.7),function ( ... )
            PlayEffectAtLoc("WaterSplashEffect",targetLoc)
        end)

    -- first see if we fished on a fish school    
    local fishSchool = GetNearbySchoolOfFish(targetLoc)      
    if(fishSchool) then
        local fishName = fishSchool:GetObjVar("SchoolOfFish")
        -- DAB TODO REQUEST FISH FROM SCHOOL
        mFish = {
            Template = AllFish[fishName].Template,
            Size = GetFishSize(),
            DisplayName = AllFish[fishName].DisplayName,
            MinSkill = math.max(0,AllFish[fishName].MinSkill - FISH_SCHOOL_DIFFICULTY_BONUS),
        }
        StartFishingTimer()
        return
    end

    -- next check to see if we have a treasure map for this location
    mFoundSosTreasureMap = CheckFindSosTreasure(this)
    if(mFoundSosTreasureMap) then
        StartFishingTimer()
        return
    end

    -- next see if we fish up a treasure map
    mFoundSos = CheckFindSos(this)
    if(mFoundSos) then
        StartFishingTimer()
        return
    end

    -- finally try to get a fish from the fish resource controller
    local fishController = GetFishController()
    if (fishController) then
        -- request a fish from the fish controller
        GetFishController():SendMessage("RequestFishResource",this,targetLoc)
        return
    end

    -- DAB TODO: We could have a default fish table for maps with no fish controller
    StartFishingTimer()    
end

RegisterEventHandler(EventType.Message,"RequestFishResourceResponse",
    function (fish)
        mFish = fish
        StartFishingTimer()
    end)

function StartFishingTimer()    
    --DebugMessage("--StartFishingTimer",DumpTable(mFish))
    -- we check to see if we catch the fish here so its one single skill check
    -- then we set the fish and reel timers based on the difficult and weight of the fish
    local fishHookTime = MIN_FISHING_TIME

    mFishHookSuccess = false
    mFishCatchSuccess = false
    if(mFish) then
        if( GetFishSuccessRoll(this,mFish) ) then
            mFishHookSuccess = true
            mFishCatchSuccess = true
        else
            -- always hook the fish when fishing into a school
            if(isSchool) then
                mFishHookSuccess = true
            else
                -- we failed our roll so give them a 50% chance to hook the fish (it will fail on reeling instead)
                mFishHookSuccess = math.random() > 0.5
            end
        end    
        -- additional hook time is a factor of MAX TIME - MIN TIME based on fish difficulty
        fishHookTime = MIN_FISHING_TIME + (mFish.MinSkill / 100 * (MAX_FISHING_TIME - MIN_FISHING_TIME))
    elseif(mFoundSos or mFoundSosTreasureMap) then
        mFishHookSuccess = true
        mFishCatchSuccess = true
    end

    CallFunctionDelayed(TimeSpan.FromSeconds(3),function() this:PlayAnimation("fishidle") end)

    this:ScheduleTimerDelay(TimeSpan.FromSeconds(fishHookTime),"fishingTimer")  
end

RegisterEventHandler(EventType.Timer,"fishingTimer",
    function()
        --DebugMessage("--fishingTimer")
        if not(mFish) and not(mFoundSos) and not(mFoundSosTreasureMap) then
            this:SystemMessage("There doesn't seem to be any fish nearby.","info")
            CleanUp()
        elseif(mFishHookSuccess) then
            StartReeling()
        else
            this:SystemMessage("You haven't found any fish.","info")
            this:SystemMessage("You haven't found any fish.")
            CheckSkillChance(this,"FishingSkill")
            CleanUp()
        end
    end)

function GetRod()
    local rodObj = this:GetEquippedObject("RightHand")
    local isRod = rodObj and GetWeaponType(rodObj) == "FishingRod" 

    if(isRod) then
        return rodObj
    end
end

function StartReeling()
    RemoveAllTimers()

    local reelTime = MIN_REELING_TIME
    if(mFish) then
        local maxSize = #ServerSettings.Resources.Fish.SizeChance
        reelTime = MIN_REELING_TIME + (mFish.Size / maxSize * (MAX_REELING_TIME - MIN_REELING_TIME))
    end

    local fishingRod = GetRod()
    if not(fishingRod) then
        this:SystemMessage("You quietly slip your fishing rod back into your pack.","info")
        CleanUp()
    else
        this:SystemMessage("Something is hooked on the line!","info")
        this:PlayObjectSound("FishReel")
        this:PlayObjectSound("FishJump")    
        this:PlayAnimation("fishhook")
        
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(reelTime),"ReelTimer")
    end
end

RegisterEventHandler(EventType.Timer,"ReelTimer",
    function()
        local fishingRod = GetRod()
        if not(fishingRod) then
            this:SystemMessage("You quietly slip your fishing rod back into your pack.","info")
            CleanUp()
        else    
            if ( Success(ServerSettings.Durability.Chance.OnToolUse) ) then
                AdjustDurability(fishingRod, -1)
            end

            if(mFoundSos) then
                CreateObjInBackpackOrAtLocation(this, "sos_map_"..mFoundSos)
                this:SystemMessage("You found a treasure map!")
                this:SystemMessage("You found a treasure map!", "event")
                CleanUp() 
                return
            end

            if(mFoundSosTreasureMap and mFoundSosTreasureMap:IsValid()) then
                mFoundSosTreasureMap:SendMessage("FoundSosTreasure", this)
                CleanUp() 
                return
            end

            if (not(mFish) or not(mFishCatchSuccess)) then
                this:SystemMessage("The "..mFish.DisplayName.." got away!","info")
                this:SystemMessage("The "..mFish.DisplayName.." got away!")
                CheckSkillChance(this,"FishingSkill")
                CleanUp()
                return
            end            

            local backpackObj = this:GetEquippedObject("Backpack")
            if( backpackObj == nil ) then 
                this:SystemMessage("[D7D700]You have no backpack. You release the fish back into the water.[-]","info")
                CleanUp() 
                return 
            end

            this:RemoveTimer("FishingAnimationTimer")
            sizeString = GetFishSizeDisplayString(mFish.Size)
            local messageStr = "[D7D700]You caught a "..mFish.DisplayName.."! "..sizeString .."[-]"
            this:SystemMessage(messageStr,"info")
            this:SystemMessage(messageStr)

            CheckSkillChance(this,"FishingSkill")
            --DebugMessage(fish.Size.." is the fish size")        

            local templateData = GetTemplateData(mFish.Template)
            local templateWeight = templateData.SharedObjectProperties.Weight
            local templateScale = templateData.ScaleModifier
            local templateResourceType = templateData.ObjectVariables.ResourceType or "Fish"

            local fishResourceType = templateResourceType .. tostring(mFish.Size)

            local stackSuccess, stackObj = TryAddToStack(fishResourceType,backpackObj,1)
            if not( stackSuccess ) then
                local fishWeight = ServerSettings.Resources.Fish.SizeWeights[mFish.Size]*templateWeight
                local fishScale = templateScale * ServerSettings.Resources.Fish.SizeScales[mFish.Size]

                local dropPosition = GetRandomDropPosition(backpackObj)
                if (not CanAddWeightToContainer(backpackObj,fishWeight)) then
                    this:SystemMessage("[D7D700]Your backpack is full. You release the fish back into the water.[-]","info")
                    CleanUp()
                else
                    CreateObjExtended(mFish.Template,backpackObj,dropPosition,Loc(0,0,0),Loc(fishScale,fishScale,fishScale),"created_fish",fishWeight,mFish.Size,fishResourceType)
                end
            else
                CleanUp()
            end
        end
    end)

RegisterEventHandler(EventType.CreatedObject,"created_fish",function (success,objRef,fishWeight,fishSize,fishResourceType)
    --DebugMessage(1)
    if (success) then
        objRef:SetSharedObjectProperty("Weight",fishWeight)
        objRef:SetObjVar("ResourceType",fishResourceType)
        objRef:SetName(GetFishTitleString(fishSize).." "..StripColorFromString(objRef:GetName()).."[-]")
        if (objRef:TopmostContainer() == nil) then
            Decay(objRef)
        end
        SetItemTooltip(objRef)
    end
    CleanUp()
end)

RegisterEventHandler(EventType.ModuleAttached,"base_fishing_controller",
    function ()
        if(initializer ~= nil) then
            DoFish(initializer.TargetLoc)
        end
    end)

RegisterEventHandler(EventType.StartMoving,"",function ( ... )
    this:SystemMessage("[D70000]The line snaps![-]","info")
    CleanUp()
end)

RegisterEventHandler(EventType.Message,"DamageInflicted",function ( ... )
    this:SystemMessage("[D70000]The line snaps![-]","info")
    CleanUp()
end)