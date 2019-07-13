require 'NOS:incl_gametime'

AI.Settings.SleepTime = 18
AI.Settings.WakeTime = 6
--AI.Settings.Debug = true
--make a spawnlocation variable if not one
if (initializer ~= nil and not this:HasObjVar("SpawnLocation")) then
    this:SetObjVar("SpawnLocation",this:GetLoc())
end
--adds to table as a scheduled event sleeping
if (AI.IdleStateTable ~= nil) then
    table.insert(AI.IdleStateTable, {StateName = "GoToSleep",Type = "sleep",Time = AI.GetSetting("SleepTime"),Duration = 6})
end

function ShouldWake()
    --DebugMessage("Checking wake.")
    if (GetGameTimeOfDay() >= AI.GetSetting("WakeTime") and GetGameTimeOfDay() <= AI.GetSetting("SleepTime")) then
        --DebugMessage("Sleep is for the weak.")
        return true
    else
        --DebugMessage("Should sleep")
        return false
    end
    return false
end

AI.StateMachine.AllStates.GoToSleep = {   
        GetPulseFrequencyMS = function() return 5000 end,

        OnEnterState = function()
            --DebugMessage(this:GetName().." is GoToSleep")
            local bedLoc = this:GetObjVar("bedLoc")
            --if I don't have a bed location
            if( bedLoc == nil ) then
                bedLoc = this:GetObjVar("SpawnLocation") --Use spawn location
                DebugMessageA(this,"[base_ai_sleep::GoToSleep] No valid sleep location")
            end
            --find all beds within 10 units of the bedloc
            local bed = FindObject(SearchMulti({SearchRange(bedLoc, 10),SearchModule("bed")}))
            if (bed ~= nil)  then
                bedLoc = bedLoc:ProjectTowards(this:GetLoc(),2)--bed:GetLoc():Project(this:GetFacing() + 180,1)
                DebugMessageA(this,"Found Sleep")
            end
            DebugMessageA(this,"SleepLoc = " .. tostring(bedLoc))
            this:PathTo(bedLoc,1.0,"goToSleep") 

        end,
    }

AI.StateMachine.AllStates.Sleep = {
        GetPulseFrequencyMS = function() return 60000 end,

        OnExitState = function()
            this:PlayAnimation("rise")
        end,

        AiPulse = function ()
            if (ShouldWake()) then
                this:SendMessage("WakeUp")
                AI.StateMachine.ChangeState("Idle")
            end
        end,

        OnEnterState = function()
            local bedLoc = this:GetObjVar("bedLoc")
            if( bedLoc == nil ) then
                bedLoc = this:GetObjVar("SpawnLocation")
            end
            --DebugMessage("bedLoc is "..tostring(bedLoc))
            if( this:GetLoc():Distance(bedLoc) < 10 ) then
                --DebugMessage("Near bed")
                local bed = FindObject(SearchMulti({SearchRange(bedLoc, 10),SearchModule("bed")}))
                if (bed == nil)  then
                    this:SendMessage("FallAsleep")--sleep right where we're at.
                else
                    bed:SendMessage("UseObject",this)
                end
                --this:PlayAnimation("lay")
            else
                DebugMessageA(this,"[base_ai_sleeping:OnEnterState] ERROR: DID NOT ARRIVE AT LOCATION")
            end
        end,
}

RegisterEventHandler(EventType.Arrived,"goToSleep",
    function (success)
        if(success) then
            --DebugMessage("gotosleep pulse")
            local bedLoc = this:GetObjVar("bedLoc")

            if( bedLoc == nil ) then
                bedLoc = this:GetObjVar("SpawnLocation")
                DebugMessageA(this,"[base_ai_sleep::GoToSleep:AIPulse] No valid sleep location")
            end

            --find all beds within 10 units of the bedloc
            local bed = FindObject(SearchMulti({SearchRange(bedLoc, 5),SearchModule("bed")}))
            if (bed ~= nil)  then
                bedLoc = bed:GetLoc()
                --DebugMessage("found sleep")
            end

            DebugMessageA(this,"bedLoc is "..tostring(bedLoc))
            if( this:GetLoc():Distance(bedLoc) < 5 ) then
                AI.StateMachine.ChangeState("Sleep")
                return
            end
        else
            DebugMessageA(this,this:GetName() .."[base_ai_sleeping:arrived] ERROR: didn't make it to bed!")
            AI.StateMachine.ChangeState("Idle")
        end
    end)
