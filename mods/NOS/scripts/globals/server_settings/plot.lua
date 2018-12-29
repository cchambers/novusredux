ServerSettings.Plot = {

    --- limit how often they can rename their plot since it updates global variables
    MaxRenameInterval = TimeSpan.FromSeconds(30),

    -- Since all plots should always be alligned and when first placing a plot it will be minimum, 
        --it's important to keep MinimumSize an even number. (Or add support to detect an odd number and allow rounding to .5 in Plot.New)
    MinimumSize = 12,

    -- maxiumsize is a required setting so we can look for controllers near 1/2 this range
    MaximumSize = 40,

    -- multiply the resource cost of building a house by this amount
    HouseResourceCostModifier = 1,

    -- multiply the tax cost for the commit cost
    CommitCostMultiplier = 5,

    Tax = {
        -- disable for free plot tax.
        Enabled = false,

        -- how much tax rate scales with plot size, expoentially.
        RateCoefficient = 1.6,

        -- since each payment writes to globals, 
            --enforce a minimum so they aren't dropping 1 as fast as possible and DoSing the globalvars.
        MinimumPayment = 100,

        -- for Time settings:
        -- see !*t here: http://lua-users.org/wiki/OsLibraryTutorial

        -- all tax payments will be taken at this time, moving balance into negative if not enough funds.
        TaxTime = {
            min = 0,
            hour = 20,
            wday = 6,
        },
        -- number of seconds past tax time that will still count it as tax time
        --- The larger this resolution the more time a server can be offline and taxes still be collected when it returns.
        --- if the server is offline longer than this, and tax time didn't take, consider if a free week for all.
        -- NOTE: This needs to be LESS THAN the taxing interval, for example if you're taxing hourly, this must be < 60 * 60
        TaxTimeResolution = 60 * 60 * 8,

        -- all negative plots will be removed from their owners and put up for sale on this date
        SaleTime = {
            min = 0,
            hour = 20,
            wday = 1,
        },
        -- see TaxTimeResolution
        SaleTimeResolution = 60 * 60 * 8,

        -- rate times this modifier will be the maximum tax a plot can have (by player added funds)
        MaxBalanceRateModifier = 4,

    },

    Auction = {
        
        StartTime = {
            min = 0,
            hour = 20,
            wday = 2,
        },

        -- how long an auction lasts (in seconds) from bidding open to bidding closed.
        Length = 60 * 30,

        -- these are the time slots, 
            --for example if sale date is at 8PM, MinumumStart is 1 day(24 hrs)
            --then the next day at 8PM, each auction will be spaced until interval, 
            --if there are more auctions than interval then some auctions will begin to run en tandem. 
        Slots = {
            Interval = TimeSpan.FromHours(1),
            Max = 8, -- interval * Max = Window of time all auctions run
        },

        -- percent of total bid that will never be refunded
        BidFee = 0.01,

    }
}