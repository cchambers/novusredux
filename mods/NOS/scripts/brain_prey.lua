
require 'NOS:combat'
require 'NOS:brain_inc' -- must come after combat, before mobile
require 'NOS:base_mobile'

local fsm = FSM(this, {
    States.Death,
    States.Flee,
    States.Leash,
    States.Aggro,
    States.Fight,
    States.Wander,
}, 3)

fsm.Start()