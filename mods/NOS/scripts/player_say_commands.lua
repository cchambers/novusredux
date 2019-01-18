BANKER_RANGE = 10

RegisterEventHandler(
	EventType.ClientUserCommand,
	"say",
	function(cmd, ...)
		cmd = string.lower(cmd)
		fullstr = string.lower(tostring(cmd .. " " .. table.concat({...}, " ")))
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
				this:SendMessage("OpenBank", banker)
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
			local tally = CountResourcesInContainer(bankObj, "coins")

			while true do
				tally, k = string.gsub(tally, "^(-?%d+)(%d%d%d)", "%1,%2")
				if (k == 0) then
					break
				end
			end
			local name = this:GetName()
			banker:NpcSpeech("Hi " .. name .. "! Your net worth is [FFD700]" .. tally .. "[-] gold.")
			this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500), "AntiBankSpam")
		end

		if (string.match(fullstr, "consider my sins")) then
			local murders = this:GetObjVar("Murders")
			if (murders ~= nil) then
				this:SystemMessage("You must atone for " .. murders .. " murders.", "info")
			else
				this:SystemMessage("Your conscience is clear.", "info")
			end
		end

		if (string.match(fullstr, "i forgive thee")) then
			-- local murderers = this:GetObjVar("MurdererForgive")
			-- -- THIS NEEDS WORK
			-- if (murderers ~= nil) then
			-- 	for k, v in pairs() do
			-- 		local m = v:GetObjVar("Murders")
			-- 		if (m ~= nil) then
			-- 			m = m - 1
			-- 			v:SetObjVar("Murders", m)
			-- 		end
			-- 	end
			-- 	this:SystemMessage("You have forgiven your aggressors.", "info")
			-- 	-- this:DelObjVar("MurdererForgive")
			-- else
			this:SystemMessage("This isn't working quite right yet.", "info")
		-- end
		end

		if (string.match(fullstr, "banish thee")) then
			local destLoc = this:GetLoc()
			local plotController = Plot.GetAtLoc(destLoc)
			this:SendMessage("StartMobileEffect", "PlotKick", plotController, nil)
		end

		if (string.match(fullstr, "guards")) then
			if (this:HasTimer("AntiGuardSpam") or IsDead(this)) then
				return
			end

			local destLoc = this:GetLoc()
			local protected = GetGuardProtectionForLoc(destLoc)
			if (protected == "Town" or protected == "Protection") then
				local mobiles =
					FindObjects(
					SearchMulti(
						{
							SearchRange(destLoc, 20),
							SearchHasObjVar("IsCriminal")
						}
					),
					GameObj(0)
				)

				for i, v in pairs(mobiles) do
					if (not (IsDead(v))) then
						GuardInstaKill(v)
					end
				end
			end
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(5), "AntiGuardSpam")
		end

		
		if (string.match(fullstr, "westy sent me")) then
			if (this:HasTimer("AntiWestySpam") or IsDead(this)) then
				return
			end
			local mobiles =
				FindObjects(
				SearchMulti(
					{
						SearchRange(this:GetLoc(), 5),
						SearchMobile()
					}
				),
				GameObj(0)
			)
			local count = 0
			local first = nil
			for i, v in pairs(mobiles) do
				if (i == 1) then first = v end
				if (not (IsDead(v))) then
					FaceObject(v,this)
					v:PlayAnimation("salute")
					count = count + 1
				end
			end
			if (first) then
				FaceObject(this,first)
			end
			this:PlayAnimation("salute")
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "AntiWestySpam")
		end

		if (string.match(fullstr, "dance battle")) then
			if (this:HasTimer("AntiDanceSpam") or IsDead(this)) then
				return
			end
			local mobiles =
				FindObjects(
				SearchMulti(
					{
						SearchRange(this:GetLoc(), 5),
						SearchMobile()
					}
				),
				GameObj(0)
			)
			local count = 0
			local first = nil
			for i, v in pairs(mobiles) do
				if (i == 1) then first = v end
				if (not (IsDead(v))) then
					FaceObject(v,this)
					v:PlayAnimation("dance_runningman")
					count = count + 1
				end
			end
			if (first) then
				FaceObject(this,first)
			end
			this:PlayAnimation("dance_runningman")
			this:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "AntiDanceSpam")
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
