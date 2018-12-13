-- HueNames = {
-- 	color825 = "Opiate",
-- }

RegisterSingleEventHandler(
	EventType.ModuleAttached,
	"dye_tub",
	function()
		DebugMessage("dye loaded")
	end
)

RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		local hue = this:GetHue()
		-- local name = HueNames[hue]
		user:SystemMessage("Select something to dye " .. hue)
		user:RequestClientTargetGameObj(this, "dyetub")
	end
)

RegisterEventHandler(
	EventType.ClientTargetGameObjResponse,
	"dyetub",
	function(target, user)
		target:SetHue(this:GetHue())
	end
)