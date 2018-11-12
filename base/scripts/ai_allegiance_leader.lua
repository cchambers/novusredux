require 'base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = false
AI.Settings.SkipIntroDialog = true

__Allegiance_Data = nil
function AllegianceData()
    if ( __Allegiance_Data == nil ) then
        __Allegiance_Data = GetAllegianceDataById(this:GetObjVar("Allegiance") or 1)
    end
    return __Allegiance_Data
end

function Dialog.OpenGreetingDialog(user)
    
    local karmaLevel = GetKarmaLevel(GetKarma(user))
    if ( karmaLevel.DisallowAllegiance ) then
        this:NpcSpeech(karmaLevel.Name.."!")
        LookAt(this, user)
        return
    end

    local allegianceData = AllegianceData()

    local userAllegianceId = GetAllegianceId(user)
    if ( userAllegianceId == nil ) then
        InteractionNoAllegiance(user)
    else
        -- already in a allegiance
        if ( userAllegianceId == AllegianceData().Id ) then
            -- in the same allegiance
            InteractionSameAllegiance(user)
        else
            -- in opposing allegiances
            InteractionOpposingAllegiance(user)
        end
    end
end

function InteractionNoAllegiance(user)
    
    local response = {}
    local text = "Are you here to join the allegiance of "..AllegianceData().Name.."?"

    response[1] = {}
    response[1].text = "Yes."
    response[1].handle = "JoinAllegianceConfirm"
    
    response[2] = {}
    response[2].text = "No."
    response[2].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)

end

function InteractionSameAllegiance(user)

    local allegianceResign = user:GetObjVar("AllegianceResign")

    if ( allegianceResign ) then
        InteractionResignAllegiance(user, allegianceResign)
        return
    end
    
    local response = {}
    local text = "Hello there warrior, keep up the good fight.\n\n"

    text = "Incase you're curious, here are allegiance rules:\n"
    text = AllegianceRules(text)
    
    response[1] = {}
    response[1].text = "Ok."
    response[1].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)

end

function InteractionResignAllegiance(user, allegianceResign)

    if ( allegianceResign ~= true and allegianceResign > DateTime.UtcNow ) then
    
        local response = {}
        local text = "I see you would like to resign, however allegiance rules dictate you wait a bit longer still."
        
        response[1] = {}
        response[1].text = "Fine."
        response[1].handle = "" 

        NPCInteractionLongButton(text,this,user,"Responses",response)
    else
    
        local response = {}
        local text = "Resign and renouce "..AllegianceData().Name.."? \n\nAll progress with this allegiance will be gone forever."
    
        response[1] = {}
        response[1].text = "Yes."
        response[1].handle = "LeaveAllegiance"
        
        response[2] = {}
        response[2].text = "Not Yet."
        response[2].handle = "" 
    
        NPCInteractionLongButton(text,this,user,"Responses",response)

    end

end

function InteractionOpposingAllegiance(user)
    
    local response = {}
    local text = "I don't deal with the likes of you."
    
    response[1] = {}
    response[1].text = "Goodbye."
    response[1].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)

end

function Dialog.OpenLeaveAllegianceDialog(user)

    local allegianceResign = user:GetObjVar("AllegianceResign")

    if ( allegianceResign ~= true ) then
        if ( allegianceResign == nil or allegianceResign > DateTime.UtcNow ) then
            Dialog.OpenGreetingDialog(user)
            return
        end
    end

    AllegianceRemovePlayer(user, AllegianceData().Id)
    local text = "Thank you for your service, now be gone!"
    
    local response = {}
    response[1] = {}
    response[1].text = "Goodbye."
    response[1].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function AllegianceRules(text)
    text = text .. "-Minimum mandatory service of "..TimeSpanToWords(ServerSettings.Allegiance.ResignTime)..".\n"
    text = text .. "-Karma is never considered for actions between opposing allegiances.\n"
    text = text .. "-Guards do not interfere with conflict between opposing allegiances.\n"
    text = text .. "-Beneficial actions on you are prohibited save for fellow allegiance members.\n"
    return text
end

function Dialog.OpenJoinAllegianceConfirmDialog(user)

    local text = "Are you ready to swear your undying fealty to "..AllegianceData().Name.."?\n\n"

    text = text .. "By joining you are bound to allegiance rules:\n"
    text = AllegianceRules(text)
    
    local response = {}
    response[1] = {}
    response[1].text = "I'm ready to fight."
    response[1].handle = "JoinAllegiance" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenJoinAllegianceDialog(user)

    AllegianceAddPlayer(user, AllegianceData().Id)
    local text = "Welcome to the allegiance of "..AllegianceData().Name..". Make us proud."
    
    local response = {}
    response[1] = {}
    response[1].text = "Ok."
    response[1].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

this:SetObjVar("Invulnerable", true)

if ( AllegianceData().AllegianceLeaderTitle ) then
    this:SetSharedObjectProperty("Title", AllegianceData().AllegianceLeaderTitle)
end

-- set the allegiance icon
--this:SetSharedObjectProperty("Faction", AllegianceData().Icon)