require 'globals.helpers.allegiance'
DelGlobalVar("Allegiance.CurrentSeason", function(success)
    CheckForAndStartNewSeason()
end)
