require 'default:globals.special_effects.main'
require 'default:globals.special_effects.reveals.main'
require 'globals.special_effects.reveals.khi'
require 'globals.special_effects.reveals.binger'

function DoReveal(mobile)
    local effectName = string.format("Reveal%s", StripColorFromString(mobile:GetName()))
    DebugMessage("Effect: ".. effectName)
    if ( SpecialEffects[effectName] == nil ) then effectName = "RevealDefault" end
    StartSpecialEffect(mobile, effectName)
end
