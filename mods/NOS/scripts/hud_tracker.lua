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
	return
end

function UpdateConsumableWindow()
	DoCount()

	local CONSUME = DynamicWindow("CONSUMABLETRACKER" .. this.Id, "Consumable Tracker", 90, 150, 45, 70, "Transparent", "TopLeft")

	local fontname = "PermianSlabSerif_Dynamic_Bold"

	local rsw = rem(4)
	local rsh = rem(2)
	local fontsize = rem(1.6)
	
	CONSUME:AddLabel(rem(0), 0, tostring(ColorizeAmount("MR", mTracked.regs.mandrake)), rsw, rsh, fontsize, "center", false, true, fontname)
	CONSUME:AddLabel(rem(3), 0, tostring(ColorizeAmount("SS", mTracked.regs.spidersilk)), rsw, rsh, fontsize, "center", false, true, fontname)
	CONSUME:AddLabel(rem(6), 0, tostring(ColorizeAmount("GS", mTracked.regs.ginseng)), rsw, rsh, fontsize, "center", false, true, fontname)
	CONSUME:AddLabel(rem(9), 0, tostring(ColorizeAmount("SA", mTracked.regs.sulfurousash)), rsw, rsh, fontsize, "center", false, true, fontname)
	CONSUME:AddLabel(rem(0), rem(1.5), tostring(ColorizeAmount("BM", mTracked.regs.bloodmoss)), rsw, rsh, fontsize, "center", false, true, fontname)
	CONSUME:AddLabel(rem(3), rem(1.5), tostring(ColorizeAmount("GL", mTracked.regs.garlic)), rsw, rsh, fontsize, "center", false, true, fontname)
	CONSUME:AddLabel(rem(6), rem(1.5), tostring(ColorizeAmount("BP", mTracked.regs.blackpearl)), rsw, rsh, fontsize, "center", false, true, fontname)
	CONSUME:AddLabel(rem(9), rem(1.5), tostring(ColorizeAmount("NS", mTracked.regs.nightshade)), rsw, rsh, fontsize, "center", false, true, fontname)
	
	local labelwidth = rem(6)
	local labelheight = rem(2)
	local labelfontsize = rem(1.6)
	local datafontsize = rem(1.4)

	CONSUME:AddLabel(rem(1.5), rem(3.5), "ARRW", labelwidth, labelheight, labelfontsize, "center", false, true, fontname)
	CONSUME:AddLabel(rem(7.5), rem(3.5), "BAND", labelwidth, labelheight, labelfontsize, "center", false, true, fontname)
	
	local arrowcount = tostring(mTracked.arrows.regular .. " / " .. mTracked.arrows.ash .. " / " .. mTracked.arrows.blight)
	local bandicount = tostring(mTracked.aid.bandages .. " : [FBAED2]" .. mTracked.aid.bloodybandages .. "[-]")
	
	CONSUME:AddLabel(rem(1.5), rem(5), arrowcount, labelwidth, labelheight, datafontsize, "center", false, true, fontname)
	CONSUME:AddLabel(rem(7.5), rem(5), bandicount, labelwidth, labelheight, datafontsize, "center", false, true, fontname)
	
	CONSUME:AddLabel(rem(1.5), rem(7), "PETS", labelwidth, labelheight, labelfontsize, "center", false, true, fontname)
	CONSUME:AddLabel(rem(7.5), rem(7), "FLWR", labelwidth, labelheight, labelfontsize, "center", false, true, fontname)

	CONSUME:AddLabel(rem(1.5), rem(8.5), mTracked.followers.pets, labelwidth, labelheight, datafontsize, "center", false, true, fontname)
	CONSUME:AddLabel(rem(7.5), rem(8.5), mTracked.followers.minions, labelwidth, labelheight, datafontsize, "center", false, true, fontname)

	this:OpenDynamicWindow(CONSUME)
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

function UpdateStatsWindow()
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
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"Hud.UpdateStats")
end

RegisterEventHandler(EventType.Timer, "Hud.UpdateStats", function() 
	UpdateStatsWindow()
	UpdateConsumableWindow()
end)
RegisterSingleEventHandler(EventType.ModuleAttached, "hud_tracker", UpdateStatsWindow)



--[[

	Reg/ammo/pet/minion/bandage

Events to listen to...

]]--