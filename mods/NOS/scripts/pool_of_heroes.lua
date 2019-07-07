
TIME_TO_RESPAWN = 60*10


this:SetSharedObjectProperty("ObjectOffset",7.5)

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Use" and usedType ~= "Examine") then return end

        local questState = user:GetObjVar("HeroQuestState")
    	if (questState == nil) then
            --DebugMessage("questState is "..tostring(questState))
    		user:SystemMessage("[$2412]","info")
    		return
    	end

    	if (questState ~= "QuestStart") then
    		user:SystemMessage("[$2413]","info")
    		return
    	end
        if (math.random(1,300) == 1) then
            user:NpcSpeech("Klaatu barada nikto!")
        end
        user:SendMessage("AdvanceQuest","SlayDemonQuest","SlayDemon","DipSword")
    	user:PlayAnimation("kneel")
    	FaceObject(user,this)
	    SetMobileModExpire(this, "Freeze", "Busy", true, TimeSpan.FromSeconds(0.25))
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.25),"imbue",user)
    end)

RegisterEventHandler(EventType.Timer,"imbue", 
    function(user)
    	user:PlayAnimation("carve")
    	FaceObject(user,this)
		user:SetObjVar("HeroQuestState","ImbuedWeapon")
        PlayEffectAtLoc("RegenEffect",user:GetLoc(),2)
		TaskDialogNotification(user,"[$2414]")				
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function ()
         SetTooltipEntry(this,"pool", "Perhaps you should look deeper.")
         AddUseCase(this,"Examine",true,"HasObject")
    end)
