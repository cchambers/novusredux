RegisterEventHandler(EventType.Message, "AssignWaveController", 
    function(WaveSource)
    	this:SetObjVar("WaveController",WaveSource)
    end)

RegisterEventHandler(EventType.Message, "AssignWaveTarget", 
    function(target)
    	this:SendMessage("AttackEnemy",target)
    end)

RegisterEventHandler(EventType.Message, "HasDiedMessage", 
    function()
    	local WaveSource = this:GetObjVar("WaveController")
        WaveSource:SendMessage("WaveMobDied")
    end)