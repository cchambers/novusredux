NoMarkSubregions = 
{
	"BarrenLands",
	"BlackForest",
}

MobileEffectLibrary.Mark = 
{
	ValidateLoc = function (self,destLoc)

		if (IsLocInRegion(destLoc, "NoTeleport")) then return false end

		if (IsDungeonMap()) then return false end

		-- prevent marking inside plots
		local plotController = Plot.GetAtLoc(destLoc)
		if ( plotController ~= nil ) then return false end
		

		local subregionName = ServerSettings.SubregionName
		for i, subregion in pairs(NoMarkSubregions) do
			if (subregionName == subregion) then
				DebugMessage(subregionName.." "..subregion)
				return false
			end
		end
		return true
	end,

	ChangeRuneAppearance = function (self, target)
		--DebugMessage(ServerSettings.SubregionName)
		local subregionName = ServerSettings.SubregionName
		if (subregionName == "SouthernHills") then
			target:SetAppearanceFromTemplate("rune_valus")

		elseif (subregionName == "SouthernRim") then
			target:SetAppearanceFromTemplate("rune_pyros")

		elseif (subregionName == "UpperPlains") then
			target:SetAppearanceFromTemplate("rune_eldeirvillage")

		elseif (subregionName == "EasternFrontier") then
			target:SetAppearanceFromTemplate("rune_helm")

		elseif (subregionName == "BarrenLands") then
			target:SetAppearanceFromTemplate("rune_oasis")

		else
			target:SetAppearanceFromTemplate("rune_blackforest")
		end
	end,

	OnEnterState = function(self,root,target,args)
		if(not target:HasObjVar("Destination") and target:GetObjVar("ResourceType") == "Rune") then

			if( target:TopmostContainer() ~= self.ParentObj or IsInBank(target)) then
				self.ParentObj:SystemMessage("Rune must be placed in your backpack.","info")
				EndMobileEffect(root)
				return false
			end

			if( target:TopmostContainer() ~= self.ParentObj ) then
				self.ParentObj:SystemMessage("[$1733]","info")
				EndMobileEffect(root)
				return false
			end

			if (target:HasObjVar("StaticDestination")) then
				self.ParentObj:SystemMessage("Rune is already marked.","info")
				EndMobileEffect(root)
				return false
			end

			local destRegionAddress = ServerSettings.RegionAddress			
			local destLoc = self.ParentObj:GetLoc()
			local destFacing = self.ParentObj:GetFacing()

			if(self:ValidateLoc(destLoc) or (IsGod(self.ParentObj))) then
				self:ChangeRuneAppearance(target)
				target:SetObjVar("RegionAddress",destRegionAddress)
				target:SetObjVar("Destination",destLoc)
				target:SetObjVar("DestinationFacing",destFacing)
				target:DelObjVar("BlankRune")
				target:SetName("Teleportation Rune")
				target:SendMessage("Mark")
				SetTooltipEntry(target,"regional_name","Portal to "..GetRegionalName(destLoc),1000)

				self.ParentObj:PlayEffect("TeleportToEffect")
				self.ParentObj:PlayObjectSound("event:/magic/air/magic_air_cast_air",false)
				self.ParentObj:SystemMessage("The rune is now marked for travel to this location.","info")
			else
				self.ParentObj:SystemMessage("This location lacks the magical energy for teleportation.","info")
			end
			--end
		else
			self.ParentObj:SystemMessage("That is not a blank rune.","info")
		end

		EndMobileEffect(root)
		return false

	end,
}