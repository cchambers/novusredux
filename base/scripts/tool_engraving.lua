
function ValidateEngrave(user,targetObj)
	if (targetObj == nil or not targetObj:IsValid()) then
		return false
	end
	if not(targetObj:HasModule("container")) or targetObj:IsMobile() then
		user:SystemMessage("You can only engrave containers.")
		return false
	end

	-- dont allow engraving on objects other people are carrying
	local topmostObj = targetObj:TopmostContainer() or targetObj
	if(topmostObj:IsMobile() and topmostObj ~= user) then
		user:SystemMessage("I'm not sure you are allowed to do that.")
		return false
	end

	if(topmostObj:GetLoc():Distance(user:GetLoc()) > OBJECT_INTERACTION_RANGE ) then    
        user:SystemMessage("You cannot reach that.")  
        return false
    end

    -- only allow engraving on objects you are carrying or in your house
    if(topmostObj ~= user) then
    	if not(IsHouseOwnerForLoc(user,topmostObj:GetLoc())) then
    		user:SystemMessage("[$2637]")  
	        return false
	    end
    end

    return true
end

function ValidateEngraveName(user,targetObj,newName)
	if(newName == "" or newName == nil) then
		user:SystemMessage("Invalid engraving. Try again.")
		return false
	end

	if(ServerSettings.Misc.EnforceBadWordFilter and HasBadWords(newName)) then
 		user:SystemMessage("[$2638]")
 		return false
 	end

 	return true
end

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ()
		AddUseCase(this,"Engrave Container",true,"HasObject")		
        SetTooltipEntry(this,"tool_desc","[$2639]")
	end)

RegisterEventHandler(EventType.Message,"UseObject",
	function (user,usedType)
		if(usedType ~= "Use" and usedType ~= "Engrave Container") then return end
		
		user:RequestClientTargetGameObj(this, "EngraveItem")
  		RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse,"EngraveItem",
  			function (targetObj)
  				if(ValidateEngrave(user,targetObj)) then
  					TextFieldDialog.Show{
				        TargetUser = user,
				        ResponseObj = this,
				        Title = "Engrave Container",
				        Description = "Maximum 20 characters",
				        ResponseFunc = function(user,newName)
				        	if(ValidateEngrave(user,targetObj) and ValidateEngraveName(user,targetObj,newName)) then
					        	local oldName = targetObj:GetName()
					        	targetObj:SetObjVar("OriginalName",oldName)					        	
					      
								local stripped, color = StripColorFromString(newName)
								if(stripped:len() > 20) then
									newName = stripped:sub(0,20)
									if(color ~= nil) then
										newName = color .. newName .. "[-]"
									end
								end

								targetObj:SetName(newName)
								user:SystemMessage("You engrave the letters on the container.")
							end
				        end
				    }
  				end
  			end)
	end)