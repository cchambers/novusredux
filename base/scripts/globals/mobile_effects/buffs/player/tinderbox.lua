MobileEffectLibrary.Tinderbox = 
{

	OnEnterState = function(self,root,target,args)
	
		self.Loc = self.ParentObj:GetLoc():Project(self.ParentObj:GetFacing(), 1.25)

		if not( self.ValidateUse(self,root) ) then
			EndMobileEffect(root)
			return false
		end
		self.CampfireTemplate = args.CampfireTemplate or self.CampfireTemplate

		self.ParentObj:SendMessage("EndCombatMessage")

		local tinderboxTemplate = GetTemplateData(self.CampfireTemplate)

		tinderboxTemplate.LuaModules.tinderbox_campfire.OwnerId = self.ParentObj.Id
		
		CreateCustomObj(self.CampfireTemplate, tinderboxTemplate, self.Loc, "created_campfire")

		self.ParentObj:PlayAnimation("kneel")

		EndMobileEffect(root)
	end,

	ValidateUse = function(self,root)

		if( self.ParentObj == nil or self.Loc == nil or not self.ParentObj:IsValid() ) then
			DebugMessage("ERROR: User Not Valid")
			return false
		end

		if ( HasMobileEffect(self.ParentObj, "Campfire") ) then
			self.ParentObj:SystemMessage("Already a campfire here.", "info")
			return false
		end

		if ( not IsPassable(self.Loc) or not self.ParentObj:HasLineOfSightToLoc(self.Loc) ) then
			self.ParentObj:SystemMessage("This is not the best place for a campfire.", "info")
			return false
		end

		local nearbyMobiles = FindObjects(SearchMobileInRange(ServerSettings.Campfire.MaxRange, true))
		for i,mob in pairs(nearbyMobiles) do
			if ( mob ~= self.ParentObj ) then
				if ( IsPlayerCharacter(mob) ) then
					if ( (ServerSettings.Campfire.RequireGroup == false or ShareGroupCheckPet(self.ParentObj, mob)) 
						and mob:GetSharedObjectProperty("CombatMode") == true ) then
						-- player in combat mode
						self.ParentObj:SystemMessage("Too chaotic to setup camp here.", "info")
						return false
					end
				else
					if ( mob:GetSharedObjectProperty("CombatMode") == true ) then
						-- NPC in combat mode.
						self.ParentObj:SystemMessage("Too chaotic to setup camp here.", "info")
						return false
					end
				end
			end
		end

		return true
	end,

	CampfireTemplate = "tinderbox_campfire",
}