--- Get the Karma for a mobile
-- @param mobile(mobileObj)
-- @return Amount of Karma the mobile has(number), 0 if Karma is not set
function GetKarma(mobile)
    Verbose("Karma", "GetKarma", mobile)
    if ( mobile == nil ) then
        LuaDebugCallStack("[Karma] Nil mobile provided to GetKarma()")
        return
    end
    -- important npcs are off the charts.
    if ( mobile:HasObjVar("ImportantNPC") ) then return 100000 end

    return mobile:GetObjVar("Karma") or 0
end

--- Set a mobiles karma to an exact amount, does not adjust.
-- @param mobile(mobileObj)
-- @param amount(number) The exact number to set their Karma too
-- @return none
function SetKarma(mobile, amount)
    Verbose("Karma", "SetKarma", mobile, amount)
    if ( mobile == nil ) then
        LuaDebugCallStack("[Karma] Nil mobile provided to SetKarma()")
        return
    end
    -- prevent players from ever having 0 karma (so they are never neutral since it's reserved for NPCs)
    if ( amount == 0 and IsPlayerCharacter(mobile) ) then amount = 1 end
    mobile:SetObjVar("Karma", amount)
end

--- Convert an amount of karma gained/lost to a string representation
-- @param amount(number)
-- @return string amount
function GetKarmaStringAmount(amount)
    Verbose("Karma", "GetKarmaStringAmount", amount)
    if ( amount < 10 ) then
        return " a little "
    elseif ( amount < 50 ) then
        return " some "
    elseif ( amount < 100 ) then
        return " "
    elseif ( amount < 1000 ) then
        return " a lot of "
    else
        return " a substantial amount of "
    end
end

--- Adjust the karma for a mobile, a system message pertaining to the change is sent.
-- @param mobile(mobileObj)
-- @param amount(number) The amount to adjust by.
-- @return none
function AdjustKarma(mobile, amount)
    Verbose("Karma", "AdjustKarma", mobile, amount)
    if ( amount == 0 or amount == nil ) then return end
    local karma = GetKarma(mobile)
    -- cache the karma level so we can check if it changed.
    local karmaLevel = GetKarmaLevel(karma)

    karma = math.floor(karma + amount + 0.5)
    SetKarma(mobile, karma)

    if ( amount > 0 ) then
        mobile:NpcSpeech(string.format("[00FF00]+%d karma[-]", amount), "combat")
        --mobile:SystemMessage("You have gained"..GetKarmaStringAmount(amount).."karma.", "info")
    else
        mobile:NpcSpeech(string.format("[FF0000]%d karma[-]", amount), "combat")
        --mobile:SystemMessage("You have lost"..GetKarmaStringAmount(math.abs(amount)).."karma.", "info")
    end

    local newKarmaLevel = GetKarmaLevel(karma)
    if ( karmaLevel.Name ~= newKarmaLevel.Name ) then
        -- Karma was changed, update the name and whatever else, maybe a message?
        if ( newKarmaLevel.DisallowAllegiance ) then AllegianceRemovePlayer(mobile) end
        mobile:SystemMessage("Your alignment is now "..newKarmaLevel.Name, "event")
        -- update the name
        mobile:SendMessage("UpdateName")
        -- update all pets
        ForeachActivePet(mobile, function(pet)
            pet:SetObjVar("Karma", karma)
            pet:SendMessage("UpdateName")
        end, true)

        --Taking opposite achievement type for karma check for title
        local oppositeAchievementType = nil

        if (IsPlayerCharacter(mobile)) then
            if ( amount > 0 ) then
                oppositeAchievementType = "KarmaBad"
                CheckAchievementStatus(mobile, "PvP", "KarmaGood",karma, {TitleCheck = "Karma"}, "Karma")
            else
                oppositeAchievementType = "KarmaGood"
                CheckAchievementStatus(mobile, "PvP", "KarmaBad",karma * -1, {TitleCheck = "Karma"}, "Karma")
            end
        end

        --Check if we can still use karma title if we are using one right now
        CheckTitleRequirement(mobile, oppositeAchievementType)
    end
end

--- convenience function to alter a karma action's amount before applying it
-- @param karmaAction Lua table karma action
-- @param newAmount(number)
-- @return the altered karma action
function AlterKarmaAction(karmaAction, newAmount)
    Verbose("Karma", "AlterKarmaAction", karmaAction, newAmount)
    karmaAction = deepcopy(karmaAction)
    karmaAction.Adjust = newAmount
    return karmaAction
end

--- Get the karma level data table for the given amount of karma.
-- @param karma(number) return value of GetKarma()
-- @return KarmaLevelData(luaTable) from ServerSettings.Karma.Levels
function GetKarmaLevel(karma)
    Verbose("Karma", "GetKarmaLevel", karma)
    karma = karma or 0
    local ss = ServerSettings.Karma.Levels
    if ( karma < 0 ) then
        -- negative karma
        for i=1,#ss do
            local ii = #ss - i + 1
            if ( karma <= ss[ii].Amount ) then return ss[ii] end
        end
        -- default to outcast.
        return ss[#ss]
    else
        -- positive karma
        for i=1,#ss do
            if ( karma >= ss[i].Amount ) then return ss[i] end
        end
        -- default to best
        return ss[1]
    end
end

function GetKarmaTitle(mobile)
    local karmaValue = GetKarma(mobile)
    local karmaLevel = GetKarmaLevel(karmaValue)

    return karmaLevel.Title, karmaValue
end

--- Calculate the amount of karma to adjust, also if initiate should end or not, this does not perform any edits and is simply a 'dry run' of Karma actions
-- @param mobileA the mobile that is performing the karma action
-- @param karmaAction(table) The KarmaActions.Positive/KarmaActions.Negative for the action.
-- @param mobileB(mobileObj)(optional) The mobile that the karma action is being performed on(if any)
-- @return amount or nil, endInitiate(boolean)
function CalculateKarmaAction(mobileA, action, mobileB)
	Verbose("Karma", "ExecuteKarmaAction", mobileA, action, mobileB)
    if ( mobileA == nil ) then
        LuaDebugCallStack("[Karma] Nil mobileA provided, need at least one mobile for a karma action.")
        return 0
    end
    if ( action == nil ) then
        LuaDebugCallStack("[Karma] Nil action supplied.")
        return 0
    end
    if ( action.Adjust == nil ) then
        LuaDebugCallStack("[Karma] Supplied action without 'Adjust', this karma action is invalid until resolved.")
        return 0
    end

    -- no reason to continue if this is a zero action (sometimes useful to skip karma actions entierly)
    if ( action.Adjust == 0 ) then return 0 end

    -- if mobileB is passed, ensure mobileA is not mobileB and mobileB is in the same region.
    if ( mobileB ~= nil and (mobileB == mobileA or not mobileB:IsValid()) ) then return 0 end
    
    -- karma adjustments can only be applied to players
    if not( IsPlayerCharacter(mobileA) ) then return 0 end

    -- disable all positive karma gains for negative alignments
    if ( action.Adjust > 0 ) then
        local karmaAlignment = GetKarmaAlignment(mobileA)
        if ( karmaAlignment and (karmaAlignment.Amount or 0) < 0 ) then return 0 end
    end

    local karmaA = GetKarma(mobileA)

    -- if they cannot be affected by this karma action any further, stop here.
    if ( action.Adjust < 0 ) then
        if ( action.UpTo and karmaA < action.UpTo ) then return 0 end
    else
        if ( action.UpTo and karmaA > action.UpTo ) then return 0 end
    end

    -- ensure they are both within the karma area.
    if ( not WithinKarmaArea(mobileA) and (mobileB ~= nil and not WithinKarmaArea(mobileB)) ) then
        return 0
    end

    local isPlayerB = false
    local isPetB = false
    local karmaB = 0

    -- setup mobileB if supplied
    if ( mobileB ~= nil ) then
        -- if range condition, ensure it's met
        if ( action.Range and mobileA:DistanceFrom(mobileB) > action.Range ) then
            return 0
        end
        
        -- explicitly stop all karma actions on your own pets/followers.
        local owner = mobileB:GetObjVar("controller")
        if ( mobileA == owner ) then return 0 end
        isPlayerB, isPetB = IsPlayerObject(mobileB), IsPet(mobileB)
        if ( owner and owner:IsValid() and not IsPossessed(mobileB)) then mobileB = owner end
        karmaB = GetKarma(mobileB)
    end

    if ( isPlayerB ) then
        -- non beneficial actions cannot affect karma when both players have consented.
        if ( not action.Beneficial and ShareKarmaGroup(mobileA, mobileB) ) then return 0 end

        -- players in opposing factions cannot affect each other's karma
        if ( Allegiance.InOpposing(mobileA, mobileB) ) then return 0 end
    end
    
    local pvpMod = 1
    local negativeAdjustMod = 1
    local npcMod = 1
    local petMod = isPetB and action.PetModifier or 1

    local endInitiate = false
    -- handle negative karma actions
    if ( action.Adjust < 0 ) then

        local karmaALevel = nil
        if ( mobileB ~= nil ) then

            -- check conflict
            if ( not action.Beneficial ) then
                if ( IsAggressorTo(mobileB, mobileA) ) then
                    --victim/defender karma action against aggressor, this is free.
                    return 0
                end
            end

            local karmaBLevel = GetKarmaLevel(karmaB)
            if ( isPlayerB ) then
                if ( action.Beneficial ) then
                    -- it's ok to benefit this karma level
                    if not( karmaBLevel.PunishBeneficialToPlayer ) then return 0 end
                else
                    -- if guards don't protect them, always free.
                    if not( karmaBLevel.GuardProtectPlayer ) then return 0 end
                end
                -- determine their player vs player modifiers
                karmaALevel = GetKarmaLevel(karmaA)
                -- set the pvp mod
                if ( action.Beneficial ) then
                    -- karma levels that are punishing to benefit don't give punishment when both are in the same level
                    if ( karmaALevel.Amount == karmaBLevel.Amount ) then return 0 end
                    pvpMod = karmaBLevel.BenefitModifier or 0
                else
                    -- chaotically aligned players cannot be punished for negative actions on one other.
                    if ( ChaoticallyAligned(karmaALevel, karmaBLevel, mobileB) ) then return 0 end
                    pvpMod = karmaALevel.PvPMods[karmaBLevel.Name]
                end
                -- if the action its self has a pvp mod, it's a mod to the normal pvp mod
                if ( action.PvPMods and action.PvPMods[karmaBLevel.Name] ) then
                    pvpMod = pvpMod * action.PvPMods[karmaBLevel.Name]
                end
                if ( pvpMod == 0 ) then return 0 end
                -- anytime an initiate gets to this point, we remove their intiate status (if the action says to)
                if ( action.EndInitiate and IsInitiate(mobileA) ) then endInitiate = true end
            else

                if ( action.Beneficial ) then
                    if ( karmaBLevel.PunishBeneficialToNPC ~= true ) then return 0 end
                    karmaALevel = GetKarmaLevel(karmaA)
                    if ( karmaALevel.Amount == karmaBLevel.Amount ) then return 0 end
                else
                    -- if guards don't protect them, always free.
                    if not( karmaBLevel.GuardProtectNPC ) then return 0 end
                end
                if ( action.NpcModifier ~= nil ) then
                    -- if mobileB is not a player, modify as such
                    npcMod = action.NpcModifier
                end
            end

        end
        
        -- determine the negative karma adjust mod
        karmaALevel = karmaALevel or GetKarmaLevel(karmaA)
        negativeAdjustMod = karmaALevel.NegativeKarmaAdjustMod
    
    else
        -- handle positive karma actions

    end

    --[[
    DebugMessage("--Execute Karma Action--")
    DebugMessage("Adjust: "..action.Adjust)
    DebugMessage("pvpMod: "..pvpMod)
    DebugMessage("negMod: "..negativeAdjustMod)
    DebugMessage("npcMod: "..npcMod)
    ]]

    local adjust = action.Adjust * pvpMod * negativeAdjustMod * npcMod * petMod

    -- prevent positive actions from going negative
    if ( action.Adjust > 0 and adjust < 0 ) then return 0 end
    -- prevent negative actions from going positive
    if ( action.Adjust < 0 and adjust > 0 ) then return 0 end

    -- finally return all the calculated karma
    return adjust, endInitiate
end

function ChaoticallyAligned(karmaALevel, karmaBLevel, mobileB)
    Verbose("Karma", "ChaoticallyAligned", karmaALevel, karmaBLevel, mobileB)
    -- chaotic / temp chaotic
    if ( karmaALevel.IsChaotic and mobileB:HasObjVar("IsChaotic") ) then
        return true
    else
        if not( karmaBLevel ) then
            karmaBLevel = GetKarmaLevel(GetKarma(mobileB))
        end
        -- chaotic / chaotic for realzies
        if ( karmaALevel.IsChaotic and karmaBLevel.IsChaotic ) then
            return true
        else
            -- non-chaotic to chaotic
            return ( karmaALevel.Amount > karmaBLevel.Amount and not karmaALevel.IsChaotic and karmaBLevel.IsChaotic )
        end
    end
    return false
end

--- Perform the actual karma handling for a karma action, will adjust mobileA's karma appropriately(if at all) for the given action.
-- @param mobileA the mobile that is performing the karma action
-- @param karmaAction(table) The KarmaActions.Positive/KarmaActions.Negative for the action.
-- @param mobileB(mobileObj)(optional) The mobile that the karma action is being performed on(if any)
-- @return none
function ExecuteKarmaAction(mobileA, action, mobileB)
    Verbose("Karma", "ExecuteKarmaAction", mobileA, action, mobileB)

    if (mobileB ~= nil) then
        local owner = mobileB:GetObjVar("controller")
        if ( owner and (owner == mobileA) ) then return 0 end
        if ( ShareKarmaGroup(mobileA, mobileB) ) then return 0 end
        if ( Allegiance.InOpposing(mobileA, mobileB) ) then return 0 end
    end

    if (action == KarmaActions.Negative.Murder) then -- and IsPlayerCharacter(aggressor)?
        local aggressor = mobileA
        local victim = mobileB
        local murders = aggressor:GetObjVar("Murders") or 0
        murders = murders + 1
        aggressor:SetObjVar("Murders", murders)
        aggressor:SendMessage("StartMobileEffect", "Chaotic")
        if (not(HasMobileEffect(aggressor, "Murderer"))) then
            aggressor:SendMessage("StartMobileEffect", "Murderer")
        end
        -- KHI TOTEM
        -- aggressor:SendMessage("Totem", "Murder")
    end

    local adjust, endInitiate = CalculateKarmaAction(mobileA, action, mobileB)

    if ( endInitiate ) then EndInitiate(mobileA) end

    if (IsPlayerCharacter(mobileA)) then
        if (action.MakeCriminal == true
        and IsPlayerObject(mobileB)
        and not(mobileB:HasObjVar("IsRed") or mobileB:HasObjVar("IsCriminal"))) then 
            mobileA:SendMessage("StartMobileEffect", "Criminal")
        end
    end
    if ( adjust and adjust ~= 0 ) then
        -- finally apply all the calculated karma
        AdjustKarma(mobileA, adjust)
        if ( action.ClearConflicts ) then
            ClearConflicts(mobileA, mobileB)
        end
    end
end

--- Check when a player performs a beneficial action on a mobile(player/npc/etc)
-- @param player(playerObj) DOES NOT ENFORCE IsPlayerCharacter()
-- @param target(mobileObj) Anything with a karma level
-- @return none
function CheckKarmaBeneficialAction(player, target)
    Verbose("Karma", "CheckKarmaBeneficialAction", player, target)
    local owner = target:GetObjVar("controller")
    if ( owner and owner:IsValid() ) then target = owner end
    -- can't get in trouble for benefiting yourself or your pets
    if ( player == target ) then return end
    -- beneficial actions are only bad against some
    local targetKarmaLevel = GetKarmaLevel(GetKarma(target))
    local isTargetPlayer = IsPlayerCharacter(target)
    if (
        (isTargetPlayer and targetKarmaLevel.PunishBeneficialToPlayer )
        or
        (not isTargetPlayer and targetKarmaLevel.PunishBeneficialToNPC)
    ) then
        ExecuteKarmaAction(player, KarmaActions.Negative.PunishForBeneficial, target)
    end

    -- flag chaotic for beneficial actions if it's a blue healing a blue
    if ( isTargetPlayer and target:HasObjVar("IsChaotic") ) then
        -- only if player is not 'for-realzies' chaotic
        if not( GetKarmaLevel(GetKarma(player)).IsChaotic ) then
            player:SendMessage("StartMobileEffect", "Chaotic")
        end
    end
end

--- Returns true if the player should be karma protected from performing an action on target that would lower player's Karma
-- @param player
-- @param action - The Karma Action to Protect against
-- @param target - The Target of the action
-- @param silent - If true, no user messages will be sent to inform player
-- @return true or false
function ShouldKarmaProtect(player, action, target, silent)
    -- Verbose("Karma", "ShouldKarmaProtect", player, action, target, silent)
    -- if not( player ) then
    --     LuaDebugCallStack("[ShouldKarmaProtect] player not provided.")
    --     return
    -- end
    -- if not( action ) then
    --     LuaDebugCallStack("[ShouldKarmaProtect] action not provided.")
    --     return
    -- end
    -- if not( target ) then
    --     LuaDebugCallStack("[ShouldKarmaProtect] target not provided.")
    --     return
    -- end

    -- -- if the action is not negative, no reason to protect
    -- if ( action.Adjust >= 0 ) then return false end

    -- local karmaAlignment = GetKarmaAlignment(player)
    -- -- no protection level set or karma level doesn't need to be protected
    -- if ( karmaAlignment == nil or karmaAlignment.Protect == nil ) then return false end

    -- local amount, endInitiate = CalculateKarmaAction(player, action, target)
    -- -- attacking also adds the cost of murder for example
    -- if ( action.PreventAdditional ) then
    --     amount = amount + CalculateKarmaAction(player, KarmaActions.Negative[action.PreventAdditional], target)
    -- end
    -- -- if they would not lose karma for this action, no protection necessary.
    -- if ( amount >= 0 ) then return false end

    -- if (
    --     -- protect losing any karma if karmaAlignment is set to a level above zero
    --     karmaAlignment.Amount > 0 and amount < 0
    --     or
    --     -- protect from losing a karma level if would-be new amount is less than the protectionAmount
    --     GetKarma(player) + amount < karmaAlignment.Protect
    -- ) then
    --     -- then karma protect them.
    --     if ( not silent and not player:HasTimer("KarmaWarned")  ) then
    --         player:ScheduleTimerDelay(ServerSettings.Karma.MinimumBetweenNegativeWarnings, "KarmaWarned")
    --         if ( karmaAlignment.Amount > 0 ) then
    --             player:SystemMessage("That action would cause you to lose Karma.", "info")
    --         else
    --             player:SystemMessage("That action would cause you to drop below your chosen Karma Alignment.", "info")
    --         end
    --     end
    --     return true
    -- end
    return false
end

--- Prevent a guard protected non-chaotic karma level player from accidently flagging chaotic from attack/aoe on a chaotic karma level
-- @param player - PlayerObj, DOES NOT ENFORCE PLAYER but this should be a player.
-- @param target - PlayerObj, DOES NOT ENFORCE PLAYER but this should be a player.
-- @param beneficial - boolean, is this a beneficial action? Also applies to temp chaotic
-- @param silent - boolean, give the user the action to bypass the protection
function ShouldChaoticProtect(player, target, beneficial, silent)
    if not( player ) then
        LuaDebugCallStack("[ShouldChaoticProtect] player not provided.")
        return false
    end
    if not( target ) then
        LuaDebugCallStack("[ShouldChaoticProtect] target not provided.")
        return false
    end

    if ( IsImmortal(player) and not TestMortal(player) ) then return false end
    
    if ( 
        -- players already temp chaotic don't need to be protected.
        player:HasObjVar("IsChaotic")
        or
        -- doesn't matter against NPCs
        not IsPlayerCharacter(player)
        or
        not IsPlayerObject(target)
        or
        -- allegiances do not affect order.
        Allegiance.InOpposing(player, target)
        or
        -- sharing karma groups ignores order flag
        ShareKarmaGroup(player, target)
        or
        -- not protected from defending against aggressors
        ( not beneficial and IsAggressorTo(target, player) )
    ) then return false end

    local playerKarmaLevel = GetKarmaLevel(GetKarma(player))
    if (
        -- if the 'attacking' player is already chaotic
        playerKarmaLevel.IsChaotic
        -- or if the 'attacking' player isn't guard protected (example: outcast)
        or
        not playerKarmaLevel.GuardProtectPlayer
    ) then return false end -- then end here

    local targetKarmaLevel = GetKarmaLevel(GetKarma(target))
    if ( beneficial ) then
        -- if target is not real chaotic or temp chaotic
        if ( not targetKarmaLevel.IsChaotic and not target:HasObjVar("IsChaotic") ) then
            return false -- then end here
        end
    else
        -- if target is not real chaotic
        if not( targetKarmaLevel.IsChaotic ) then
            return false -- then end here
        end
    end
    
    player:SendMessage("StartMobileEffect", "Chaotic")
    return false

    -- -- inform and give action to bypass
    -- if ( not silent and not player:HasTimer("ChaoticWarning") ) then
    --     if ( player:HasObjVar("ForceOrderOptIn") ) then
    --         -- automatically flag them
    --         player:SendMessage("StartMobileEffect", "Chaotic")
    --         return false
    --     else
    --         player:ScheduleTimerDelay(ServerSettings.Karma.ChaoticWarningTimespan, "ChaoticWarning")

    --         local dynWindow = DynamicWindow(
    --             "OrderOptIn", --(string) Window ID used to uniquely identify the window. It is returned in the DynamicWindowResponse event.
    --             "", --(string) Title of the window for the client UI
    --             263, --(number) Width of the window
    --             332, --(number) Height of the window
    --             -131, --startX, --(number) Starting X position of the window (chosen by client if not specified)
    --             60, --startY, --(number) Starting Y position of the window (chosen by client if not specified)
    --             "Transparent",--windowType, --(string) Window type (optional)
    --             "Top" --windowAnchor --(string) Window anchor (default "TopLeft")
    --         )

    --         dynWindow:AddImage(0,0,"ShieldBackground")
    --         dynWindow:AddLabel(131,100,"Fight for Order?",140,80,28,"center",false,true)
    --         dynWindow:AddLabel(131,152,GetTimerLabelString(ServerSettings.Karma.ChaoticWarningTimespan,true),0,0,18,"center")
    --         dynWindow:AddButton(20,200,"","Continue",100,32,"","orderoptin")
    --         dynWindow:AddButton(142,200,"","Cancel",100,32)
    --         dynWindow:AddButton(119,240,"","",0,0,"Attacking a chaotic player makes you attackable to ALL chaotic players with no karma penalty for 5 minutes.","",false,"Help")

    --         player:OpenDynamicWindow(dynWindow)
    --     end
    -- end

    -- return true -- protect them from aggressive
end

--- Set the player's karma alignment to a karma level, allowing them to do bad deeds up to a point and no further
-- @param player
-- @param level - deletes alignment if not set
function SetKarmaAlignment(player, level)
    if not( player ) then
        LuaDebugCallStack("[SetKarmaAlignment] player not provided.")
        return
    end
    if ( level == nil ) then
        player:DelObjVar("KarmaAlignment")
        -- clear it
        player:SetObjVar("Karma", -1)
        player:SendMessage("UpdateName")
        ForeachActivePet(player, function(pet)
            pet:SetObjVar("Karma", -1)
            pet:SendMessage("UpdateName")
        end, true)
    else
        player:SetObjVar("KarmaAlignment", level)
        if ( (ServerSettings.Karma.Levels[level].Amount or 0) < 0 and GetKarma(player) > 0 ) then
            -- clear it
            player:SetObjVar("Karma", -1)
            player:SendMessage("UpdateName")
            ForeachActivePet(player, function(pet)
                pet:SetObjVar("Karma", -1)
                pet:SendMessage("UpdateName")
            end, true)
            player:SendMessage("EndChaoticEffect") -- end the temp chaotic, they are real chaotic now.
        end
    end
end

--- Get the karma level a player is aligned with
-- @param player
-- @return karma level the player should never go under
function GetKarmaAlignment(player)
    if not( player ) then
        LuaDebugCallStack("[GetKarmaAlignment] player not provided.")
        return ServerSettings.Karma.Levels[1] -- default to strongest protection
    end
    local protectionLevel = player:GetObjVar("KarmaAlignment")
    if ( protectionLevel == nil ) then return nil end -- alignment not set
    return ServerSettings.Karma.Levels[protectionLevel]
end

--- Get the name of the level a player is aligned with
-- @param player
-- @return amount of karma the player should never go under
function GetKarmaAlignmentName(player)    
    local karmaAlignment = GetKarmaAlignment(player)
    if ( karmaAlignment == nil ) then return nil end -- alignment not set
    if (player:HasObjVar("IsRed")) then
        return "Murderer"
    end
    return karmaAlignment.AlignmentName or ""
end

--- Get the name of the level a player is aligned with
-- @param player
-- @return amount of karma the player should never go under
function GetKarmaLevelFromAlignmentName(alignment)    
    for i,karmaInfo in pairs(ServerSettings.Karma.Levels) do
        if(karmaInfo.AlignmentName == alignment) then
            return i, (karmaInfo.Amount or 0)
        end
    end
end

--- Check player against a container on a loot (item removed from a container)
-- @param player(playerObj) Player doing the looting
-- @param container(Container) Container being looted from (mobileB:TopmostContainer())
-- @return false if should prevent, nil otherwise
function CheckKarmaLoot(player, container)
    Verbose("Karma", "CheckKarmaLoot", player, container)
    if ( container == nil ) then
        LuaDebugCallStack("[CheckKarmaLoot] Nil container provided.")
        return false
    end
    if ( container:IsPermanent() ) then return end
    -- can't get in trouble doing stuff to yourself..
    if ( player == container ) then return end
    -- only mobiles supported right now
    if not( container:IsMobile() ) then return end
    -- can't get in trouble doing stuff to your pets
    if ( player == container:GetObjVar("controller") ) then return end

    if ( IsPlayerCharacter(container) ) then
        -- can't get in trouble looting your own corpse
        if ( player == container:GetObjVar("BackpackOwner") ) then return end
        if ( 
            -- disallow looting in protected areas.
            IsGuaranteedProtected(container, player)
            or
            -- prevent accidental flagging chaotic (order)
            ShouldChaoticProtect(player, container)
            or
            -- prevent losing karma if set to and would
            ShouldKarmaProtect(player, KarmaActions.Negative.LootPlayerContainer, container) 
        ) then return false end
        -- if looting a player owned container that's not theirs, execute negative action
        ExecuteKarmaAction(player, KarmaActions.Negative.LootPlayerContainer, container)
        return
    else
        -- the container is not tagged by the player, therefor the player doesn't have the right to loot.
        if ( IsMobTaggedBy(container, player) == false ) then

            local tag = container:GetObjVar("Tag") -- the player(s) to lose karma against (the winners)
            local wronged, wrongedAmount = nil, 0
            -- loop all winners, stopping on first one we'd lose karma against
            for winner,bool in pairs(tag) do
                if ( winner and winner:IsValid() ) then
                    local amount, endInitiate = CalculateKarmaAction(player, KarmaActions.Negative.LootUnownedKill, winner)
                    if ( amount < wrongedAmount ) then
                        wrongedAmount = amount
                        wronged = winner
                        break
                    end
                end
            end

            if ( wronged and wrongedAmount < 0 ) then
                -- if karma is protected
                local karmaAlignment = GetKarmaAlignment(player)
                if ( karmaAlignment ~= nil and karmaAlignment.Protect ~= nil and karmaAlignment.Protect >= 0 ) then
                    if not( player:HasTimer("KarmaWarned") ) then
                        player:ScheduleTimerDelay(ServerSettings.Karma.MinimumBetweenNegativeWarnings, "KarmaWarned")
                        local groupId = GetGroupId(player)
                        if ( groupId ~= nil and wronged:GetObjVar("TagGroup") == groupId ) then
                            player:SystemMessage("Not your turn, looting would cause karma loss.", "info")
                        else
                            player:SystemMessage("That is not your kill, looting would cause karma loss.", "info")
                        end
                    end
                    return false -- protect them
                end
                ExecuteKarmaAction(player, KarmaActions.Negative.LootUnownedKill, wronged)
            end
            
        end
    end
end

--- Anyone that is an aggressor to the victim will have a Murder Karma action executed on them.
-- @param victim(mobileObj)
-- @return none
function KarmaPunishAllAggressorsForMurder(victim)
    Verbose("Karma", "KarmaPunishAllAggressorsForMurder", victim)
    local aggressors = victim:GetObjVar("MurdererForgive") or {}
    ForeachAggressor(victim, function(aggressor)
        if ( victim ~= aggressor and aggressor:IsValid()) then
            if (victim:IsPlayer() and not(victim:HasObjVar("IsCriminal") or victim:HasObjVar("IsRed"))) then
                table.insert(aggressors, aggressor)
                ExecuteKarmaAction(aggressor, KarmaActions.Negative.Murder, victim)
            end
		end
    end)
    CallFunctionDelayed(TimeSpan.FromSeconds(1),function ( ... )
        victim:SetObjVar("MurdererForgive", aggressors)
    end)
end



--- Colorize a mobile name dependant on their karma
-- @param mobile(mobileObj) the mobile used to decide the name color
-- @param newName(string) The name to be colorized
-- @return colorized newName(string)
function ColorizeMobileName(mobile, newName)
    Verbose("Karma", "ColorizeMobileName", mobile, newName)
    if ( mobile == nil ) then
        LuaDebugCallStack("[Karma] Nil mobile supplied to ColorizeMobileName")
        return newName
    end

    local color = nil

    if ( mobile:HasObjVar("ImportantNPC") ) then
        color = "F2F5A9"
    else
        color = GetKarmaLevel(GetKarma(mobile)).NameColor
    end

    if (mobile:HasObjVar("IsCriminal")) then color = "C0C0C0" end
    if (mobile:HasObjVar("IsRed")) then color = "FF0000" end

	return string.format("[%s]%s[-]", color, newName)
end

--- Colorize a player's name dependant on their karma
-- @param player(mobileObj) the playerObj used to decide the name color
-- @param newName(string) The name to be colorized
-- @return colorized newName(string)
function ColorizePlayerName(player, newName)
    Verbose("Karma", "ColorizePlayerName", player, newName)
    if ( player == nil ) then
        LuaDebugCallStack("[Karma] Nil player supplied to ColorizePlayerName")
        return newName
    end

    local color = player:GetObjVar("NameColorOverride")

    if ( color == nil and not(TRAILER_BUILD) ) then
        if ( IsImmortal(player) and not TestMortal(player) ) then color = "FFBF00" end
    end

    if ( color == nil ) then
        local karma = GetKarma(player)
        -- prevent players from ever having a white name
        if ( karma == 0 ) then karma = 1 end
        color = GetKarmaLevel(karma).NameColor
    end

    if (player:HasObjVar("IsCriminal")) then color = "C0C0C0" end
    if (player:HasObjVar("IsRed")) then color = "FF0000" end

	return string.format("[%s]%s[-]", color, newName)
end


--- Perform the positive karma action Daily Login with checks
-- @param player(playerObj)
-- @return none
function DailyLogin(player)
    Verbose("Karma", "DailyLogin", player)
    local lastDailyLoginReward = player:GetObjVar("KarmaDaily")
    local now = DateTime.UtcNow
    if ( lastDailyLoginReward == nil or lastDailyLoginReward + ServerSettings.Karma.DailyLoginInterval < now ) then
        player:SetObjVar("KarmaDaily", now)
		ExecuteKarmaAction(player, KarmaActions.Positive.DailyLogin)
    end
end

--- Determine if a mobile is in a local zone region (Checks only specific Zones)
-- @param mobileObj
-- @return true/false
function WithinKarmaZone(mobileObj)
    Verbose("Karma", "WithinKarmaZone", mobileObj)
    local ss = ServerSettings.Karma.DisableKarmaZones
	for i=1,#ss do
		if ( mobileObj:IsInRegion(ss[i]) ) then return false end
    end
    return true
end

--- Determine if a mobile is in a location that karma matters (Check RegionAddress and Specific zones)
-- @param mobileObj
-- @return true/false
function WithinKarmaArea(mobileObj)
    Verbose("Karma", "WithinKarmaArea", mobileObj)
    -- first check region address
    local regionAddress = ServerSettings.RegionAddress
    local ss = ServerSettings.Karma.DisableKarmaRegionAddresses
	for i=1,#ss do
		if ( regionAddress == ss[i] ) then return false end
    end
    -- then check zone
    return WithinKarmaZone(mobileObj)
end