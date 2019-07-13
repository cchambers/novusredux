require 'NOS:incl_magic_sys'
CLOAK_DURATION = 30

function EndEffect()
	-- del buff icon.
	RemoveBuffIcon(this,"CloakSpell")

	-- do the actual 'reveal'
	this:SendMessage("RemoveInvisEffect", "sp_cloak_effect")
	this:SystemMessage("The cloak effect has ended.", "info")

	-- unregister our event handlers.
	UnregisterEventHandler("sp_cloak_effect", EventType.Message, "HasDiedMessage")
	UnregisterEventHandler("sp_cloak_effect", EventType.Message, "BreakInvisEffect")
	UnregisterEventHandler("sp_cloak_effect", EventType.Message, "DamageInflicted")
	UnregisterEventHandler("sp_cloak_effect", EventType.Timer, "CloakTimer")
	UnregisterEventHandler("sp_cloak_effect", EventType.StartMoving, "")

	-- get rid of this module, no longer needed.
	this:DelModule("sp_cloak_effect")
end

RegisterSingleEventHandler(EventType.ModuleAttached, "sp_cloak_effect", 
	function()
		-- prevent players griefing by cloaking the banker..dem jerks..
		local huntersMark = HasMobileEffect(this, "HuntersMark")
		local canCloak = not(this:IsMoving()) and (IsPlayerCharacter(this) or IsPet(this)) and not huntersMark
		if not( canCloak ) then
			if ( huntersMark ) then
				self.ParentObj:SystemMessage("You are revealed and cannot hide cloak now.", "info")
			end
			-- can't detach in the same frame as attach.
			CallFunctionDelayed(TimeSpan.FromSeconds(0.001), function()
				this:DelModule("sp_cloak_effect")
			end)

			return
		end
		-- register all the event handlers we'll need for a successful cloak.
		RegisterEventHandlers()

		-- make them invisible through the 'stacking effect' for invis.
		this:SendMessage("AddInvisEffect", "sp_cloak_effect")

		-- end invis in the given time.
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(CLOAK_DURATION), "CloakTimer")

		AddBuffIcon(this, "CloakSpell", "Cloaked", "cloak", "Invisible to all!", true)
	end)

-- done through a function to prevent registering handlers on a return out of ModuleAttached.
function RegisterEventHandlers()
	RegisterEventHandler(EventType.Message, "HasDiedMessage", 
		function()
			EndEffect()
		end)

	RegisterEventHandler(EventType.Message, "BreakInvisEffect", 
		function()
			EndEffect()
		end)

	RegisterEventHandler(EventType.Timer, "CloakTimer", 
		function()
			EndEffect()
		end)

	RegisterEventHandler(EventType.Message, "DamageInflicted", 
		function()
			EndEffect()
		end)

	RegisterEventHandler(EventType.StartMoving, "",
		function()
			EndEffect()
		end)
end

RegisterEventHandler(EventType.LoadedFromBackup, "", function()
        if ( this:HasModule("sp_cloak_effect") ) then
          	RegisterEventHandlers()
          	this:SendMessage("AddInvisEffect", "sp_cloak_effect")
			-- end invis in the given time.
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(CLOAK_DURATION), "CloakTimer")
			AddBuffIcon(this, "CloakSpell", "Cloaked", "cloak", "Invisible to all!", true)
        end
    end)