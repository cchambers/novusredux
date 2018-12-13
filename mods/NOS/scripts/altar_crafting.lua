

mCurUserTable = {}
mCraftingItem = {}

function HandleModuleLoaded()
	AddUseCase(this,"Sorcery",true)		
    SetTooltipEntry(this,"metalsmith_crafting_desc","Can be used to create magical items.\n")
end

function HandleUseTool(user,useType)

	--DebugMessage("Received Use Request")
	
	if(useType ~= "Sorcery") then return end
	
	if( user == nil or not(user:IsValid()) ) then
		return
	end
	
	user:AddModule("base_crafting_controller")
	user:SendMessage("InitiateCrafting", this,"MagerySkill")
end


RegisterEventHandler(EventType.Message, "UseObject", HandleUseTool)
RegisterSingleEventHandler(EventType.ModuleAttached, "altar_crafting", HandleModuleLoaded)
