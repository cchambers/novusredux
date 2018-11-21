--If you find an object of the same creation template id, destroy myself.
RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function()
	CallFunctionDelayed(TimeSpan.FromSeconds(3),function()
		nearbyObjects = FindObjects(SearchTemplate(this:GetCreationTemplateId(),10))
		--DebugMessage("NearbyObjects is "..DumpTable(nearbyObjects))
		if (#nearbyObjects > 0) then
			for i,j in pairs(nearbyObjects) do 
				if (j:GetLoc() == this:GetLoc()) then
					this:Destroy()
				end
			end
		end
	end)
end)