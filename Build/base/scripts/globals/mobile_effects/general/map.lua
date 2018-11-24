MobileEffectLibrary.Map = 
{
	OnEnterState = function(self,root,target,args)
		local mapName = target:GetObjVar("MapName")
		local waypoints = target:GetObjVar("UserWaypoints")
		local useType = args.UseType
		if (useType == nil) then 
			EndMobileEffect(root)
			return
		end

		if (waypoints == nil) then 
			waypoints = {} 
		end

		RegisterEventHandler(EventType.Message, "UpdateWaypoints",
			function (waypoints)
				target:SetObjVar("UserWaypoints", waypoints)
			end)

		if (useType == "open") then
			local subMaps = self.ParentObj:GetObjVar("SubMaps") or {}
			local hasSubMap = false
			for i, j in pairs(subMaps) do
				if (mapName == j) then
					hasSubMap = true
				end
			end

			if not (hasSubMap) then
				ClientDialog.Show
				{
					TargetUser = self.ParentObj,
					DialogId = "MemorizeMap",
				    TitleStr = "Memorize Map",
				    DescStr = "Would you like to commit this map of "..SubregionDisplayNames[mapName].." to memory?",
				    Button1Str = "Yes",
				    Button2Str = "No",
				    ResponseObj= self.ParentObj,
				    ResponseFunc= 
				    function(dialogUser, dialogButtonId)
						local dialogButtonId = tonumber(dialogButtonId)
						if (dialogUser == nil) then return end

						if (dialogButtonId == 0) then
							AddSubMap(self.ParentObj, self.ParentObj, target)
							EndMobileEffect(root)
						else
							self.ParentObj:SendMessage("OpenMapWindow", mapName, target, false, true)
						end
					end,
				}
			else
				self.ParentObj:SendMessage("OpenMapWindow", mapName, target, false, true)
			end

		elseif (useType == "rename") then
			RenameMap(self.ParentObj, target)
			EndMobileEffect(root)
		end
	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.Message, "UpdateWaypoints")
	end,

	-- Optional function to handle when the effect is applied while already active, set nil or keep commented out when not needed.
	OnStack = function(self,root,target,args)
		self.ParentObj:SendMessage("CloseMap")
		EndMobileEffect(root)
	end,
}