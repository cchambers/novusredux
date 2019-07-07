require 'base_template_list_window'

FormPresets = {
	TwoTowers = {
			
	},

	GodFavorites = {

	},	
}

-- add prebuilt categories
FormPresets.StartingTemplates = {}
for i,templateName in pairs(GetAllTemplateNames("starting_templates")) do
	table.insert(FormPresets.StartingTemplates, templateName)
end
FormPresets.Mobiles = {}
for i,templateName in pairs(GetAllTemplateNames("mobiles")) do
	table.insert(FormPresets.Mobiles, templateName)
end

-- override base_template_list_window functions
function GetFormCategories()
	if(IsGod(this)) then
		return {'Mobiles','StartingTemplates','GodFavorites','TwoTowers'}
	end

	if(categoryName == "TwoTowers" and ServerSettings.WorldName == "TwoTowers") then
	    local twoTowersController = FindObjectWithTag("MapController")
        if(twoTowersController ~= nil and twoTowersController:GetObjVar("FormChangeEnabled")) then
        	return {'TwoTowers'}
        end
	end

	return {}
end

function GetFormTemplates()
	templatesListTable = {}
	for i,templateName in pairs(FormPresets[templateListCategory]) do 
		table.insert(templatesListTable,templateName)
	end

	table.sort(templatesListTable)

	return templatesListTable
end

function ShowSelectCategory()
	local newWindow = DynamicWindow("FormList","Create Object",450,600)

	AddSelectCategory(newWindow,0,GetFormCategories())

	this:OpenDynamicWindow(newWindow)
end

function ShowFormTemplates()
	if(templateListCategory == "") then
		templateListCategoryIndex = 0
		ShowSelectCategory()
		return
	end

	local newWindow = DynamicWindow("FormList","Select Form",450,600)
	
	AddSelectTemplate(newWindow,0,true,GetFormTemplates(),GetFormCategories())

	this:OpenDynamicWindow(newWindow)
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ()
		ShowFormTemplates()
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ()
		-- got stuck somehow
		this:DelModule(GetCurrentModule())
	end)

RegisterEventHandler(EventType.DynamicWindowResponse,"FormList",
	function (user,returnId,fieldData)
		if(returnId ~= nil) then
			local action, template = string.match(returnId, "(%a+):([%a_%d]*)")

			if(HandleCategoryButtons(action, template,GetFormCategories())) then
				ShowFormTemplates()
			elseif(action == "select") then
				this:SendMessage("ChangeMobileToTemplate",template)				
				this:DelModule(GetCurrentModule())
			end
		else
			this:DelModule(GetCurrentModule())
		end
	end)



