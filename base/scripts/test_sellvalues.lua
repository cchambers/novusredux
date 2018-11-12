
local CREATE_COUNT = 10
local createData = {}
local allTemplates = GetAllTemplateNames()

function PrintReport()
	file = io.open("sellvalues.txt", "w+")
	io.output(file)
	for templateName,entry in pairs(createData) do
		local sellValue = createData[templateName].SellValue / CREATE_COUNT
		io.write(templateName..","..sellValue.."\n")		
	end
	io.close(file)
end

function CreateNext()
	if(#allTemplates > 0) then
		local templateName = allTemplates[1]
		CreateObj(templateName,Loc(0,0,0),"itemSpawn",templateName)	
		table.remove(allTemplates,1)
		DebugMessage("INTERNAL: CreateNext Creating: "..tostring(templateName).." Remaining: "..tostring(#allTemplates))
	else
		PrintReport()
	end
end
CreateNext()

RegisterEventHandler(EventType.CreatedObject,"itemSpawn",
	function(success,objRef,templateName)
		RegisterEventHandler(EventType.Timer,"item"..objRef.Id,
			function()
				local sellValue = GetItemValue(objRef,"coins")
				if(sellValue > 0) then
					if(createData[templateName] == nil) then
						createData[templateName] = { SellValue = sellValue, Count = 1 }
					else
						createData[templateName] = { SellValue = createData[templateName].SellValue + sellValue, Count = createData[templateName].Count + 1 }				
					end

					DebugMessage("INTERNAL: Item: "..tostring(objRef:GetCreationTemplateId()).." Value: "..tostring(sellValue))

					if(createData[templateName].Count == CREATE_COUNT) then				
						CreateNext()
					else
						CreateObj(templateName,Loc(0,0,0),"itemSpawn",templateName)
					end
				else
					CreateNext()
				end

				objRef:Destroy()
				UnregisterEventHandler("test_sellvalues",EventType.Timer,"item"..objRef.Id)				
			end)
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(50),"item"..objRef.Id)
	end)