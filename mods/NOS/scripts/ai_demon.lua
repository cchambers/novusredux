require 'default:ai_demon'

if (initializer ~= nil) then
    if( initializer.Names ~= nil ) then  
        local nameTable = initializer.Names
        local name = nameTable[math.random(1,#nameTable)]
		this:SetName(name)
    end
end

if (this:HasObjVar("DoEffect")) then
    local effect = this:GetObjVar("DoEffect")
    -- local delay = this:GetObjVar("EffectDelay") or 2
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"DoEffect", effect)
end

RegisterEventHandler(EventType.Timer,"DoEffect",function ( effect )
    this:PlayEffect(effect, 3)
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(2),"DoEffect", effect)
end)