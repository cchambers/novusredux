

mCurUserTable = {}
mCraftingItem = {}

function HandleModuleLoaded()
	AddUseCase(this,"Fabrication",false)	SetDefaultInteraction(this,"Fabrication")
	SetTooltipEntry(this,"fabrication_crafting_desc","Can be used to fabricate specific items.\n")		
end

function HandleUseTool(user,useType)

	--DebugMessage("Received Use Request")
	if(useType ~= "Fabrication") then return end	

	if( user == nil or not(user:IsValid()) ) then
		return
	end

	user:AddModule("base_crafting_controller")
	user:SendMessage("InitiateCrafting", this,"FabricationSkill","Resources")
end


RegisterEventHandler(EventType.Message, "UseObject", HandleUseTool)
RegisterSingleEventHandler(EventType.ModuleAttached, "fabrication_crafting", HandleModuleLoaded)