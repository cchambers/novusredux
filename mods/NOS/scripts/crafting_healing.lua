

mCurUserTable = {}
mCraftingItem = {}

function HandleModuleLoaded()
	AddUseCase(this,"First Aid",true)
	SetTooltipEntry(this,"crafting_desc","Can be used to create bandages and other healing items.\n")	
end

function HandleUseTool(user,useType)

	--DebugMessage("Received Use Request")
	if(useType ~= "First Aid") then return end

	if ( this:TopmostContainer() ~= user ) then
		user:SystemMessage("That must be in your backpack to use it.","info")
		return false
	end

	if( user == nil or not(user:IsValid()) ) then
		return false
	end
	user:AddModule("base_crafting_controller")
	user:SendMessage("InitiateCrafting", this,"HealingSkill","First Aid")
end


RegisterEventHandler(EventType.Message, "UseObject", HandleUseTool)
RegisterSingleEventHandler(EventType.ModuleAttached, "crafting_healing", HandleModuleLoaded)
