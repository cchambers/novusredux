
ClubTracks = {
	{
		Length = 39 + 60*8, -- two minutes long
		DisplayName = "Cosmic Gate",
		MusicName = "CosmicGate",
	},
	{
		Length = 22 + 60*6, -- two minutes long
		DisplayName = "Energy Sound",
		MusicName = "EnergySound",
	},
	{
		Length = 32 + 60*5, -- two minutes long
		DisplayName = "Space Aura",
		MusicName = "SpaceAura",
	},
	{
		Length = 45 + 60*7, -- two minutes long
		DisplayName = "The Heavenly Envoy",
		MusicName = "TheHeavenlyEnvoy",
	},
	{
		Length = 1 + 60*3, -- two minutes long
		DisplayName = "Rise Again",
		MusicName = "RiseAgain",
	},
	{ 
		Length = 15.11,
		DisplayName = "None",
		MusicName = "ClubAmbience",
		Loop = true,
		Hide = true,
	},
}
 
function GetRandomTrack()
	local allTracks = {}
	for i,j in pairs(ClubTracks) do
		table.insert(allTracks,j.MusicName)
	end
	return allTracks[math.random(1,#allTracks)]
end

function GetTrackInfo(track)
	local trackToCheck = track or this:GetObjVar("CurrentTrack")
	for i,j in pairs(ClubTracks) do
		if (j.MusicName == trackToCheck) then
			return j
		end
	end
end

function CreateQueue()
	local Queue = {}
	this:SetObjVar("Queue",Queue)
	this:SetObjVar("QueueFirst",0)
	this:SetObjVar("QueueLast",0)
end

function AddTrackToQueue(trackName)
	local Queue = this:GetObjVar("Queue") 
	local last = this:GetObjVar("QueueLast")
	last = last + 1
	Queue[last] = trackName
	this:SetObjVar("Queue",Queue)
	this:SetObjVar("QueueLast",last)
end

function PlayNextQueueItem()
	--DebugMessage(1)
	local Queue = this:GetObjVar("Queue") 
	local last = this:GetObjVar("QueueLast")
	local first = this:GetObjVar("QueueFirst")
	if (last == first) then
		PlayTrack("ClubAmbience")
		return
	end
	first = first + 1
	PlayTrack(Queue[first])
	Queue[first] = nil
	this:SetObjVar("Queue",Queue)
	this:SetObjVar("QueueLast",last)
	this:SetObjVar("QueueFirst",first)
end

function GetTrack(trackName)
	for i,j in pairs(ClubTracks) do
		if (j.MusicName == trackName) then
			return j
		end
	end
end

function PlayTrack(trackName)
	--DebugMessage(trackName.. " is trackName")
	
	local players = {}
	if (GetRegion("FoundersArea")) == nil then
		players = FindObjects(SearchPlayerInRange(15))
	else
		players = FindPlayersInGameRegion("FoundersArea")
	end
	--DebugMessage("PLAYERS:"..DumpTable(players))
	local track = GetTrack(trackName)
	
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(track.Length),"PlayNextTrack")	

	if(not(track.Loop) or (trackName ~= this:GetObjVar("CurrentTrack"))) then
		for n,k in pairs(players) do
			--DebugMessage(1,"C")
			k:PlayMusic(trackName,0,1.0)
			--DebugMessage(1.5,"trackName is "..tostring(trackName))
		end		
	end

	this:SetObjVar("CurrentTrack",trackName)
end

function HandleEnterHearingRange(player)
	local trackTime = GetCurrentTrackTime()
	--DebugMessage(1,"B")
	player:PlayMusic(this:GetObjVar("CurrentTrack"),trackTime,1.0)
end
function HandleExitHearingRange(player)
	local trackTime = GetCurrentTrackTime()
	--DebugMessage(1,"B")
	player:PlayMusic(this:GetObjVar("CurrentTrack"),trackTime,0.3)
end

function GetCurrentTrackTime()
	--DebugMessage(2)
	local timerDelay = this:GetTimerDelay("PlayNextTrack") or TimeSpan.FromSeconds(0)
	--DebugMessage("CurrentTrack"..tostring(this:GetObjVar("CurrentTrack")))
	local trackInfo = GetTrackInfo(this:GetObjVar("CurrentTrack")) 
	return trackInfo.Length - timerDelay.TotalSeconds
end

 function ShowJukeboxWindow(user,selectedTrack)
    local newWindow = DynamicWindow("JukeBoxWindow","Jukebox",440,310)

    selectedTrack = selectedTrack or "CosmicGate"
 	local currentTrackInfo = GetTrackInfo(this:GetObjVar("CurrentTrack"))
 	local trackDisplayName = currentTrackInfo.DisplayName
    newWindow:AddLabel(20, 10, "[F3F781]Currently Playing: [-]"..(trackDisplayName or ""),600,0,18,"left",false)
    newWindow:AddLabel(20, 225, "Cost to play: [F3F781]"..(this:GetObjVar("QueueCost") or "[-]"),600,0,18,"left",false)

    --newWindow:AddButton(320, 10, "Refresh", "Refresh", 80, 23, "", "", false,"")
 
 
    --newWindow:AddLabel(20, 100, "[F3F781]Behaviors:[-]",0,0,18,"left",true)
    newWindow:AddImage(20,75-45,"DropHeaderBackground",380,185,"Sliced")
 
    local scrollWindow = ScrollWindow(25,81-45,355,160,25)
    for i,trackData in pairs(ClubTracks) do
    	if (not trackData.Hide) then
	        scrollElement = ScrollElement()
	        if((i-1) % 2 == 1) then
	       	 	scrollElement:AddImage(0,0,"Blank",330,25,"Sliced","1A1C2B")
	        end    
			local pressed = ""
			if(trackData.MusicName == selectedTrack) then
				pressed = "pressed"
			end
			scrollElement:AddButton(320, 0, "select|"..trackData.MusicName, "", 0, 18, "", "", false, "Selection",pressed)
	        scrollElement:AddLabel(5, 4, trackData.DisplayName,0,0,18,"left")
	        scrollWindow:Add(scrollElement)
	    end
    end
       
    newWindow:AddScrollWindow(scrollWindow)
    newWindow:AddButton(270, 270-45, "play|"..selectedTrack, "Play", 110, 23, "", "", true,"")
       
 
    user:OpenDynamicWindow(newWindow,this)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"JukeBoxWindow",function (user,returnId)
	--DebugMessage(0)
	if (not user:IsValid()) then return end
	if (returnId == "") then return end
	--DebugMessage(1)
	local action = StringSplit(returnId,"|")[1]
	local track = StringSplit(returnId,"|")[2]
	if (action == "play") then
		local trackInfo = GetTrackInfo(track)
		ClientDialog.Show{
			    TargetUser = user,
			    TitleStr = "Confirm Queue",
			    DescStr = "Do you wish to queue the song "..tostring(trackInfo.DisplayName).."? [D7D700]"..this:GetObjVar("QueueCost").." Copper)",
			    Button1Str = "Confirm",
			    Button2Str = "Cancel",
			    ResponseObj = this,
			    ResponseFunc = function (user,buttonId)
    				RequestConsumeResource(user,"coins",this:GetObjVar("QueueCost"),"PlayCoins",this) 
					RegisterSingleEventHandler(EventType.Message, "ConsumeResourceResponse", 
					    function (success,transactionId,user)
        					if (transactionId == "PlayCoins") then
        						if (success) then 
        							--DebugMessage("Win")
									AddTrackToQueue(track)
									user:SystemMessage("[$1904]","info")
        						else
        							--DebugMessage("Fail")
        							user:SystemMessage("[D70000]You do not have enough money.[-]","info")
        							return
        						end
        					end
					    end)
					end,
			}
		--AddTrackToQueue(track)
		--user:SystemMessage("[$1905]")
	elseif (action == "select") then
		ShowJukeboxWindow(user,track)
	end
end)



RegisterEventHandler(EventType.Message,"UseObject",function (user,useType)
	if (useType ~= "Play") then return end
	local trackList = {}
	ShowJukeboxWindow(user)
end)

function OnLoad()
	CreateQueue()		
	if (not this:HasObjVar("QueueCost")) then this:SetObjVar("QueueCost",10) end
	AddUseCase(this,"Play",true)
	PlayNextQueueItem()
end

RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(), function ( ... )
	OnLoad()
end)

RegisterEventHandler(EventType.LoadedFromBackup,"",function ( ... )
	OnLoad()
end)

RegisterEventHandler(EventType.Timer,"PlayNextTrack",PlayNextQueueItem)

RegisterEventHandler(EventType.EnterView,"ClubDrone",function(user)
	--DebugMessage("Firing")
	if not(user:IsInRegion("FoundersArea")) then
		CallFunctionDelayed(TimeSpan.FromSeconds(2),function() HandleExitHearingRange(user) end)
	end
end)
RegisterEventHandler(EventType.LeaveView,"JukeBoxPlay",function(user)
	HandleExitHearingRange(user)
end)
RegisterEventHandler(EventType.EnterView,"JukeBoxPlay",function(user)
	--DebugMessage("A")
	HandleEnterHearingRange(user)
end)

AddView("ClubDrone",SearchUser())

if (GetRegion("FoundersArea")) == nil then
	AddView("JukeBoxPlay",SearchPlayerInRange(15))
else
	AddView("JukeBoxPlay",SearchMulti({SearchUser(),SearchRegion("FoundersArea",true)}))
end