--[[

	Used in the seedobject tool, responsible for registering events to the player.

]]

function Cleanup()
	this:DelModule("seedobjects")
end

if ( initializer ~= nil ) then
	if ( initializer.Command == "targetocp") then -- target object creation parameters
		RegisterSingleEventHandler(EventType.ClientTargetGameObjResponse, "SeedobjectsTargetOcp",
			function(target, user)
				user:ExecuteJavascript("SeedEditor", "ocptarg('"..BuildObjectCreationParams(target).."');")
				Cleanup()
			end)
		this:RequestClientTargetGameObj(this, "SeedobjectsTargetOcp")
	end
end