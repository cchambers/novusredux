RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType == "Ignite/Extinguish") then
			local isLit = this:GetSharedObjectProperty("IsLit")
			if (isLit == false) then
				this:SetObjVar("HeatSource", true)
			else
				this:DelObjVar("HeatSource")
			end
			this:SetSharedObjectProperty("IsLit",not isLit)
		end
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "lightable",
	function()
        AddUseCase(this,"Ignite/Extinguish",false)        
	end)