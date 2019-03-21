
mEffect = nil
mDelay = nil
mWhere = nil
mLength = nil

function CheckEffect() 
    if (this:HasObjVar("DoEffect") and not(IsDead(this))) then
        mEffect = this:GetObjVar("DoEffect")
        mDelay = this:GetObjVar("EffectDelay") or 2
        mLength = this:GetObjVar("EffectLength") or mDelay*2
        mWhere = this:GetObjVar("EffectBone")
        if (mWhere ~= nil) then
            mWhere = tostring("Bone="..mWhere)
        else
            mWhere = "Bone=Ground"
        end
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "DoEffect")
    else
        this:ScheduleTimerDelay(TimeSpan.FromMinutes(5),"CheckEffect")
    end
end

RegisterEventHandler(EventType.Timer,"DoEffect",function ()
    if (not(IsDead(this))) then
        this:PlayEffectWithArgs(mEffect, mLength, mWhere)
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(mDelay), "DoEffect")
    end
end)
RegisterEventHandler(EventType.Timer,"CheckEffect", CheckEffect)

CheckEffect()