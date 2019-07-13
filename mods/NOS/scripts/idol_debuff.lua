require 'NOS:base_idol_player_script'

--Make them suck at combat
function AttachDebuff()
    SetMobileMod(this, "AttackSpeedTimes", "IdolDebuff", 2)
    SetMobileMod(this, "AttackTimes", "IdolDebuff", 0.5)
    SetMobileMod(this, "ManaRegenTimes", "IdolDebuff", 0.5)
    SetMobileMod(this, "HealthRegenTimes", "IdolDebuff", 0.5)
	AddBuffIcon(this,"Cursed","Cursed","backstab","[$1849]",false)
end

function DetachDebuff()
	RemoveBuffIcon(this,"Cursed")
    SetMobileMod(this, "AttackSpeedTimes", "IdolDebuff", nil)
    SetMobileMod(this, "AttackTimes", "IdolDebuff", nil)
    SetMobileMod(this, "ManaRegenTimes", "IdolDebuff", nil)
    SetMobileMod(this, "HealthRegenTimes", "IdolDebuff", nil)
end
AttachDebuff()