PrestigeData = {}

-- Some common postcast/precast functions for prestige abilities
function PrestigePreCastBow(player, target)
    player:PlayAnimation("draw_bow")
end
function PrestigePostCastBow(player, target)
    player:PlayAnimation("Attack")
    PerformClientArrowShot(player, target)
end

require 'NOS:globals.static_data.prestige.fighter'
require 'NOS:globals.static_data.prestige.rogue'
require 'NOS:globals.static_data.prestige.mage'
--require 'NOS:globals.static_data.prestige.monk'
require 'NOS:globals.static_data.prestige.crafter'
require 'NOS:globals.static_data.prestige.npc'
require 'NOS:globals.static_data.prestige.skills'

-- DAB NOTE: This is a wierd place to do this but we need sorted lists of this data and this makes sure it only sorts once
PrestigeDataSorted = {}
for className, data in pairs(PrestigeData) do
	if( data.NoUnlock ~= true ) then
		if(data.Abilities) then
			data.AbilitiesSorted = {}
			for abilityName, abilityData in pairs(data.Abilities) do
				table.insert(data.AbilitiesSorted,{Name = abilityName, Data = abilityData})
			end
			table.sort(data.AbilitiesSorted,function(a,b) return a.Name < b.Name end)
		end
		table.insert(PrestigeDataSorted,{Name = className, Data = data})
	end
end
table.sort(PrestigeDataSorted,function(a,b) return a.Name < b.Name end)