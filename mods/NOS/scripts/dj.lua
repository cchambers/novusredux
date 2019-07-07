

DanceAnimations = {
	"dance_wave", --1
	"dance_gangamstyle", --2	
	"dance_bellydance", --3
	"dance_cabbagepatch", --4
	"dance_chickendance", --5
	"dance_guitarsolo", --6
	"dance_headbang", --7
	"dance_hiphop", --8
	"dance_macarena", --9
	"dance_raisetheroof", --10
	"dance_robot", --11
	"dance_runningman", --12
	"dance_twist", --13
}

function GetRange()
    return this:GetObjVar("Range") or 10
end

function Dance(i)
    this:PlayAnimation(DanceAnimations[i or math.random(1,#DanceAnimations)])
    local nearbyMobiles = FindObjects(SearchMobileInRange(GetRange()))
    for mi,mobile in pairs(nearbyMobiles) do
		if ( HasHumanAnimations(mobile) ) then
            mobile:PlayAnimation(DanceAnimations[i or math.random(1,#DanceAnimations)])
        end
    end
end

for i,dance in pairs(DanceAnimations) do
	RegisterEventHandler(EventType.Message, "q"..i, function() Dance(i) end)
end

RegisterEventHandler(EventType.Message, "r", function() Dance() end)