require 'incl_player_guild'

nameSuffix = {
	{ Suffix = function(guild) return "|"..guild.Tag.."|" end, Condition = function(guild,targetObj) return guild ~= nil and guild.Tag ~= nil end },
	{ Suffix = function() return "<Initiate>" end, Condition = function(guild,targetObj) return IsInitiate(targetObj) end },
	{ Suffix = function() return "<GOD>" end, Condition = function(guild,targetObj) return IsGod(targetObj) end },
	{ Suffix = function() return "<DGOD>" end, Condition = function(guild,targetObj) return IsDemiGod(targetObj) and not(IsGod(this)) end },
	{ Suffix = function() return "<IMM>" end, Condition = function(guild,targetObj) return IsImmortal(targetObj) and not(IsDemiGod(this)) end },
}

function GetNameSuffix(targetObj)
	local guild = Guild.Get(this)
	local suffix = ""
	for i,suffixEntry in pairs(nameSuffix) do
		if(suffixEntry.Condition(guild,targetObj or this)) then
			suffix = suffix .. " " .. suffixEntry.Suffix(guild)
		end
	end

	return suffix
end