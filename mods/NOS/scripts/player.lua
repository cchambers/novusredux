
require 'default:player'

nameSuffix = {
	{Suffix = function(guild)
			return "[" .. guild.Tag .. "]"
		end, Condition = function(guild)
			return guild ~= nil and guild.Tag ~= nil
		end}
}

namePrefix = {
	{Prefix = function()
			return "Noob "
		end, Condition = function(targetObj)
			return IsInitiate(targetObj)
		end},
	{Prefix = function()
			return "Admin "
		end, Condition = function(targetObj)
			return IsGod(targetObj) and not (TestMortal(targetObj))
		end},
	{Prefix = function()
			return "GM "
		end, Condition = function(targetObj)
			return IsDemiGod(targetObj) and not (IsGod(this)) and not (TestMortal(targetObj))
		end},
	{Prefix = function()
			return "Counselor "
		end, Condition = function(targetObj)
			return IsImmortal(targetObj) and not (IsDemiGod(this)) and not (TestMortal(targetObj))
		end}
}

function GetNameSuffix(targetObj)
	local guild = Guild.Get(this)
	local suffix = ""
	if (guild) then 
		suffix = suffix .. " " .. suffixEntry.Suffix(guild)
	end
	return suffix
end

function GetNamePrefix(targetObj)
	local prefix = ""
	for i, prefixEntry in pairs(namePrefix) do
		if (prefixEntry.Condition(targetObj or this)) then
			prefix = prefix .. " " .. prefixEntry.Prefix()
		end
	end

	return prefix
end

if(IsDemiGod(this)) then
	require 'default:base_player_mobedit'
end

function UpdateName()
	Verbose("Player", "UpdateName")
	local charName = ColorizePlayerName(this, GetNamePrefix() .. this:GetName() .. GetNameSuffix())
	this:SetSharedObjectProperty("DisplayName", charName)
end