ServerSettings.Karma = {

    -- if this is true, they are also free from guards for actions between guild members
    GuildMembersFreeFromKarma = true,

    -- the karma that will be set when a player is initialized.
    NewPlayerKarma = 2500,

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
    MinimumBetweenNegativeWarnings = TimeSpan.FromSeconds(0.5),

    -- always keep these ordered from highest to lowest
    Levels = {
        {
            Amount = 10000,
            Name = "Trustworthy",
            NameColor = "ffff99",
            Title = "%s the Trustworthy", -- %s will be replaced with the mobile's name.
            --Negative Karma Adjustment modifiers are used to compound negative acts by players of positive karma and to reduce players of negative karma from falling off a cliff.
            NegativeKarmaAdjustMod = 5,
            -- do guards protect this karma level for players?
            GuardProtectPlayer = true,
            -- do guards protect this karma level for NPCs?
            GuardProtectNPC = true,
            --PvPMods: Player Vs Player Modifiers; Karma rewards are not given at low levels of positive karma as people may use this to game high karma through killing red accomplices. Accomplishing high karma must be a grind to those not generating it organically.
            PvPMods = {
                Trustworthy = 2,
                Honest = 1.5,
                Good = 1.25,
                Neutral = 1,
                Rude = 0,
                Scoundrel = -1,
                Outcast = -1.25,
            }
        },
        {
            Amount = 5000,
            Name = "Honest",
            NameColor = "355fb2",
            Title = "%s the Honest",
            NegativeKarmaAdjustMod = 3,
            GuardProtectPlayer = true,
            GuardProtectNPC = true,
            PvPMods = {
                Trustworthy = 2,
                Honest = 1.5,
                Good = 1.25,
                Neutral = 1,
                Rude = 0,
                Scoundrel = -1,
                Outcast = 1.25,
            }
        },
        {
            Amount = 2500,
            Name = "Good",
            NameColor = "82abff",
            Title = "%s the Good",
            NegativeKarmaAdjustMod = 1.5,
            GuardProtectPlayer = true,
            GuardProtectNPC = true,
            PvPMods = {
                Trustworthy = 2,
                Honest = 1.5,
                Good = 1.25,
                Neutral = 1,
                Rude = 0,
                Scoundrel = 0,
                Outcast = 0,
            }
        },
        {
            Amount = 0,
            Name = "Neutral",
            NameColor = "FFFFFF",
            Title = "%s",
            NegativeKarmaAdjustMod = 1,
            GuardProtectPlayer = true,
            PunishBeneficialToNPC = true,
            PvPMods = {
                Trustworthy = 2,
                Honest = 1.5,
                Good = 1.25,
                Neutral = 1,
                Rude = 0,
                Scoundrel = 0,
                Outcast = 0,
            }
        },
        {
            Amount = -2500,
            Name = "Rude",
            NameColor = "A7A7A7",
            Title = "%s the Rude",
            NegativeKarmaAdjustMod = 1,
            GuardProtectPlayer = true,
            GuardHostileNPC = true,
            PunishBeneficialToNPC = true,
            PvPMods = {
                Trustworthy = 2,
                Honest = 1.5,
                Good = 1.25,
                Neutral = 1,
                Rude = 0,
                Scoundrel = 0,
                Outcast = 0,
            },
            -- Apply and modify the Positive Karma action SlayMonster ONLY when slaying an NPC of this Karma Level.
            SlayMonsterModifier = 1,
        },
        {
            Amount = -5000,
            Name = "Scoundrel",
            NameColor = "FF8000",
            Title = "%s the Scoundrel",
            NegativeKarmaAdjustMod = 0.5,
            GuardProtectPlayer = true,
            GuardHostileNPC = true,
            PunishBeneficialToNPC = true,
            PvPMods = {
                Trustworthy = 1,
                Honest = 1,
                Good = 1,
                Neutral = 1,
                Rude = 0,
                Scoundrel = 0,
                Outcast = 0,
            },
            SlayMonsterModifier = 2,
        },
        {
            Amount = -10000,
            Name = "Outcast",
            NameColor = "FF0000",
            Title = "%s the Outcast",
            NegativeKarmaAdjustMod = 0.25,
            -- guards will attack this player, don't set guard protect to true when this is true, things might get weird?
            GuardHostilePlayer = true,
            -- guards will attack this NPC, don't set guard protect to true when this is true, things might get weird?
            GuardHostileNPC = true,
            -- If any beneficial actions are performed on this karma level (as a player), the one performing will have a negative karma action executed on them
            PunishBeneficialToPlayer = true,
            -- If any beneficial actions are performed on this karma level (as an NPC), the one performing will have a negative karma action executed on them
            PunishBeneficialToNPC = true,
            --
            DisallowBlueResurrectShrines = false,
            -- prevent this karma level from using factions
            DisallowAllegiance = true,
            PvPMods = {
                Trustworthy = 1,
                Honest = 1,
                Good = 1,
                Neutral = 1,
                Rude = 0,
                Scoundrel = 0,
                Outcast = 0,
            },
            SlayMonsterModifier = 3,
        }
    }
}