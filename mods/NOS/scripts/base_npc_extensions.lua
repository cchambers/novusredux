--base_interaction_checks.lua
--Simply include this for backwards compatability with older "npc_" scripts

function CanUseNPC(user)
    if not(user) then
        LuaDebugCallStack("ERROR: CanUseNPC called for nil user")
        return false
    end

     if (IsDead(this)) then return false end
    --DebugMessage("AI.MainTarget is "..tostring(AI.MainTarget),"user is "..tostring(user)," and is in combat is "..tostring(IsInCombat(this)))
    if (AI.MainTarget == user and IsInCombat(this)) then 
        if (InsultTarget ~= nil and AI.GetSetting("CanConverse")) then
            --DebugMessage("Yarrgh why are you doing this")
            InsultTarget(user)
        end
        user:CloseDynamicWindow("Responses")
        return false
    end
    return true
end

RegisterEventHandler(EventType.Message,"DamageInflicted",function (damager,damageAmount)
    damager:CloseDynamicWindow("Responses")
    damager:CloseDynamicWindow("Answer")
    damager:CloseDynamicWindow("Question")
    damager:CloseDynamicWindow("Questions")
	damager:CloseDynamicWindow("Actions")
end)