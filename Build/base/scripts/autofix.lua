function DoAutofix()	
end

RegisterEventHandler(EventType.ModuleAttached,"autofix",DoAutofix)	
RegisterEventHandler(EventType.Message,"autofix",DoAutofix)