

mCurUserTable = {}
mCraftingItem = {}

function HandleModuleLoaded()
	AddUseCase(this,"Blacksmithing",false)
	SetDefaultInteraction(this,"Blacksmithing")
    SetTooltipEntry(this,"metalsmith_crafting_desc","Can be used to blacksmith specific items.\n")
end

function HandleUseTool(user,useType)

	--DebugMessage("Received Use Request")
	
	if(useType ~= "Blacksmithing") then return end
	
	if( user == nil or not(user:IsValid()) ) then
		return
	end
	
	user:AddModule("base_crafting_controller")
	user:SendMessage("InitiateCrafting", this,"MetalsmithSkill","Weapons")
end


RegisterEventHandler(EventType.Message, "UseObject", HandleUseTool)
RegisterSingleEventHandler(EventType.ModuleAttached, "metalsmith_crafting", HandleModuleLoaded)
