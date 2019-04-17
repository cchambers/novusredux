local HueNames = {
	hue819 = "Snow",
	hue820 = "Ice",
	hue821 = "Perrywinkle",
	hue824 = "Aqua",
	hue825 = "Verite",
	hue826 = "Fire",
	hue827 = "Brazen",
	hue829 = "Tangie",
	hue831 = "Lit",
	hue832 = "Solar",
	hue833 = "Blaze",
	hue835 = "Bloo",
	hue836 = "Silver",
	hue838 = "Blurple",
	hue855 = "Salmon",
	hue856 = "Bloodrock",
	hue857 = "Wine",
	hue871 = "Chrome",
	hue874 = "Desert Sands",
	hue877 = "Bronze",
	hue878 = "Vile",
	hue879 = "Chocolate",
	hue884 = "Stone",
	hue899 = "Pure",
	hue901 = "Musk",
	hue902 = "Lavender",
	hue904 = "Ruby",
	hue906 = "Moo",
	hue915 = "Adamantium",
	hue921 = "Lime",
	hue922 = "Sherbet",
	hue923 = "Limon",
	hue930 = "Peach",
	hue947 = "Spectral",
	hue957 = "Pika",
	hue953 = "Void",
	hue957 = "Pika",
	hue950 = "Crimson",
	hue966 = "Nerd",
	hue971 = "Typhoon",
	hue973 = "Royal",
	hue976 = "Glacier",
	hue984 = "Dread"
}

if (initializer ~= nil) then
	if (initializer.Random ~= nil) then
		local range = {1, 976}
		if (initializer.Random == "rare") then
			range = {819, 976}
		else
			range = {1, 806}
		end
		local len = 27
		local rand = math.random(range[1], range[2])
		this:SetHue(rand)
		local name = HueNames["hue" .. rand] or rand
		if (name) then
			this:SetName(name .. " Dye Tub")
		end
	end
end

RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)
		local hue = this:GetHue()
		local name = HueNames["hue" .. hue]
		if (not (name)) then
			name = hue
		end
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
		local dyeable = true

		if not (IsInBackpack(target, user)) then
			user:SystemMessage("That must be in your backpack to dye.", "info")
			return false
		end

		if (target == nil) then
			return
		end

		if (target:HasObjVar("ArmorType")) then
			local armorType = target:GetObjVar("ArmorType")
			if (armorType ~= "Cloth" and armorType ~= "MageRobe" and armorType ~= "Padded" and armorType ~= "Linen") then
				dyeable = false
			end
		end

		if (target:HasObjVar("ResourceType")) then
			local resourceType = target:GetObjVar("ResourceType")
			if (resourceType ~= "Rune") then
				dyeable = false
			end
		end

		if (target:HasModule("stackable")) then	
			dyeable = false
		end

		if (target:HasObjVar("LockedDown") or target:HasObjVar("NoReset")) then
			dyeable = false
		end

		if (target:HasObjVar("WeaponType") or target:IsMobile()) then
			local weaponType = target:GetObjVar("WeaponType")
			if (weaponType ~= "Spellbook") then
				dyeable = false
			end
		end

		if (GetWeight(target) <= 0 and Plot.IsOwner(user, target)) then
			dyeable = false
		end

		if (target:HasObjVar("CanDye")) then
			dyeable = target:GetObjVar("CanDye")
		end

		-- if (IsGod(user)) then dyeable = true end

		if (not (dyeable)) then
			user:SystemMessage("You cannot dye that.", "info")
			return
		end

		target:SetHue(this:GetHue())
	end
)
