require 'scriptcommands'

function DoCommand(commandStr)	
	commandArgs = StringSplit(commandStr," ")
	if(#commandArgs == 0) then
		DebugMessage("[runcommand] Command failed (invalid args): "..commandStr)
		return
	end

	commandName = commandArgs[1]	
	local commandInfo = GetCommandInfo(commandName)
	if not( commandInfo ) then
		DebugMessage("[runcommand] Command failed (no entry): "..commandStr)
		return
	end

	DebugMessage("[runcommand] Running Command: "..commandStr)

	local func = commandInfo.Func
	table.remove(commandArgs,1)
	commandInfo.Func(table.unpack(commandArgs))	
end

RegisterEventHandler(EventType.Timer,"Destroy",
	function()
		this:Destroy()
	end)

if(initializer ~= nil) then
	commandStr = this:GetObjVar("CommandStr")
	if( commandStr ~= nil ) then
		DoCommand(commandStr)
	end

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(30),"Destroy")
end