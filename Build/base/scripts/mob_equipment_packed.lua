function ValidateUse(user)
	if( user == nil or not(user:IsValid()) or IsDead(user)) then
		return false
	end

	if (this:TopmostContainer() ~= user) then
		user:SystemMessage("That must be in your backpack to unpack it.","info")
		return false
	end

	return true
end

function RequestPlacementTarget(user)
	local unpackedTemplate = this:GetObjVar("EquipmentTemplate")	
	if( unpackedTemplate == nil ) then
		return
	end

	user:SystemMessage("Who do you wish to apply this to?")
	user:RequestClientTargetGameObj(this, "targetObj")
end

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Unpack" and usedType ~="Use") then return end
		
		if not(ValidateUse(user) ) then
			return
		end

		RequestPlacementTarget(user)
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "targetObj", 
	function(targetObj,user)
		-- validate target
		if( not(targetObj) ) then
			return
		end

		if not( IsController(user,targetObj)) then
			user:SystemMessage("You can not equip animals or monsters that are not under your control.","info")
			return
		end

		local supportedPetTag = this:GetObjVar("SupportedPetTag")
		if(supportedPetTag and not(targetObj:HasObjectTag(supportedPetTag))) then
			user:SystemMessage("It doesn't seem to fit.","info")
			return
		end

		-- this is sorta a hack to stop dreads
		if(GetPetSlots(targetObj) > ServerSettings.Pets.MaxSlotsToAllowDismiss) then
			user:SystemMessage("It doesn't seem to fit.","info")
			return
		end

		local unpackedTemplate = this:GetObjVar("EquipmentTemplate")	
		if( unpackedTemplate ~= nil ) then
			ClientDialog.Show{
			    TargetUser = user,
			    TitleStr = "Confirm Equip",
			    DescStr = "Are you sure you wish to equip this onto "..StripColorFromString(targetObj:GetName()).."? Once equipped, it can not be removed.",
			    Button1Str = "Confirm",
			    Button2Str = "Cancel",
			    ResponseObj = this,
			    ResponseFunc = function (user,buttonId)
			    		if(targetObj and targetObj:IsValid() and IsController(user,targetObj)) then
				    		CreateEquippedObj(unpackedTemplate,targetObj)
				    		this:Destroy()
				    	end
					end,
			}
		end
	end)


RegisterSingleEventHandler(EventType.ModuleAttached, GetCurrentModule(), 
    function ()
         AddUseCase(this,"Unpack",true,"HasObject")
    end)