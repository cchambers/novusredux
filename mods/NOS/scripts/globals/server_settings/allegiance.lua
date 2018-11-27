ServerSettings.Allegiance = {

    ResignTime = TimeSpan.FromDays(7),

    Allegiances = {
        {
            Id = 1,
            Name = "Chaos",
            Icon = "Fire",
            IconLarge = "FireFactionSymbolLarge",
            AllegianceLeaderTitle = "Agent of Chaos",

            -- important to keep these listed from lowest to highest
            Titles = {
                {
                    Percent = 0.2,
                    Title = "Acolyte",
                    Description = "This is an Allegiance title."
                },
                {
                    Percent = 0.5,
                    Title = "Torchbearer",
                    Description = "This is an Allegiance title."
                },
                {
                    Percent = 0.8,
                    Title = "Ember Sentinel",
                    Description = "This is an Allegiance title."
                },
                {
                    Percent = 0.95,
                    Title = "Ardent Flame",
                    Description = "This is an Allegiance title."
                },
                {
                    Percent = 0.99,
                    Title = "Overseer of Chaos",
                    Description = "This is an Allegiance title."
                },
            },
        },
        {
            Id = 2,
            Name = "Order",
            Icon = "Water",
            IconLarge = "WaterFactionSymbolLarge",
            AllegianceLeaderTitle = "Agent of Order",

            -- important to keep these listed from lowest to highest
            Titles = {
                {
                    Percent = 0.2,
                    Title = "Servant",
                    Description = "This is an Allegiance title."
                },
                {
                    Percent = 0.5,
                    Title = "Worshipper",
                    Description = "This is an Allegiance title."
                },
                {
                    Percent = 0.8,
                    Title = "Elder Mystic",
                    Description = "This is an Allegiance title."
                },
                {
                    Percent = 0.95,
                    Title = "Rain Bringer",
                    Description = "This is an Allegiance title."
                },
                {
                    Percent = 0.99,
                    Title = "Harbringer of Order",
                    Description = "This is an Allegiance title."
                },
            },
        },
    }
}