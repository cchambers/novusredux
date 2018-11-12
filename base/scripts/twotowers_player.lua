function GetController()
	return FindObjectWithTag("MapController")
end

function CleanUp()
	DebugMessage("twotowers_player CleanUp")
	this:DelObjVar("OverrideDeath")	
	this:DelObjVar("OverrideQuestWindow")
	this:SetObjVar("IsDead", false)		
	this:SendMessage("RemoveInvisEffect","twotowers_spectator")
end

function OnLoad()	
	DebugMessage("twotowers_player OnLoad")

	this:SetObjVar("OverrideDeath",true)
	this:SetObjVar("OverrideQuestWindow",true)
end

RegisterEventHandler(EventType.Message,"twotowers_spectator",
	function ( ... )
		DebugMessage("twotowers_player twotowers_spectator")

		this:SetObjVar("IsDead", true)		
		this:SendMessage("AddInvisEffect","twotowers_spectator")
	end)

RegisterEventHandler(EventType.Message,"twotowers_player",
	function ( ... )
		DebugMessage("twotowers_player twotowers_player")

		this:DelObjVar("IsDead")		
		this:SendMessage("RemoveInvisEffect","twotowers_spectator")
	end)

RegisterEventHandler(EventType.Message,"HasDiedMessage",
	function (killer)
		GetController():SendMessage("PlayerKilled",this,killer)
	end)

RegisterEventHandler(EventType.ModuleAttached,GetCurrentModule(),
	function ( ... )
		DebugMessage("twotowers_player ModuleAttached")

		if(IsDead(this)) then
			this:SendMessage("Resurrect",100,this,true)
		end

		OnLoad()
	end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ( ... )
		DebugMessage("twotowers_player LoadedFromBackup")

		if(GetWorldName() ~= "TwoTowers") then
			CleanUp()
		else 
			OnLoad()
		end
	end)

RegisterEventHandler(EventType.ClientUserCommand,"quest",
	function()
		GetController():SendMessage("ToggleScoreWindow",this)
	end)

if(IsImmortal(this)) then
	RegisterEventHandler(EventType.ClientUserCommand,"start",
		function(gameType)
			GetController():SendMessage("StartMatch",gameType)
		end)
end