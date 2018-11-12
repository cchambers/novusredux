mCreateCustomSelectedObject = nil
mCreateTemplateId = "blank"
mCreateCustomSort = "name"
allObjects = nil

function OpenCreateCustomWindow()
	local newWindow = DynamicWindow("CustomCreateWindow","Custom Create",450,670)

	local objList = ScrollWindow(12,12,400,476,34)

	local clientIdFile = SERVER_DATADIRECTORY .. "/ClientIdReference.txt"

	allObjects = {}
	if(file_exists(clientIdFile)) then	
    	for line in io.lines(clientIdFile) do    		
    		local id,objectName = line:gsub("%a+/",""):match("(%d+)\t(.+)")
    		if(objectName) then
	    		table.insert(allObjects,{ Id = tonumber(id), Name = objectName})
	    	end
    	end
    end

    table.sort(allObjects,function (a,b)
    	if(mCreateCustomSort == "name") then
    		return a.Name < b.Name 
    	elseif(mCreateCustomSort == "id") then
    		return a.Id < b.Id 
    	end
    end)

    for i,info in pairs(allObjects) do
		local selected = (mCreateCustomSelectedObject ~= nil and mCreateCustomSelectedObject.Id == info.Id) and "pressed" or ""

		scrollElement = ScrollElement()
	--add the section
		scrollElement:AddButton(2,4,tostring(info.Id),"",387,31,"","",false,"SkillSectionButton",selected)
		
		scrollElement:AddLabel(24,10,"[A1ADCC]"..info.Id.."[-]",225,35,18,"left")
		scrollElement:AddLabel(80,10,"[A1ADCC]"..info.Name.."[-]",225,35,18,"left")
	
		objList:Add(scrollElement)
    end

    newWindow:AddScrollWindow(objList)

    newWindow:AddLabel(20,503,"Sort",0,0,18)

    local selected = (mCreateCustomSort == "name") and "pressed" or ""
    newWindow:AddButton(80,500,"Name","Name",80,25,"",nil,false,"",selected)
    local selected = (mCreateCustomSort == "id") and "pressed" or ""
    newWindow:AddButton(180,500,"Id","Id",50,25,"",nil,false,"",selected)

    newWindow:AddLabel(20,542,"Template Id",0,0,18)
    newWindow:AddTextField(130,540,280,25,"TemplateId",mCreateTemplateId)

    local disabled = (mCreateCustomSelectedObject == nil) and "disabled" or ""
    newWindow:AddButton(240,580,"Create","Create",150,25,"",nil,false,"",disabled)

    this:OpenDynamicWindow(newWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"CustomCreateWindow",
	function ( user,buttonId,fieldData)
		if(buttonId == "Name") then
			mCreateCustomSort = "name"
			OpenCreateCustomWindow()
		elseif(buttonId == "Id") then
			mCreateCustomSort = "id"
			OpenCreateCustomWindow()
		elseif(buttonId == "Create") then
			local templateData = GetTemplateData("blank")
			templateData.Name = mCreateCustomSelectedObject.Name
			templateData.ClientId = mCreateCustomSelectedObject.Id
			CreateCustomObj("blank",templateData,this:GetLoc())
		elseif(buttonId) then
			local clientId = tonumber(buttonId)
			if(clientId) then
				for i,info in pairs(allObjects) do
					if(info.Id == clientId) then
						mCreateCustomSelectedObject = info
					end
				end
				OpenCreateCustomWindow()
			end
		end
	end)