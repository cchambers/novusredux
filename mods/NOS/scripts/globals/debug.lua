global_table = _G

-- Profiling Helper Functions
profileData = {	
	totals = {},
	counts = {},
	start = {}
}

function ProfileStart(name)
	profileData.start[name] = ServerTimeMs()
end

function ProfileEnd(name)
	if not(profileData.start[name]) then DebugMessage("Missing ProfileStart: "..name) return end
	
	profileData.counts[name] = (profileData.counts[name] or 0) + 1
	profileData.totals[name] = (profileData.totals[name] or 0) + (ServerTimeMs() - profileData.start[name])
end

function OutputProfile()
	DebugMessage("--Profile--")

	local profData = {}
	for name,time in pairs(profileData.totals) do 
		local count = profileData.counts[name]
		table.insert(profData,{Name=name,Time=time,Count=count})
	end
	table.sort(profData,function(a,b) return a.Time > b.Time end)

	for i,entry in pairs(profData) do 
		if(i <= 10)	then 
			DebugMessage("----"..entry.Name..": "..tostring(entry.Time).." ("..entry.Count..")")
		end
	end

	profileData.totals = {}
	profileData.counts = {}
	profileData.start = {}
end

-- Memory Debugging Helpers
function trim_table(t,maxdepth,result,curDepth)
	curDepth = curDepth or 1
	result = result or t

	if(curDepth > maxdepth) then return result end

	for k,v in pairs(t) do
		if(type(v) == "table") then
			result[k] = {}
			trim_table(v,maxdepth,result[k],curDepth+1)
		else
			result[k] = v
		end
	end

	return result
end

function dump_to_xml(t,maxdepth,xmlOut,filter,curDepth,seen)
	curDepth = curDepth or 1	

	if seen and seen[t] then return xmlOut end

  	local s = seen or {}
  	local res = setmetatable({}, getmetatable(t))
    s[t] = res

	if(curDepth > maxdepth) then return result end

	for k,v in pairs(t) do
		if(not(filter) or filter(k,v,curDepth)) then 
			if(type(v) == "table") then
				local key = k
				if(type(k) == "number") then
					key = "num"..tostring(k)
				end
				local subXmlOut = xmlOut:append(tostring(key))
				subXmlOut["value"] = "table"
				dump_to_xml(v,maxdepth,subXmlOut,filter,curDepth+1,s)
			else
				local key = k
				if(type(k) == "number") then
					key = "num"..tostring(k)
				end
				local subXmlOut = xmlOut:append(tostring(key))
				if(type(v) == "function") then
					local finfo = debug.getinfo(v,'n')
					subXmlOut["value"] = finfo.name
				else
					subXmlOut["value"] = tostring(v)
				end
			end
		end
	end
	
	return xmlOut
end

function dump_registry_to_xml()
	if(xml == nil) then
		DebugMessage("dump_registry_to_xml support not available")
		return
	end

	local xmlOut = xml.new("root")

	collectgarbage("collect")
	collectgarbage("collect")
	xmlOut = dump_to_xml(debug.getregistry(),10,xmlOut)
	xmlOut:save("registry.xml")
end

function dump_object_to_xml(gameObj)
	if(xml == nil) then
		DebugMessage("dump_object_to_xml support not available")
		return
	end

	local xmlOut = xml.new("root")

	collectgarbage("collect")
	collectgarbage("collect")
	xmlOut = dump_to_xml(global_table["object"..gameObj.Id],10,xmlOut)
	xmlOut:save("object"..gameObj.Id..".xml")
end

function dump_globals_to_xml()
	if(xml == nil) then
		DebugMessage("dump_globals_to_xml support not available")
		return
	end

	local xmlOut = xml.new("root")

	local filterFunc = (
		function(k,v,curDepth) 
			return curDepth > 1 or (type(k) == "string" and not(k:match("object")))
        end)

	collectgarbage("collect")
	collectgarbage("collect")
	xmlOut = dump_to_xml(global_table,10,xmlOut,filterFunc)
	xmlOut:save("globals.xml")
end

function dump_all_objects_to_xml()
	if(xml == nil) then
		DebugMessage("dump_all_objects_to_xml support not available")
		return
	end
	
	local xmlOut = xml.new("root")

	local filterFunc = (
		function(k,v,curDepth) 
			return curDepth > 1 or (type(k) == "string" and k:match("object"))
        end)

	collectgarbage("collect")
	collectgarbage("collect")
	xmlOut = dump_to_xml(global_table,10,xmlOut,filterFunc)
	xmlOut:save("allobjects.xml")
end

function deep_count(t,entries,maxdepth,root,curdepth)
	curDepth = curDepth or 0
	root = root or ""
	local leafCount = 0
	local subTables = 0
	for k,v in pairs(t) do
		if(type(v) == "table") then
			subTables = subTables + 1
			leafCount = leafCount + deep_count(v,entries,maxdepth,root.."."..tostring(k),curDepth+1)
		else
			leafCount = leafCount + 1
		end
	end

	if(curDepth <= maxdepth or subTables == 0) then
		if(entries[root] ~= nil) then
			entries[root] = entries[root] + leafCount
		else
			entries[root] = leafCount
		end
	end

	return leafCount
end

function MemDump()
	local entries = {}

	for k,v in pairs(global_table) do
		if(k:match("object%d+")) then
			for moduleName,moduleData in pairs(v) do											
				if not(moduleName == 'this' or moduleName == 'module_count') then
					if(type(moduleData) == "table") then
						deep_count(moduleData,entries,3,moduleName)
					end
				end
			end
		end
	end
			
	return entries
end

beginDump = {}
function MemBegin()
	beginDump = MemDump()
end

function MemEnd()
	local endDump = MemDump()
	local results = {}

	for k,v in pairs(endDump) do
		results[k] = endDump[k] - (beginDump[k] or 0)
	end

	local array = {}
	for key, value in pairs(results) do
		table.insert(array,{name = key, value = value})		
	end
	table.sort(array,function(a,b) return a.value < b.value end)

	DebugMessage("------------------ BEGIN DUMP ------------------")
	for k,v in pairs(array) do	
		if(v.value > 5)	 then
			DebugMessage(v.name ..": "..v.value)
		end
	end
end
