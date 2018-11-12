

mCurUserTable = {}
mCraftingItem = {}

function HandleModuleLoaded()
	AddUseCase(this,"Woodsmith",true)		
	SetTooltipEntry(this,"crafting_woodsmith_desc","Can be used to woodsmith specific items.\n")	
end

function HandleUseTool(user,useType)
	
	--DebugMessage("Received Use Request")
	if(useType ~= "Woodsmith") then return end	
	
	if( user == nil or not(user:IsValid()) ) then
		return
	end

	user:AddModule("base_crafting_controller")
	user:SendMessage("InitiateCrafting", this,"WoodsmithSkill","Furnishings")
end


RegisterEventHandler(EventType.Message, "UseObject", HandleUseTool)
RegisterSingleEventHandler(EventType.ModuleAttached, "crafting_woodsmith", HandleModuleLoaded)
