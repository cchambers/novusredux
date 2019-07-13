require 'NOS:base_warchief' 

--Collection of random names for NPCs
npcNames = {  "Seidon",
              "Mazu",
              "Oceanus" }

Warchief.MyTeam = "Water"

--Append Warcamp (Color) team specific sayings to phrases list
table.insert(Warchief.ThingsToSay, "Killing enemies is like drinking a glass of water.")
table.insert(Warchief.ThingsToSay, "Still waters run deep.")
table.insert(Warchief.ThingsToSay, "[$1606]")

function HandleModuleLoaded()
  	--Call Parent constructor
  	Warchief.Init()
  	this:SetName("Warchief "..npcNames[math.random(1, #npcNames)])  
end

RegisterSingleEventHandler(EventType.ModuleAttached, "ai_WaterWarchief", HandleModuleLoaded)
