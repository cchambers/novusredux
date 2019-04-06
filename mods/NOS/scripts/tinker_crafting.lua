

mCurUserTable = {}
mCraftingItem = {}

function HandleModuleLoaded()
	AddUseCase(this,"Tinkering",false)
	SetDefaultInteraction(this,"Tinkering")
    SetTooltipEntry(this,"tinkering_crafting_desc","Can be used to blacksmith specific items.\n")
end

function HandleUseTool(user,useType)

	--DebugMessage("Received Use Request")
	
	if(useType ~= "Tinkering") then return end
	
	if( user == nil or not(user:IsValid()) ) then
		return
	end
	
	user:AddModule("base_crafting_controller")
	user:SendMessage("InitiateCrafting", this,"TinkeringSkill","Resources")
end


RegisterEventHandler(EventType.Message, "UseObject", HandleUseTool)
RegisterSingleEventHandler(EventType.ModuleAttached, "tinkering_crafting", HandleModuleLoaded)
