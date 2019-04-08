MobileEffectLibrary.ApplyPoison = 
{
	OnEnterState = function(self,root,target,args)
		-- on target, check EDGED, FOOD, or DRINK...
		if not( IsInBackpack(target, self.ParentObj) ) then
			self.ParentObj:SystemMessage("That must be in your backpack to poison.","info")
			EndMobileEffect(root)
			return false
		end

		local canPoison = {
			Dagger = true,
			Poniard = true,
			Kryss = true,
			BoneDagger = true,
			Warfork = true,
			Voulge = true,
			Spear = true,
			Halberd = true,
			Scythe = true,
			Broadsword = true,
			Longsword = true,
			Saber = true,
			Katana = true,
			LargeAxe = true,
			GreatAxe = true,
			BladedClub = true,
			Skinner = true,
			LetterOpener = true,
			Stiletto = true,
			FulleredDagger = true,
			Zukuri = true,
			BoarSpear = true,
			Pike = true,
			Poleaxe = true,
			Spetum = true,
			Naginata = true,
			Rapier = true,
			Crescent = true,
			Ninjato = true,
			Butcher = true
		}
		self.PotionLevel = args.PoisonLevel
		local weaponType = target:GetObjVar("WeaponType")
		local isPoisoned = target:GetObjVar("PoisonCharges")
		local skillLevel = GetSkillLevel(self.ParentObj, "PoisoningSkill")
		if (canPoison[weaponType] == true and isPoisoned == nil) then
			local success = CheckSkillChance(self.ParentObj, "PoisoningSkill", skillLevel / args.PoisonLevel)
			if (success) then
				target:SetObjVar("PoisonLevel", args.PoisonLevel)
				target:SetObjVar("PoisonCharges", math.random(3, math.max(skillLevel / 10, 5)))
				SetTooltipEntry(target,"poisoned","[00ff00]POISONED[-]", 999)
				self.ParentObj:SystemMessage("You have successfully poisoned the weapon!", "info")
			else 
				self.ParentObj:SystemMessage("You fail to poison the object. The poison was wasted.", "info")
			end
		else 
			if (isPoisoned ~= nil) then
				self.ParentObj:SystemMessage("That is already poisoned.", "info")
				EndMobileEffect(root)
				return false
			end
			self.ParentObj:SystemMessage("That cannot be poisoned.", "info")
			EndMobileEffect(root)
			return false
		end

		if (self.PotionLevel < 5) then
			self.DoBottleReturn(self, root)
		end

		EndMobileEffect(root)
	end,
	
	DoBottleReturn = function(self, root) 
		local backpackObj = self.ParentObj:GetEquippedObject("Backpack")
		local template = tostring("empty_bottle_"..self.PotionLevel)
		local lootObjects = backpackObj:GetContainedObjects()
		local pots = false
		for index, lootObj in pairs(lootObjects) do	    		
			if(lootObj:GetCreationTemplateId() == template ) then
				pots = true
				lootObj:SetObjVar("StackCount", (lootObj:GetObjVar("StackCount") or 1) + 1)
				CallFunctionDelayed(TimeSpan.FromSeconds(0.5), function () SetItemTooltip(lootObj) end)
				break
			end
		end

		if (not(pots)) then
			CreateObjInBackpack(self.ParentObj, template)
		end
		-- self.PotionLevel
	end
}