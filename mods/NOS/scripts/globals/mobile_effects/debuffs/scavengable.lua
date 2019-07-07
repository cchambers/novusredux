MobileEffectLibrary.Scavengable = 
{
	PersistDeath = true,

	OnEnterState = function(self,root,target,args)
		self.Duration = args.Duration or self.Duration
		self.Target = target

		target:SystemMessage("You have marked your target for scavenging.","info")
		target:PlayLocalEffect(self.ParentObj,"RegenEffect",0,"Color=ffff00")

		RegisterEventHandler(EventType.Message, "HasDiedMessage", function()
			self._HasDied = true
			
			RegisterEventHandler(EventType.CreatedObject, "ScavengeObject", function (success,objref,stackCount,hue,equipMob)
				if ( hue ~= nil ) then
					objref:SetColor(hue)
				end
				if ( stackCount > 1 ) then
					RequestSetStack(objref, stackCount)
				end
				SetItemTooltip(objref)
			end)

			RegisterEventHandler(EventType.EnterView, "CloseEnoughToScavenge", function(obj)
				if ( not self._HasBeenScavenged and obj == self.Target ) then
					self._HasBeenScavenged = true
					self.Scavenge(self,root)
				end
			end)
			AddView("CloseEnoughToScavenge", SearchPlayerInRange(2, true))
			
		end)
	end,

	Scavenge = function(self,root)
		local backpackObj = self.Target:GetEquippedObject("Backpack")
        if ( backpackObj == nil ) then
            EndMobileEffect(root)
            return
        end


        self.Target:SystemMessage("You attempt to scavenge the fallen foe.","info")
        self.Target:SendMessage("EndCombatMessage")
		SetMobileModExpire(self.Target, "Disable", "Scavenge", true, TimeSpan.FromSeconds(1))
        self.Target:PlayAnimation("carve")
        CallFunctionDelayed(TimeSpan.FromSeconds(1),function() self.Target:PlayAnimation("idle") end)

        -- get the info from template.
        local templateData = GetTemplateData(self.ParentObj:GetCreationTemplateId())
        local ScavengeTables = nil
        for moduleName,initializer in pairs(templateData.LuaModules) do 
            if ( initializer.ScavengeTables ~= nil ) then
                ScavengeTables = initializer.ScavengeTables
            end
        end
        -- put the items into the player's backpack.
        if ( ScavengeTables ~= nil ) then
            self.Target:SystemMessage("You attempt to scavenge from the corpse.", "info")
			for key,subTable in pairs(ScavengeTables) do
				-- if the ScavengeTables has items
				if( subTable.LootItems ~= nil ) then
					local itemCount = subTable.NumItems or 0
					if(itemCount > 0) then
						local availableItems = FilterLootItemsByChance(subTable.LootItems)	
						for i=1,itemCount do
							if( #availableItems > 0 ) then
								local itemIndex = GetRandomLootItemIndex(availableItems)
								local itemTemplateId = availableItems[itemIndex].Template
								local hue = availableItems[itemIndex].Hue
								local stackCount = availableItems[itemIndex].StackCount or 1
								if (availableItems[itemIndex].Templates ~= nil) then
									for index,template in pairs(availableItems[itemIndex].Templates) do
										local dropPos = GetRandomDropPosition(backpackObj)
										CreateObjInContainer(template, backpackObj, dropPos, "ScavengeObject",stackCount,hue,equipMob)
									end
								else
									if( availableItems[itemIndex].Unique == true ) then
										table.remove(availableItems,itemIndex)
									end
									local dropPos = GetRandomDropPosition(backpackObj)
									CreateObjInContainer(itemTemplateId, backpackObj, dropPos, "ScavengeObject",stackCount,hue,equipMob)
								end
							end
						end
					end
				end
			end
        end

		EndMobileEffect(root)
	end,

	OnExitState = function(self,root)
		self.Target:StopLocalEffect(self.ParentObj,"RegenEffect",2.0)

		UnregisterEventHandler("", EventType.Message, "HasDiedMessage")
		if ( self._HasDied ) then
			DelView("CloseEnoughToScavenge")
			UnregisterEventHandler("", EventType.CreatedObject, "ScavengeObject")
			UnregisterEventHandler("", EventType.EnterView, "CloseEnoughToScavenge")
		end
	end,

	GetPulseFrequency = function(self,root)
		return self.Duration
	end,

	AiPulse = function(self,root)
		EndMobileEffect(root)
	end,

	Duration = TimeSpan.FromMinutes(2),
	Target = nil,

	_HasDied = false,
	_HasBeenScavenged = false, --prevent potential race conditions from multiple scavenge
}