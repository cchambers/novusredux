-- OBJVAR EDIT WINDOW

objVarEditInfo = nil

function ValidateEditData()
	return objVarEditInfo.Target ~= nil 
		and objVarEditInfo.Target:IsValid() 
		and objVarEditInfo.Name ~= nil 
		and objVarEditInfo.Name ~= ""
		and objVarEditInfo.Type ~= nil
		and objVarEditInfo.Type ~= ""
		and objVarEditInfo.Data[objVarEditInfo.Type] ~= nil
end

function RefreshObjVarEditWindow()
	local windowHeight = 320
	if(objVarEditInfo.Type == "table") then
		windowHeight = 500
	end

	local newWindow = DynamicWindow("ObjVarEditWindow","Edit ObjVar",450,windowHeight)

	newWindow:AddLabel(20, 20, "[F3F781]Name:[-]",600,0,18,"left",false)
	if(objVarEditInfo.IsNew) then
		newWindow:AddTextField(80, 20, 260,20, "ObjVarName", objVarEditInfo.Name)
	else
		newWindow:AddLabel(80, 20, objVarEditInfo.Name,600,0,18,"left",false)
	end

	newWindow:AddLabel(20, 50, "[F3F781]Type:[-]",600,0,18,"left",false)
	
	local buttonStates = { 
		String = (objVarEditInfo.Type=="string") and "pressed" or "", 
		Number = (objVarEditInfo.Type=="number") and "pressed" or "",
		Bool = (objVarEditInfo.Type=="boolean") and "pressed" or "",
		Table = (objVarEditInfo.Type=="table") and "pressed" or "",
		Loc = (objVarEditInfo.Type=="Loc") and "pressed" or "",
		GameObj = (objVarEditInfo.Type=="GameObj") and "pressed" or "",
		PermanentObj = (objVarEditInfo.Type=="PermanentObj") and "pressed" or ""
	}

	if not(objVarEditInfo.ExcludeTypes.string) then
		newWindow:AddButton(80, 50, "Type|string", "string", 100, 23, "", "", false,"Selection",buttonStates.String)
	end
	if not(objVarEditInfo.ExcludeTypes.number) then
		newWindow:AddButton(210, 50, "Type|number", "number", 100, 23, "", "", false,"Selection",buttonStates.Number)
	end
	if not(objVarEditInfo.ExcludeTypes.Loc) then
		newWindow:AddButton(340, 50, "Type|Loc", "Loc", 100, 23, "", "", false,"Selection",buttonStates.Loc)
	end
	if not(objVarEditInfo.ExcludeTypes.boolean) then
		newWindow:AddButton(80, 80, "Type|boolean", "boolean", 100, 23, "", "", false,"Selection",buttonStates.Bool)
	end
	if not(objVarEditInfo.ExcludeTypes.table) then
		newWindow:AddButton(210, 80, "Type|table", "table", 100, 23, "", "", false,"Selection",buttonStates.Table)	
	end
	if not(objVarEditInfo.ExcludeTypes.GameObj) then
		newWindow:AddButton(80, 110, "Type|GameObj", "GameObj", 100, 23, "", "", false,"Selection",buttonStates.GameObj)
	end
	if not(objVarEditInfo.ExcludeTypes.PermanentObj) then
		newWindow:AddButton(210, 110, "Type|PermanentObj", "PermanentObj", 100, 23, "", "", false,"Selection",buttonStates.PermanentObj)
	end

	newWindow:AddImage(20,150,"Divider",360,1,"Sliced")

	if(objVarEditInfo.Type == "string") then
		newWindow:AddLabel(20, 163, "[F3F781]Value:[-]",600,0,18,"left",false)
		newWindow:AddTextField(80, 160, 300,20, "StringValue", objVarEditInfo.Data.string or "")
	elseif(objVarEditInfo.Type == "number") then
		newWindow:AddLabel(20, 163, "[F3F781]Value:[-]",600,0,18,"left",false)
		newWindow:AddTextField(80, 160, 300,20, "NumberValue", objVarEditInfo.Data.number and tostring(objVarEditInfo.Data.number) or "")
	elseif(objVarEditInfo.Type == "Loc") then
		newWindow:AddLabel(20, 163, "[F3F781]X:[-]",600,0,18,"left",false)
		newWindow:AddTextField(40, 160, 100,20, "LocXValue", objVarEditInfo.Data.Loc and tostring(objVarEditInfo.Data.Loc.X) or "")
		newWindow:AddLabel(150, 163, "[F3F781]Y:[-]",600,0,18,"left",false)
		newWindow:AddTextField(170, 160, 100,20, "LocYValue", objVarEditInfo.Data.Loc and tostring(objVarEditInfo.Data.Loc.Y) or "")
		newWindow:AddLabel(280, 163, "[F3F781]Z:[-]",600,0,18,"left",false)
		newWindow:AddTextField(300, 160, 100,20, "LocZValue", objVarEditInfo.Data.Loc and tostring(objVarEditInfo.Data.Loc.Z) or "")

		newWindow:AddButton(30, 210, "SelectLoc", "Select Loc", 150, 23, "", "", false,"")
	elseif(objVarEditInfo.Type == "boolean") then		
		newWindow:AddLabel(20, 163, "[F3F781]Value:[-]",600,0,18,"left",false)
		local trueButtonState = (objVarEditInfo.Data.boolean or false) and "pressed" or ""		
		newWindow:AddButton(80, 163, "BoolVal|true", "True", 100, 23, "", "", false,"Selection",trueButtonState)
		local falseButtonState = (objVarEditInfo.Data.boolean or false) and "" or "pressed"
		newWindow:AddButton(210, 163, "BoolVal|false", "False", 100, 23, "", "", false,"Selection",falseButtonState)
	elseif(objVarEditInfo.Type == "GameObj") then
		newWindow:AddLabel(20, 163, "[F3F781]Value:[-]",600,0,18,"left",false)
		newWindow:AddTextField(80, 160, 300,20, "GameObjValue", objVarEditInfo.Data.GameObj and tostring(objVarEditInfo.Data.GameObj.Id) or "")

		newWindow:AddButton(30, 210, "SelectObj", "Select Object", 150, 23, "", "", false,"")
	elseif(objVarEditInfo.Type == "PermanentObj") then
		newWindow:AddLabel(20, 163, "[F3F781]Value:[-]",600,0,18,"left",false)
		newWindow:AddTextField(80, 160, 300,20, "PermanentObjValue", objVarEditInfo.Data.PermanentObj and tostring(objVarEditInfo.Data.PermanentObj.Id) or "")

		newWindow:AddButton(30, 210, "SelectPermObj", "Select Object", 150, 23, "", "", false,"")
	elseif(objVarEditInfo.Type == "table") then
		if(objVarEditInfo.Data.table == nil) then
			newWindow:AddLabel(20, 163, "Table editing coming soon (tm)",0,0,18,"left",false)
		else
			local tableStr = DumpTable(objVarEditInfo.Data.table)
			if(#tableStr > 500) then
				tableStr = string.sub(tableStr,1,500)
			end
			newWindow:AddLabel(20, 163, tableStr,400,230,18,"",true)
		end
	end

	if(objVarEditInfo.Type ~= "table") then
		newWindow:AddButton(310, windowHeight - 90, "SaveObjVar", "Save", 100, 23, "", "", true,"")
	end

	objVarEditInfo.TargetUser:OpenDynamicWindow(newWindow,this)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"ObjVarEditWindow",
	function (user,returnId,fieldData)
		if(fieldData ~= nil) then
			if(fieldData.ObjVarName ~= nil) then
				objVarEditInfo.Name = fieldData.ObjVarName
			end

			if(fieldData.StringValue ~= nil) then
				objVarEditInfo.Data.string = fieldData.StringValue
			end

			if(fieldData.NumberValue ~= nil) then
				objVarEditInfo.Data.number = tonumber(fieldData.NumberValue)
			end

			if(fieldData.LocXValue ~= nil and fieldData.LocYValue ~= nil and fieldData.LocZValue ~= nil) then
				local locX, locY, locZ = tonumber(fieldData.LocXValue), tonumber(fieldData.LocYValue), tonumber(fieldData.LocZValue)
				if(locX ~= nil and locY ~= nil and locZ ~= nil) then
					objVarEditInfo.Data.Loc = Loc(locX, locY, locZ)													
				end
			end

			if(fieldData.GameObjValue ~= nil) then
				local id = tonumber(fieldData.GameObjValue)
				if(id ~= nil) then
					objVarEditInfo.Data.GameObj = GameObj(id)
				end
			end

			if(fieldData.PermanentObjValue ~= nil) then
				local id = tonumber(fieldData.PermanentObjValue)
				if(id ~= nil) then
					objVarEditInfo.Data.PermanentObj = GameObj(id)
				end
			end
		end

		if(returnId:match("Type")) then
			objVarEditInfo.Type = returnId:sub(6)
			RefreshObjVarEditWindow()
		elseif(returnId == "SaveObjVar") then			
			if(ValidateEditData()) then
				if(objVarEditInfo.SaveFunc ~= nil) then
					objVarEditInfo.Data = objVarEditInfo.Data[objVarEditInfo.Type]
					objVarEditInfo.SaveFunc(objVarEditInfo)
				end
			else
				objVarEditInfo.TargetUser:SystemMessage("Objvar edit data failed validation. Try again.")
				RefreshObjVarEditWindow()
			end
		elseif(returnId == "SelectLoc") then
			objVarEditInfo.TargetUser:RequestClientTargetLoc(this, "SelectObjVarLoc")
		elseif(returnId == "SelectObj") then
			objVarEditInfo.TargetUser:RequestClientTargetGameObj(this, "SelectObjVarObj")
		elseif(returnId == "SelectPermObj") then
			objVarEditInfo.TargetUser:RequestClientTargetAnyObj(this, "SelectObjVarPermObj")
		elseif(returnId:match("BoolVal")) then			
			if(objVarEditInfo ~= nil) then
				objVarEditInfo.Data.boolean = (returnId:match("true") ~= nil)
				RefreshObjVarEditWindow()
			end
		end
	end)

RegisterEventHandler(EventType.ClientTargetLocResponse, "SelectObjVarLoc", 
	function (success, targetLoc)	
		if(success) then
			if(objVarEditInfo ~= nil) then
				objVarEditInfo.Data.Loc = targetLoc
				RefreshObjVarEditWindow()
			end
		end
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "SelectObjVarObj", 
    function(target,user)
    	if(target ~= nil and objVarEditInfo ~= nil) then
    		objVarEditInfo.Data.GameObj = target
    		RefreshObjVarEditWindow()
    	end
    end)

RegisterEventHandler(EventType.ClientTargetAnyObjResponse, "SelectObjVarPermObj", 
    function(target,user)
    	if(target ~= nil and objVarEditInfo ~= nil) then
    		if not(target:IsPermanent()) then
    			objVarEditInfo.TargetUser:SystemMessage("You must select a permanent object.")
    		else
	    		objVarEditInfo.Data.PermanentObj = target
    			RefreshObjVarEditWindow()
    		end
    	end
    end)

ObjVarEditWindow = {
	Show = function (curEditInfo)
		objVarEditInfo = curEditInfo
		-- convert the data to a table to support multiple types
		local objVarData = objVarEditInfo.Data
		objVarEditInfo.Data = {}
		if(objVarEditInfo.Type ~= "") then
			objVarEditInfo.Data[objVarEditInfo.Type] = objVarData
		end	

		objVarEditInfo.ExcludeTypes = objVarEditInfo.ExcludeTypes or {}
		objVarEditInfo.TargetUser = objVarEditInfo.TargetUser or this

		--DebugMessage(DumpTable(objVarEditInfo))
		
		RefreshObjVarEditWindow()
	end,
}

