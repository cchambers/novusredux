require 'base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = true
AI.Settings.EnableBuy = false
AI.Settings.SkipIntroDialog = true

-- this is used if we need to forget an ability before we can learn the new one
storedAbilityBookInfo = nil

function GetPrestigeClass()
    return this:GetObjVar("PrestigeClass") or ""
end

function Dialog.OpenGreetingDialog(user)
    local text = nil
    local response = {}
    
    text = "Greetings traveler. Are you here to train in the ways of the "..GetPrestigeDisplayName(GetPrestigeClass()).."?"

    response[1] = {}
    response[1].text = "Yes."
    response[1].handle = "TrainPrestige"

    response[2] = {}
    response[2].text = "Actually, I'd like to learn some basics."
    response[2].handle = "SkillTrain"
    
    response[3] = {}
    response[3].text = "Goodbye."
    response[3].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function HandleForget(user,position)
    if(not(ValidateAbilityUnlock(user,storedAbilityBookInfo.Class,storedAbilityBookInfo.Ability,storedAbilityBookInfo.Book))) then
        return
    end

    if(SlotPrestigeAbility(user, storedAbilityBookInfo.Class,storedAbilityBookInfo.Ability,position)) then
        ConsumeBook(user,storedAbilityBookInfo.Book,storedAbilityBookInfo.Ability,storedAbilityBookInfo.Rank)
        UpdatePrestigeAbilityAction(user,position)        
    end
    storedAbilityBookInfo = nil

    user:CloseDynamicWindow("Responses")
end

function Dialog.OpenForget1Dialog(user)
    HandleForget(user,1)
end

function Dialog.OpenForget2Dialog(user)
    HandleForget(user,2)
end

function Dialog.OpenForget3Dialog(user)
    HandleForget(user,3)
end

function Dialog.OpenCancelForgetDialog( ... )
    storedAbilityBookInfo = nil
end

function OpenForgetSkillDialog(user)
    local text = "It is impossible to have proficiency in more than 3 prestige abilities at one time. Which ability do you wish to forget?"

    response = {}
    for i=1,3 do
        local paClass,paName = GetSlottedPrestigeAbility(user,i)
        table.insert(response,{text=paName, handle="Forget"..i})
    end
    response[4] = {text="Nevermind.", handle="CancelForget"}

    NPCInteractionLongButton(text,this,user,"Responses",response)    
end

function OpenPrestigeAbilityAssignedWindow(user,prestigeAbility)
    local msgStr = "Prestige Ability Unlocked: "..GetPrestigeAbilityDisplayName(GetPrestigeClass(),prestigeAbility)
    user:SystemMessage(msgStr,"info")
    user:SendMessage("OpenPrestigeBook")

    user:PlayObjectSound("event:/ui/quest_complete",false)
end

function ConsumeBook(user,bookObj,prestigeAbility,rank)
    bookObj:Destroy()

    local pointCost = ServerSettings.Prestige.AbilityRankPointCost[rank]
    ConsumePrestigePoints(user,pointCost)

    OpenPrestigeAbilityAssignedWindow(user,prestigeAbility)
end

function ConfirmTrainAbility(user,bookObj,prestigeClass,prestigeAbility,paData)
    ClientDialog.Show{
        TargetUser = user,
        ResponseObj = this,
        DialogId = "TrainAbilityConfirm",
        TitleStr = "Train Ability",
        DescStr = "Do you wish to train "..GetPrestigeAbilityDisplayName(prestigeClass,prestigeAbility).."? This will consume "..ServerSettings.Prestige.AbilityRankPointCost[paData.Rank].." Ability Points.",
        Button1Str = "Confirm",
        Button2Str = "Cancel",
        ResponseFunc=function(user,buttonId)
            if (user == nil) then return end

            if (buttonId == nil) then return end

            if (buttonId == 0 and ValidateAbilityUnlock(user,prestigeClass,prestigeAbility,bookObj)) then
                local position = SlotPrestigeAbility(user, prestigeClass, prestigeAbility)
                if(position) then
                    CheckAchievementStatus(user, "Activity", "AbilityCount", position)
                    ConsumeBook(user,bookObj,prestigeAbility,paData.Rank)
                    UpdatePrestigeAbilityAction(user,position)
                else
                    storedAbilityBookInfo = {Class=prestigeClass, Ability=prestigeAbility, Book=bookObj, Rank=paData.Rank}
                    OpenForgetSkillDialog(user)
                end                
            end
        end,
    }
end

function HandleBookTargetted(user,targetObj)
    local canUnlock = false
    local reason = "Games"
    local prestigeClass = GetPrestigeClass()
    local prestigeAbility = ""
    local paData = nil 

    if(targetObj) then              
        prestigeAbility = targetObj:GetObjVar("PrestigeAbility")
        if not( prestigeAbility ) then
            reason = "MissingBook"
        else
            paData = GetPrestigeAbility(prestigeClass,prestigeAbility)
            if not(paData) then
                reason = "WrongTrainer"
            else
                canUnlock, reason = ValidateAbilityUnlock(user,prestigeClass,prestigeAbility,targetObj)
                if( canUnlock ) then
                    user:CloseDynamicWindow("Responses")
                    ConfirmTrainAbility(user,targetObj,prestigeClass,prestigeAbility,paData)
                end
            end
        end
    end

    if not(canUnlock) then
        local text = "I have no time to play games. Return to me when you have the book."
        
        if(reason == "Points") then 
            text = "You do not have enough ability points to unlock that ability. You need atleast "..ServerSettings.Prestige.AbilityRankPointCost[paData.Rank].."." 
        elseif(reason == "MissingBook") then 
            text = "You have not handed me the correct skill book." 
        elseif(reason == "WrongTrainer") then 
            text = "I do not have the knowledge to train you in that ability. You must seek out another trainer." 
        elseif(reason == "LessThanCurrent") then
            text = "I only teach forward, you as a student are beyond what that book can offer."
        elseif(reason:match("Skill")) then
            local preReqs = BuildPrestigePrerequisitesString(paData or GetPrestigeAbility(prestigeClass,prestigeAbility))
            text = "You do not have the required skill to unlock this ability.\n\nRequires:\n"..preReqs
        end

        local response = {
        {
            text = "Ok."
        } }

        NPCInteractionLongButton(text,this,user,"Responses",response)
    end
end

function Dialog.OpenTrainPrestigeDialog(user)
    -- finally ask for a scroll
    local text = "Hand me a "..GetPrestigeDisplayName(GetPrestigeClass()).." prestige ability skill book and we will begin your training."
    local response = {
        {
            text = "I will return when I have the book."
        } }

    NPCInteractionLongButton(text,this,user,"Responses",response)

    RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse, "bookTarget",
        function (targetObj)
            HandleBookTargetted(user,targetObj)
        end)
    user:RequestClientTargetGameObj(this, "bookTarget")
end

function Dialog.OpenSkillTrainDialog(user)
        SkillTrainer.ShowTrainContextMenu(user)
end