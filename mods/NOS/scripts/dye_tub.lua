HueNames = {
	hue819 = "Snow",
	hue820 = "Ice",
	hue821 = "Perrywinkle",
	hue824 = "Aqua",
	hue825 = "Opiate",
	hue826 = "Fire",
	hue827 = "Brazen",
	hue831 = "Lit",
	hue832 = "Solar",
	hue835 = "Bloo",
	hue836 = "Silver",
	hue838 = "Blurple",
	hue855 = "Salmon",
	hue856 = "Bloodrock",
	hue857 = "Wine",
	hue871 = "Chrome",
	hue877 = "Bronze",
	hue878 = "Vile",
	hue879 = "Chocolate",
	hue899 = "Pure",
	hue901 = "Musk",
	hue904 = "Ruby",
	hue915 = "Adamantium",
	hue921 = "Lime",
	hue922 = "Sherbet",
	hue923 = "Limon",
	hue930 = "Peach"
}

-- RegisterSingleEventHandler(
-- 	EventType.ModuleAttached,
-- 	"dye_tub",
-- 	function()
-- 		DebugMessage("dyes loaded")
-- 	end
-- )

RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		local hue = this:GetHue()
		local name = HueNames["hue"..hue]
		if (not(name)) then name = hue end
		local objName = this:GetName()
		if (objName ~= name .. "Dye Tub" or objName == "Dye Tub" and name) then
			this:SetName(name .. " Dye Tub")
		end
		user:SystemMessage("Select something to dye '" .. name .. "'")
		user:RequestClientTargetGameObj(this, "dyetub")
	end
)

RegisterEventHandler(
	EventType.ClientTargetGameObjResponse,
	"dyetub",
	function(target, user)
		local dyeable = true;

		if (target:HasObjVar("ArmorType")) then
			local armorType = target:GetObjVar("ArmorType")
			if (armorType ~= "Cloth") then dyeable = false end
		end
		
		if (target:HasObjVar("LockedDown") or target:HasObjVar("NoReset")) then 
			dyeable = false
		end
		
		if (target:HasObjVar("WeaponType") or target:IsMobile()) then
			dyeable = false
		end
		
		-- if (IsGod(user)) then dyeable = true end

		if (not(dyeable)) then 
			user:SystemMessage("You cannot dye that.")
			return
		end
		target:SetHue(this:GetHue())
	end
)