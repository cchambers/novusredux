
local m_HouseData = Plot.GetHouseDataFromHouse(this)
local m_Tally = this:GetObjVar("Tally") or {}
local m_Resources = m_HouseData.Resources or {
    Wood = 100000,
    Stone = 100000,
}
local m_Count = {}
local m_Controller = this:GetObjVar("PlotController")

-- load the count into memory on first run
for k,v in pairs(m_Resources) do
    m_Count[k] = this:GetObjVar(k.."Count") or 0
    -- set them to 5% for testing
    if ( ServerSettings.Plot.HouseResourceCostModifier ~= 1 ) then
        m_Resources[k] = math.round(m_Resources[k] * ServerSettings.Plot.HouseResourceCostModifier)
    end
end

-- add a resource
function AddResource(type, amount)
    if ( m_Resources[type] ) then
        m_Count[type] = m_Count[type] + amount
        this:SetObjVar(type.."Count", m_Count[type])
    end
end

-- check if the resources are full, and turn plot into house if they are
function CheckReady()
    local ready = true
    for k,v in pairs(m_Count) do
        if ( v < m_Resources[k] ) then ready = false end
    end

    if ( ready ) then
        Plot.FoundationToHouse(this, m_HouseData, function(house)
            if ( house ) then
                -- save the list of who helped build the house
                house:SetObjVar("BuildLedger", m_Tally)
                -- Grant achievement to anyone nearby who contributed when house gets built (similar to boss loot distribution)
                local nearbyPlayers = FindObjects(
                    SearchPlayerInRange(20,true) --in 20 units
                )

                for i,j in pairs(nearbyPlayers) do
                    if (m_Tally[j] ~= nil and j:IsValid()) then
                        CheckAchievementStatus(j, "Activity", "HouseBuilding", 1)
                    end
                end
            end
        end)
    end
    return ready
end

function UpdateTooltip()
    for k,v in pairs(m_Resources) do
        SetTooltipEntry(this, k.."Count", string.format("%s: %s / %s", k, m_Count[k], m_Resources[k]))
    end
end

-- handle an object being dropped onto the plot
RegisterEventHandler(EventType.Message, "HandleDrop", function(user,droppedObj)
    if ( droppedObj and droppedObj:IsValid() ) then
        local type = droppedObj:GetObjVar("ResourceType")
        if ( m_Resources[type] ) then
            local remaining = m_Resources[type] - m_Count[type]
            if ( remaining < 1 ) then return end
            -- adjust by the smaller of the two
            local amount = math.min(
                GetStackCount(droppedObj),
                remaining
            )
            
            droppedObj:SendMessage("AdjustStack", -amount)
            AddResource(type, amount)

            -- keep track of who contributed what
            if not( m_Tally[user] ) then m_Tally[user] = {} end
            if not( m_Tally[user][type] ) then m_Tally[user][type] = 0 end
            m_Tally[user][type] = m_Tally[user][type] + amount
            this:SetObjVar("Tally", m_Tally)

            user:SystemMessage(string.format("%s %s added", amount, type), "info")

            UpdateTooltip()

            CheckReady()
        end
    end
end)

RegisterEventHandler(EventType.Message, "UseObject", function(user,usedType)
    if ( usedType == "God Finish House" and IsGod(user) ) then
        Plot.FoundationToHouse(this, m_HouseData)
    elseif (usedType == "Destroy") then
        if ( Plot.IsOwner(user, m_Controller) ) then
            -- Are you sure?
            ClientDialog.Show{
                TargetUser = user,
                DialogId = "DestroyFoundation",
                TitleStr = "Destroy Foundation",
                DescStr = "Are you sure you wish to destroy this foundation? No resources or blueprint will be refunded.",
                Button1Str = "Confirm Destroy",
                Button2Str = "Cancel",
                ResponseObj = this,
                ResponseFunc = function( userr, buttonId )
                    if ( userr == user ) then
                        buttonId = tonumber(buttonId)
                        if ( buttonId == 0 ) then
                            this:Destroy()
                            return
                        end
                    end
                end,
            }
        else
            user:SystemMessage("Only plot owners can destroy foundations.", "info")
        end
    end
end)

RegisterSingleEventHandler(EventType.ModuleAttached, "house_foundation", function()
    this:SetName("[FF5d3c]A House Foundation[-]")
    UpdateTooltip()
    SetTooltipEntry(this, "Desc", "\nTo add materials to the house construction, drop them directly onto the foundation.",-1000)

    AddUseCase(this,"Destroy",false)
    AddUseCase(this,"God Finish House",false,"IsGod")

    this:SetObjVar("DropRange",30)
end)