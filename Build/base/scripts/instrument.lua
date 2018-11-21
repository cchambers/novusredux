
RegisterSingleEventHandler(EventType.ModuleAttached, "instrument", 
    function ()
        do return end --disabled
        this:SetObjVar("ItemType", "Instrument")
        SetTooltipEntry(this,"instrument", "Play Me!")
        AddUseCase(this,"Play", true)
    end
)

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        do return end --disabled
        if(usedType == "Play") then
            if(user:HasTimer("PlayedInstrumentRecently")) then
                user:SystemMessage("Cannot play again yet.")
                return
            end

            local musicSkill = GetSkillLevel(user,"MusicianshipSkill") or 0
            local chanceToPlayWell = musicSkill
            if(chanceToPlayWell < 5) then
                chanceToPlayWell = 5
            end
            local success = false
            local delay = TimeSpan.FromMilliseconds(500)
            if(math.random(0,99) < chanceToPlayWell) then
                --Play good music here
                user:SystemMessage("Hey that sounds good!")
                success = true
                delay = TimeSpan.FromSeconds(2)
            else
                --Play shite music here
                user:SystemMessage("You could use more practice.")
            end
            --skill gain
            CheckSkillChance(user,"MusicianshipSkill", (100 - musicSkill) / 100)
            --no more playing for 9 seconds
            user:ScheduleTimerDelay(TimeSpan.FromSeconds(9), "PlayedInstrumentRecently")
            --to trigger provocation stuff
            user:ScheduleTimerDelay(delay, "InstrumentFinishedPlaying", success)
        end
    end
)
