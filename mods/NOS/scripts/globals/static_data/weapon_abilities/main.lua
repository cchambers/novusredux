
WeaponAbilitiesData = {}

require 'NOS:globals.static_data.weapon_abilities.weapons'
require 'NOS:globals.static_data.weapon_abilities.bows'
require 'NOS:globals.static_data.weapon_abilities.shields'
require 'NOS:globals.static_data.weapon_abilities.npc'
require 'NOS:globals.static_data.weapon_abilities.skills'
require 'NOS:globals.static_data.weapon_abilities.tools'


--[[  all possible options

		MobileEffect = "EFFECTNAME", -- apply this effect to the mobile performing ability.
		MobileEffectArgs = {
			Duration = TimeSpan.FromSeconds(1), -- each mobile effect's args are different (some don't have any)
		},
		TargetMobileEffect = "EFFECTNAME", -- apply this effect to the TARGET of the mobile performing ability.
		TargetMobileEffectArgs = {
			Duration = TimeSpan.FromSeconds(1),
		},
		CombatMods = { -- some MobileMods are also CombatMods, since MobileMods works inside the local VM space (base_mobile.lua),
						-- these values cannot be accessed outside the Lua module.
						-- CombatMods work near identical; but not every MobileMod is available, CombatMods don't update stats, and they are only useable inside combat.lua VM.
						-- This 'mirrored' functionality let's us apply some MobileMods to a single, specific, weapon swing, without the costly, async nature of recalculating an entire stat.
			--CombatModType = value,
			AttackTimes = 0.4, -- to give +40% attack on a swing, for example.
		},
		Action = { -- base for the action button that goes on action bar
			DisplayName = "SOMENAME",
			Tooltip = "SOMEDESCRIPTION",
			Icon = "Fireball",
			Enabled = true
		},
		Stamina = 100, -- set to 0 if no stamina is required, defaults to 100. amount of stamina required to perform.
		SkipHitAction = true, -- (optional) for queued weapon abilities, when this is true, the normal hit actions will be bypassed. This allows queued weapon abilities to bypass normal weapon damage.

		Instant = true, -- (optional)
		-- options if instant is true
		NoTarget = true, -- (optional)
		Cooldown = TimeSpan.FromSeconds(4), -- (optional, defaults to like 4 minutes)
		Range = 5, -- (optional) defaults to weapon range
		NoCombat = true, --(optional) set to true, it won't force combat when using.
		AllowCloaked = true, --(optional) set to true to allow abilites to be used while cloaked.
]]