mAmount = 0

mDurationMinutes = 2

mBuffed = false

function HandleLoaded()
	DebugMessage("Potection fired")
end 

function CleanUp()
	-- SetMobileMod(this, "AgilityPlus", "SpellAgile", nil)
	-- this:SystemMessage("Agility has worn off, decreasing your agility by " .. mAmount, "event")
	-- RemoveBuffIcon(this, "WeakenSpellBuff")
	-- mAmount = 0
	-- this:DelModule(GetCurrentModule())
end

RegisterEventHandler(
	EventType.Timer,
	"SpellAgileBonusTimer",
	function()
		CleanUp()
	end
)

RegisterEventHandler(
	EventType.Message,
	"SpellHitEffectsp_protection_effect",
	function(caster)
		HandleLoaded()
	end
)
