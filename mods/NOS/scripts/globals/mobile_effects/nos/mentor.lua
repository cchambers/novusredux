MobileEffectLibrary.Mentor = {
    ShouldStack = false,
    OnEnterState = function(self, root, target, args)
        self.Path = self.ParentObj:GetObjVar("MentorPath")

        if (self.Path == nil) then
            self.ParentObj:SystemMessage("You must first choose the type of training you will be known for.", "info")

            local fontname = "PermianSlabSerif_Dynamic_Bold"
            mMENTOR = DynamicWindow("CHOOSEMENTORTYPE", "Choose Mentor Path", 450, 260, 47, 68, "Draggable", "Center")
            -- mMENTOR:AddLabel(75, 10, "RANGER", 110, 30, 20, "center", false, true, fontname)
            mMENTOR:AddButton(
                20,
                40,
                "CombatSkillType",
                "Combat",
                110,
                24,
                "Teach the skills of a warrior.",
                "",
                true,
                "Default",
                "default"
            )
            mMENTOR:AddButton(
                180,
                50,
                "TradeSkillType",
                "Trade",
                110,
                24,
                "Teach the skills of a craftsman.",
                "",
                true,
                "Default",
                "default"
            )
            self.ParentObj:OpenDynamicWindow(mMENTOR)

            RegisterEventHandler(
                EventType.DynamicWindowResponse,
                "CHOOSEMENTORTYPE",
                function(user, buttonId)
                    if (buttonId ~= nil and buttonId ~= "") then
                        user:SetObjVar("MentorPath")
                        self.RequestInitialTarget(self, root, target, args)
                    end
                    return
                end
            )
        else 
            self.RequestInitialTarget(self, root, target, args)
        end
    end,
    RequestInitialTarget = function(self, root, target, args)
        -- handle a new target
        RegisterSingleEventHandler(
            EventType.ClientTargetGameObjResponse,
            "Mentor.Choose",
            function(target)
                self.ParentObj:SystemMessage(
                    "apply beingmentored mobileeffect to target and ping them every 3 seconds for 30"
                )
                target:SystemMessage("Targeted for learnin")
                EndMobileEffect(root)
            end
        )
        self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "Mentor.Choose")
    end,
    OnExitState = function(self, root)
        return
    end,
    Path = nil
}
