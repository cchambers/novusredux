MobileEffectLibrary.ApplyPoison = 
{
	OnEnterState = function(self,root,target,args)
		-- on target, check EDGED, FOOD, or DRINK...
			
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
				GreatAxe = true
			}

			local weaponType = target:GetObjVar("WeaponType")
			local isPoisoned = target:GetObjVar("PoisonCharges")
			local skillLevel = GetSkillLevel(self.ParentObj, "PoisoningSkill")
			if (canPoison[weaponType] == true and isPoisoned == nil) then
				local success = CheckSkillChance(self.ParentObj, "PoisoningSkill", (skillLevel * 2) / args.PoisonLevel)
				if (success) then
					target:SetObjVar("PoisonLevel", args.PoisonLevel)
					target:SetObjVar("PoisonCharges", math.random(3, math.max(skillLevel / 10, 5)))
					SetTooltipEntry(target,"poisoned","[00ff00]POISONED[-]", 999)
					self.ParentObj:SystemMessage("You have successfully poisoned the weapon!")
				else 
					self.ParentObj:SystemMessage("You fail to poison the object. The poison was wasted.")
				end
			else 
				if (isPoisoned ~= nil) then
					self.ParentObj:SystemMessage("That is already poisoned.")
					EndMobileEffect(root)
					return false
				end
				self.ParentObj:SystemMessage("That cannot be poisoned.")
				EndMobileEffect(root)
				return false
			end

			EndMobileEffect(root)
		end,

	OnExitState = function(self,root)

	end,
}