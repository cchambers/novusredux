
local guideObj = nil
local queuedEvent = nil
local isDismissing = false

function IsGuideSummoned()
	return guideObj and not(guideObj:ContainedBy())
end

function InitializeGuide()
	guideObj = this:GetObjVar("MagicalGuideObj")
	if not(guideObj) or not(guideObj:IsValid()) then
		local spawnLoc = GetNearbyPassableLoc(this,360,2,4)
		CreateObj("npe_magical_guide",spawnLoc,"guide_created",this)
	end
end

function OnNPELoad()
	if( (this:GetObjVar("InitiateMinutes") or 0) < 1 ) then
		this:DelModule("npe_player")
		return false
	end

	InitializeGuide()	
end

function DoTriggerMessage(eventId,messageIndex)
	if(this:HasTimer("MessageExtended")) then
		this:RemoveTimer("MessageExtended")
	end

	messageIndex = messageIndex or 1

	local eventData = MagicalGuideEvents[eventId]
	guideObj:NpcSpeechToUser(eventData.Messages[messageIndex],this,"event")
	guideObj:SendMessage("RefreshAutoDimissTimer")
	if(#eventData.Messages > messageIndex) then
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(4),"MessageExtended",eventId,messageIndex+1)
	end
end
RegisterEventHandler(EventType.Timer,"MessageExtended", function(...) DoTriggerMessage(...)	end)

function DoEventTrigger(eventId,eventLoc)
	if not(IsGuideSummoned()) then
		eventLoc = eventLoc or this:GetLoc()
		queuedEvent = { Id = eventId, Loc = eventLoc, Time = DateTime.UtcNow }

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"CheckQueuedEvent")
	else
		DoTriggerMessage(eventId)
	end
end

function DoQueuedEvent()
	if(IsGuideSummoned() and not(isDismissing) and queuedEvent) then 
		DoEventTrigger(queuedEvent.Id)
	end
	queuedEvent = nil
end

RegisterEventHandler(EventType.Message,"DoGuideEvent",
	function (eventId,eventLoc)
		DoEventTrigger(eventId,eventLoc)
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ( ... )
		OnNPELoad()
	end)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ( ... )		
		OnNPELoad()
	end)

RegisterEventHandler(EventType.Message,"UITutorialComplete",
	function ( ... )
		if not(this:HasObjVar("NewbieWelcomeComplete")) then
			local dialogTitle = "Where am I?"
			local dialogText = "You awaken to find yourself in the strangest of places. You have no memory of how you got here. Or even of who you were in your former life. All you can remember is a blinding flash of light... and your own name. \n"
			local response = {{text="Ok.",handle="Ok"}}
			NPCInteraction(dialogText,nil,this,"NewbieWelcome",response,dialogTitle)		

			--GW HACK Live doesn't like the hotbar flow on initial login for somereason.
			CallFunctionDelayed(TimeSpan.FromSeconds(2.5),
				function()		
					UpdateHotbar(this)
				end)

			this:SetObjVar("NewbieWelcomeComplete",true)
		end
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "NewbieWelcome",
	function ( ... )
		if(IsGuideSummoned()) then
			guideObj:SendMessage("Welcome")
		end
		this:CloseDynamicWindow("NewbieWelcome")
	end)

RegisterEventHandler(EventType.CreatedObject, "guide_created",
	function (success,objRef)
		if(success) then
			guideObj = objRef
			guideObj:SendMessage("SetOwner",this)
			this:SetObjVar("MagicalGuideObj",guideObj)
		end
	end)

RegisterEventHandler(EventType.Timer,"CheckQueuedEvent",
	function ()
		if((DateTime.UtcNow - queuedEvent.Time > ServerSettings.NewPlayer.MagicalGuideEventTimeout)
				or (this:GetLoc():Distance(queuedEvent.Loc) > ServerSettings.NewPlayer.MagicalGuideEventMaxDistance)) then
			queuedEvent = nil
		else
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"CheckQueuedEvent")
		end
	end)

RegisterEventHandler(EventType.EnterView,"WorldTriggerView",
	function (targetObj)
		local eventId = targetObj:GetObjVar("GuideEventId")		
		
		DoEventTrigger(eventId,targetObj:GetLoc())
	end)

function EndNPE()	
	RemoveDynamicMapMarker(this,"GuideWaypoint")

	this:DelObjVar("InitiateMinutes")
	
	UpdateHotbar(this)

	guideObj:Destroy()
	this:DelObjVar("MagicalGuideObj")
	this:CloseDynamicWindow("GuideButton")

	this:SendMessage("UpdateName")

	this:DelModule("npe_player")
end

RegisterEventHandler(EventType.Message,"SetGuideWaypoint",
	function (user,waypointName,waypointLoc,waypointObj)
		local mapMarker = {Map="NewCelador", Icon="marker_circle1", Location=waypointLoc, Obj=waypointObj, Tooltip=waypointName, RemoveDistance=5}
		AddDynamicMapMarker(user,mapMarker,"GuideWaypoint")
		user:FireTimer("UpdateMapMarkers")
	end)

RegisterEventHandler(EventType.Message,"EndNPE",
	function ( ... )
        ClientDialog.Show{
            TargetUser = this,
            DialogId = "InitiateExpired",
            TitleStr = "Protection Expired",
            DescStr = "[$1945]",
            Button1Str = "Ok",
        }        

		isDismissing = true

		CallFunctionDelayed(TimeSpan.FromSeconds(2),function()
			EndNPE()
		end)	
	end)

RegisterEventHandler(EventType.ClientUserCommand, "Guide",
	function ()
		if(isDismissing) then return end 

		if(IsGuideSummoned()) then
			guideObj:SendMessage("Interact")
		else
			guideObj:SendMessage("Summon")	
			guideObj:SendMessage("Interact")
			if(queuedEvent) then
				this:RemoveTimer("CheckQueuedEvent")
				CallFunctionDelayed(TimeSpan.FromSeconds(1),
				function() 
					DoQueuedEvent()							
				end)
			end
		end
	end)

-- we put the view on the player because we want it to fire even when the guide is dismissed
AddView("WorldTriggerView",SearchHasObjVar("GuideEventId",5))

this:RemoveTimer("CheckQueuedEvent")