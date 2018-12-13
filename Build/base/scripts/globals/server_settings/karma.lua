ServerSettings.Karma = {

    -- the karma that will be set when a player is initialized.
    NewPlayerKarma = 1,

    -- the karma level for alignment that will be set when a player is initialized.
    NewPlayerKarmaAlignment = 1,

	-- zones in-game will be disabled from karma.
	DisableKarmaZones = {
		"Arena"
	},
	-- Regions with this address will be disabled
	DisableKarmaRegionAddresses = {
		"TwoTowers"
	},

    -- the minimum time between daily login bonus
    DailyLoginInterval = TimeSpan.FromHours(20),

    -- to prevent spam on blocking negative karma
    MinimumBetweenNegativeWarnings = TimeSpan.FromSeconds(3),

    -- if they try to accept the window after this long, it will deny flagging order.
    ChaoticWarningTimespan = TimeSpan.FromSeconds(10),

    -- always keep these ordered from highest to lowest,
    Levels = {
        {
            Amount = 1,
            Protect = 0,
            Name = "Innocent",
            AlignmentName = "Peaceful",
            NameColor = "82ABFF",
            Title = "The Innocent", -- %s will be replaced with the mobile's name.
            --Negative Karma Adjustment modifiers are used to compound negative acts by players of positive karma and to reduce players of negative karma from falling off a cliff.
            NegativeKarmaAdjustMod = 1,
            -- do guards protect this karma level for players?
            GuardProtectPlayer = true,
            -- do guards protect this karma level for NPCs?
            GuardProtectNPC = true,
            --PvPMods: Player Vs Player Modifiers; Karma rewards are not given at low levels of positive karma as people may use this to game high karma through killing red accomplices. Accomplishing high karma must be a grind to those not generating it organically.
            PvPMods = {
                Innocent = 1,
                Neutral = 1,
                Chaos = 0,
                Outcast = 0,
            }
        },
        {
            -- neutral exists as a way for npcs to have white names.
            Amount = 0,
            Name = "Neutral",
            NameColor = "FFFFFF",
            Title = "The Neutral",
            NegativeKarmaAdjustMod = 1,
            PunishBeneficialToNPC = true,
            PunishBeneficialToPlayer = true,
            BenefitModifier = 0.5,
            PvPMods = {
                Innocent = 1,
                Neutral = 1,
                Chaos = 0,
                Outcast = 0,
            },
            -- Apply and modify the Positive Karma action SlayMonster ONLY when slaying an NPC of this Karma Level.
            SlayMonsterModifier = 0,
            Hidden = true,
        },
        {
            Amount = -1,
            Protect = -9999,
            Name = "Chaos",
            AlignmentName = "Chaotic",
            NameColor = "FF8000",
            Title = "The Chaotic",
            IsChaotic = true, -- chaotic allignments are free to kill each other, and everyone can temporarily flag chaotic by choice
            NegativeKarmaAdjustMod = 1,
            GuardProtectPlayer = true,
            GuardHostileNPC = true,
            PunishBeneficialToNPC = true,
            BenefitModifier = 0.8,
            PvPMods = {
                Innocent = 1,
                Neutral = 1,
                Chaos = 0,
                Outcast = 0,
            },
            SlayMonsterModifier = 20,
        },
        {
            Amount = -10000,
            Name = "Outcast",
            AlignmentName = "Unlawful",
            NameColor = "FF0000",
            Title = "The Outcast",
            NegativeKarmaAdjustMod = 0.1,
            -- guards will attack this player, don't set guard protect to true when this is true, things might get weird?
            GuardHostilePlayer = true,
            -- guards will attack this NPC, don't set guard protect to true when this is true, things might get weird?
            GuardHostileNPC = true,
            -- If any beneficial actions are performed on this karma level (as a player), the one performing will have a negative karma action executed on them
            PunishBeneficialToPlayer = true,
            -- If any beneficial actions are performed on this karma level (as an NPC), the one performing will have a negative karma action executed on them
            PunishBeneficialToNPC = true,
            --
            DisallowBlueResurrectShrines = true,
            -- prevent this karma level from using factions
            DisallowAllegiance = true,
            BenefitModifier = 1.25,
            PvPMods = {
                Innocent = 1,
                Neutral = 1,
                Chaos = 0,
                Outcast = 0,
            },
            SlayMonsterModifier = 20,
        }
    }
}