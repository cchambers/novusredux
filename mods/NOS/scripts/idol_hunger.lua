require 'base_idol_player_script'

--Make them really hungry, curse of the idol
function AttachDebuff()
	this:SendMessage("SetFullLevelPct",10)
end

function DetachDebuff()
end
AttachDebuff()