require 'NOS:base_warchief' 

--Collection of random names for NPCs
npcNames = {  "Brand",
              "Agni",
              "Vulcan" }

Warchief.MyTeam = "Fire"

--Append Warcamp (Color) team specific sayings to phrases list
table.insert(Warchief.ThingsToSay, "Everyone learns faster on fire.")
table.insert(Warchief.ThingsToSay, "You live and you burn.")

if(initializer ~= nil) then
  	--Call Parent constructor
  	Warchief.Init()
  	this:SetName("Warchief "..npcNames[math.random(1, #npcNames)])  
end
