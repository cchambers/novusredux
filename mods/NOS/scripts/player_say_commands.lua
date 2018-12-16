BANKER_RANGE = 10

RegisterEventHandler(
	EventType.ClientUserCommand,
	"say",
	function(cmd, ...)
		cmd = string.lower(cmd)
		if (cmd == "bank" or cmd == "banker") then
			if (this:HasTimer("AntiBankSpam") or IsDead(this)) then
				return
			end

			-- look for bankers.
			local banker =
				FindObject(
				SearchMulti(
					{
						SearchMobileInRange(BANKER_RANGE),
						SearchObjVar("AI-EnableBank", true)
					}
				)
			)

			if (banker ~= nil) then
				OpenBank(this, banker)
			end

			this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500), "AntiBankSpam")
			return
		end

		if ("balance") then
			if (this:HasTimer("AntiBankSpam") or IsDead(this)) then
				return
			end

			-- look for bankers.
			local banker =
				FindObject(
				SearchMulti(
					{
						SearchMobileInRange(BANKER_RANGE),
						SearchObjVar("AI-EnableBank", true)
					}
				)
			)

			local bankObj = this:GetEquippedObject("Bank")
			local tally = 0
			local objects = FindItemsInContainerRecursive(bankObj)

			for i, v in pairs(objects) do
				local type = v:GetObjVar("ResourceType")
				if (type == "coins") then
					tally = tally + v:GetObjVar("StackCount")
				end
			end

			while true do
				tally, k = string.gsub(tally, "^(-?%d+)(%d%d%d)", "%1,%2")
				if (k == 0) then
					break
				end
			end
			local name = this:GetName();
			banker:NpcSpeech(name .. ", your net worth is [FFD700]" .. tally .. "[-] Gold!")
			this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500), "AntiBankSpam")
			return
		end

		local args = {...}
		if (#args > 0) then
			args[1] = string.lower(args[1])
			if (ValidPetCommand(args[1]) and not IsDead(this) and #GetActivePets(this) > 0) then
				if (args[2]) then
					args[2] = string.lower(args[2])
				end
				ProcessPetCommand(this, cmd, args)
			end
		end
	end
)
