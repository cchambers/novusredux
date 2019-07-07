MobileEffectLibrary.MapAtlas = 
{
	OnEnterState = function(self,root,target,args)
		local waypoints = target:GetObjVar("UserWaypoints")
		local useType = args.UseType
		
		if (useType == nil) then 
			EndMobileEffect(root)
			return
		end

		if (waypoints == nil) then 
			waypoints = {} 
		end
		RegisterEventHandler(EventType.ClientTargetGameObjResponse, "AddMapResponse", function(clientTarget,user)
			if (clientTarget == nil) then EndMobileEffect(root) return end

			if (clientTarget:HasObjVar("MapName")) then
				AddSubMap(self.ParentObj, target, clientTarget)
			end
			EndMobileEffect(root)
		end)

		RegisterEventHandler(EventType.ClientTargetGameObjResponse, "MergeWaypointsResponse", function(clientTarget,user)
			if (clientTarget == nil) then EndMobileEffect(root) end

			if (clientTarget:HasObjVar("UserWaypoints")) then
				AddWaypoints(self.ParentObj, target, clientTarget)
			end
			EndMobileEffect(root)
		end)

		RegisterEventHandler(EventType.Message, "UpdateWaypoints",
			function (waypoints)
				target:SetObjVar("UserWaypoints", waypoints)
				UpdateMapTooltip(target)
			end)

		if (useType == "open") then
			self.ParentObj:SendMessage("OpenMapWindow", target:GetObjVar("WorldMap"), target, true, true, target:GetObjVar("SubMaps"))
		elseif (useType == "addMap") then
			self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "AddMapResponse")
		elseif (useType == "merge") then
			self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "MergeWaypointsResponse")
		elseif (useType == "rename") then
			RenameMap(self.ParentObj, target)
			EndMobileEffect(root)
		end
	end,

	AddMapDialog = function (self, root, target, mapObj)
		ClientDialog.Show{
			TargetUser = self.ParentObj,
			DialogId = "AddMap",
			TitleStr = "Add Map",
			DescStr = "Add this map and its waypoints to the atlas?\nYou cannot remove the map once it has been added.",
			Button1Str = "Yes",
			Button2Str = "No",
			ResponseFunc = function ( user, buttonId )
				buttonId = tonumber(buttonId)
				if( buttonId == 0) then				
					AddSubMap(self.ParentObj, target, mapObj)
				end
				EndMobileEffect(root)
			end
		}
	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.Message, "UpdateWaypoints")
		UnregisterEventHandler("", EventType.Message, "CloseMap")
		UnregisterEventHandler("", EventType.ClientTargetGameObjResponse, "MergeWaypointsResponse")
		UnregisterEventHandler("", EventType.ClientTargetGameObjResponse, "AddMapResponse")
	end,

	-- Optional function to handle when the effect is applied while already active, set nil or keep commented out when not needed.
	OnStack = function(self,root,target,args)
		self.ParentObj:SendMessage("CloseMap")
		EndMobileEffect(root)
	end,
}