require 'account_functions'

this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(60000), "decayObject");

RegisterEventHandler(EventType.Timer, "decayObject", function()
	this:Destroy();
end)


RegisterEventHandler(
	EventType.Message,
	"UseObject",
	function(user, usedType)

		if (this:HasObjVar("lastUsed")) then
			local elapsed = os.time() - this:GetObjVar("lastUsed");
			if (elapsed < 1) then
				return;
			end
		end

		this:SetObjVar("lastUsed", os.time());

		if (this:DistanceFrom(user) > 2.5) then
			user:SystemMessage("That is too far away.");
			return;
		end

		if (this:HasObjVar("IsTaken")) then
			user:SystemMessage("This is already being picked up.");
			return;
		end

		this:SetObjVar("IsTaken", true);
		user:SetFacing(user:GetLoc():YAngleTo(this:GetLoc()));
		SetMobileMod(user, "Disable", "CastFreeze", true);



		local user_id = user:GetAttachedUserId();
		local table = GlobalVarRead(user_id.."_jail");
		if (not(table["isJailed"])) then
			user:SystemMessage(tostring("Account not jailed"));
		end

		
		local newJailTime = table["jailTime"] - 10;
		WriteAccountVar(user_id, "jail", "jailTime", newJailTime);

		local currentTime = os.time();
		local timeServed = currentTime - table["jailTime"];
		local timeLeft = table["sentence"] - timeServed;
	
		local timeLeftMinutes = math.floor(timeLeft/60);
		user:SystemMessage(tostring("You picked up some poo, 10 seconds off your jail sentence. Time left in sentence: "..timeLeftMinutes.." minutes."));
		this:PlayEffect("LaughingSkullEffect",0);
		user:PlayAnimation("kneel");
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(2500), "destroyObjectTimer");
	
		RegisterEventHandler(EventType.Timer, "destroyObjectTimer", function()
			user:PlayAnimation("idle");
			SetMobileMod(user, "Disable", "CastFreeze", nil);
			this:Destroy();
		
		end)

	end
)
