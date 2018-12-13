ServerSettings.Conflict = {

    -- Do guards attack non-guard protected karma levels who are aggressors?
    GuardsKillAggressors = false,

    -- The duration of the Aggressor/Victim/Defender relation. 
    -- These must be locked in the same timespan so we can do reverse checks. 
        -- For example: Determine all aggressors by checking who a mobile is a Victim/Defender to.
    RelationDuration = TimeSpan.FromSeconds(100)

}