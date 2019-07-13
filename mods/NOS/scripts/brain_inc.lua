
mSkipAddCombatModule = true -- prevent base_mobile from attaching combat module

function SetCurrentTarget(newTarget)
    if ( mCurrentTarget ~= newTarget ) then
        mCurrentTarget = newTarget
		this:SendMessage("CurrentTargetUpdate", mCurrentTarget)
    end
    if ( not mCurrentTarget and mInCombatState ) then
        EndCombat()
    end
end

SetInCombat(false)
SetCurrentTarget(nil)

OverrideEventHandler("NOS:combat", EventType.Message, "SetCurrentTarget", SetCurrentTarget)