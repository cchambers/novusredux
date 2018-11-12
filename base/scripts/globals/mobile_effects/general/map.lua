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
			self.ParentObj:SendMessage("OpenMapWindow", mapName, target, false, true)
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