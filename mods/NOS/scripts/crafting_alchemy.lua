

mCurUserTable = {}
mCraftingItem = {}

function HandleModuleLoaded()
	AddUseCase(this,"Alchemy",true)
	SetTooltipEntry(this,"crafting_woodsmith_desc","Can be used to create potions and other items.\n")	
end

function HandleUseTool(user,useType)

	--DebugMessage("Received Use Request")
	if(useType ~= "Alchemy") then return end	

	if( user == nil or not(user:IsValid()) ) then
		return
	end
	user:AddModule("base_crafting_controller")
	user:SendMessage("InitiateCrafting", this,"AlchemySkill","Potions")
end


RegisterEventHandler(EventType.Message, "UseObject", HandleUseTool)
RegisterSingleEventHandler(EventType.ModuleAttached, "crafting_alchemy", HandleModuleLoaded)
