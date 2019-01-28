MobileEffectLibrary.Recall = 
{
	OnEnterState = function(self,root,target,args)
		-- if ( GetKarmaLevel(GetKarma(self.ParentObj)).GuardHostilePlayer ) then
		-- 	self.ParentObj:SystemMessage("You must attone for your negative actions before the gods will allow you to do this.","info")

		-- 	EndMobileEffect(root)
		-- 	return false
		-- end
		
		-- if ( target == self.ParentObj ) then
		-- 	local bindLoc = GetPlayerSpawnPosition(self.ParentObj)
		-- 	local bindRegionAddress = ServerSettings.RegionAddress

		-- 	local spawnPosEntry = self.ParentObj:GetObjVar("SpawnPosition")
		-- 	if ( spawnPosEntry ~= nil ) then
		-- 		bindLoc = spawnPosEntry.Loc
		-- 		bindRegionAddress = spawnPosEntry.Region
		-- 	end

		-- 	-- send them home
		-- 	TeleportUser(self.ParentObj, self.ParentObj, bindLoc, bindRegionAddress, self.ParentObj:GetFacing())

		-- 	EndMobileEffect(root)
		-- 	return false
		-- end

		if ( target:HasObjVar("Destination") ) then
			local destRegionAddress = target:GetObjVar("RegionAddress")

			if (destRegionAddress == "TestMap") then
				self.ParentObj:SystemMessage("How'd you get that? Have this instead...","info")
				target:Destroy()
				CreateObjInBackpack(self.ParentObj,"item_ale")
				EndMobileEffect(root)
				return false
			end

			local targetLoc = target:GetObjVar("Destination")

			TeleportUser(
				self.ParentObj,
				self.ParentObj,
				target:GetObjVar("Destination"),
				destRegionAddress,
				target:GetObjVar("DestinationFacing")
			)
			
			EndMobileEffect(root)
			return false
		end
		
		-- handle recall runes for teleport towers
		if ( target:HasObjVar("ResourceType") ) then
			local resourceType = target:GetObjVar("ResourceType")
			if ( ServerSettings.Teleport.Destination[resourceType] ) then

				TeleportUser(
					self.ParentObj,
					self.ParentObj,
					ServerSettings.Teleport.Destination[resourceType].Destination,
					target:GetObjVar("RegionAddress"),
					ServerSettings.Teleport.Destination[resourceType].DestFacing
				)
			
				EndMobileEffect(root)
				return false
			end
		end

		EndMobileEffect(root)
		-- return false to prevent any timers from being started.
		return false

	end,
}