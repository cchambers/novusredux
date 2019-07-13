require 'incl_faction'

-- DAB NOTE: This should be changed before alpha, for playtesters in pre-alpha we can speed this up
-- For now pulse the decay every 10 minutes and regain 10 faction each time
FACTION_DECAY_PULSE_FREQ_SECS = 10 * 60
FACTION_DECAY_AMOUNT_PER_PULSE = 10

local negativeFactionCount = 0

function FactionDecayPulse(internalName)
	local curFaction = GetFaction(this,internalName)
	local changeAmount = 0

	--DebugMessage("FactionDecayPulse",internalName,curFaction)

	if(curFaction < 0) then
		changeAmount = math.min(FACTION_DECAY_AMOUNT_PER_PULSE,-curFaction)
		--DebugMessage("Decaying",internalName,changeAmount)
		ChangeFactionByAmount(this,changeAmount,internalName)
	end

	if(curFaction + changeAmount >= 0) then
		--DebugMessage("Unregister",internalName,curFaction + changeAmount)
		UnregisterEventHandler("player_faction_decay",EventType.Timer,internalName.."Decay")
		negativeFactionCount = negativeFactionCount - 1

		if(negativeFactionCount == 0) then
			--DebugMessage("DelModule",internalName,negativeFactionCount)
			this:DelModule("player_faction_decay")
		end
	else
		CheckBindPoint(this,GetFactionFromInternalName(internalName),curFaction + changeAmount)
		
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(FACTION_DECAY_PULSE_FREQ_SECS),internalName.."Decay")
	end
end

function RegisterDecayPulse(internalName)
	--DebugMessage("ScheduleDecayPulse",internalName,negativeFactionCount)

	RegisterEventHandler(EventType.Timer,internalName.."Decay",
		function ( ... )
			FactionDecayPulse(internalName)
		end)

	if(not(this:HasTimer(internalName.."Decay"))) then 
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(FACTION_DECAY_PULSE_FREQ_SECS),internalName.."Decay")
	end

	negativeFactionCount = negativeFactionCount + 1
end

RegisterEventHandler(EventType.Message,"StartFactionDecay",
	function (internalName)
		RegisterDecayPulse(internalName)
	end)

-- when we load this module, register an eventhandler for every negative faction we currently have
for i, factionInfo in pairs(Factions) do
	local curFaction = GetFaction(this,factionInfo.InternalName)
	if(curFaction < 0) then
		RegisterDecayPulse(factionInfo.InternalName)
	end
end
