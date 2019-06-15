require 'base_mobile_advanced'
--require 'base_ai_conversation'

thingsToSay = { "Welcome to Uaran!", 
                "Lovely weather we are having.", 
                "Have you met Puppy? Isn't he friendly?", 
                "Have you seen the Mayor? I must speak with him!",
                "Welcome adventurer!",
                "Greetings",
                "Have you seen the dead gate?",
                "I hear the dead are stirring in their graves." }

function HandleModuleLoaded()
  if( initializer.Names ~= nil ) then
    this:SetName(npcNames[math.random(1, #initializer.Names)])  
  end
end

function HandleEnterView(target)
  --DebugMessage("npc:HandleEnterView(" .. tostring(target) .. ")")
  this:NpcSpeech(thingsToSay[math.random(1,#thingsToSay)])
  this:SetFacing(this:GetLoc():YAngleTo(target:GetLoc()))
end

function HandleInteract(user,usedType)
    if(usedType ~= "Interact") then return end
    
    this:NpcSpeech("That tickles!")
end

RegisterSingleEventHandler(EventType.ModuleAttached, "ai_npc", HandleModuleLoaded)
RegisterEventHandler(EventType.EnterView, "NearbyPlayer", HandleEnterView)
RegisterEventHandler(EventType.Message, "UseObject", HandleInteract)

AddView("NearbyPlayer", SearchPlayerInRange(5))
