
local FSM_DEFAULT_PULSE_RATE = TimeSpan.FromSeconds(1)
local FSM_DEFAULT_SLEEP_RANGE = 30
local FSM_DEFAULT_SLEEP_DELAY = TimeSpan.FromSeconds(2)
local FSM_DEFAULT_PATH_TIMEOUT = TimeSpan.FromSeconds(10)
local FSM_DEBUG = false

function FSM(parentObj, states, pulseRate, sleepDelay)

    local paused = true

    local self = {
        ParentObj = parentObj,
        States = states,
        PulseRate = pulseRate and TimeSpan.FromSeconds(pulseRate) or FSM_DEFAULT_PULSE_RATE,
        SleepDelay = sleepDelay and TimeSpan.FromSeconds(sleepDelay) or FSM_DEFAULT_SLEEP_DELAY,
    }
  
    function self.Pulse()
        if ( not self.ParentObj or not self.ParentObj:IsValid() ) then return end
        if ( not FSM_DEBUG and #FindObjects(SearchPlayerInRange(self.SleepRange or FSM_DEFAULT_SLEEP_RANGE, true)) < 1 ) then
            if not( paused ) then
                paused = true
                for i=1,#self.States do
                    if ( self.States[i].OnPause ) then self.States[i].OnPause(self) end
                end
            end
            self.Schedule(self.SleepDelay:Add(TimeSpan.FromMilliseconds(math.random(100,500))))
            return
        end
        if ( paused ) then
            paused = false
            for i=1,#self.States do
                if ( self.States[i].OnResume ) then self.States[i].OnResume(self) end
            end
        end
        self.Loc = self.ParentObj:GetLoc()
        for i=1,#self.States do
            if ( self.States[i].ShouldRun ~= nil and self.States[i].ShouldRun(self) ) then
                self.LastState = self.States[i].Name or "Unknown State"
                if ( FSM_DEBUG ) then DebugMessage("Running State", self.LastState) end
                -- allow a run state to return true and prevent a normal schedule
                if ( self.States[i].Run(self) == true ) then return end
                break
            end
        end
        self.Schedule()
    end

    function self.Schedule(delay)
        if ( not self.ParentObj or not self.ParentObj:IsValid() ) then return end
        self.ParentObj:ScheduleTimerDelay((delay or self.PulseRate):Add(TimeSpan.FromMilliseconds(math.random(10,200))), "FSMPulse")
    end

    function self.Register()
        RegisterEventHandler(EventType.Timer, "FSMPulse", self.Pulse)
        RegisterEventHandler(EventType.Arrived, "FSMPath", self.PathClear)
        RegisterEventHandler(EventType.Timer, "PathTimeout", self.PathClear)
        RegisterEventHandler(EventType.Message, "CurrentTargetUpdate", function(t)
            self.PathClear()
            self.CurrentTarget = t
        end)
        if ( FSM_DEBUG ) then RegisterEventHandler(EventType.Message, "FSM", function()
            DebugTable(self)
        end) end
    end

    function self.PathFollow(target, distance, speed)
        self.PathClear()
        self.IsPathing = self.ParentObj:PathToTarget(target, distance or self.FollowDistance or 2, speed or self.PathSpeed or 4)
        self.ParentObj:ScheduleTimerDelay(FSM_DEFAULT_PATH_TIMEOUT, "PathTimeout")
    end

    function self.PathTo(target, speed)
        self.PathClear()
        self.IsPathing = self.ParentObj:PathTo(target, speed or self.PathSpeed or 1, "FSMPath", true)
        self.ParentObj:ScheduleTimerDelay(FSM_DEFAULT_PATH_TIMEOUT, "PathTimeout")
    end

    function self.PathClear()
        if ( self.IsPathing ) then
            self.IsPathing = false
            self.ParentObj:ClearPathTarget()
        end
    end

    function self.SetTarget(target)
        self.ParentObj:SendMessage("SetCurrentTarget", target)
    end

    function self.ValidCombatTarget(target)
        return ( 
            target ~= nil
            and (self.CanSeeInvis or not target:IsCloaked())
            and target:GetObjVar("MobileTeamType") ~= self.TeamType
            and not target:HasObjVar("Invulnerable") and ValidCombatTarget(self.ParentObj, target, true)
        )
    end

    function self.RemoveState(state)
        if ( not state ) then return end
        local states = {}
        for i=1,#self.States do
            if not( self.States[i] == state ) then
                states[#states+1] = self.States[i]
            elseif ( FSM_DEBUG ) then
                DebugMessage("[FSM] Removed state:", state.Name or "Unknown", "from:", self.ParentObj)
            end
        end
        self.States = states
    end

    function self.ReplaceState(state, with)
        if ( not state ) then return end
        for i=1,#self.States do
            if ( self.States[i] == state ) then
                self.States[i] = with
                if ( FSM_DEBUG ) then DebugMessage("[FSM] Replaced state:", state.Name or "Unknown", "with:", with.Name or "Unknown") end
                return true
            end
        end
        return false
    end

    function self.Start()
        self.TeamType = (self.ParentObj:GetObjVar("MobileTeamType") or "Unknown")
        self.Loc = self.ParentObj:GetLoc()
        for i=1,#self.States do
            if ( self.States[i].Init ) then
                self.States[i].Init(self)
            end
        end
        self.Register()
        self.Schedule()
        if ( FSM_DEBUG ) then DebugMessage("[FSM] Started for", self.ParentObj) end
    end

    -- return instance from creator function
    return self
end

FSMHelper = {}

FSMHelper.NearbyFriend = function(self, range, dead)
    return FindObjects(SearchMulti({
        SearchMobileInRange(range, true, dead or false, true),
        SearchObjVar("MobileTeamType", self.TeamType),
    }))
end

FSMHelper.WeaponAbilityInit = function(self)
    -- check for abilites
    local weaponAbilites = self.ParentObj:GetObjVar("WeaponAbilities")
    if ( weaponAbilites ) then
        self.WeaponAbilities = {}
        for k,v in pairs(weaponAbilites) do
            self.WeaponAbilities[#self.WeaponAbilities+1] = (string.lower(k)=="primary")
        end
    end
end

FSMHelper.CombatAbilityInit = function(self)
    local combatAbilites = self.ParentObj:GetObjVar("CombatAbilities")
    if ( combatAbilites ) then
        self.CombatAbilities = {}
        for i=1,#combatAbilites do
            self.CombatAbilities[i] = {combatAbilites[i], GetPrestigeAbilityClass(combatAbilites[i])}
        end
    end
end

FSMHelper.SpellInit = function(self)
    -- check for spells
    local availableSpells = self.ParentObj:GetObjVar("AvailableSpellsDictionary")
    if ( availableSpells ) then
        self.Spells = {}
        for k,v in pairs(availableSpells) do
            self.Spells[#self.Spells+1] = k
        end
    end
end

FSMHelper.RandomSpell = function(self, delaySeconds)
    if ( self.Spells and not self.ParentObj:HasTimer("RecentSpell") ) then
        if ( FSMHelper.CastSpell(self, self.Spells[math.random(1,#self.Spells)]) ) then
            self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(delaySeconds), "RecentSpell")
        end
    end
end

FSMHelper.CastSpell = function(self, spellName)
    local mana = GetCurMana(self.ParentObj)
    if ( mana > 0 ) then
        local spell, target = SpellData.AllSpells[spellName]
        if ( spell and mana >= spell.manaCost ) then
            if ( spell.BeneficialSpellType ) then
                if ( spell.TargetMustBeDead ) then
                    target = FSMHelper.NearbyFriend(self, spell.SpellRange, true)[1]
                else
                    -- selfish healing
                    if ( 
                        spell.SpellType == "HealTypeSpell"
                        and
                        GetCurHealth(self.ParentObj) < GetMaxHealth(self.ParentObj)
                    ) then
                        target = self.ParentObj
                    end
                    if not( target ) then
                        target = FSMHelper.NearbyFriend(self, spell.SpellRange)[1]
                    end
                end
            else
                target = self.CurrentTarget
            end
        end

        if ( target and (target == self.ParentObj or self.Loc:DistanceSquared(target:GetLoc()) <= spell.SpellRange) ) then
            self.ParentObj:SendMessage("CastSpellMessage",spellName,self.ParentObj,target)
            return true
        end
    end
    return false
end

FSMHelper.RandomWeaponAbility = function(self, delaySeconds)
    if ( self.WeaponAbilities and not self.ParentObj:HasTimer("RecentWeaponAbility") ) then
        QueueWeaponAbility(self.ParentObj, math.random(1, #self.WeaponAbilities))
        self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(delaySeconds), "RecentWeaponAbility")
    end
end

FSMHelper.RandomCombatAbility = function(self, delaySeconds, target)
    if ( self.CombatAbilities and not self.ParentObj:HasTimer("RecentCombatAbility") ) then
        local i = math.random(1, #self.CombatAbilities)
        PerformPrestigeAbility(self.ParentObj, target or self.CurrentTarget, self.CombatAbilities[i][2], self.CombatAbilities[i][1])
        self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(delaySeconds), "RecentCombatAbility")
    end
end