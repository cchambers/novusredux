mBackpackObj = this:GetEquippedObject("Backpack")
mWarningLevels = { 0, 10, 30, 50, 100 }
mLevelColors = { "FF0000", "FFA500", "FFFF00", "C0C0C0", "BADA55" }

mScaleBase = 10
mScaleIncrease = 0.1
mScaleMin = 8
mScaleMax = 20

mTracked = {
	followers = {
		pets = 0,
		minions = 0,	
	},
	aid = {
		bandages = 0,
		bloodybandages = 0
	},
	arrows = {
		regular = 0,
		--feathered = 0
		ash = 0,
		blight = 0,
	},
	regs = {
		mandrake = 0,
		bloodmoss = 0,
		garlic = 0,
		spidersilk = 0,
		sulfurousash = 0,
		nightshade = 0,
		blackpearl = 0,
		ginseng = 0
	},
	-- potions = {
	-- 	healing = 0,
	-- 	mana = 0,
	-- 	stamina = 0
	-- },
}

function rem(amount) 
	return amount * mScaleBase
end

function DoCount() 
	local petSlots = MaxActivePetSlots(this)
	local remainingSlots = GetRemainingActivePetSlots(this)
	local petSlotsTaken = petSlots - remainingSlots

	mTracked = {
		followers = {
			pets = tostring(petSlotsTaken.." / "..petSlots),
			minions = tostring("0 / 3")
		},
		aid = {
			bandages = CountResourcesInContainer(mBackpackObj,"Bandage"),
			bloodybandages = CountResourcesInContainer(mBackpackObj,"BloodyBandage")
		},
		arrows = {
			regular = CountResourcesInContainer(mBackpackObj,"Arrows"),
			--feathered = 0
			ash = CountResourcesInContainer(mBackpackObj,"AshArrows"),
			blight = CountResourcesInContainer(mBackpackObj,"BlightwoodArrows"),
		},
		regs = {
			mandrake = CountResourcesInContainer(mBackpackObj,"Mandrake"),
			bloodmoss = CountResourcesInContainer(mBackpackObj,"Bloodmoss"),
			garlic = CountResourcesInContainer(mBackpackObj,"Garlic"),
			spidersilk = CountResourcesInContainer(mBackpackObj,"Spidersilk"),
			sulfurousash = CountResourcesInContainer(mBackpackObj,"Sulfurousash"),
			nightshade = CountResourcesInContainer(mBackpackObj,"Nightshade"),
			blackpearl = CountResourcesInContainer(mBackpackObj,"Blackpearl"),
			ginseng = CountResourcesInContainer(mBackpackObj,"Ginseng")
		}
	}
	UpdateConsumableWindow()
end


function UpdateConsumableWindow()
	mCONSUME = DynamicWindow("CONSUMABLETRACKER" .. this.Id, "Consumable Tracker", 90, 150, 47, 68, "TransparentDraggable", "TopLeft")
	local PH = GlobalVarReadKey("GlobalPowerHour", "Donations") or 0
	PH = (PH / 2500000) * 100
	PH = tostring(math.round(PH, 2) .. "%")

	if (not(IsDead(this))) then
		local fontname = "PermianSlabSerif_Dynamic_Bold"

		local rsw = rem(4)
		local rsh = rem(2)
		local fontsize = rem(1.6)
		
		mCONSUME:AddLabel(rem(0), 0, tostring(ColorizeAmount("MR", mTracked.regs.mandrake)), rsw, rsh, fontsize, "center", false, true, fontname)
		mCONSUME:AddLabel(rem(3), 0, tostring(ColorizeAmount("SS", mTracked.regs.spidersilk)), rsw, rsh, fontsize, "center", false, true, fontname)
		mCONSUME:AddLabel(rem(6), 0, tostring(ColorizeAmount("GS", mTracked.regs.ginseng)), rsw, rsh, fontsize, "center", false, true, fontname)
		mCONSUME:AddLabel(rem(9), 0, tostring(ColorizeAmount("SA", mTracked.regs.sulfurousash)), rsw, rsh, fontsize, "center", false, true, fontname)
		mCONSUME:AddLabel(rem(0), rem(1.5), tostring(ColorizeAmount("BM", mTracked.regs.bloodmoss)), rsw, rsh, fontsize, "center", false, true, fontname)
		mCONSUME:AddLabel(rem(3), rem(1.5), tostring(ColorizeAmount("GL", mTracked.regs.garlic)), rsw, rsh, fontsize, "center", false, true, fontname)
		mCONSUME:AddLabel(rem(6), rem(1.5), tostring(ColorizeAmount("BP", mTracked.regs.blackpearl)), rsw, rsh, fontsize, "center", false, true, fontname)
		mCONSUME:AddLabel(rem(9), rem(1.5), tostring(ColorizeAmount("NS", mTracked.regs.nightshade)), rsw, rsh, fontsize, "center", false, true, fontname)
		
		local labelwidth = rem(6)
		local labelheight = rem(2)
		local labelfontsize = rem(1.6)
		local datafontsize = rem(1.4)
		local valuewidth = rem(8)

		mCONSUME:AddLabel(rem(1.5), rem(3.5), "ARRW", labelwidth, labelheight, labelfontsize, "center", false, true, fontname)
		mCONSUME:AddLabel(rem(7.5), rem(3.5), "BAND", labelwidth, labelheight, labelfontsize, "center", false, true, fontname)
		
		local arrowcount = tostring(mTracked.arrows.regular .. " / " .. mTracked.arrows.ash .. " / " .. mTracked.arrows.blight)
		local bandicount = tostring(mTracked.aid.bandages .. " : [FBAED2]" .. mTracked.aid.bloodybandages .. "[-]")
		
		mCONSUME:AddLabel(rem(1.5), rem(5), arrowcount, valuewidth, labelheight, datafontsize, "center", false, true, fontname)
		mCONSUME:AddLabel(rem(7.5), rem(5), bandicount, valuewidth, labelheight, datafontsize, "center", false, true, fontname)
		
		mCONSUME:AddLabel(rem(1.5), rem(7), "PETS", labelwidth, labelheight, labelfontsize, "center", false, true, fontname)
		mCONSUME:AddLabel(rem(7.5), rem(7), "G-PH", labelwidth, labelheight, labelfontsize, "center", false, true, fontname)

		mCONSUME:AddLabel(rem(1.5), rem(8.5), mTracked.followers.pets, valuewidth, labelheight, datafontsize, "center", false, true, fontname)
		mCONSUME:AddLabel(rem(7.5), rem(8.5), PH, valuewidth, labelheight, datafontsize, "center", false, true, fontname)
	end

	local next = this:GetObjVar("NextPowerHour")
	local hasNext = next ~= nil
	local now = DateTime.UtcNow
	if (hasNext) then
		canPowerHour = now > next
	else
		canPowerHour = true
	end
	if(canPowerHour) then
		mCONSUME:AddButton(0, 105, "ConfirmPowerHour", "Power Hour!", 90, 24, "", "", false, "Default", "default")
	end
	StatBar()
	this:OpenDynamicWindow(mCONSUME)
end

function ColorizeAmount(what, amount)
	local level = #mWarningLevels
	for i,v in pairs(mWarningLevels) do
		if (amount >= v) then
			level = i
		end
	end
	return "["..mLevelColors[level].."]"..what.."[-]"
end

function UpdateCnx()
	local NOSCNX = DynamicWindow("NOSCNX" .. this.Id, "Server Stats", 600, 60, 0, -14, "Transparent", "BottomLeft")
	local online = GlobalVarRead("User.Online")
	local total = 0
	if (online ~= nil) then
		for user,y in pairs(online) do
			total = total + 1
		end
	end

	if (total < 2) then total = 2 end
	total = tostring(total)
	NOSCNX:AddLabel(18, 0, tostring("[bada55]" .. total .. "[-] players connected // join global chat at: [bada55]nos.gg/discord[-]"), 1000, 20, 18, "left", true, true, "SpectralSC-SemiBold")
	this:OpenDynamicWindow(NOSCNX)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"Hud.UpdateStats")
end

function UpdateAlert()
	local NOSALERT = DynamicWindow("NOSALERT" .. this.Id, "Server Stats", 600, 60, 0, -300, "Transparent", "BottomLeft")
	
	NOSALERT:AddLabel(18, 0, tostring("[ff0000]Alert:[-] Event incoming, COLOR WARS in... "), 1000, 20, 18, "left", true, true, "SpectralSC-SemiBold")
	this:OpenDynamicWindow(NOSALERT)
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"Hud.UpdateStats")
end



function StatBar() 
	mCONSUME:AddStatBar(-20, -35, 129, 7, "Health", "FF0000", this)
	mCONSUME:AddStatBar(-20, -27, 129, 7, "Mana", "3388ff", this)
	mCONSUME:AddStatBar(-20, -19, 129, 7, "Stamina", "fffd52", this)
end

RegisterEventHandler(EventType.Timer, "Hud.UpdateStats", function() 
	-- UpdateAlert()
	UpdateCnx()
	DoCount()
	local alert = this:HasObjVar("AlertActive")
	if (alert ~= nil) then
		-- get "AlertEnds"
	end
end)


RegisterSingleEventHandler(EventType.ModuleAttached, "hud_tracker", UpdateConsumables)

RegisterEventHandler(
			EventType.DynamicWindowResponse,
			"CONSUMABLETRACKER" .. this.Id,
			function(user, buttonId)
				local next = user:GetObjVar("NextPowerHour")
				local hasNext = next ~= nil
				local now = DateTime.UtcNow
				if (hasNext) then
					canPowerHour = now > next
				else
					canPowerHour = true
				end
				if (canPowerHour) then
					ClientDialog.Show {
						TargetUser = user,
						DialogId = "PowerHour" .. user.Id,
						TitleStr = "Start Power Hour",
						DescStr = string.format("Are you ready to begin your power hour? You will only be able to use it again after 22 hours passes."),
						Button1Str = "Yes",
						Button2Str = "No",
						ResponseObj = user,
						ResponseFunc = function(user, buttonId)
							local buttonId = tonumber(buttonId)
							if (user == nil or buttonId == nil) then
								return
							end
							if (buttonId == 0) then
								user:SetObjVar("NextPowerHour", DateTime.UtcNow:Add(TimeSpan.FromHours(22)))
								user:SendMessage("StartPowerHour")
								ShowStatusElement(user,{IsSelf=true,ScreenX=10,ScreenY=10})
								return
							end
						end
					}
				else 
					user:SystemMessage("You cannot power hour quite yet.")
				end
				
				return
			end
		)

--[[

	Reg/ammo/pet/minion/bandage

Events to listen to...

]]--