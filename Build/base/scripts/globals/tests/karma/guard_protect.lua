
table.insert(Tests, function(done)
    Test.SetName("Karma:Guard Protect")

    -- if true, will only show instances where not-protected/not-allguards
    local inverse = false

    -- fun test to show that table.insert is slightly slower than alternative
    local tableInsert = false

    local before = DateTime.UtcNow

    local guardTypes = {
        "None",
        "Neutral",
        "Protection",
        "Town"
    }

    local karmaLevels = deepcopy(ServerSettings.Karma.Levels)

    -- add more karmaLevels to test temporary chaotic as well
    for i=1,#karmaLevels do
        if ( karmaLevels[i].GuardProtectPlayer and not karmaLevels[i].IsChaotic ) then
            local newlevel = deepcopy(karmaLevels[i])
            newlevel.TempChaotic = true
            karmaLevels[#karmaLevels+1] = newlevel
        end
    end

    local total = #karmaLevels * #karmaLevels * #guardTypes
    local I = 0
    local data = {}
    local aName, bName, protection

    --override GuardProtect
    GuardProtect = function(victim, aggressor, allGuards)
        if ( (not inverse and allGuards) or (inverse and not allGuards) ) then
            if not( data.AllGuards ) then data.AllGuards = {} end
            if not( data.AllGuards[protection] ) then data.AllGuards[protection] = {} end
            if not( data.AllGuards[protection][bName] ) then data.AllGuards[protection][bName] = {} end
            
            if ( tableInsert ) then
                table.insert(data.AllGuards[protection][bName], aName)
            else
                data.AllGuards[protection][bName][#data.AllGuards[protection][bName]+1] = aName
            end
        end
    end
    
    -- create 'players'
    KarmaTest.Setup(function(playerA, playerB)

        -- test every karma level and karma action against every other karma level and action
        local success = false
        -- loop all possible guard actions
        for i=1,#guardTypes do
            --override GetGuardProtection
            protection = guardTypes[i]
            GetGuardProtection = function() return guardTypes[i] end
            -- loop all levels, updating A to all levels
            for la=1,#karmaLevels do
                local levelA = karmaLevels[la]
                SetKarma(playerA, levelA.Amount)
                aName = levelA.Name

                -- set 'self' as temporarily chaotic
                if ( levelA.TempChaotic ) then
                    aName = aName ..".Chaotic"
                    playerA:SetObjVar("IsChaotic", true)
                else
                    playerA:DelObjVar("IsChaotic")
                end

                -- loop all levels, updating B to each level.
                for lb=1,#karmaLevels do
                    I = I + 1
                    local levelB = karmaLevels[lb]
                    SetKarma(playerB, levelB.Amount)
                    bName = levelB.Name

                    -- set 'target' as temporarily chaotic
                    if ( levelB.TempChaotic ) then
                        bName = bName ..".Chaotic"
                        playerB:SetObjVar("IsChaotic", true)
                    else
                        playerB:DelObjVar("IsChaotic")
                    end
                    
                    local protected = IsProtected(playerB, playerA)
                    if ( (not inverse and protected) or (inverse and not protected) ) then
                        if not( data.IsProtectedFrom ) then data.IsProtectedFrom = {} end
                        if not( data.IsProtectedFrom[protection] ) then data.IsProtectedFrom[protection] = {} end
                        if not( data.IsProtectedFrom[protection][bName] ) then data.IsProtectedFrom[protection][bName] = {} end

                        if ( tableInsert ) then
                            table.insert(data.IsProtectedFrom[protection][bName], aName)
                        else
                            data.IsProtectedFrom[protection][bName][#data.IsProtectedFrom[protection][bName]+1] = aName
                        end
                    end

                    -- advance A against B
                    AdvanceConflictRelation(playerA, playerB)

                    --DebugMessage(I, total)
                    if ( I == total ) then
                        data.IsProtectedFrom.Neutral = inverse and "All" or "None"
                        data.IsProtectedFrom.None = inverse and "All" or "None"
                        local jsonData = json.encode(data)
                        file = io.output("test_guard_protect.json","a+")
                        io.write(jsonData)
                        file:close()
                        -- move onto next test
                        local after = DateTime.UtcNow
                        Test.OutputDifference(before, after)
                        done()
                    end
                end
            end
        end
    end, true, true)

end)