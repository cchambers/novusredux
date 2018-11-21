--

--mCurUserTable = {}
--mCraftingItem = {}

function HandleModuleLoaded()
	AddUseCase(this,"Enhancement",false)
	SetTooltipEntry(this,"crafting_enhancement_desc","Can be used to apply enhancement to equipment.\n")	
end

function HandleUseTool(user,useType)

	--DebugMessage("Received Use Request")
	if(useType ~= "Enhancement") then return end	

	if( user == nil or not(user:IsValid()) ) then
		return
	end
	if(not user:HasModule("enhancement_controller")) then
		user:AddModule("enhancement_controller")
	end
	user:SendMessage("InitiateCrafting", this,"Enhancement")
end


RegisterEventHandler(EventType.Message, "UseObject", HandleUseTool)
RegisterSingleEventHandler(EventType.ModuleAttached, "crafting_enhancement", HandleModuleLoaded)
