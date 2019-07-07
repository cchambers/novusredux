-- This is NOT used by normal animalken pets. They use pet_controller

AI.StateMachine.AllStates.Stabled = {
        OnEnterState = function()
            mForcedTarget = false
            mCombatTarget = nil
            AI.ClearAggroList()
            this:StopMoving()
        end,
    }
RegisterEventHandler(EventType.Message, "UnStabled", 
    function (args)
        --DebugMessage("CurState is "..AI.StateMachine.CurState)
        if(not IsDead(this)) then AI.StateMachine.ChangeState("Follow") else
            AI.StateMachine.ChangeState("Dead")
        end
    end)

RegisterEventHandler(EventType.Message, "Stabled",
    function(args)
        local controller = this:GetObjVar("controller") or this:GetObjVar("HirelingOwner")
        local tempPack = controller:GetEquippedObject("TempPack")
        if( tempPack ~= nil ) then
            AI.StateMachine.ChangeState("Stabled")
            this:MoveToContainer(tempPack,Loc(0,0,0))
        end
    end)