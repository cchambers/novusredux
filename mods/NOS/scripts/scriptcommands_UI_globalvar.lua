function ShowGlobalVar(recordPath)
	recordPath = recordPath or ""

	local windowHeight = 500	
	local newWindow = DynamicWindow("GlobalVarWindow","Global Var",450,windowHeight)

	newWindow:AddLabel(20, 20, "[F3F781]Path:[-]",600,0,18,"left",false)	
	newWindow:AddLabel(80, 20, recordPath,600,0,18,"left",false)	
	
	newWindow:AddImage(20,50,"Divider",360,1,"Sliced")
			
	newWindow:AddLabel(20, 63, DumpTable(GlobalVarRead(recordPath)),400,330,18,"",true)	

	this:OpenDynamicWindow(newWindow)
end

function ListGlobalVars(results)
	if(#results > 100) then
		this:SystemMessage("Results exceeded limit. Showing first 100.")
	end

	local newWindow = DynamicWindow("GlobalVarList","Matching Records",450,530)
	
	local scrollWindow = ScrollWindow(20,20,380,445,25)
	for i,recordName in pairs(results) do
		if(i <= 100) then
			local scrollElement = ScrollElement()
			scrollElement:AddButton(10, 0, recordName, recordName, 360, 25, "", "", true,"List")
			scrollWindow:Add(scrollElement)
		end
	end
	newWindow:AddScrollWindow(scrollWindow)

	this:OpenDynamicWindow(newWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"GlobalVarList",
	function(user,buttonId)
		if(buttonId ~= nil and buttonId ~= "") then
			ShowGlobalVar(buttonId)
		end
	end)