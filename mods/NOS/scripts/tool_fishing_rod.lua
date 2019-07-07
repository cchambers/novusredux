require 'incl_fishing'

RegisterSingleEventHandler(EventType.ModuleAttached, "tool_fishing_rod", 
    function()
        SetTooltipEntry(this,"fishing_use", "Used for catching fish.")
        --AddUseCase(this,"Fish",true,"HasObject")
    end)

fisher = nil