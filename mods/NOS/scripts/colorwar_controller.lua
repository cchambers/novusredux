colorWars = "[FF7F00]COLOR[-] [0000FF]WARS[-]"
mCountdownStart = 3
mCountdownEvery = 1
mOutside = nil
mNeeds = 4
mPlayers = {}
mPlayerCount = 0
mCaptains = {}
mWaiting = 0
mLastTeamPick = nil

mGameController = nil


-- ui
mScaleBase = 10
mScaleIncrease = 0.1
mScaleMin = 8
mScaleMax = 20

function rem(amount) 
	return amount * mScaleBase
end

function OpenRegistration()
    mCountdown = mCountdownStart
    -- TotemGlobalEvent("colorwar")
    GlobalVarDelete("ColorWar.Player", nil)
    GlobalVarWrite(
        "ColorWar.Registration",
        nil,
        function(record)
            record["open"] = true
            return true
        end
    )

    DoBroadcast()
end

function DoBroadcast() 
    if (mCountdown <= 0) then
        ServerBroadcast("Summoning players for " .. colorWars, true)
    elseif(mCountdown > (mCountdownStart / 2)) then
        ServerBroadcast(colorWars.." registration open for the next "..mCountdown.." minutes! To queue, type: /cw", true)
    else
        ServerBroadcast(colorWars.." registration closing soon! "..mCountdown.." minutes remain -> /cw", true)
    end

    mPlayers = GlobalVarRead("ColorWar.Queue")
    local inQueue = 0
    if (mPlayers) then
        for player, t in pairs(mPlayers) do
            if (GlobalVarReadKey("User.Online", player)) then
                inQueue = inQueue + 1
            end
        end
    end
    local nearbyPlayers = FindObjects(SearchPlayerInRange(30))
    if (mCountdown > (mCountdownStart / 3)) then
       
        for i = 1, #nearbyPlayers do
            nearbyPlayers[i]:SystemMessage("If you just got out of "..colorWars.." please requeue (/cw) or you may be ejected!")
        end
    elseif (inQueue < mNeeds) then
        ServerBroadcast("Color Wars cancelled -- not enough entrants.", true)
        CloseRegistration()
        return
    end

    mCountdown = mCountdown - mCountdownEvery
    if (mCountdown >= 0) then 
        this:ScheduleTimerDelay(TimeSpan.FromMinutes(mCountdownEvery), "ColorWar.Broadcast")
    else
        SummonPlayers()
    end
end

function SummonPlayers()
    mPlayers = GlobalVarRead("ColorWar.Queue")
    local count = 0
    for player, t in pairs(mPlayers) do
        if (GlobalVarReadKey("User.Online", player)) then
            player:SetObjVar("ColorWarWaiting", true)
            count = count + 1
            GlobalVarWrite(
                "ColorWar.Player",
                nil,
                function(record)
                    record[this] = true
                    return true
                end
            )
            player:SendMessageGlobal("GlobalSummon", this:GetObjVar("Destination"), this:GetObjVar("RegionAddress"))
            DebugMessage("Summoning " .. player:GetName() .. " for Color Wars.")
        else
            DebugMessage(player:GetName() .. " is no longer online.")
        end
    end
    DebugMessage(tostring("Summoned " .. count .. " players for Color Wars."))

    -- if less than 6 people, extend "OPEN" for 5 mins?
    CloseRegistration()

    CallFunctionDelayed(TimeSpan.FromSeconds(30), PickCaptains)
end

function PickCaptains()
    for player, t in pairs(mPlayers) do
        player:ScheduleTimerDelay(TimeSpan.FromSeconds(15), "ColorWar.Roll")
        player:SystemMessage("Want to be a captain? Time to roll for it! (/roll)", "event")
    end
    this:ScheduleTimerDelay(TimeSpan.FromSeconds(20), "ColorWar.DoCaptains")
    EjectNonPlayers()
end

function DoCaptains()
    mCaptains = {}
    local heads = -1
    local tails = -1

    for player, t in pairs(mPlayers) do
        local roll = player:GetObjVar("ColorWarRoll") or 0
        player:DelObjVar("ColorWarRoll")

        if (roll > heads) then
            if (mCaptains.red) then
                mCaptains.blue = mCaptains.red
                tails = heads
            end
            heads = roll
            mCaptains.red = player
        elseif (roll > tails) then
            tails = roll
            mCaptains.blue = player
        end
    end
    this:SendMessage("ColorWar.MakeCaptains")
end

function MakeCaptains()
    ChoosePlayer(mCaptains.red, 831, true, true)
    CallFunctionDelayed(TimeSpan.FromSeconds(0.25), function () 
        ChoosePlayer(mCaptains.blue, 835, true)
    end)
end

function ChoosePlayer(player, team, captain, firstPick)
    if (player == nil) then
        DebugMessage(tostring("PLAYER NIL " .. team))
        return
    end
    player:SetObjVar("ColorWarTeam", team)
    player:DelObjVar("ColorWarWaiting")
    if (captain) then
        player:SetObjVar("ColorWarCaptain", true)
    end

    if (team == 831) then
        player:SendMessageGlobal("GlobalSummon", this:GetObjVar("e831"), this:GetObjVar("RegionAddress"))
    end

    if (team == 835) then
        player:SendMessageGlobal("GlobalSummon", this:GetObjVar("e835"), this:GetObjVar("RegionAddress"))
    end

    if (firstPick) then
        player:SystemMessage("Choose someone for your team.", "event")
    else
        mLastTeamPick = team
    end
    
    local nearbyPlayers = FindObjects(SearchPlayerInRange(30))
    mWaiting = 0
    for i = 1, #nearbyPlayers do
        if(nearbyPlayers[i]:HasObjVar("ColorWarWaiting")) then
            mWaiting = mWaiting + 1
        end
    end

    DebugMessage(tostring("WAITING: " .. mWaiting))
    
    if (mWaiting == 0) then
        StartRound()
    else
        NextChoice()
    end
end


function NextChoice()
    if (mLastTeamPick == 831) then
        ShowPicker(mCaptains.blue)
    else
        ShowPicker(mCaptains.red)
    end
end

function ShowPicker(user) 
    user:SystemMessage("Choose a player!")
    user:RequestClientTargetGameObj(this, "ColorWar.PlayerChosen")
end

function HandlePlayerChosen(target, user) 
    if( target == nil or target == user or not(IsPlayerCharacter(target))) then
        user:SystemMessage(tostring("Choose someone! There are " .. mWaiting .. " players waiting."), "info") 
        ShowPicker(user)
    elseif (target:HasObjVar("ColorWarTeam")) then 
        user:SystemMessage("Choose someone that isn't already on a team.", "info")
        ShowPicker(user)
    elseif (not(target:HasObjVar("ColorWarWaiting"))) then
        user:SystemMessage("That player was not queued, choose someone else.", "info")
        ShowPicker(user)
    else
       ChoosePlayer(target, user:GetObjVar("ColorWarTeam"))
    end
end

function EjectNonPlayers()
    local nearbyPlayers = FindObjects(SearchPlayerInRange(30))
    for i = 1, #nearbyPlayers do
    local who = nearbyPlayers[i]
        if (not(IsImmortal(who))) then
            if (not(who:HasObjVar("ColorWarWaiting")) and not(who:HasObjVar("ColorWarWaiting"))) then
                who:SystemMessage("You were ejected for failing to queue! Try again later.","info")
                who:SendMessageGlobal("GlobalSummon", this:GetObjVar("outside"), this:GetObjVar("RegionAddress"))
            end
        end
    end
end

function ChooseClass(user)
	if (CheckChar(user) == false) then
        user:SystemMessage("You still have some stuff on your character. BANK IT OR LOSE IT!","info")
        CallFunctionDelayed(TimeSpan.FromSeconds(8),function ()
            ChooseClass(user)
        end)
		return false
	else
		local fontname = "PermianSlabSerif_Dynamic_Bold"
		
		local fontsize = rem(2)

		mCLASS = DynamicWindow("CHOOSECLASS", "Choose Starting Class", 450, 260, 47, 68, "Draggable", "Center")

		mCLASS:AddLabel(75, 10, "RANGER", 110, 30, rem(2), "center", false, true, fontname)
		mCLASS:AddButton(20, 40, "cw_kit_ranger_light", "Ranger (Light)", 110, 24, "Shortbow/Leather", "", true, "Default", "default")
		mCLASS:AddButton(20, 70, "cw_kit_ranger_heavy", "Ranger (Heavy)", 110, 24, "Warbow/Leather", "", true, "Default", "default")
		
		mCLASS:AddLabel(75, 110, "MAGE", 110, 30, rem(2), "center", false, true, fontname)
		mCLASS:AddButton(20, 140, "cw_kit_mage", "Mage", 110, 24, "Staff/Crucible/Cloth", "", true, "Default", "default")

		mCLASS:AddLabel(300, 10, "WARRIOR", 110, 30, rem(2), "center", false, true, fontname)
		
		mCLASS:AddLabel(235, 30, "HEAVY", 110, 30, rem(1.5), "center", false, true, fontname)
		mCLASS:AddLabel(355, 30, "LIGHT", 110, 30, rem(1.5), "center", false, true, fontname)
		
		mCLASS:AddButton(180, 50, "cw_kit_warrior_heavy_bashing", "Bashing", 110, 24, "War Hammer/Plate", "", true, "Default", "default")
		mCLASS:AddButton(180, 80, "cw_kit_warrior_heavy_lancing", "Lancing", 110, 24, "Halberd/Plate", "", true, "Default", "default")
		mCLASS:AddButton(180, 110, "cw_kit_warrior_heavy_slashing", "Slashing", 110, 24, "Great Axe/Plate", "", true, "Default", "default")
		mCLASS:AddButton(180, 140, "cw_kit_warrior_heavy_piercing", "Piercing", 110, 24, "Poniard/Shield/Plate", "", true, "Default", "default")

		mCLASS:AddButton(300, 50, "cw_kit_warrior_light_bashing", "Bashing", 110, 24, "Mace/Shield/Chain", "", true, "Default", "default")
		mCLASS:AddButton(300, 80, "cw_kit_warrior_light_lancing", "Lancing", 110, 24, "Spear/Chain", "", true, "Default", "default")
		mCLASS:AddButton(300, 110, "cw_kit_warrior_light_slashing", "Slashing", 110, 24, "Katana/Shield/Chain", "", true, "Default", "default")
		mCLASS:AddButton(300, 140, "cw_kit_warrior_light_piercing", "Piercing", 110, 24, "Dagger/Shield/Chain", "", true, "Default", "default")
		user:OpenDynamicWindow(mCLASS)
	end
end


function CheckChar(user)
	local success = true
	local items = FindItemsInContainerRecursive(user:GetEquippedObject("Backpack"),
	function (item)
		success = false
		return
	end)

	local RightHand = user:GetEquippedObject("RightHand")
	if (RightHand ~= nil) then success = false end
	local LeftHand = user:GetEquippedObject("LeftHand")
	if (LeftHand ~= nil) then success = false end
	local Chest = user:GetEquippedObject("Chest")
	if (Chest ~= nil) then success = false end
	local Legs = user:GetEquippedObject("Legs")
	if (Legs ~= nil) then success = false end
	local Head = user:GetEquippedObject("Head")
	if (Head ~= nil) then success = false end

	local remainingPets = GetRemainingActivePetSlots(user)
    local maxPets = MaxActivePetSlots(user)
    
    local pets = maxPets - remainingPets
	
	if (pets ~= 0) then
		user:SystemMessage("Stable your pets.","info")
		success = false
	end
	return success
end

function KitConfirm(user, kit)
	if (CheckChar(user) == true) then
		if (kit == nil) then return false end
		local team = user:GetObjVar("ColorWarTeam")
		if (not(user:HasObjVar("HueActual"))) then
			user:SetObjVar("HueActual", user:GetHue())
			user:SetHue(team)
		end

		if (user:HasObjVar("ColorWarCaptain")) then
			if (team == 831) then
				CreateObjInBackpack(user, "cw_flag_red")
			else
				CreateObjInBackpack(user, "cw_flag_blue")
			end
		end

		CreateObjInBackpack(user, kit)

        
        user:SetStatValue("Health", GetMaxHealth(user))
        user:SetStatValue("Mana", 250)
        user:SetStatValue("Stamina", 250)

		user:PlayEffect("ShockwaveEffect")
		user:SetObjVar("ColorWarPlayer", true)
		user:SetObjVar("ColorWarPoints", 0)
		user:SetObjVar("ColorWarKit", kit)
		local charTable = {
			Karma = user:GetObjVar("Karma") or 0,
			Fame = user:GetObjVar("Fame") or 0,
			Murders = user:GetObjVar("Murders") or 0,
			MurderTick = user:GetObjVar("MurderTick") or 0
		}

		user:SetObjVar("StatsActual", charTable)

		CallFunctionDelayed(TimeSpan.FromSeconds(0.25),function ( ... )
			SendToBase(user)
			end)
	else
		user:SystemMessage("You trying to sneak stuff in on me?", "info")
	end
end

function SendToBase(user) 
    local team = user:GetObjVar("ColorWarTeam")
    local destVar = "e" .. team .. "base"
    destVar = this:GetObjVar(destVar)
    user:SendMessageGlobal("GlobalSummon", destVar, this:GetObjVar("GameRegion"))
end

function CloseRegistration()
    GlobalVarDelete("ColorWar.Queue", nil)
    GlobalVarWrite(
        "ColorWar.Registration",
        nil,
        function(record)
            record["open"] = false
            return true
        end
    )
end


function StartRound()
    local nearbyPlayers = FindObjects(SearchPlayerInRange(30))
    for i = 1, #nearbyPlayers do
        if(nearbyPlayers[i]:HasObjVar("ColorWarTeam")) then
            nearbyPlayers[i]:SystemMessage("That's everyone! Hurry to your base, the round begins SOON!", "event")
            ChooseClass(nearbyPlayers[i])
        end
    end

    mGameController = GameObj(68396825)
    mGameController:SendMessageGlobal("ColorWar.StartRound")
    this:ScheduleTimerDelay(TimeSpan.FromMinutes(45),"ColorWar.NoVote")
end

function CheckRoundStarted()
    return
end



function DoRevealStuff()
	mLoc = this:GetLoc()

	local mobiles =
		FindObjects(
		SearchMulti(
			{
				SearchRange(mLoc, 30),
				SearchMobile()
			}
		),
		GameObj(0)
	)
	for i, v in pairs(mobiles) do
        if (HasMobileEffect(v, "Hide")) then
            v:SendMessage("StartMobileEffect", "Revealed")
        end
        if (IsDead(v)) then
			v:SendMessage("Resurrect", 100, this, true)
        end
	end
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"ColorWar.EntryReveal")
end

function VoteStart()
    GlobalVarWrite(
        "ColorWar.Vote",
        nil,
        function(record)
            record["open"] = true
            return true
        end
    )
    ServerBroadcast(colorWars.." vote opened for the next 2 minutes! Should we start up a CW? /cwvote", true)
    this:ScheduleTimerDelay(TimeSpan.FromMinutes(2),"ColorWar.Voting")
    this:ScheduleTimerDelay(TimeSpan.FromMinutes(45),"ColorWar.NoVote")
end

function VoteEnd()
    -- if count > mNeeds
    mPlayers = GlobalVarRead("ColorWar.Queue")
    local count = 0
    for player, t in pairs(mPlayers) do
        if (GlobalVarReadKey("User.Online", player)) then
            count = count + 1
        end
    end
    if (count >= mNeeds - 2) then
        this:SendMessage("ColorWar.Go")
    else
        ServerBroadcast("Color War vote failed. Try again later!", true)
        GlobalVarDelete("ColorWar.Queue", nil)
    end
    GlobalVarWrite(
        "ColorWar.Vote",
        nil,
        function(record)
            record["open"] = false
            return true
        end
    )
end

RegisterEventHandler(EventType.Timer, "ColorWar.EntryReveal", DoRevealStuff)
this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"ColorWar.EntryReveal")

RegisterEventHandler(EventType.Message, "ColorWar.Eject", EjectNonPlayers)
RegisterEventHandler(EventType.Message, "ColorWar.Go", OpenRegistration)
RegisterEventHandler(EventType.Message, "ColorWar.NextChoice", NextChoice)
RegisterEventHandler(EventType.Message, "ColorWar.MakeCaptains", MakeCaptains)
RegisterEventHandler(EventType.Message, "ColorWar.StartRound", StartRound)
RegisterEventHandler(EventType.Message, "ColorWar.VoteStart", VoteStart)

RegisterEventHandler(EventType.Timer, "ColorWar.Broadcast", DoBroadcast)
RegisterEventHandler(EventType.Timer, "ColorWar.PickCaptains", PickCaptains)
RegisterEventHandler(EventType.Timer, "ColorWar.DoCaptains", DoCaptains)
RegisterEventHandler(EventType.Timer, "ColorWar.Voting", VoteEnd)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "ColorWar.PlayerChosen", HandlePlayerChosen)
RegisterEventHandler(EventType.DynamicWindowResponse, "CHOOSECLASS",
			function(user, buttonId)
				if (buttonId ~= nil and buttonId ~= "") then
					KitConfirm(user, buttonId)
                else
                    ChooseClass(user)
                end
				return
			end
		)


RegisterEventHandler(
    EventType.Message,
    "ColorWar.Queue",
    function(args)
        local user = args.user

        for index, char in pairs(mQueue) do
            if (char == user) then
                table.remove(mQueue, index)
                DebugMessage("De-queued " .. user:GetName() .. " for Color Wars.")
                user:SendMessageGlobal("ColorWar.Exit")
                return
            end
        end

        table.insert(mQueue, user)
        DebugMessage("Queued " .. user:GetName() .. " for Color Wars.")
        user:SendMessageGlobal("ColorWar.Enter")
    end
)
