require 'default:base_ai_mob'

function AI.Init()
    -- DAB NOTE: We are calling SetSetting so it sets the objvar so we can see this externally
    AI.SetSetting("ChargeSpeed",AI.GetSetting("ChargeSpeed"))
    
    local crSet = AI.GetSetting("ChaseRange") or 0
    local bodSz = GetBodySize(this) or 0 
    local chaseViewRange = math.min(crSet + bodSz,30)

    AddAIView("chaseRange",SearchMobileInRange(chaseViewRange,this:HasObjVar("SeeInvis")))
    
    --DFB HACK: Remove the trap view 
    --AddAIView("trapView",SearchObjectInRange(chaseViewRange),0.5)
    this:SetObjVar("SpawnPosition",this:GetLoc())
    if (initializer ~= nil) then
        if( initializer.Names ~= nil ) then
            local newName = initializer.Names[math.random(#initializer.Names)]
            this:SetName(newName)
        end        
    end
    local initialState = AI.InitialState
    local shouldSleep = AI.GetSetting("ShouldSleep")
    if (initialState == nil)then
        if (shouldSleep) then
            initialState = "Disabled"
        else
            initialState = "Idle"
        end
    end
    AI.StateMachine.Init(initialState)

    if (shouldSleep)then
        AddView("PlayersInRange",SearchPlayerInRange(30,true),0.5)
    end
    ViewsSleeping = shouldSleep
end
