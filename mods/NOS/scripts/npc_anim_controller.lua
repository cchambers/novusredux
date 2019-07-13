-- this is an example sequence... is intended to be overridden by initializer, or editted in game
AnimSequence = {		
}
LoopSequence = true

curIndex = 1
selAnim = nil
editType = "Anim"

function GetPathLocStr(loc)
	return string.format("%.2f %.2f",loc.X,loc.Z)
end

function ShowEditWindow(user)
	local newWindow = DynamicWindow("EditWindow","Edit Animation Sequence ("..this.Id..")",600,380)

    local scrollWindow = ScrollWindow(10,10,355,250,25)

    local animSeq = this:GetObjVar("AnimSequence") or {}
    for i,entry in pairs(animSeq) do
        local scrollElement = ScrollElement()
        if((i-1) % 2 == 1) then
        scrollElement:AddImage(0,0,"Blank",330,25,"Sliced","242400")
        end    

        if(entry.Anim) then
	        scrollElement:AddLabel(5, 5, "Anim: "..entry.Anim,0,0,18)
	    elseif(entry.PathTo) then
	    	scrollElement:AddLabel(5, 5, "PathTo: "..GetPathLocStr(entry.PathTo),0,0,18)
	    end
        scrollElement:AddLabel(180, 5, "Min: "..(entry.DelayMin or 1),0,0,18)
        scrollElement:AddLabel(240, 5, "Max: "..(entry.DelayMax or 1),0,0,18)
        
        local selState = ""
        if(i == selAnim) then
            selState = "pressed"
        end
           
        scrollElement:AddButton(320, 0, "Select|"..i, "", 0, 22, "", "", false, "Selection",selState)
        scrollWindow:Add(scrollElement)
    end

    newWindow:AddScrollWindow(scrollWindow)
    newWindow:AddButton(10, 260, "Play", "Play", 80, 23, "", "", false,"")
    newWindow:AddButton(90, 260, "Stop", "Stop", 80, 23, "", "", false,"")
    newWindow:AddButton(180, 260, "AddAnim", "Add", 100, 23, "", "", false,"")

    local editState = selAnim and "" or "disabled"
    newWindow:AddButton(280, 260, "DelAnim", "Delete", 100, 23, "", "", false,"",editState)      

    local shouldLoop = this:GetObjVar("LoopSequence") or false
    newWindow:AddButton(10, 290, "LoopToggle", "Loop Sequence", 0, 22, "", "", false, "Selection",(shouldLoop and "pressed") or "")

    -- right pane

    if(selAnim) then
    	newWindow:AddButton(390, 10, "EditType|Anim", "Anim", 0, 22, "", "", false, "Selection",((editType=="Anim") and "pressed") or "")
    	newWindow:AddButton(390, 40, "EditType|PathTo", "PathTo", 0, 22, "", "", false, "Selection",((editType=="PathTo") and "pressed") or "")

    	local animInfo = animSeq[selAnim]
	    local curY = 80

	    if(editType == "Anim") then
			newWindow:AddLabel(391,curY,"Anim",0,0,16)
			curY = curY + 20
			newWindow:AddTextField(390,curY + 4,180,20,"anim",(animInfo.Anim or ""))
			curY = curY + 40
		elseif(editType == "PathTo") then
			newWindow:AddLabel(391,curY,"Path",0,0,16)
			curY = curY + 20
			
			local pathLocStr = nil
			if (animInfo.PathTo) then
				pathLocStr = GetPathLocStr(animInfo.PathTo)
			else
				pathLocStr = GetPathLocStr(this:GetLoc())
			end
			newWindow:AddTextField(390,curY + 4,120,20,"path",pathLocStr)
			newWindow:AddButton(515, curY, "TargetPath", "Target", 60, 23, "", "", false,"")
			curY = curY + 40			
		end

		newWindow:AddLabel(391,curY,"Min",0,0,16)
		curY = curY + 20
		newWindow:AddTextField(390,curY + 4,180,20,"min",tostring(animInfo.DelayMin or 1))
		curY = curY + 40
		newWindow:AddLabel(391,curY,"Max",0,0,16)
		curY = curY + 20
		newWindow:AddTextField(390,curY + 4,180,20,"max",tostring(animInfo.DelayMax or 1))
		curY = curY + 40
		newWindow:AddButton(450, curY, "Save", "Save",0,23,"","",false)  
	end

    user:OpenDynamicWindow(newWindow,this)
end


RegisterEventHandler(EventType.DynamicWindowResponse,"EditWindow",
	function (user,returnId,fields)
		if not(IsGod(user)) then return end	

		if(returnId == "Play") then
			Play()
		elseif(returnId == "Stop") then
			Stop()
		elseif(returnId == "LoopToggle") then
			local shouldLoop = not(this:GetObjVar("LoopSequence") or false)
			this:SetObjVar("LoopSequence",shouldLoop)
			ShowEditWindow(user)
		elseif(returnId:match("Select")) then
			selAnim = tonumber(returnId:sub(8))
			local animSeq = this:GetObjVar("AnimSequence")
			if(animSeq[selAnim].Anim) then
				editType = "Anim"
			elseif(animSeq[selAnim].PathTo) then
				editType = "PathTo"
			end
			ShowEditWindow(user)
		elseif(returnId:match("EditType")) then
			editType = returnId:sub(10)
			local animSeq = this:GetObjVar("AnimSequence")
			if(editType == "Anim") then
				animSeq[selAnim].PathTo = nil
			elseif(editType == "PathTo") then
				animSeq[selAnim].Anim = nil
			end
			this:SetObjVar("AnimSequence",animSeq)
			ShowEditWindow(user)
		elseif(returnId == "DelAnim") then
			if(selAnim ~= nil) then
				local animSeq = this:GetObjVar("AnimSequence") or {}
				table.remove(animSeq,selAnim)
				this:SetObjVar("AnimSequence",animSeq)
				selAnim = nil
				ShowEditWindow(user)
			end
		elseif(returnId == "AddAnim") then
			local animSeq = this:GetObjVar("AnimSequence") or {}
			table.insert(animSeq,{Anim="wave",DelayMin=1,DelayMax=1})
			this:SetObjVar("AnimSequence",animSeq)
			selAnim = #animSeq
			ShowEditWindow(user)
		elseif(returnId == "Save") then
			local animSeq = this:GetObjVar("AnimSequence")
			if(editType == "Anim") then
				animSeq[selAnim].Anim = fields.anim or ""
			elseif(editType == "PathTo") then
				local comps = StringSplit(fields.path," ")
				if(#comps >= 2) then
					animSeq[selAnim].PathTo = Loc(tonumber(comps[1]),0,tonumber(comps[2]))
				end
			end
			animSeq[selAnim].DelayMin = tonumber(fields.min) or 1
			animSeq[selAnim].DelayMax = tonumber(fields.max) or 1
			this:SetObjVar("AnimSequence",animSeq)
			ShowEditWindow(user)
		elseif(returnId == "TargetPath") then
			user:RequestClientTargetLoc(this, "SelectLocation")
            RegisterSingleEventHandler(EventType.ClientTargetLocResponse,"SelectLocation",
            	function (success, targetLoc)
            		if(success) then
	            		local animSeq = this:GetObjVar("AnimSequence")
    	        		animSeq[selAnim].PathTo = targetLoc
    	        		this:SetObjVar("AnimSequence",animSeq)
    	        		ShowEditWindow(user)
    	        	end
            	end)
		else
			selAnim = nil
		end
	end)

function Step(animSeq)
	if not(curIndex) then return end
	
	animSeq = animSeq or this:GetObjVar("AnimSequence") or {}
	local curSeq = animSeq[curIndex]

	curIndex = curIndex + 1
	if(curIndex > #animSeq) then
		curIndex = 1
	end

	local loopSeq = this:GetObjVar("LoopSequence") or false
	if(loopSeq or curIndex ~= 1) then
		if(curSeq.DelayMax > 0) then
			CallFunctionDelayed(TimeSpan.FromSeconds(math.random((curSeq.DelayMin or 1),(curSeq.DelayMax or 1))), 
				function ( ... )
					HandleAnim()
				end)
		else
			HandleAnim()
		end
	end
end

function HandleAnim()
	if not(curIndex) then return end

	local animSeq = this:GetObjVar("AnimSequence") or {}
	
	if(#animSeq < curIndex) then curIndex = 1 end	

	local curSeq = animSeq[curIndex]

	--DebugMessage(""..curIndex..": "..(curSeq.Anim or curSeq.PathTo:ToString()))

	if(curSeq.Anim and curSeq.Anim ~= "") then
		this:PlayAnimation(curSeq.Anim)
		Step()
	elseif(curSeq.PathTo) then
		this:PathTo(curSeq.PathTo,curSeq.PathToSpeed or 1,"animpath")		
	else
		Step()
	end
end

RegisterEventHandler(EventType.Arrived,"animpath",
	function ( ... )
		Step()
	end)

function Play()
	curIndex = 1
	this:SetObjVar("AnimStartPos",this:GetLoc())
	this:SetObjVar("AnimStartFacing",this:GetFacing())
	HandleAnim()
end
RegisterEventHandler(EventType.Message,"play",Play)

function Stop()
	curIndex = nil

	local startPos = this:GetObjVar("AnimStartPos")
	local startFacing = this:GetObjVar("AnimStartFacing")
	this:SetWorldPosition(startPos)
	this:SetFacing(startFacing)

	if (IsSitting(this)) then
		--this:PlayAnimation("sit")
	else
		this:PlayAnimation("idle")
	end
end
RegisterEventHandler(EventType.Message,"stop",Stop)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ( ... )		
		if(initializer) then
			if(initializer.AnimSequence) then
				this:SetObjVar("AnimSequence",initializer.AnimSequence)
			else
				this:SetObjVar("AnimSequence",AnimSequence)
			end

			if(initializer.LoopSequence) then
				this:SetObjVar("LoopSequence",initializer.LoopSequence)
			else
				this:SetObjVar("LoopSequence",LoopSequence)
			end

			if(initializer.User) then
				ShowEditWindow(initializer.User)
			end
		end
		AddUseCase(this,"Play",true,"IsGod")
	end)

RegisterEventHandler(EventType.Message,"UseObject",
	function ( user,usedType)
		if not(IsGod(user)) then return end

		if(usedType == "Play") then
			Play()
		end
	end)

RegisterEventHandler(EventType.Message,"OpenAnimEdit",
	function ( user)
		ShowEditWindow(user)
	end)