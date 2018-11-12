
Sections = {	
	{
		Id = "Main",
		DisplayName = "Server Announcements",
		Restriction = "Immortal",
	},
	{
		Id = "Merchant",
		DisplayName = "Merchant Advertisements",
		Restriction = "None",
	},
	{
		Id = "Other",
		DisplayName = "General Postings",
		Restriction = "None",
	},
}
mBoard = nil
TAB_SIZE = 190

function GetSectionById(sectionId)
	local sectionIndex = IndexOf(Sections,sectionId,function(item,id) return item.Id == id end)
	return Sections[sectionIndex]
end

function ShowMessageBoard(user)
	--DebugMessage("m note is "..tostring(mSelectedNote))
	--DebugMessage("mCurrentSection is "..tostring(mCurrentSection))
	local mainWindow = DynamicWindow("MessageBoard",StripColorFromString(mBoard:GetName()),804,480,-410,-280,"","Center")
	local numSections = CountTable(Sections)
	local myNotes = mBoard:GetContainedObjects() or {}
	mCurrentSection = mCurrentSection or "Main"

	local tabButtons = {}
	for i,data in pairs(Sections) do
		table.insert(tabButtons,{ Text=data.DisplayName, TabId=data.Id})
	end

	AddTabMenu(mainWindow,
	{
        ActiveTab = mCurrentSection, 
        Buttons = tabButtons,
        ButtonWidth = 200,
    })	
	
	mainWindow:AddButton(630,0,"Search","Search",0,0,"Search for a posting",nil,false,"")
	mainWindow:AddButton(702,0,"Post","Post",0,0,"Make a posting",nil,false,"")
	if (#myNotes > 0) then
		local sectionHasNote = false
		for i,j in pairs(myNotes) do
			local section = j:GetObjVar("Section") or "Other"
			if (section == mCurrentSection) then
				sectionHasNote = true
			end
		end
		if (sectionHasNote) then
			mainWindow:AddImage(8,28,"BasicWindow_Panel",210,407,"Sliced")
			local notesWindow = ScrollWindow(12,43-9,190,390,26) --423 not 430?
			local sectionHasNote = false
			for i,j in pairs(myNotes) do
				local section = j:GetObjVar("Section") or "Other"
				--DebugMessage("Section is "..tostring(section),"mCurrentSection is "..tostring(mCurrentSection))
				if (section == mCurrentSection) then
					local title = j:GetObjVar("Title") or "<Untitled>"
					local noteElement = ScrollElement()
					--noteElement:AddLabel(0,210,title,210,35,20,"center")
					noteElement:AddButton(0,0,"Note|"..j.Id,title,195-12-5,26,"Open this note.",nil,false,"List")
					notesWindow:Add(noteElement)

					mSelectedNote = mSelectedNote or j
					--Draw the main window
					if (mSelectedNote == j) then
						mainWindow:AddImage(216,28,"BasicWindow_Panel",560,40,"Sliced")
						if (j:HasObjVar("AuthorName")) then
							title = title .. " [C7C7C7]- By "..tostring(j:GetObjVar("AuthorName"))
						else
							title = title .. " [C7C7C7]- By Anonymous"
						end
						if (IsBoardOwner(this) or j:GetObjVar("Author") == this) then
							mainWindow:AddButton(585+20+TAB_SIZE/3+2+40,32,"Delete","Delete",TAB_SIZE/3,0,"Remove this posting.",nil,false,"")
						end

						mainWindow:AddImage(216,70,"BasicWindow_Panel",560,215,"Sliced")
						mainWindow:AddLabel(224,78,j:GetObjVar("ScrollContents") or "",550,210,18,"center",true)
						local xOffset = 0
						if (j:GetObjVar("MapMarker") ~= nil) then
							xOffset = 85
							mainWindow:AddButton(220,40,"MapMarker","Save Map Marker",165,20,"Add the note's map marker to your map.",nil,false,"")
						end
						mainWindow:AddLabel(470+14+xOffset,40,title,450,20,20,"center")
						local comments = j:GetObjVar("CommentTable") or {}
						mainWindow:AddImage(216,285,"BasicWindow_Panel",560,190-42,"Sliced")
						local commentWindow = ScrollWindow(213,290,558,130,65)

						--Comments are stored like this: 
						--[[
						{
							Author = "Author's Name Here",
							Date = "Date and time as a string",
							Comment = "Insert comment here",

						}
						]]
						for index,commentEntry in pairs(comments) do
							--DebugMessage(DumpTable(commentEntry))
							local commentElement = ScrollElement()
							commentElement:AddImage(6,3,"BasicWindow_Panel",540,65,"Sliced")
							commentElement:AddLabel(10,8,"Author: "..commentEntry.Author,540,20,16)
							commentElement:AddLabel(10,8+18,"Date: "..commentEntry.Date,540,20,16)
							commentElement:AddLabel(10,8+18+18,"Comment: "..commentEntry.Comment,540,20,16)
							
							commentWindow:Add(commentElement)
						end
						local postElement = ScrollElement()
						postElement:AddImage(6,3,"BasicWindow_Panel",540,65,"Sliced")
						postElement:AddButton(490,23,"PostComment","Post",50,20,"Post a comment",nil,false,"")
						postElement:AddTextField(10,23, 485,21, "PostCommentField", "Type your comment here.")
						
						--DebugMessage("Here")
						commentWindow:Add(postElement)

						mainWindow:AddScrollWindow(commentWindow)
					end
				end
			end
			mainWindow:AddScrollWindow(notesWindow)
		else
			mainWindow:AddLabel(400,200,"No postings in this section.",500,100,20,"center")
		end
	else
		mainWindow:AddLabel(400,200,"This message board has no postings!",500,100,20,"center")
	end
	user:OpenDynamicWindow(mainWindow,this)
end

--[[local stripped, color = StripColorFromString(newName)
if(stripped:len() > 20) then
	newName = stripped:sub(0,20)
	if(color ~= nil) then
		newName = color .. newName .. "[-]"
	end
end--]]
MAX_SEARCH_RESULTS = 7
function ShowSearchWindow(user)
	TextFieldDialog.Show{
        TargetUser = user,
        ResponseObj = this,
        Title = "Search tags and notes for string:",
        Description = "Maximum 20 characters",
        ResponseFunc = function(user,searchStr)
        	if(searchStr == "" or searchStr == nil) then
        		user:SystemMessage("Invalid search. Try again.")
        		return
        	end
        	
        	local myNotes = mBoard:GetContainedObjects()
        	local noteText = ""
        	local noteTags = ""
        	local noteSearchEntry = {}
        	for index,note in pairs(myNotes) do
        		noteText = note:GetObjVar("ScrollContents") or ""
        		noteTags = note:GetObjVar("Tags") or ""
        		--DebugMessage("note text is "..tostring(noteText))
        		--DebugMessage("noteTags is "..tostring(noteTags))
        		local _, count = string.gsub(noteText, searchStr, "")
        		--DebugMessage("Count is "..tostring(count))
        		local _, tagCount = string.gsub(noteTags, searchStr, "")
        		--DebugMessage("tagCount is "..tostring(tagCount))
        		if (count > 0 or tagCount > 0) then
	        		local result = {}
	        		result.note = note
	        		result.count = count + tagCount
	        		result.title = note:GetObjVar("Title") or "<Untitled>"
	        		table.insert(noteSearchEntry,result)
	        	end
	        	if (#noteSearchEntry > MAX_SEARCH_RESULTS) then break end
        	end
        	--DebugMessage("Dumping noteSearchEntry once")
        	--DebugMessage(DumpTable(noteSearchEntry))
			table.sort(noteSearchEntry,function(a,b) return (a.count or 0) < (b.count or 0) end)
			local searchResults = {}
        	--DebugMessage("Dumping noteSearchEntry twice")
			--DebugMessage(DumpTable(noteSearchEntry))
			for i,j in pairs(noteSearchEntry) do
				searchResults[i] = j.title .. " "..j.count.." matches."
			end
        	--DebugMessage("Dumping search results")
			--DebugMessage(DumpTable(searchResults))
			if (#searchResults == 0) then
				this:SystemMessage("No search results found.")
			end
			mButtonIds = noteSearchEntry
			ButtonMenu.Show{
	        	TargetUser = this,
		        DialogId = "SearchResults",
		        TitleStr = "Search Results: "..tostring(#noteSearchEntry or 0).." results found.",
		        Buttons = searchResults,
		        ResponseFunc = function(users,buttonResult) 
		        	mSelectedNote = mButtonIds[buttonResult].note
		        	mCurrentSection = mSelectedNote:GetObjVar("Section") or "Other"
		        	ShowMessageBoard(user)
		        end,
		    } 
        end
    }
end

mPostTitle = "Type the title of your post here."
mPostTags = "Example: items,gold,bounty,reward"

function ShowPostNoteWindow(user)
	local mainWindow = DynamicWindow("PostMessage","Post to the board",720,300,-200,0,"","Center")
	mainWindow:AddLabel(350,0,"Add a title to the note you're going to post.",500,20,20,"center")
	mainWindow:AddTextField(250,25, 210,21, "PostTitle", mPostTitle)
	mainWindow:AddLabel(350,50,"[$1938]",500,40,20,"center")
	mainWindow:AddTextField(120,94, 460,42, "PostTags", mPostTags)
	mainWindow:AddLabel(350,145,"[$1939]",500,20,20,"center")
	local count = 0
	for i,j in pairs(Sections) do			
		local buttonState = (mPostSection == j.Id) and "pressed" or ""
		mainWindow:AddButton(40+count*BUTTON_SIZE,170,"ChoseSection|"..j.Id,j.DisplayName,200,26,"",nil,false,"List",buttonState)
		count = count + 1
	end
	mainWindow:AddButton(290,210,"PostToBoard","Post Note",120,0,"",nil,true)
	user:OpenDynamicWindow(mainWindow,this)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"MessageBoard",
function (user,buttonId,buttonFields)
	if (user == nil or not user:IsValid()) then
		return
	end
	if (buttonId == nil or buttonId == "") then
		return
	end

	local newTab = HandleTabMenuResponse(buttonId)
	if(newTab) then
		mCurrentSection = newTab
		ShowMessageBoard(user)		
		return
	end

	local blah = StringSplit(buttonId,"|")
	buttonId = blah[1]
	local index = blah[2]
	--DebugMessage(user,buttonId,index)
	if (buttonId == "Delete") then
		user:SystemMessage("[D70000]Post removed!!![-]")
		mSelectedNote:Destroy()
	end
	if (buttonId == "Post") then
		user:RequestClientTargetGameObj(this,"PostNote")
		local backpack = user:GetEquippedObject("Backpack")
		backpack:SendOpenContainer(user)
		user:SystemMessage("Select the note you would like to post.")
	end
	if (buttonId == "Search") then
		ShowSearchWindow(user)
	end
	if (buttonId == "PostComment") then
		local myNotes = mBoard:GetContainedObjects()
		for i,j in pairs(myNotes) do
			if (j == mSelectedNote) then
				local comments = j:GetObjVar("CommentTable") or {}
				local result = {Author=user:GetName(),Date=os.date(),Comment=buttonFields.PostCommentField}
				table.insert(comments,result)
				j:SetObjVar("CommentTable",comments)
			end
		end
	end
	if (buttonId == "MapMarker") then
		user:SystemMessage("[$1935]")
		AddMapMarker(user,{Icon="marker_diamond1", Location=mSelectedNote:GetObjVar("MapMarker"), Map=mSelectedNote:GetObjVar("Region"), Tooltip=mSelectedNote:GetName().."'s' Location"},"NoteMapMarker"..mSelectedNote.Id)
	end
	if (buttonId == "Note") then
		mSelectedNote = GameObj(tonumber(blah[2]))
	end
	
	ShowMessageBoard(user)
end)

BUTTON_SIZE = 210
RegisterEventHandler(EventType.ClientTargetGameObjResponse, "PostNote", 
	function (target,user)
		if ((target == nil) or not target:IsValid()) then return end
		mMessageToPost = target
		--DebugMessage("Arriving")
		if (not target:HasObjVar("ScrollContents") or not target:HasObjVar("Rewriteable")) then
			user:SystemMessage("[$1936]")
			return
		end
		if (target:GetObjVar("ScrollContents") == "") then
			user:SystemMessage("[$1937]")
			return
		end
		ShowPostNoteWindow(user)
	end)

RegisterEventHandler(EventType.DynamicWindowResponse,"PostMessage",
function(user,buttonId,buttonFields)
	if (user == nil or not user:IsValid()) then
		return
	end

	if(buttonId ~= nil and buttonId ~= "") then
		mPostTags = buttonFields.PostTags
		mPostTitle = buttonFields.PostTitle
		if (buttonId == "PostToBoard" and mMessageToPost ~= nil ) then
			if (buttonId == "" or buttonId == nil) then
				return
			end
			if (buttonId == "Cancel") then
				return
			end
			if (mPostTitle:len() > 28) then
				this:SystemMessage("[$1940]")
				return
			end
			if (mPostTags:len() > 250) then
				this:SystemMessage("[$1941]")
				return
			end

			mMessageToPost:SetObjVar("Title",mPostTitle)
			mMessageToPost:SetObjVar("Tags",mPostTags)
			mMessageToPost:SetObjVar("Section",mPostSection)
			mMessageToPost:SetObjVar("AuthorName",this:GetName())
			mMessageToPost:SetObjVar("Author",this)
            Decay(mMessageToPost, 60*60*24*5)
			this:SystemMessage("Post will be removed in 5 days.")
			local randomLoc = GetRandomDropPosition(mBoard)
			mMessageToPost:MoveToContainer(mBoard,randomLoc)
			return
		end
		local args = StringSplit(buttonId,"|")
		if (args[1] == "ChoseSection") then
			local sectionData = GetSectionById(args[2])
			local sectionRestriction = sectionData.Restriction
			local passRestriction = true
			if (not IsImmortal(user)) then
				if (sectionRestriction == "Immortal") then
					passRestriction = false
				end
				if (sectionRestriction == "HouseOwner") then
					if (HasHouseAtLoc(mBoard:GetLoc())) then
						if not IsHouseOwnerForLoc(user,mBoard:GetLoc()) then
							passRestriction = false
						end
					end
				end	
			else
			 	passRestriction = true
			end
			if (passRestriction) then
				mPostSection = sectionData.Id
				this:SystemMessage("Chose "..sectionData.DisplayName.." as the post's section")
				ShowPostNoteWindow(user)
			else
				this:SystemMessage("[$1942]")
			end
		end
	end
end)

function IsBoardOwner(user)
	if (IsImmortal(user)) then return true end

	if (HasHouseAtLoc(mBoard:GetLoc())) then
		if IsHouseOwnerForLoc(user,mBoard:GetLoc()) then
			return true
		end
	end
	return false
end

RegisterEventHandler(EventType.Message,"StartMessageBoard",function (newBoard,newSections)
	--DebugMessage("Recieved Sections")
	if (newSections ~= nil) then
		Sections = newSections 
	end
	--DebugMessage(DumpTable(newSections))
	mBoard = newBoard
	ShowMessageBoard(this)
end)

function CleanUp()
	this:CloseDynamicWindow("PostMessage")
	this:CloseDynamicWindow("MessageBoard")
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.StartMoving,"",function ( ... )
	CleanUp()
end)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),function ( ... )
	ShowMessageBoard(this)
end)