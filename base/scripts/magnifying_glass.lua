
function ValidateUse(user)
   --DebugMessage(2)
    if( user == nil or not(user:IsValid()) ) then
        return false
    end
   --DebugMessage(2.5)
    if( this:TopmostContainer() ~= user ) then
        user:SystemMessage("[$1908]")
        return false
    end
   --DebugMessage(2.6)
    return true
end

RegisterSingleEventHandler(EventType.ModuleAttached, "magnifying_glass", 
    function()
        SetTooltipEntry(this,"magnifying_glass", "Can be used to examine things more throughly.")
        AddUseCase(this,"Examine",true,"HasObject")
    end)

glassUser = nil

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,useType)
        if(useType ~= "Use" and useType ~= "Examine") then return end

        if not( ValidateUse(user) ) then return end

        user:SystemMessage("What do you wish to examine?")
        user:RequestClientTargetGameObj(this, "examine")
        glassUser = user
    end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "examine", 
    function(target)        
       --DebugMessage(1)
        if not( ValidateUse(glassUser) ) then return end
        if( glassUser:GetLoc():Distance(target:GetLoc()) >= 3 ) then
            glassUser:SystemMessage("You need to be close to it to examine it.")
            return
        end
		SetMobileModExpire(this, "Disable", "Examining", true, TimeSpan.FromSeconds(3))
        this:ScheduleTimerDelay(TimeSpan.FromSeconds(3),"examineTimer",target)  
        ProgressBar.Show{TargetUser=glassUser,Label="Examining",Duration=3.0}
    end)

RegisterEventHandler(EventType.Timer,"examineTimer",
    function(target)
       ---DebugMessage("ANALYZING")
        if not( ValidateUse(glassUser) ) then return end

        local backpackObj = glassUser:GetEquippedObject("Backpack")
        if( backpackObj == nil ) then return end
        --DebugMessage(0)
        if (target:HasObjVar("MagnifyingGlassQuest")) then
            --DebugMessage(target:GetObjVar("MagnifyingGlassQuest"))
            --DebugMessage(target:GetObjVar("MagnifyingGlassQuestState"))
            --DebugMessage(target:GetObjVar("MagnifyingQuestRequirement"))
            glassUser:SendMessage("AdvanceQuest",target:GetObjVar("MagnifyingGlassQuest"),target:GetObjVar("MagnifyingGlassQuestState"),target:GetObjVar("MagnifyingQuestRequirement"))
        end
        if (target:HasObjVar("MagnifyingGlassDescription")) then
            glassUser:SystemMessage(target:GetObjVar("MagnifyingGlassDescription"))
            return
        end
        local resultString = ""
        
            if (target:GetSharedObjectProperty("IsDead") or target:HasObjVar("IsGhost")) then
                resultString = resultString .. " It's definitely dead."
            end
            if (not target:IsMobile()) then
               --DebugMessage(target:GetSharedObjectProperty("Weight"))
                if (target:GetSharedObjectProperty("Weight") < 0) then
                    if (target:HasModule("packed_object")) then
                        resultString = resultString .. "[$1909]"
                    else
                        resultString = resultString .. " It's too heavy to be picked up."
                    end
                else
                    resultString = resultString .. "[$1910]"
                end
                if (target:HasObjVar("ResourceType")) then
                    resultString = resultString .. " It looks like you can make something with it."
                end
                if (target:HasObjVar("locked")) then
                    resultString = resultString .. " It appears to be locked"
                end
                if (target:HasObjVar("ResourceSourceId")) then
                    resultString = resultString .. "[$1911]"
                end
                if (target:HasObjVar("Valuable")) then
                    if (target:HasObjVar("Worthless")) then
                        resultString = resultString .. " You probablly couldn't sell it."
                    end
                    local value = this:GetObjVar("Valuable") or GetItemValue(target,"coins")
                    if (value < 5) then
                        resultString = resultString .. "[$1912]"
                    elseif (value < 30) then
                        resultString = resultString .. " It might be worth a few coins."
                    elseif (value < 65) then
                        resultString = resultString .. " It has some value, but not much."
                    elseif (value < 100) then
                        resultString = resultString .. " It might be worth a few coins."
                    elseif (value < 200) then
                        resultString = resultString .. " It looks like it could sell for a lot."
                    elseif (value < 500) then
                        resultString = resultString .. "[$1913]"
                    elseif (value < 1000) then
                        resultString = resultString .. "[$1914]"
                    elseif (value < 10000) then
                        resultString = resultString .. "[$1915]"
                    elseif (value > 10000) then
                        resultString = resultString .. " It's priceless."
                    else
                        resultString = resultString .. " You can't ascertain it's value"
                    end
                end
            end
            if (target:HasObjVar("CanBeTamed")) then
                resultString = resultString .. " It looks like it's tameable."
            end
            if (target:GetObjVar("Alcohol") ~= nil) then
                resultString = resultString .. " It'll get you drunk."
            end
            local modules = target:GetAllModules()
            for i,j in pairs(modules) do
                if (j == "container") then
                    resultString = resultString .. " It looks like you can put a few things inside it."
                end
                if (j == "food") then
                    resultString = resultString .. " It looks eatable."
                end
                if (j == "door") then
                    resultString = resultString .. " It does open and close."
                end
                if (j == "artifact") then
                    resultString = resultString .. " It appears very old, maybe thousands of years."
                end
                if (j == "relic") then
                    resultString = resultString .. "[$1916]"
                end
                if (j == "idol") then
                    resultString = resultString .. "[$1917]"
                end
                if (j == "note") then
                    if (target:HasObjVar("AnotherLanguage")) then
                        resultString = resultString .. "[$1918]"
                    else
                        resultString = resultString .. "[$1919]"
                    end
                end
                if (j == "stackable") then
                    if (target:GetObjVar("StackCount") == nil or target:GetObjVar("StackCount") == 1) then
                        resultString = resultString .. "[$1920]"
                    else
                        resultString = resultString .. " It looks like there's a stack of them there."
                    end
                end
                if (j == "key") then
                    if( target:HasObjVar("lockUniqueId") ) then
                        resultString = resultString .. " It looks like it's been keyed to open something."
                    else
                        resultString = resultString .. "[$1921]"
                    end
                end
                if (j == "potion_regen") then
                    resultString = resultString .. " The magic substance within is drinkable."
                end
                if (j == "trapped_object") then
                    resultString = resultString .. " It appears to be rigged with a trap."
                end
                if (j == "spell_scroll") then
                    resultString = resultString .. " It has magic words written on it."
                end
                if (j == "recipe") then
                    resultString = resultString .. " It has instructions for crafting something on it."
                end
                if (j == "clothing_dye") then
                    resultString = resultString .. " It looks like it would stain whatever it touches."
                end
                if (j == "tool_base") then
                    resultString = resultString .. " It looks like you could make something with it."
                end
                if (j == "teleporter") then
                    resultString = resultString .. " It looks like you could make something with it."
                end
                if (j == "custom_char_window") then
                    resultString = resultString .. "[$1922]"
                end
                if (j == "teleporter") then
                    resultString = resultString .. " It looks like it can take you somewhere."
                end
                if (j == "armor_base") then
                    resultString = resultString .. " You could protect yourself by wearing it."
                end
                if (j == "apply_bonuses") then
                    resultString = resultString .. " It appears to be enchanted with magic."
                end
                if (j == "weapon_base") then
                    resultString = resultString .. " You could probablly kill something with it."
                end
                if (j == "god_negate_damage") then
                    resultString = resultString .. "[$1923]"
                end
                if (j == "animal_parts") then
                    resultString = resultString .. " You can harvest it's corpse for materials."
                end
                if (j == "housing_blueprint") then
                    resultString = resultString .. "[$1924]"
                end
            end
            if (target:GetObjVar("Drug") ~= nil) then
                resultString = resultString .. " Who knows what will happen if you eat it?"
            end
            local tags = target:GetObjectTags()
            for i,j in pairs(tags) do
                if (j == "Human") then
                    resultString = resultString .. " It looks human."
                end
                if (j == "Female") then
                    resultString = resultString .. "[$1925]"
                end
                if (j == "Male") then
                    resultString = resultString .. "[$1926]"
                end
                if (j == "Undead") then
                    resultString = resultString .. " It was probablly human at some point."
                end
                if (j == "Head") then
                    resultString = resultString.." You can wear it on your head."
                end
                if (j == "Legs") then
                    resultString = resultString.." You can wear it like pants."
                end
                if (j == "Chest") then
                    resultString = resultString.." You can wear it as a top."
                end
                if (j == "Weapon" or j == "Shield") then
                    resultString = resultString.." You can wield it."
                end
             end
             if (target:IsMobile()) then
                local mobileType = target:GetMobileType()
                if (mobileType == "Friendly") then
                    resultString = resultString .. " They appear friendly enough."
                elseif (mobileType == "Animal") then
                    resultString = resultString .. " It's an animal alright."
                elseif (mobileType == "Monster") then
                    resultString = resultString .. "[$1927]"
                end
                local baseHealth = GetMaxHealth(target)
                if (baseHealth ~= nil) then
                    if (baseHealth <= 15) then
                        resultString = resultString .. " It's looks like you could kill them easily."
                    elseif (baseHealth <= 50) then
                        resultString = resultString .. " You could probablly kill it with a few good hits."
                    elseif (baseHealth <= 100 ) then
                        resultString = resultString .. "[$1928]"
                    elseif (baseHealth <= 150) then
                        resultString = resultString .. " It looks like you could take them."
                    elseif (baseHealth < 200) then
                        resultString = resultString .. " It looks strong."
                    elseif (baseHealth <= 250) then
                        resultString = resultString .. " They look formidable."
                    elseif (baseHealth <= 1000) then
                        resultString = resultString .. "[$1929]"
                    else
                        resultString = resultString .. " It looks immensely powerful."
                    end
                else
                    resultString = resultString .. " You aren't sure how strong it is."
                end
                local curHealth = GetCurHealth(target)
                if (not target:GetSharedObjectProperty("IsDead")) then
                    if (curHealth < baseHealth/4) then
                        resultString = resultString .. " They look like they're near death."
                    elseif (curHealth < baseHealth/2) then
                        resultString = resultString .. " They look like they're heavily wounded."
                    elseif (curHealth < baseHealth*2/3) then
                        resultString = resultString .. " They look like they're injured."
                    elseif (curHealth < baseHealth) then
                        resultString = resultString .. " They look like they're slightly injured."
                    end
                end
                if (target:HasObjVar("IsGhost")) then
                    resultString = resultString .. "[$1930]"
                end
                if (IsImmortal(target)) then
                    resultString = resultString .. "[$1931]"
                end
            end
        glassUser:SystemMessage(resultString)

    end)