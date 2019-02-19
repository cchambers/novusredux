mCharges = nil

RegisterSingleEventHandler(
	EventType.ModuleAttached,
	GetCurrentModule(),
	function()
		local charges = this:GetObjVar("ImbueCharges")
		if (charges == nil) then
			charges = math.random(6, 20)
			this:SetObjVar("ImbueCharges", charges)
		end
		local level = this:GetObjVar("ExecutionerLevel")
		this:SetObjVar("ImbuedWeapon", true)
		this:SetObjVar("WasImbued", true)
		SetTooltipEntry(this, "imbued", "[ff00ff]IMBUED:[-] " .. ServerSettings.Executioner.LevelString[level], 998)
	end
)

RegisterEventHandler(
	EventType.Message,
	"Imbue.RemoveCharge",
	function()
		local charges = this:GetObjVar("ImbueCharges")
		charges = charges - 1
		if (charges == 0) then
			RemoveTooltipEntry(this, "imbued")
			this:DelObjVar("ExecutionerLevel")
			this:DelObjVar("ImbueCharges")
			this:DelObjVar("ImbuedWeapon")
			this:DelModule(GetCurrentModule())
		else
			this:SetObjVar("ImbueCharges", charges)
		end
	end
)
