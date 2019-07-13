

baseIsPlayerCharacter = IsPlayerCharacter
IsPlayerCharacter = function(mob)
    if ( mob:HasObjVar("IsPlayer") ) then return true end
    return baseIsPlayerCharacter(mob)
end

baseUpdateConflictRelation = UpdateConflictRelation
function UpdateConflictRelation(mobileA, mobileB, isPlayerA, isPlayerB, newRelation, guardCheck)
    baseUpdateConflictRelation(mobileA, mobileB, IsPlayerCharacter(mobileA), IsPlayerCharacter(mobileB), newRelation, guardCheck)
end

KarmaTest = {
    CreateMobile = function(cb, isPlayer)
        Create.AtLoc("skeleton", Loc(0,0,0), function(mob)
            if ( mob ) then
                if ( isPlayer ) then
                    mob:SetObjVar("IsPlayer", true)
                end
                if ( cb ) then cb(mob) end
            end
        end, true)
    end,
    Setup = function(cb, isPlayerA, isPlayerB)
        KarmaTest.CreateMobile(function(mobA)
            KarmaTest.CreateMobile(function(mobB)
                if ( cb ) then cb(mobA, mobB) end
            end, isPlayerB)
        end, isPlayerA)
    end,
}

require 'globals.tests.karma.negative_actions'
require 'globals.tests.karma.guard_protect'
