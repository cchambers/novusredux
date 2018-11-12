--[[
    
    KarmaActionName = {
        -- the amount to adjust
        Adjust = -10,
        -- the max amount this karma action can affect
        UpTo = -500,

        -- These only apply to NEGATIVE mods. (Adjust < 0)

        -- if the action is being performed on a NPC (not a player character), it's multiplied by this amount
        NpcModifier = 0.1
    },

]]


KarmaActions = {}
require 'globals.static_data.karma.negative_actions'
require 'globals.static_data.karma.positive_actions'