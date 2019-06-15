WeatherObjects = nil

-- NOTE: we put the views on the player objects because singleobjectsearchers are extremely efficient compared to a region searcher
function UpdateWeatherViews()
	WeatherObjects = FindObjectsWithTag("WeatherController")

	for i,weatherObject in pairs(WeatherObjects) do
		local weatherRegion = weatherObject:GetObjVar("WeatherRegion")
		if(weatherRegion) then
			local viewName = "Weather-"..weatherRegion

			RegisterEventHandler(EventType.EnterView,viewName,
				function ( ... )			
					weatherObject:SendMessage("EnterWeatherRegion",this)
				end)
			RegisterEventHandler(EventType.LeaveView,viewName,
				function ( ... )
					weatherObject:SendMessage("LeaveWeatherRegion",this)
				end)

			--MJT Hack: Stops weather effects manually. 
			--After release, should really be handled by an identifier when creating/removing effects.
			local weatherEffects = 
			{
				"DesertWeatherEffect",
				"RainEffect",
				"RainStormEffect",
				"RainLightEffect"
			}
			for index, effectName in pairs(weatherEffects) do
				this:StopLocalEffect(this, effectName, 1.0)
			end

			if (GetRegion("NoWeather")) then
                AddView(viewName,SearchSingleObject(this,SearchMulti{SearchRegion(weatherRegion),SearchExcludeRegion("NoWeather")}),1.0)
            else
                AddView(viewName,SearchSingleObject(this,SearchRegion(weatherRegion)),1.0)
            end
		end
	end
end

RegisterEventHandler(EventType.Message,"UpdateWeatherViews",
	function ( ... )
		UpdateWeatherViews()
	end)

