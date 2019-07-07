
local _corpse

if ( initializer and initializer.Corpse ) then
    _corpse = initializer.Corpse
    this:SetObjVar("Corpse", _corpse)
end

if ( _corpse == nil ) then
    _corpse = this:GetObjVar("Corpse")
end

local delay = TimeSpan.FromSeconds(1)
function CheckCorpse()
    if ( _corpse == nil or not _corpse:IsValid() ) then
        this:Destroy()
        return
    end
    this:ScheduleTimerDelay(delay, "CheckCorpse")
end
RegisterEventHandler(EventType.Timer, "CheckCorpse", CheckCorpse)
this:ScheduleTimerDelay(delay, "CheckCorpse")