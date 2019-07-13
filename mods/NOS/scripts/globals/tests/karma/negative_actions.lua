
table.insert(Tests, function(done)
    Test.SetName("Karma:Negative Actions")

    local total = #ServerSettings.Karma.Levels * #ServerSettings.Karma.Levels * CountTable(KarmaActions.Negative)
    local I = 0
    local data = {}
    local levelA, levelB, protection
    
    -- create 'players'
    KarmaTest.Setup(function(playerA, playerB)

        -- test every karma level and karma action against every other karma level and action
        local success = false
        -- loop all levels, updating A to all levels
        for la=1,#ServerSettings.Karma.Levels do
            levelA = ServerSettings.Karma.Levels[la]
            SetKarma(playerA, levelA.Amount)
            -- loop all levels, updating B to each level.
            for lb=1,#ServerSettings.Karma.Levels do
                levelB = ServerSettings.Karma.Levels[lb]
                SetKarma(playerB, levelB.Amount)
                -- loop all negative actions
                for action,d in pairs(KarmaActions.Negative) do
                    I = I + 1


                        if not( data[action] ) then data[action] = {} end
                        if not( data[action][levelA.Name] ) then data[action][levelA.Name] = {} end
                        local amount, endInitiate = CalculateKarmaAction(playerA, d, playerB)
                        data[action][levelA.Name][levelB.Name] = amount
                        
                        if ( I == total ) then
                            local jsonData = json.encode(data)
                            file = io.output("test_negative_actions.json","a+")
                            io.write(jsonData)
                            file:close()
                            -- move onto next test
                            done()
                        end


                end
            end
        end
    end, true, true)

end)