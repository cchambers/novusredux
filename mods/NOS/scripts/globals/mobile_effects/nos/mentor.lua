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
                40,
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
                        user:SetObjVar("MentorPath", buttonId)
                        self.SelectSkill(self, root, target, buttonId)
                    end
                    return
                end
            )
        else
            self.SelectSkill(self, root, target, self.Path)
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
            end
        )
        self.ParentObj:RequestClientTargetGameObj(self.ParentObj, "Mentor.Choose")
    end,
    SelectSkill = function(self, root, target, path)
        self.Path = self.Path or path
        local newWindow = DynamicWindow("CHOOSESKILL", "You can train...", 320, 530)
        local mentorSkills = self.ParentObj:GetObjVar("SkillDictionary") -- all of the players skills
        local allSkills = {}

        local scrollWindow = ScrollWindow(20, 40, 250, 375, 25)

        for skillName, skillData in pairs(SkillData.AllSkills) do
            if (not (skillData.Skip)) then
                DebugMessage(tostring(self.Path .. " " .. skillName .. " " .. skillData.SkillType))
                if (mentorSkills[skillName] ~= nil and mentorSkills[skillName].SkillLevel >= 90) then
                    table.insert(allSkills, skillName)
                end
            end
        end

        for i, skillName in pairs(allSkills) do
            local name = allSkills[i]
            local scrollElement = ScrollElement()
            if ((i - 1) % 2 == 1) then
                scrollElement:AddImage(0, 0, "Blank", 230, 25, "Sliced", "1A1C2B")
            end
            scrollElement:AddLabel(45, 3, skillName, 0, 0, 18)
            local selState = ""
            if (skillName == self.selectedSkillName) then
                selState = "pressed"
            end
            scrollElement:AddButton(20, 2, "select|" .. skillName, "", 0, 18, "", "", false, "Selection", selState)
            scrollWindow:Add(scrollElement)
        end
        newWindow:AddScrollWindow(scrollWindow)

        newWindow:AddButton(15, 420, "train|", "Train", 100, 23, "", "", false, "", buttonState)

        self.ParentObj:OpenDynamicWindow(newWindow)

        EndMobileEffect(root)
    end,
    OnExitState = function(self, root)
        return
    end,
    Path = nil
}
