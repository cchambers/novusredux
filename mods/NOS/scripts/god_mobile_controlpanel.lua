PanelButtons = {
	["Random NPC Name"] = function(user) DoNpcName() end,
	["Random Player Name"] = function(user) DoPlayerName() end,
	["Change Form"] = function(user)
		local templatesListTable = GetAllTemplateNames("starting_templates")
		ButtonMenu.Show{
	        TargetUser = user,
	        DialogId = "change_form",
	        TitleStr = "Select Form",
	        ResponseType = "str",
	        Buttons = templatesListTable,
	        ResponseFunc = function(users,buttonStr) this:SendMessage("ChangeMobileToTemplate",buttonStr) end,
	    } 
	end,
	["Attack"] = function(user)
		user:RequestClientTargetGameObj(this, "attackTarget")
		RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse, "attackTarget",
			function(target,users)
				if(target) then
					this:SendMessage("EnableAI")
					this:FireTimer("attack_wait")
					RegisterSingleEventHandler(EventType.Timer,"attack_wait",
						function ( ... )
							this:SendMessage("AttackEnemy",target)
						end)					
				end
			end)
	end,	
	["Disable AI"] = function(user)
		this:ClearPathTarget()
		this:SendMessage("ClearTarget")
		this:SendMessage("DisableAI")
	end,
	["Sit"] = function(user)
		this:SendMessage("SitInChair")
	end,
	["Stand"] = function(user)
		this:SendMessage("StopSitting")
	end,
	["Push"] = function(user)
		user:SendMessage("PushObject",this)
	end,
}

function DoControlPanel(user)
	buttonList = {}
	for buttonStr,func in pairs(PanelButtons) do
		table.insert(buttonList,buttonStr)
	end

    ButtonMenu.Show{
        TargetUser = user,
        ResponseType = "str",
        DialogId = "control_panel",
        TitleStr = this:GetName().." Control",
        Buttons = buttonList,
        ResponseFunc = function(user,buttonStr)
        	if(buttonStr ~= nil) then
            	PanelButtons[buttonStr](user)
            	this:FireTimer("panel_delay",user)            	
            end
        end,
    }  
end

RegisterEventHandler(EventType.Message,"UseObject",
    function (user,usedType)
        if(usedType == "Control Panel") then
        	DoControlPanel(user) 
    	end
  	end)

RegisterEventHandler(EventType.Timer,"panel_delay",DoControlPanel)

RegisterSingleEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function()
		AddUseCase(this,"Control Panel",false) 
	end)