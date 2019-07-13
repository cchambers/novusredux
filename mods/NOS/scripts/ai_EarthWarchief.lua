require 'NOS:base_warchief' 

--Collection of random names for NPCs
npcNames = {  "Ash",
              "Rhea",
              "Joro" }

Warchief.MyTeam = "Earth"

--Append Warcamp (Color) team specific sayings to phrases list
table.insert(Warchief.ThingsToSay, "He that plants trees loves others besides himself.")
table.insert(Warchief.ThingsToSay, "[$47]")
table.insert(Warchief.ThingsToSay, "[$48]")

if(initializer ~= nil) then
  	--Call Parent constructor
  	Warchief.Init()
  	this:SetName("Warchief "..npcNames[math.random(1, #npcNames)])  
end
