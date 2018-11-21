require "incl_player_guild"

nameSuffix = {
	{
		Suffix = function(guild)
			return "[" .. guild.Tag .. "]"
		end,
		Condition = function(guild)
			return guild ~= nil and guild.Tag ~= nil
		end}
}

namePrefix = {
	{
		Suffix = function()
			return "<noob>"
		end,
		Condition = function(targetObj)
			return IsInitiate(targetObj)
		end},
	{
		Suffix = function()
			return "Admin"
		end,
		Condition = function(targetObj)
			return IsGod(targetObj)
		end},
	{
		Suffix = function()
			return "GM"
		end,
		Condition = function(targetObj)
			return IsDemiGod(targetObj) and not (IsGod(this))
		end},
	{
		Suffix = function()
			return "Counselor"
		end,
		Condition = function(targetObj)
			return IsImmortal(targetObj) and not (IsDemiGod(this))
		end}
}

function GetNameSuffix(targetObj)
	local guild = Guild.Get(this)
	local suffix = ""
	for i, suffixEntry in pairs(nameSuffix) do
		if (suffixEntry.Condition(guild)) then
			suffix = suffix .. " " .. suffixEntry.Suffix(guild)
		end
	end

	return suffix
end

function GetNamePrefix(targetObj)
	local guild = Guild.Get(this)
	local prefix = ""
	for i, prefixEntry in pairs(namePrefix) do
		if (prefixEntry.Condition(targetObj or this)) then
			prefix = prefix .. prefixEntry.Suffix(guild) .. " "
		end
	end

	return prefix
end
