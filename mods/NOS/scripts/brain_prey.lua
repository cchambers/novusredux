
require 'combat'
require 'brain_inc' -- must come after combat, before mobile
require 'base_mobile'

local fsm = FSM(this, {
    States.Death,
    States.Flee,
    States.Leash,
    States.Aggro,
    States.Fight,
    States.Wander,
}, 3)

fsm.Start()