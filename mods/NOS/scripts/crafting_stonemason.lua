

mCurUserTable = {}
mCraftingItem = {}

function HandleModuleLoaded()
	AddUseCase(this,"Stonemason",true)		
	SetTooltipEntry(this,"crafting_woodsmith_desc","Can be used to stonecraft specific items.\n")	
end

function HandleUseTool(user,useType)
	
	DebugMessage("Received Use Request")
	if(useType ~= "Stonemason") then return end	
	
	if( user == nil or not(user:IsValid()) ) then
		return
	end

	user:AddModule("base_crafting_controller")
	user:SendMessage("InitiateCrafting", this,"StonemasonSkill","Resources")
end


RegisterEventHandler(EventType.Message, "UseObject", HandleUseTool)
RegisterSingleEventHandler(EventType.ModuleAttached, "crafting_stonemason", HandleModuleLoaded)
