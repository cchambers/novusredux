ServerSettings.Allegiance = {

    ResignTime = TimeSpan.FromDays(7),

    Allegiances = {
        {
            Id = 1,
            Name = "Pyros",
            Icon = "Fire",
            IconLarge = "FireFactionSymbolLarge",
            AllegianceLeaderTitle = "Agent of Pyros",

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
                    Title = "Overseer of Fire",
                    Description = "This is an Allegiance title."
                },
            },
        },
        {
            Id = 2,
            Name = "Tethys",
            Icon = "Water",
            IconLarge = "WaterFactionSymbolLarge",
            AllegianceLeaderTitle = "Priest of Tethys",

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
                    Title = "Lord of the Storms",
                    Description = "This is an Allegiance title."
                },
            },
        },
    }
}