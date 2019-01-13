MobileEffectLibrary.ApplyPoison = 
{
	OnEnterState = function(self,root,target,args)
		-- on target, check EDGED, FOOD, or DRINK...
			
			local canPoison = {
				Broadsword = true,
				Longsword = true,
				Kryss = true,
			}

			local type = target:GetObjVar("WeaponType")

			if (canPoison[type] == true) then
				target:SetObjVar("PoisonLevel", args.PoisonLevel)
				target:SetObjVar("PoisonCharges", 10)
				self.ParentObj:SystemMessage("Poisoned!")
			else 
				self.ParentObj:SystemMessage("That cannot be poisoned.")
				return false
			end

			EndMobileEffect(root)
		end,

	OnExitState = function(self,root)

	end,
}