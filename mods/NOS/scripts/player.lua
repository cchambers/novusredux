
require 'default:player'
require 'incl_player_names.lua'

if(IsDemiGod(this)) then
	require 'default:base_player_mobedit'
end

function UpdateName()
	Verbose("Player", "UpdateName")
	local charName = ColorizePlayerName(this, GetNamePrefix() .. this:GetName() .. GetNameSuffix())
	this:SetSharedObjectProperty("DisplayName", charName)
end