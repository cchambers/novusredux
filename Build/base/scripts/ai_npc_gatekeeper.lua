require 'base_ai_npc'

RUNE_PURCHASE_FEE = 100

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = false
AI.Settings.SkipIntroDialog = true

gatekeeperTeleporterObject = nil

nukeTargets = {}

function GetDestinationPrice(destInfo)
    return destInfo.Price * (1-ServerSettings.Merchants.GatekeeperDiscount)
end

function GetTeleporterObject()
    if not(gatekeeperTeleporterObject) then
        gatekeeperTeleporterObject = FindObject(SearchHasObjVar("GatekeeperTeleporter",20))
    end
    return gatekeeperTeleporterObject
end

function Dialog.OpenGreetingDialog(user)
    FaceObject(this,user)
    
    local karmaLevel = GetKarmaLevel(GetKarma(user))
    if not( karmaLevel.GuardProtectPlayer ) then
        this:NpcSpeech("I don't deal with you, "..karmaLevel.Name.."!")
        return
    end
    
    local text = "Greetings. Where would you like to go?"
    local responses = {}

    local destinations = this:GetObjVar("Destinations") or {}
    
    for i,destinationInfo in pairs(destinations) do
        local text = destinationInfo.DisplayName
        if(GetDestinationPrice(destinationInfo) > 0) then
            text = text .. " (" ..ValueToAmountStr(GetDestinationPrice(destinationInfo),false,true)..")"
        end

        table.insert(responses,{
            text = text,
            handle = tostring(i)
        })
    end
    --[[
    table.insert(responses,{
            text = "I want a rune for this location.",
            handle = "BuyRune",
        })
    ]]--
    table.insert(responses,{
            text = "Nevermind.",
            handle = "Close",
        })

    NPCInteractionLongButton(text,this,user,"Responses",responses)
end

RegisterEventHandler(EventType.ModuleAttached,"ai_npc_gatekeeper",
    function ( ... )
        if(initializer and initializer.Destinations) then
            this:SetObjVar("Destinations",initializer.Destinations)
        end

        this:SetObjVar("IsGuard",true)
    end)

OverrideEventHandler("base_ai_npc",EventType.DynamicWindowResponse, "Responses",
    function ( user,buttonId )    
        if(buttonId == nil or buttonId == "") then return end

        if(buttonId == "Close") then
            user:CloseDynamicWindow("Responses")            
        elseif(buttonId == "BuyRune") then
            local text = "Sure. I can sell you one for "..RUNE_PURCHASE_FEE.." coins."
            local responses = {
                {
                    text = "Great!",
                    handle = "BuyRune2",
                },
                {
                    text = "Nevermind.",
                    handle = "Close",
                },
            }
            NPCInteractionLongButton(text,this,user,"Responses",responses)
        elseif(buttonId == "BuyRune2") then
            user:CloseDynamicWindow("Responses")     
            BuyRune(user)
        else
            local destinations = this:GetObjVar("Destinations")
            local responseIndex = tonumber(buttonId)
            if(destinations and responseIndex and responseIndex <= #destinations) then            
                local destinationInfo = destinations[responseIndex]

                if not(GetTeleporterObject()) then
                    this:NpcSpeech("This tower is not active.")
                    return
                end

                local price = GetDestinationPrice(destinationInfo)

                if (price > 0 and CountCoins(user) < price) then
                    this:NpcSpeech("I beg your pardon, but you can't afford that.")
                    return
                end

                if(price > 0) then
                    local transactionId = "Teleport|"..buttonId
                    RequestConsumeResource(user,"coins",price,transactionId,this)                   
                else
                    CompleteTransaction(user,destinationInfo)
                end
            end
        end
    end)

OverrideEventHandler("base_ai_mob",EventType.Message,"AddThreat",
    function (targetObj,amount)
        if(targetObj:DistanceFrom(this) <= ServerSettings.PlayerInteractions.GatekeeperProtectionRange) then
            table.insert(nukeTargets,targetObj)
            local faceTarget = nukeTargets[1]
            if not(this:HasTimer("NukeComplete")) then
                FaceObject(this,faceTarget)

                this:PlayAnimation("cast")
                this:PlayEffect("CastWater2")
                this:PlayObjectSound("event:/magic/air/magic_air_cast_air",false,1.0)

                CallFunctionDelayed(TimeSpan.FromSeconds(1),
                    function ( ... )
                        for i,nukeTarget in pairs(nukeTargets) do
                            nukeTarget:SendMessage("ProcessTrueDamage", this, 5000, true)
                            nukeTarget:PlayEffect("LightningCloudEffect")
                            nukeTarget:SystemMessage("[$1820]","info")
                            if not(IsPlayerCharacter(nukeTarget)) then
                                nukeTarget:SetObjVar("guardKilled",true)
                            end
                        end
                    end,"NukeComplete")
            end
        end
    end)

function CompleteTransaction(user,destinationInfo)
    if not(GetTeleporterObject()) then return end

    FaceObject(this,user)

    this:NpcSpeech("One moment while I attune your body to that destination.")

    -- this is on a timer so it can handle multiple people
    CallFunctionDelayed(TimeSpan.FromSeconds(1),function ()
        if not(this:HasTimer("CastComplete")) then
            this:PlayAnimation("cast")
            this:PlayEffect("CastWater2")
            this:PlayObjectSound("event:/magic/air/magic_air_cast_air",false,2.0)
        end
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"CastComplete")
    end)                        

    CallFunctionDelayed(TimeSpan.FromSeconds(3.2),function()
            PlayEffectAtLoc("TeleportToEffect",user:GetLoc())
            user:SystemMessage("You have been attuned for travel to the "..destinationInfo.DisplayName,"info")
            user:SendMessage("StartMobileEffect", "GatekeeperEffect", GetTeleporterObject(), destinationInfo)
        end)
end

function BuyRune(user)
    RequestConsumeResource(user,"coins",RUNE_PURCHASE_FEE,"Rune|",this)
end

function CreateRune(user)
    local runeTemplate = this:GetObjVar("RuneTemplate")
    CreateObjInBackpackOrAtLocation(user, runeTemplate, "RuneCreated")
    this:NpcSpeech("It's been a pleasure doing business with you.")
    user:SystemMessage("The gatekeeper hands you a teleportation rune.","info")
    RegisterSingleEventHandler(EventType.CreatedObject,"RuneCreated",
        function(success,objRef)
            if(success) then
                local regionAddress = ServerSettings.RegionAddress
                if(regionAddress) then
                    objRef:SetObjVar("RegionAddress", regionAddress)
                end
                SetItemTooltip(objRef, true)
            end
        end)
end

RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
    function (success,transactionId,user)   
        if(success) then            
            local args = StringSplit(transactionId,"|")

            if(args[1] == "Teleport") then
                local responseIndex = tonumber(args[2])
                if not(responseIndex) then return end

                local destinations = this:GetObjVar("Destinations")
                if not(destinations) or not(destinations[responseIndex]) then return end

                local destinationInfo = destinations[responseIndex]

                CompleteTransaction(user,destinationInfo)
            elseif(args[1] == "Rune") then
                CreateRune(user)
            end
        else
            this:NpcSpeech("I beg your pardon, but you can't afford that.")
            return
        end
    end)

RegisterEventHandler(EventType.Timer, "CastComplete",
    function ( ... )
        this:PlayAnimation("cast_heal")
        this:StopEffect("CastWater2",0.5)
    end)