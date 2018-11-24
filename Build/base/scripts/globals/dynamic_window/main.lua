function GetButtonState(varObj,value)
	if(varObj==value) then return "pressed" end

	return ""
end

function GetTimerLabelString(timespan,shortened)
	local timerStr = (shortened and "TIMER_S") or "TIMER"
	return "["..timerStr..":"..timespan:ToString("hh\\:mm\\:ss").."]"
end

require 'globals.dynamic_window.hud'
require 'globals.dynamic_window.dialog'
require 'globals.dynamic_window.prestige'
require 'globals.dynamic_window.tabwindow'
require 'globals.dynamic_window.tutorialbook'


-- some ui static data
DecorateButtonSprites = 
{
	RotateCW = {"HouseDecorationWindow_RotateCW_Default","HouseDecorationWindow_RotateCW_Hover","HouseDecorationWindow_RotateCW_Click"},
	RotateCCW = {"HouseDecorationWindow_RotateCCW_Default","HouseDecorationWindow_RotateCCW_Hover","HouseDecorationWindow_RotateCCW_Click"},	
	Blank = {"HouseDecorationWindow_Button_Default","HouseDecorationWindow_Button_Hover","HouseDecorationWindow_Button_Click"}
}