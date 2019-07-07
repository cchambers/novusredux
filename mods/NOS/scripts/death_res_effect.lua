
mDecreaseAmount = 0.8

mDurationMinutes = 1

mDeathRes = false

function HandleLoaded()

	if( this:HasTimer("DeathResTimer") ) then
		this:RemoveTimer("DeathResTimer")
	end

	SetMobileMod(this, "StrengthTimes", "DeathResEffect", mDecreaseAmount)
	AddBuffIcon(this,"DeathResEffect","Curse of Death","reanimateskeleton","[$1234]",false,(mDurationMinutes*60))
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "DeathResTimer")
	if not( mDeathRes ) then
		this:SystemMessage("You have been cursed by Death", SYSTEM_MESSAGE_TYPE_EVENT)
	end
	mDeathRes = true
end

function CleanUp()
	SetMobileMod(this, "StrengthTimes", "DeathResEffect", nil)
	this:SystemMessage("The curse has been lifted", SYSTEM_MESSAGE_TYPE_EVENT)
	RemoveBuffIcon(this,"DeathResEffect")
	mDecreaseAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Timer, "DeathResTimer", function()
	CleanUp()
	end)

RegisterEventHandler(EventType.ModuleAttached,"death_res_effect",
 	function()
		HandleLoaded()
	end)

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
	function ()
		if (this:HasTimer("DeathResTimer")) then
			SetMobileMOd(this, "StrengthTimes", "DeathResEffect", mDecreaseAmount)
			AddBuffIcon(this,"DeathResEffect","Curse of Death","reanimateskeleton","[$1234]",false,mDurationMinutes*15)
		end
	end)