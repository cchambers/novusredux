function OnLoad()
    this:FireTimer("WeatherPulse")
end

isWeatherActive = false
playersInWeather = {}
function WeatherPulse()
    -- keep timer going even if weatherSettings are empty
    local pulseFreq = this:GetObjVar("WeatherPulseFrequencyMins") or 1
    this:ScheduleTimerDelay(TimeSpan.FromMinutes(pulseFreq),"WeatherPulse")
    
    local weatherRegion = this:GetObjVar("WeatherRegion")
    local weatherEffect = this:GetObjVar("WeatherEffect")
    if(weatherRegion and weatherEffect) then
        if(isWeatherActive) then            
            local stopChance = this:GetObjVar("WeatherStopChance") or 0.1
            isWeatherActive = (math.random() > stopChance) 

            if not(isWeatherActive) then
                DebugMessage("Weather Controller: Weather stopping")
                for playerObj,dummy in pairs(playersInWeather) do
                    if(playerObj and playerObj:IsValid()) then
                        playerObj:StopLocalEffect(playerObj,weatherEffect,1.0)
                    end
                end
            end
            playersInWeather = {}            
        else
            local startChance = this:GetObjVar("WeatherStartChance") or 1.0
            isWeatherActive = (math.random() <= startChance) 

            if(isWeatherActive) then
                DebugMessage("Weather Controller: Weather starting")
                for i,playerObj in pairs(FindPlayersInGameRegion(weatherRegion)) do
                    playerObj:PlayLocalEffect(playerObj,weatherEffect)
                    playersInWeather[playerObj] = true
                end
            end
        end
    end
end

function OnEnterWeatherRegion(playerObj)
    DebugMessage("Weather Controller: On Enter "..tostring(playerObj))
    if(isWeatherActive and not(playersInWeather[playerObj])) then
        DebugMessage("Weather Controller: Sending play message")
        local weatherEffect = this:GetObjVar("WeatherEffect")
        playerObj:PlayLocalEffect(playerObj,weatherEffect)
        playersInWeather[playerObj] = true
    end
end

function OnLeaveWeatherRegion(playerObj)
    DebugMessage("Weather Controller: On Leave "..tostring(playerObj))
    if(isWeatherActive and playersInWeather[playerObj]) then
        DebugMessage("Weather Controller: Sending stop message")
        local weatherEffect = this:GetObjVar("WeatherEffect")
        playerObj:StopLocalEffect(playerObj,weatherEffect,1.0)
        playersInWeather[playerObj] = nil
    end
end

RegisterEventHandler(EventType.Timer,"WeatherPulse",function ( ... ) WeatherPulse() end)
RegisterEventHandler(EventType.Message,"EnterWeatherRegion",function ( ... ) OnEnterWeatherRegion(...) end)
RegisterEventHandler(EventType.Message,"LeaveWeatherRegion",function ( ... ) OnLeaveWeatherRegion(...) end)

RegisterEventHandler(EventType.ModuleAttached,"weather_controller", 
    function ( ... ) 
        this:SetObjectTag("WeatherController")

        OnLoad() 
    end)

RegisterEventHandler(EventType.LoadedFromBackup,"", function ( ... ) OnLoad() end)