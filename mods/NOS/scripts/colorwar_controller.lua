-- RoundID

mQueue = {}

function HandleModuleLoaded() 
    GlobalVarWrite("ColorWar.Controller", { primary = this })
end

RegisterEventHandler(EventType.ModuleAttached, GetCurrentModule(), HandleModuleLoaded)

RegisterEventHandler(EventType.Message,"ColorWar.Queue", function ( args )
    local user = args.user

    for index, char in pairs(mQueue) do
        if (char == user) then
            table.remove(mQueue, index)
            DebugMessage("De-queued " .. user:GetName() .. " for Color Wars.")
            user:SendMessageGlobal("ColorWar.Exit")
            return
        end
    end

    table.insert(mQueue, user)
    DebugMessage("Queued " .. user:GetName() .. " for Color Wars.")
    user:SendMessageGlobal("ColorWar.Enter")
end)