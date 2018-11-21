require 'base_ai_settings'
require 'base_ai_state_machine'

local bonesForRitual = 10

AI.Settings.ShouldSleep = false

PropPermObjects = {
	PortalAnimation = nil,
	BonePile = nil
}

portalObj = nil

local bonesCollected = 0

function UpdateBones()
	local percentComplete = bonesCollected / bonesForRitual 
	if(percentComplete >= 1.0) then
		PropPermObjects.BonePile:SetVisualState("Large")
	elseif(percentComplete > 0.5) then
		PropPermObjects.BonePile:SetVisualState("Medium")
	elseif(bonesCollected > 0) then
		PropPermObjects.BonePile:SetVisualState("Default")
	else
		PropPermObjects.BonePile:SetVisualState("Hidden")
	end

	if(bonesCollected >= bonesForRitual) then
		AI.StateMachine.ChangeState("WaitingForTokens")
	end
end

AI.StateMachine.AllStates = {	
	Inactive = {		
		OnEnterState = function(self)
			if(portalObj ~= nil and portalObj:IsValid()) then
				portalObj:Destroy()
				portalObj = nil
			end
			--DebugMessage("HIDE "..tostring(PropPermObjects.BonePile).." "..tostring(PropPermObjects.PortalAnimation))
			PropPermObjects.BonePile:SetVisualState("Hidden")
			PropPermObjects.PortalAnimation:SetVisualState("Hidden")

			this:DelObjVar("CatacombsPortalActive")

			AddView("Bones",SearchObjVar("ResourceType","Bones",1),1)
			RegisterEventHandler(EventType.EnterView,"Bones",
				function(targetObj)
					bonesCollected = bonesCollected + GetStackCount(targetObj)
					targetObj:Destroy()
					UpdateBones()
				end)
		end,

		OnExitState = function(self)
			UnregisterEventHandler("catacombs_portal_controller",EventType.EnterView,"Bones")
			UnregisterEventHandler("catacombs_portal_controller",EventType.LeaveView,"Bones")
			DelView("Bones")
		end,
	},

	WaitingForTokens = {
		GetPulseFrequencyMS = function() return 2500 end,

		OnEnterState = function(self)						
			PropPermObjects.PortalAnimation:SetVisualState("Default")			

			self:AiPulse()
		end,

		AiPulse = function(self)	
			if(bonesCollected < bonesForRitual) then
				AI.StateMachine.ChangeState("Inactive")
				return
			end

			local contemptObj = nil
			local deceptionObj = nil
			local pestilenceObj = nil

			local objsOnAltar = FindObjects(SearchRange(this:GetLoc(),5))
			for i,obj in pairs(objsOnAltar) do 
				if(obj:GetCreationTemplateId() == "deception_skull") then
					contemptObj = obj
				elseif(obj:GetCreationTemplateId() == "ruin_skull") then
					deceptionObj = obj
				elseif(obj:GetCreationTemplateId() == "contempt_skull") then
					pestilenceObj = obj
				end
			end

			if(contemptObj and deceptionObj and pestilenceObj) then
				AI.StateMachine.ChangeState("PortalActive")
				contemptObj:Destroy()					
				deceptionObj:Destroy()				
				pestilenceObj:Destroy()
			end
		end,

		OnExitState = function(self,newState)			
			this:StopEffect("RadiationAuraEffect")
		end
	},

	PortalActive = {
		--GetPulseFrequencyMS = function() return 4 * 60 * 60 * 1000 end,

		OnEnterState = function(self)
		    local sendto = GetRegionAddressesForName("Catacombs")
		    if(#sendto == 0) then
		    	DebugMessage("Error unable to find Catacombs")
				return
			end

			MessageRemoteClusterController(sendto[1], "Reset")

			CallFunctionDelayed(TimeSpan.FromSeconds(8),function ( ... )
				this:PlayEffect("RedCoreImpactWaveEffect")		
				this:SetObjVar("CatacombsPortalActive",true)
				RegisterSingleEventHandler(EventType.CreatedObject,"portal",
					function(success,objRef)
						portalObj = objRef
						local catacombsHubLoc = MapLocations.Catacombs.Hub
					
						objRef:SetObjVar("Destination",catacombsHubLoc)
						objRef:SetObjVar("RegionAddress","Catacombs")
						objRef:SetName("Mysterious Portal")
						objRef:SetColor("FF0000")

						AddView("ActivePortal",SearchSingleObject(objRef),1000)
						RegisterEventHandler(EventType.LeaveView,"ActivePortal",
							function()
								AI.StateMachine.ChangeState("Inactive")
							end)
					end)

				CreateTempObj("portal_red",this:GetLoc(),"portal")
			end)
		end,

		--AiPulse = function(self)
		--	AI.StateMachine.ChangeState("Inactive")
		--end
	}
}

function OnLoad()
	local searchResults = FindPermanentObjects(PermanentObjSearchHasObjectTag("Catacombs Portal Animation"))
	if(#searchResults > 0) then
		PropPermObjects.PortalAnimation = searchResults[1]
	end
	searchResults = FindPermanentObjects(PermanentObjSearchHasObjectTag("Catacombs Portal Bone Pile"))	
	if(#searchResults > 0) then
		PropPermObjects.BonePile = searchResults[1]
	end

	AI.StateMachine.Init("Inactive")
end


function OnClose()
	this:PlayEffect("DeathwaveEffect")		
	this:PlayEffect("RedCoreImpactWaveEffect")		
	AI.StateMachine.ChangeState("Inactive")
end


RegisterSingleEventHandler(EventType.ModuleAttached,"catacombs_portal_controller",OnLoad)
RegisterSingleEventHandler(EventType.LoadedFromBackup,"",OnLoad)
RegisterEventHandler(EventType.Message,"close_catacombs_portal",OnClose)



