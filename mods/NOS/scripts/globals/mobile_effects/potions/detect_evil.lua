MobileEffectLibrary.PotionDetectEvil = 
{

	OnEnterState = function(self,root,target,args)
		self.Range = args.Range or self.Range
		if ( self.ParentObj:HasTimer("RecentPotion") ) then
			self.ParentObj:SystemMessage("Cannot use again yet.", "info")
			EndMobileEffect(root)
			return false
		end

		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(30), "RecentPotion")

		self.ParentObj:PlayEffect("MeatExplosion")--TODO: Change effect.
		self.ParentObj:PlayObjectSound("event:/objects/consumables/potion/potion_use")

		self._Used = true

		return true
	end,

	OnExitState = function(self,root)
		if ( self._Used ) then
			self._Used = false
			local nearbyPlayers = FindObjects(SearchPlayerInRange(self.Range, true))
			local evilFound = 0
			local player
			for i=1,#nearbyPlayers do
				player = nearbyPlayers[i]
				if ( 
					player ~= self.ParentObj
					and
					not IsImmortal(player)
					and
					GetKarmaLevel(GetKarma(player)).Evil == true
				) then
					evilFound = evilFound + 1
				end
			end

			local message
			if ( evilFound > 0 ) then
				if ( evilFound > 6 ) then
					message "Very large"
				elseif ( evilFound > 3 ) then
					message = "Large"
				elseif ( evilFound > 1 ) then
					message = "Some"
				else
					message = "Little"
				end
			else
				message = "No"
			end

			self.ParentObj:SystemMessage(message .. " presence of evil detected.", "info")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromSeconds(1),

	Range = 20,
	_Used = false,
}