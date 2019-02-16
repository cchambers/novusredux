RegisterEventHandler(
    EventType.Message,
    "UseObject",
    function(user, usedType)
        if (usedType ~= "Use" and usedType ~= "Examine") then
            return
        end

        if(this:HasTimer("NoSpam")) then 
            user:SystemMessage("Let it breathe, man.", "info")
            return false
        else
            this:ScheduleTimerDelay(TimeSpan.FromMinutes(2), "NoSpam")
        end

        FaceObject(user, this)
        SetMobileModExpire(user, "Freeze", "Binger", true, TimeSpan.FromSeconds(3))
        StartSpecialEffect(this, "Binger")
        CallFunctionDelayed(
            TimeSpan.FromSeconds(1.5),
            function()
                user:PlayAnimation("bow")
                user:PlayEffect("bsSmoke",8)
            end
        )
    end
)
