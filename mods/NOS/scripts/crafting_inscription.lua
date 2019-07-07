

mCurUserTable = {}
mCraftingItem = {}

function HandleModuleLoaded()
	AddUseCase(this,"Inscription",true)
	SetTooltipEntry(this,"crafting_woodsmith_desc","Can be used to create spell scrolls and spellbooks.\n")	
end

function HandleUseTool(user,useType)

	--DebugMessage("Received Use Request")
	if(useType ~= "Inscription") then return end	

	if( user == nil or not(user:IsValid()) ) then
		return
	end
	user:AddModule("base_crafting_controller")
	user:SendMessage("InitiateCrafting", this,"InscriptionSkill","Scrolls")
end


RegisterEventHandler(EventType.Message, "UseObject", HandleUseTool)
RegisterSingleEventHandler(EventType.ModuleAttached, "crafting_inscription", HandleModuleLoaded)
