BANKER_RANGE = 10

RegisterEventHandler(
	EventType.ClientUserCommand,
	"say",
	function(cmd, ...)
		cmd = string.lower(cmd)
		fullstr = string.lower(tostring( cmd .. " " .. table.concat({...}, " ")))
		if (string.match(fullstr, "bank")) then
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
				this:SendMessage("OpenBank",banker)
			end
			this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500), "AntiBankSpam")
		end

		if (string.match(fullstr, "balance")) then
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
			local tally = CountResourcesInContainer(bankObj,"coins")

			while true do
				tally, k = string.gsub(tally, "^(-?%d+)(%d%d%d)", "%1,%2")
				if (k == 0) then
					break
				end
			end
			local name = this:GetName();
			banker:NpcSpeech("Hi " .. name .. "! Your net worth is [FFD700]" .. tally .. "[-] gold.")
			this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500), "AntiBankSpam")
		end

		if (string.match(fullstr, "consider my sins")) then
			local murders = this:GetObjVar("Murders")
			if (murders ~= nil) then
				this:SystemMessage("You must attone for " .. murders .. " murders.", "info")
			else 
				this:SystemMessage("Your conscious is clear.", "info")
			end
		end

		if (string.match(fullstr, "i forgive thee")) then
			local murderers = this:GetObjVar("MurdererForgive")
			if (murderers ~= nil) then
				this:SystemMessage("You have forgiven your aggressors.", "info")
				this:DelObjVar("MurdererForgive")
			else 
				this:SystemMessage("You have no one to forgive.", "info")
			end
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
