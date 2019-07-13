require 'NOS:base_mobile_advanced'
require 'NOS:incl_magic_sys'
require 'NOS:god_mobile_controlpanel'
--require 'NOS:base_ai_conversation'

lastTarget = nil
this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"pulse")
RegisterEventHandler(EventType.Timer,"pulse",
function ( ... )
    local target = this:GetObjVar("Target")
    if(IsDead(this)) then
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"pulse")
    elseif(this:HasObjVar("PlayAnim")) then
        local animDelay = this:GetObjVar("AnimDelay") or 1
        this:PlayAnimation(this:GetObjVar("PlayAnim"))
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(animDelay),"pulse")
    elseif(this:HasObjVar("CastSpell") and target and target:IsValid()) then
        local spell = this:GetObjVar("CastSpell")
        local range = GetSpellRange(spell,this)
        --this:PathToTarget(target,range,ServerSettings.Stats.RunSpeedModifier)
        if(this:DistanceFrom(target) < range) then
            local castDelay = GetSpellCastTime(spell, this) + 0.5 + (math.random())
            this:SendMessage("CastSpellMessage",spell,this,target,target:GetLoc())
            local castable = {"Fireball","Icelance","Spikepath","Souldrain","Voidblast"}
            --local castable = {"Icelance"}
            this:SetObjVar("CastSpell",castable[math.random(#castable)])
            SetCurMana(this,GetMaxMana(this))
            this:ScheduleTimerDelay(TimeSpan.FromSeconds(castDelay),"pulse")  
        else
            this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"pulse")
        end
    else
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"pulse")
    end
end)

