
require 'base_player_charwindow'
require 'base_player_guild_UI'
require 'incl_player_guild'

RegisterEventHandler(EventType.Message,"UseObject",
	function (user,usedType)
		user:SystemMessage("Khi's [FF0000]AWESOME[-] Guild Stone!");
		GuildInfo()
	end)