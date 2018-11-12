require 'scriptcommands_UI_goto'
require 'editmode_scriptcommands_manage'

-- This list is populated with the RegisterCommand function, all built in commands are
-- registered at the bottom of this file
CommandList = {}

-- Command functions

function GetCommandInfo(commandName)
	for i, commandInfo in pairs(CommandList) do
		if( commandInfo.Command == commandName 
			or (commandInfo.Aliases ~= nil and IsInTableArray(commandInfo.Aliases,commandName)) ) then
			-- we also return the index as the second parameter
			return commandInfo, i		
		end
	end
end

function Usage(commandName)
	local commandInfo = GetCommandInfo(commandName)
	local usageStr = "Usage: /"..commandName
	if( commandInfo.Usage ~= nil ) then
		usageStr = usageStr.." "..commandInfo.Usage
	end
	this:SystemMessage(usageStr)
end	

-- Note: This function replaces any existing command with the same name
-- This makes it easy for mods to replace existing commands
function RegisterCommand(commandInfo)
	if( commandInfo.Func == nil ) then
		DebugMessage("[scriptcommands][RegisterCommand] ERROR: Invalid command function!")
	end

	-- remove old command with this name
	local oldCommandInfo, oldIndex = GetCommandInfo(commandInfo.Command)
	if(oldCommandInfo ~= nil) then
		-- unregister the user command event handlers
		local oldCommandNames = oldCommandInfo.Aliases or {}
    	table.insert(oldCommandNames,oldCommandInfo.Command)
    	for i,commandName in pairs(oldCommandNames) do
    		UnregisterEventHandler('scriptcommands',EventType.ClientUserCommand,commandName)
    	end
    	-- replace the old command in the list
    	CommandList[oldIndex] = commandInfo
	else
		-- add this new command to the end
		table.insert(CommandList,commandInfo)
	end

	local commandNames = commandInfo.Aliases or {}
    table.insert(commandNames,commandInfo.Command)

	for i,commandName in pairs(commandNames) do
		RegisterEventHandler(EventType.ClientUserCommand, commandName, 
			function (...)
				if ( LuaCheckAccessLevel(this,commandInfo.AccessLevel) or this:HasObjVar("IsGod") ) then					
					commandInfo.Func(...)			
				end
			end)
	end
end

function DoShutdown(reason,shouldRestart)	
	local reasonMessage = reason or "Unspecified"
	if(shouldRestart == nil) then shouldRestart = false end	

	ServerBroadcast(reasonMessage,true)
	ShutdownServer(shouldRestart)
end

RegisterEventHandler(EventType.Timer, "shutdown",
	function(reason,shouldRestart)
		DoShutdown(reason,shouldRestart)
	end)

-- Default command functions are stored in this table for readability
-- If you override one of these functions, it must be reregistered using RegisterCommand
-- or the command will still reference the old version of the function
DefaultCommandFuncs= 
{
	ReloadBehavior = function(behaviorName)
		if( behaviorName == nil ) then
			Usage("reloadbehavior")
		end

		ReloadModule(behaviorName)
	end,

	Log = function(...)
		local line = CombineArgs(...)
		if( line == nil ) then Usage("log") return end

		DebugMessage("Player Log:",this,":",line)
	end,

	Shutdown = function(timeSecs,...)			
		if( timeSecs ~= nil ) then
			local arg = table.pack(...)
			local reason = "Server is shutting down in "..timeSecs.." seconds."
			if(#arg > 0) then
				reason = ""
				for i = 1,#arg do reason = reason .. tostring(arg[i]) .. " " end
			end
			
			ServerBroadcast(reason,true)
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(tonumber(timeSecs)),"shutdown",reason)
		else
			Usage("shutdown")
		end		
	end,

	Restart = function(timeSecs,...)			
		if( timeSecs ~= nil ) then
			local arg = table.pack(...)
			local reason = "Server is restarting in "..timeSecs.." seconds."
			if(#arg > 0) then
				reason = ""
				for i = 1,#arg do reason = reason .. tostring(arg[i]) .. " " end
			end

			ServerBroadcast(reason,true)
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(tonumber(timeSecs)),"shutdown",reason,true)
		else
			Usage("shutdown")
		end		
	end,	
}

RegisterCommand{ Command="reloadbehavior", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.ReloadBehavior, Usage="<behavior>", Desc="[DEBUG COMMAND] Reload the behavior in memory.", Aliases={"reload"}}
RegisterCommand{ Command="log", Category = "Debug", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.Log, Usage="<log string>", Desc="[DEBUG COMMAND] Write a line to the lua log" }
RegisterCommand{ Command="shutdown", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.Shutdown, Usage="<delay_seconds> [<reason>]", Desc="[$1785]" }	
RegisterCommand{ Command="restart", Category = "Dev Power", AccessLevel = AccessLevel.God, Func=DefaultCommandFuncs.Restart, Usage="<delay_seconds> [<reason>]", Desc="[$1786]" }	
RegisterCommand{ Command="gotolocation", Category = "God Power", AccessLevel = AccessLevel.Immortal, Func=DefaultCommandFuncs.Goto, Usage="[<x>] [<y>] [<z>]", Desc="[$1787]", Aliases={"goto"}}