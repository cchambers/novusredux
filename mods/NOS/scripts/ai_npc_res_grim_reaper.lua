require 'NOS:incl_combat_abilities'
require 'NOS:incl_magic_sys'

this:SetCloak(true)
this:SetObjVar("VisibleToDeadOnly",true)

RegisterEventHandler(EventType.Message, "UseObject", 
	function (user,usedType)
		if(usedType ~= "Interact") then return end
		if(not IsDead(user)) then return end
		FaceObject(this,user)

		local text = "[$1227]"
		local response = {
			--{text="I'm ready to go to the Void.",handle="DeleteChar"},
			{text="I wish to rejoin the living.",handle="AnotherChance"},
			{text="I have some questions for you.",handle="Dialog"},
			{text="I don't need your help.",handle=""},
		}
		NPCInteraction(text,this,user,"InteractionWindow",response)							
	end)

RegisterEventHandler(EventType.DynamicWindowResponse, "InteractionWindow",
	function (user,buttonId)
		if (buttonId == "AnotherChance") then
			local text = "[$1228]"
			local response = {
					{text="Yes, I accept the penalty.",handle="RestoreCharacter"},
					{text="Nope. Nevermind.",handle=""},
				}
			NPCInteraction(text,this,user,"InteractionWindow",response)	
		end
		if (buttonId == "Dialog") then
			local text = "[$1229]"
			local response = {
				{text="Why do you do this?",handle="WhyDoThis"},
				{text="What did I do wrong?",handle="DoWrong"},
				{text="What is your relation to Kho?",handle="Kho"},
				{text="I would like to help you.",handle="HelpDeath"},
				{text="I'm done here.",handle=""},
			}
			NPCInteraction(text,this,user,"InteractionWindow",response)		
		end
		if (buttonId == "Kho") then
			QuickDialogMessage(this,user,"[$1230]")
		end
		if (buttonId == "HelpDeath") then
			QuickDialogMessage(this,user,"[$1231]")
		end
		if (buttonId == "DoWrong") then
			QuickDialogMessage(this,user,"[$1232]")
		end
		if (buttonId == "WhyDoThis") then
			QuickDialogMessage(this,user,"[$1233]")
		end
		if (buttonId == "RestoreCharacter") then
			user:SendMessage("PlayerResurrect",this,nil,true)			
			user:AddModule("death_res_effect")

			this:DelObjVar("Target")
			local nearbyPlayers = FindObjects(SearchMulti({SearchPlayerInRange(30),SearchObjVar("IsDead",true)}))
			if (#nearbyPlayers <= 1) then
				this:Destroy()
			end
			--DFB HACK: Hack to force an object update so he doesn't stay cloaked.
			CallFunctionDelayed(TimeSpan.FromSeconds(1),function( ... )				
				this:PathTo(this:GetLoc():Project(this:GetFacing(),1),1.0,"ForceObjectUpdateHack")
			end)
			--this:Destroy()
		end
	end)

--Simplest AI ever.
this:SetSharedObjectProperty("CombatMode",true)
this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"AnnoyPlayer")
RegisterEventHandler(EventType.Timer,"AnnoyPlayer",function ()
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1 + math.random()),"AnnoyPlayer")
	if this:GetObjVar("Target") == nil or not this:GetObjVar("Target"):IsValid() then
		local nearbyPlayersThatAreDead = FindObjects(SearchMulti({SearchHasObjVar("IsGhost"),SearchPlayerInRange(30)}))
		if (#nearbyPlayersThatAreDead > 0) then
			this:SetObjVar("Target",nearbyPlayersThatAreDead[1]) 
		else
			this:Destroy()
		end
		return
	end
	if (this:DistanceFrom(this:GetObjVar("Target")) > 30) then return end
	FaceObject(this,this:GetObjVar("Target"))
	if (math.random(1,5) == 1) then
		this:PathToTarget(this:GetObjVar("Target"),3.0,4.0)
		this:SetSharedObjectProperty("CombatMode",true)
	end
end)
this:PlayEffect("DarkEnergySpawnEffect")

this:ScheduleTimerDelay(TimeSpan.FromSeconds(4.0),"VoidAura")
RegisterEventHandler(EventType.Timer,"VoidAura",function()
  this:PlayEffect("VoidAuraEffect",6)
  this:ScheduleTimerDelay(TimeSpan.FromSeconds(4.0),"VoidAura")
end)
this:FireTimer("VoidAura")
