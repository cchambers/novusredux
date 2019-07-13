
require 'combat'
require 'brain_inc' -- must come after combat, before mobile
require 'base_mobile_advanced'

local fsm

function Start()
    fsm = FSM(this, {
        States.Death,
        States.Flee,
        States.Attack,
        States.Leash,
        States.Aggro,
        States.Fight,
        States.Wander,
    })

    if ( this:GetObjVar("AI-CanFlee") ~= true ) then
        fsm.RemoveState(States.Flee)
    end
    
    if ( 
        this:HasObjVar("CombatAbilites")
        or
        this:HasObjVar("WeaponAbilites")
        or
        this:HasObjVar("AvailableSpellsDictionary")
    ) then
        fsm.ReplaceState(States.Fight, States.FightAdvanced)
    end

    fsm.Start()
end

local _OnMobileLoad = OnMobileLoad
function OnMobileLoad()
    _OnMobileLoad()
    Start()
end