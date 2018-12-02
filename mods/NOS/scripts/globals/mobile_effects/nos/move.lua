MobileEffectLibrary.Move = {
    OnEnterState = function(self, root, target)
        local user = self.ParentObj
        local move = self
        move.what = target
        user:SystemMessage("Where to?")
        user:RequestClientTargetLoc(this, "select_teleport_destination")

        RegisterEventHandler(
            EventType.ClientTargetLocResponse,
            "select_teleport_destination",
            function(success, targetLoc)
                move.where = targetLoc
                user:SendMessage("do_teleport")
            end
        )

        RegisterEventHandler(
            EventType.Message,
            "do_teleport",
            function()
                move.what:SetWorldPosition(move.where)
            end
        )
    end
}
