mSkillTable = {}
mUser = nil

function HandleModuleLoaded() 
    mUser = this
    if (skillFix == nil) then
        mSkillTable = mUser:GetObjVar("SkillDictionary") or {}
        local count = 0
        for key, vals in pairs(mSkillTable) do
            local skill = SkillData.AllSkills[key]
            if (skill == nil) then 
                count = count + 1
            end
        end
        if (count > 0) then
            for i = 1, count do
                ScheduleKill(i)
            end
        end
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(count + 2), "FinishSkillaKilla");
    end
end

function ScheduleKill(num) 
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(num), "SkillaKilla");
end

function KillSkill()
    local count = 0
    for key, vals in pairs(mSkillTable) do
        count = count + 1
        local skill = SkillData.AllSkills[key]
        if (skill == nil) then 
            -- table.remove(mSkillTable, count)
            DebugMessage(tostring("Attempting to remove " .. key .. " from mUser " .. mUser:GetName()))
            break
        end
    end
end

function Finish() {
    -- mUser:SetObjVar("SkillDictionary", mSkillTable)
}

RegisterEventHandler(EventType.Timer, "SkillaKilla", KillSkill)
RegisterEventHandler(EventType.Timer, "FinishSkillaKilla", Finish)
RegisterSingleEventHandler(EventType.ModuleAttached, "fix_skillfix", HandleModuleLoaded)

