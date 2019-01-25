RegisterEventHandler(EventType.Message,"TransitionColorFromMossToBloodmoss",
    function(objRef)
        ChangeColorOverTime(objRef, "556B2F", this:GetColor())
		this:SetColor("556B2F")
		
        Decay(this, 900)  -- 900 seconds is 15 minutes
    end
)

function ChangeColorOverTime(object, startColor, endColor)
	RegisterEventHandler(EventType.Timer, "ChangeColorOverTime", 
		function (object, startColor, endColor, step)
			if(step == nil) then
				step = 0
			end

			-- When step hits 100, this is done.
			if(step >= 100) then
                DebugMessage("Color has completed the change.")
                this:RemoveTimer("ChangeColorOverTime")
				return
			end
			
			step = step + 5

			local newColor = fade_RGB(startColor, endColor, step)
			--DebugMessage(tostring(startColor)..", "..tostring(endColor)..", "..tostring(newColor)..", "..tostring(step))
			object:SetColor(newColor)
			this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500), "ChangeColorOverTime", object, startColor, endColor, step)
		end)

	DebugMessage("resource.lua: ChangeColorOverTime(): ")
	this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(500), "ChangeColorOverTime", object, startColor, endColor)   
end

function fade_RGB(colour1, colour2, percentage)
	r1, g1, b1 = string.match(colour1, "([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])")
	r2, g2, b2 = string.match(colour2, "([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])([0-9A-F][0-9A-F])")
	r3 = tonumber(r1, 16)*(100-percentage)/100.0 + tonumber(r2, 16)*(percentage)/100.0
	g3 = tonumber(g1, 16)*(100-percentage)/100.0 + tonumber(g2, 16)*(percentage)/100.0
	b3 = tonumber(b1, 16)*(100-percentage)/100.0 + tonumber(b2, 16)*(percentage)/100.0
	--local colour3 = Dec2Hex(r3)..Dec2Hex(g3)..Dec2Hex(b3)
	--DebugMessage(tostring(colour1)..", "..tostring(tonumber(r1, 16))..", "..tostring(tonumber(g1, 16))..", "..tostring(tonumber(b1, 16)))
	--DebugMessage(tostring(colour2)..", "..tostring(tonumber(r2, 16))..", "..tostring(tonumber(g2, 16))..", "..tostring(tonumber(b2, 16)))
	--DebugMessage(tostring(colour3)..", "..tostring(tonumber(r3, 16))..", "..tostring(tonumber(g3, 16))..", "..tostring(tonumber(b3, 16)))
	--DebugMessage(tostring(percentage))
	return Dec2Hex(r3)..Dec2Hex(g3)..Dec2Hex(b3)
end

function Dec2Hex(nValue) -- http://www.indigorose.com/forums/threads/10192-Convert-Hexadecimal-to-Decimal
	if type(nValue) == "string" then
		nValue = String.ToNumber(nValue);
	end
	nHexVal = string.format("%X", nValue);  -- %X returns uppercase hex, %x gives lowercase letters
	sHexVal = nHexVal.."";
	if nValue < 16 then
		return "0"..tostring(sHexVal)
	else
		return sHexVal
	end
end