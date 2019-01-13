MobileEffectLibrary.ApplyPoison = 
{
	OnEnterState = function(self,root,target,args)
		-- on target, check EDGED, FOOD, or DRINK...
			
			local canPoison = {
				Broadsword = true,
				Longsword = true,
				Kryss = true,
			}

			local weaponType = target:GetObjVar("WeaponType")
			local isPoisoned = target:GetObjVar("PoisonCharges")
			DebugMessage(isPoisoned)
			if (canPoison[weaponType] == true and isPoisoned == nil) then
				local success = CheckSkillChance(self.ParentObj, "PoisoningSkill")
				if (success) then
					target:SetObjVar("PoisonLevel", args.PoisonLevel)
					target:SetObjVar("PoisonCharges", 10)
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