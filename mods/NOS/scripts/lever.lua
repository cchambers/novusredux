--Generic lever that sends message to any objects in "LeverListener" objVar

function ToggleLever(forceClose)

    local isOpen = forceClose or this:GetSharedObjectProperty("IsActivated");
    if( isOpen ) then
        this:SetSharedObjectProperty("IsActivated", false)
        --DebugMessage("Closing door")
    else
        this:SetSharedObjectProperty("IsActivated", true)
        --DebugMessage("Opening door")
    end

    this:PlayObjectSound("Use", true)

    MessageLeverListeners()

end

--Send "LeverPulled" message to all listeners
function MessageLeverListeners()
	local leverListeners = this:GetObjVar("LeverListeners") or {}

	for i, j in pairs(leverListeners) do
		j:SendMessage("LeverPulled", this, this:GetSharedObjectProperty("IsActivated"))
	end
end

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType ~= "Use" and usedType ~= "Operate") then return end

        if not (this:DistanceFrom(user) < 2) then
            user:SystemMessage("Cannot reach that from here.")
            return
        end

        ToggleLever()
    end)

RegisterEventHandler(EventType.Message, "TryAddLeverListener", 
	function(object)
		local leverListeners = this:GetObjVar("LeverListeners") or {}

		--Check if object is already a listener
		for i, j in pairs(leverListeners) do
			if (j == object) then
				return
			end
		end

		--If not, add object to listeners
		table.insert(leverListeners, object)
		this:SetObjVar("LeverListeners", leverListeners)

	end)

RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function()
        AddUseCase(this,"Operate",true)
    end)