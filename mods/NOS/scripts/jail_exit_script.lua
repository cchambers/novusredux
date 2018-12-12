require 'account_functions'

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

		local user_id = user:GetAttachedUserId();

		local jail_record = user_id.."_jail";
		local table = GlobalVarRead(jail_record);
		if (table == nil) then
			user:SystemMessage(tostring("Account not jailed"));
			return;
		end
		
		local currentTime = os.time();
		local timeServed = currentTime - table["jailTime"];
		local timeLeft = table["sentence"] - timeServed;

		if (timeLeft < 0) then
			user:SetWorldPosition(table["jailLocation"]);
			user:DelObjVar("NoGains");
			user:SystemMessage(jail_record);
			GlobalVarDelete(jail_record, "delComplete");
		end

		user:SystemMessage(tostring("Time left in sentence: "..timeLeft));

	end
)
