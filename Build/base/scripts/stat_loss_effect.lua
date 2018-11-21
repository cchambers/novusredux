
mDecreaseAmount = -0.3

mDurationMinutes = 20

mStatLoss = false

function ApplyStatLoss()
	SetMobileMod(this,"StrengthTimes", "StatLossEffect", mDecreaseAmount)
	SetMobileMod(this,"AgilityTimes", "StatLossEffect", mDecreaseAmount)
	SetMobileMod(this,"IntelligenceTimes", "StatLossEffect", mDecreaseAmount)
	SetMobileMod(this,"ConstitutionTimes", "StatLossEffect", mDecreaseAmount)
	SetMobileMod(this,"WisdomTimes", "StatLossEffect", mDecreaseAmount)
	SetMobileMod(this,"WillTimes", "StatLossEffect", mDecreaseAmount)
	AddBuffIcon(this,"StatLossEffect","Stat Loss","reanimateskeleton","Your soul is weakened",false,mDurationMinutes*60)
end

function HandleLoaded()

	if( this:HasTimer("StatLossTimer") ) then
		this:RemoveTimer("StatLossTimer")
	end

	ApplyStatLoss()

	this:ScheduleTimerDelay(TimeSpan.FromMinutes(mDurationMinutes), "StatLossTimer")
	if not( mStatLoss ) then
		this:SystemMessage("Your soul is weakened", SYSTEM_MESSAGE_TYPE_EVENT)
	end
	mStatLoss = true
end

function CleanUp()
	SetMobileMod(this,"StrengthTimes", "StatLossEffect", nil)
	SetMobileMod(this,"AgilityTimes", "StatLossEffect", nil)
	SetMobileMod(this,"IntelligenceTimes", "StatLossEffect", nil)
	SetMobileMod(this,"ConstitutionTimes", "StatLossEffect", nil)
	SetMobileMod(this,"WisdomTimes", "StatLossEffect", nil)
	SetMobileMod(this,"WillTimes", "StatLossEffect", nil)
	this:SystemMessage("You have returned to strength", SYSTEM_MESSAGE_TYPE_EVENT)
	RemoveBuffIcon(this,"StatLossEffect")
	mDecreaseAmount = 0
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Timer, "StatLossTimer", function()
	CleanUp()
	end)

RegisterEventHandler(EventType.ModuleAttached,"stat_loss_effect",
 	function()
		HandleLoaded()
	end)

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
	function ()
		if (this:HasTimer("StatLossTimer")) then
			ApplyStatLoss()
		end
	end)