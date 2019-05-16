function UpdateCorpseOnPlayerResurrected(corpseObj)
    if ( corpseObj and corpseObj:IsValid() ) then

		-- remove 'appearance' items if not full loot
		if not ( ServerSettings.PlayerInteractions.FullItemDropOnDeath ) then
			local leftHand = corpseObj:GetEquippedObject("LeftHand")
			local rightHand = corpseObj:GetEquippedObject("RightHand")
			local chest = corpseObj:GetEquippedObject("Chest")
			local legs = corpseObj:GetEquippedObject("Legs")
			local head = corpseObj:GetEquippedObject("Head")
			local body = corpseObj:GetEquippedObject("BodyPartHead")
			local hair = corpseObj:GetEquippedObject("BodyPartHair")

			if ( leftHand ~= nil ) then leftHand:Destroy() end
			if ( rightHand ~= nil ) then rightHand:Destroy() end
			if ( chest ~= nil ) then chest:Destroy() end
			if ( legs ~= nil ) then legs:Destroy() end
			if ( head ~= nil ) then head:Destroy() end
			if ( body ~= nil) then body:Destroy() end
			if ( hair ~= nil) then hair:Destroy() end
		end

		-- disallow resing
		corpseObj:DelObjVar("PlayerObject")
		-- turn the corpse into a skeleton
		corpseObj:SetAppearanceFromTemplate("skeleton")
		corpseObj:DelObjVar("NoSkele")

		return true
	end
	return false
end