
function UseItem(user,useType)
	local script = this:GetObjVar("UserScript")
	local objectScript = this:GetObjVar("ObjectScript")
	if (script ~= nil) then
		user:AddModule(script)
		user:SendMessage("InitializeScriptItem")
		if (this:HasObjVar("ItemUseMessage")) then
			user:SystemMessage(this:GetObjVar("ItemUseMessage"),"info")
		end
		if (this:HasObjVar("DestroyOnUse")) then
			this:Destroy()
		end
	end
	if (objectScript ~= nil) then
		this:AddModule(objectScript)
		this:SendMessage("InitializeScriptItem")
	end
end

RegisterEventHandler(EventType.Message,"UseObject",
	function(user,useType)
		if (user ~= nil and user:IsValid()) then
			--DebugMessage(1)
			if (not this:HasObjVar("UseOutsideBackpack")) then
				if (this:TopmostContainer() ~= user) then
					user:SystemMessage("The item must be in your backpack to use it.","info")
					return
				end
			end
			if (user:HasTimer(this:GetObjVar("UseTimer"))) then 
				user:SystemMessage(this:GetObjVar("ItemCannotUseMessage"),"info")
				return
			end
			if (useType == "Use") then
				if (this:HasObjVar("Confirm")) then
					ClientDialog.Show{
					    TargetUser = user,
					    DialogId = "ScriptItem",
					    TitleStr = "Are you sure?",
					    DescStr = this:GetObjVar("ConfirmDesc"),
					    Button1Str = "Yes",
					    Button2Str = "No",
					    ResponseFunc = function ( user, buttonId )
							if (buttonId == 0) then
								UseItem(user,"Use")
							end
						end
					}
				else
					UseItem(user,useType)
				end
			end
		end
	end)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function()	
		if (not this:HasModule("merchant_sale_item")) then
			AddUseCase(this,"Use",true)
		end
	end)