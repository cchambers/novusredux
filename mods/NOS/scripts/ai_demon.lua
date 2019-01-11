require 'default:ai_demon'

if (this:HasObjVar("DoEffect")) then
    local effect = this:GetObjVar("DoEffect")
    -- local delay = this:GetObjVar("EffectDelay") or 2
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"DoEffect", effect)
end

RegisterEventHandler(EventType.Timer,"DoEffect",function ( effect )
    this:PlayEffect(effect, 3)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"DoEffect", effect)
end)