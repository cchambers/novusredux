searchTypes = {
	"Name",
	"Region",
	"HasObjVar",
	"HasModule",
	"DistanceFrom",
	"Container",
	"Template",
}

searchInfo = {}
found = nil

function ShowNewSearch(arg)
	if(arg ~= nil) then
		searchInfo.Param = arg
	end
	
	local newWindow = DynamicWindow("ObjectList","New Search",450,320)
	newWindow:AddLabel(20, 20, "[F3F781]New Object Search[-]",600,0,18,"left",false)

	newWindow:AddButton(80, 50, "Type:Name", "Name", 100, 23, "", "", false,"Selection",GetButtonState(searchInfo.Type,"Name"))
	newWindow:AddButton(230, 50, "Type:Region", "Region", 100, 23, "", "", false,"Selection",GetButtonState(searchInfo.Type,"Region"))	
	newWindow:AddButton(80, 80, "Type:HasModule", "HasModule", 100, 23, "", "", false,"Selection",GetButtonState(searchInfo.Type,"HasModule"))
	newWindow:AddButton(230, 80, "Type:DistanceFrom", "DistanceFrom", 100, 23, "", "", false,"Selection",GetButtonState(searchInfo.Type,"DistanceFrom"))	
	newWindow:AddButton(80, 110, "Type:Container", "Container", 100, 23, "", "", false,"Selection",GetButtonState(searchInfo.Type,"Container"))
	newWindow:AddButton(230, 110, "Type:HasObjVar", "HasObjVar", 100, 23, "", "", false,"Selection",GetButtonState(searchInfo.Type,"HasObjVar"))
	newWindow:AddButton(80, 140, "Type:Template", "Template", 100, 23, "", "", false,"Selection",GetButtonState(searchInfo.Type,"Template"))

	newWindow:AddLabel(20, 193, "[F3F781]Value:[-]",600,0,18,"left",false)
	newWindow:AddTextField(80, 190, 300,20, "StringValue", searchInfo.Param or "")

	newWindow:AddButton(310, 230, "DoSearch", "Search", 100, 23, "", "", true,"")
	this:OpenDynamicWindow(newWindow)
end

function OpenSearchMap(_search,searchResults)
	local mapName = ServerSettings.WorldName
	local subregionName = ServerSettings.SubregionName
	if(subregionName) then
		mapName = subregionName
	end

	--DebugMessage(1)
	_search = _search or SearchInfo
	local results = searchResults or DoObjectSearch(_search)
	local dynWindow = DynamicWindow("MapWindow",mapName,740,700,-350,-350,"Transparent","Center")
	dynWindow:AddButton(695,22,"","",46,28,"","",true,"ScrollClose")

	local objectLocation = Loc(0,0,0)
	local max = 100
	local mapIcons = {}
	for i,object in pairs(results) do
		if (i <= max) then
			objectLocation = object:GetLoc()
			if (object:TopmostContainer() ~= nil) then
				objectLocation = object:TopmostContainer():GetLoc()
			end
			table.insert(mapIcons,{Icon="marker_diamond1", Location=objectLocation, Tooltip = object:GetName().."\nID:"..tostring(object.Id)})
		end
	end
	dynWindow:AddMap(0,0,700,700,mapName,false,true,mapIcons)
	this:OpenDynamicWindow(dynWindow)
end

function DoObjectSearch(_search)
	local found = {}
	if(_search.Type == "Name") then
		found = FindObjects(SearchName(_search.Param))
	elseif(_search.Type == "Region") then
		found = FindObjects(SearchRegion(_search.Param))
	elseif(_search.Type == "HasObjVar") then
		found = FindObjects(SearchHasObjVar(_search.Param))
	elseif(_search.Type == "HasModule") then
		found = FindObjects(SearchModule(_search.Param))
	elseif(_search.Type == "DistanceFrom") then
		found = FindObjects(SearchObjectInRange(tonumber(_search.Param)))
	elseif(_search.Type == "Container") then
		local contObj = GameObj(tonumber(_search.Param))
		found = contObj:GetContainedObjects()
	elseif(_search.Type == "Template") then
		found = FindObjects(SearchTemplate(_search.Param))
	end
	return found
end

function ShowObjectList(selectedObject,search)
	if(search == nil) then search = searchInfo end

	local newWindow = DynamicWindow("ObjectList","Search Window",450,530)
	local max = 100
	
	local scrollWindow = ScrollWindow(20,40,380,375,25)

	found = DoObjectSearch(search)

	for i, obj in pairs(found) do
		if (i > max) then
			this:SystemMessage("Search returned over 100 results... ("..#found..")")
			break
		end
		local scrollElement = ScrollElement()	

		if((i-1) % 2 == 1) then
            scrollElement:AddImage(0,0,"Blank",360,25,"Sliced","1A1C2B")
        end
		
		scrollElement:AddLabel(5, 3, obj:GetName() .. " ("..obj.Id..")",0,0,18)

		local selState = ""
		if(selectedObject ~= nil and obj.Id == selectedObject.Id) then
			selState = "pressed"
		end
		scrollElement:AddButton(340, 3, "select:"..obj.Id, "", 0, 18, "", "", false, "Selection",selState)
		scrollWindow:Add(scrollElement)
	end
	newWindow:AddScrollWindow(scrollWindow)

	local buttonParam = (selectedObject and tostring(selectedObject.Id)) or ""
	newWindow:AddButton(15, 420, "teleport:"..buttonParam, "Tele there", 100, 23, "", "", false,"",buttonState)--goto
	newWindow:AddButton(115, 420, "teleportToMe:"..buttonParam, "Tele here", 100, 23, "", "", false,"",buttonState)--goto me
	newWindow:AddButton(215, 420, "info:"..buttonParam, "Info", 100, 23, "", "", false,"",buttonState)--info
	newWindow:AddButton(315, 420, "slay:"..buttonParam, "Slay", 100, 23, "", "", false,"",buttonState)--destroy	
	newWindow:AddButton(115, 443, "new", "New Search", 100, 23, "", "", false,"")
	newWindow:AddButton(215, 443, "showMap", "Map View", 100, 23, "", "", false,"")
	this:OpenDynamicWindow(newWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"ObjectList",
	function (user,returnId,fieldData)
		if(returnId ~= nil) then
			local items = StringSplit(returnId,":")
			local action = items[1]
			local param = items[2]

			-- handle no object buttons first
			if(action=="Type") then
				searchInfo.Type = param
				ShowNewSearch()
				return
			elseif(action=="DoSearch") then
				searchInfo.Param = fieldData.StringValue
				ShowObjectList(selectedObject)
				return
			elseif(action == "showMap") then
				OpenSearchMap(searchInfo,found)
			elseif(action=="new") then
				ShowNewSearch()
				return
			end

			if (param == nil or not type(param) == "number") then
				this:SystemMessage("Check arguments")
				found = nil
				return
			end
			local object = GameObj(tonumber(param))
			if(action== "teleport") then
				if( object ~= nil ) then
					local topCont = object:TopmostContainer() or object
					this:SetWorldPosition(topCont:GetLoc())
					this:PlayEffect("TeleportToEffect")
				end
			elseif(action== "teleportToMe") then
				if( object ~= nil ) then
					object:PlayEffect("TeleportFromEffect")
					object:SetWorldPosition(this:GetLoc())
					object:PlayEffect("TeleportToEffect")
				end
			elseif(action== "info") then
				if( object ~= nil ) then
					DoInfo(object)
				end
			elseif(action== "slay") then
				if( object ~= nil ) then
					DoSlay(object)
				end
			elseif(action== "select") then
				ShowObjectList(object)
			elseif(action == "UserListNext") then
				UserListPage = UserListPage + 1
				ShowObjectList(object)
			elseif( action == "UserListPrev") then
				UserListPage = UserListPage - 1
				ShowObjectList(object)
			end
		end	
	end)
