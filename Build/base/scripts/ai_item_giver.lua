require 'base_ai_npc'

AI.Settings.MerchantEnabled = false
AI.Settings.EnableTrain = false
AI.Settings.EnableBuy = false
AI.Settings.SkipIntroDialog = true

function Dialog.OpenGreetingDialog(user)
    local text = nil
    local response = {}
    
    text = this:GetObjVar("Greeting") or "Welcome traveler."

    response[1] = {}
    response[1].text = this:GetObjVar("ItemMessage") or "I would like an item."
    response[1].handle = "GiveItem"
    
    response[2] = {}
    response[2].text = "Goodbye."
    response[2].handle = "" 

    NPCInteractionLongButton(text,this,user,"Responses",response)
end

function Dialog.OpenGiveItemDialog(user)    
    local itemTemplate = this:GetObjVar("ItemTemplate")
    if not(itemTemplate) then
        this:NpcSpeech("I have nothing to give you.")
    else
        local timerId = this:GetCreationTemplateId().."Wait"
        if(user:HasTimer(timerId)) then
            this:NpcSpeech("You just got one! Please come back later.")
        else
            local giveMessage = this:GetObjVar("GiveMessage") or "Here you go!"
            this:NpcSpeech(giveMessage)

            local backpackObj = user:GetEquippedObject("Backpack")
            backpackObj:SendOpenContainer(user)

            CreateObjInBackpackOrAtLocation(user, itemTemplate) 
            user:ScheduleTimerDelay(TimeSpan.FromMinutes(1),timerId)
        end
    end

    user:CloseDynamicWindow("Responses")
end
