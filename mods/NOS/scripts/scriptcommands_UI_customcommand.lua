icons = {"attack_target",
		"auraoffire",
		"backpack",
		"backstab",
		"charge",
		"cloak",
		"combat_target",
		"crosscut",
		"defend",
		"drivingstrike",
		"evaluate",
		"fireball",
		"flurry",
		"followthrough",
		"force_peace",
		"god button",
		"heal",
		"human",
		"icelance",
		"impale",
		"lightning",
		"lunge",
		"picklock",
		"pillaroffire",
		"pommel",
		"pulverize",
		"pummel",
		"regenfocus",
		"rend",
		"restore",
		"resurrect",
		"riposte",
		"settings button",
		"shadowrun",
		"shield_bash",
		"shockwave",
		"skills",
		"steal",
		"stealth",
		"sunder",
		"tamecreature",
		"target_self",
		"teleport",
		"magicalguide",

		-- RPG Pack
		"Acid Arrow",
		"Acid Splash",
		"Arcane Arrow",
		"Arcane Shackles",
		"Arcane Shield2",
		"Ball Lightning 01",
		"Ball Lightning 02",
		"Bash",
		"Berserker Rage",
		"Blessed Hammer",
		"Blink Strike",
		"Blizzard",
		"Burning Arrow",
		"Charge",
		"Cleave",
		"Deflect",
		"Dispel",
		"Divine Aura 01",
		"Divine Aura 02",
		"Eclipse",
		"Eclipse2",
		"Electic Web",
		"Elemental Arrow",
		"Elemental Shield",
		"Fatal Strike",
		"Feral Rage",
		"Fiery Arrow",
		"Fire and Ice",
		"Fire Shackles",
		"Fire Shackles2",
		"Fire Shield",
		"Fire Shield2",
		"Flame Mark",
		"Force Push 01",
		"Force Push 02",
		"Gust of Wind",
		"Hammer Smash",
		"Healing Hands",
		"Hellstorm 02",
		"Hellstorm 03",
		"Hellstorm",
		"Holy Shield",
		"Ice Barrier",
		"Icy Arrow",
		"Immolation",
		"Leap",
		"Lightning Dagger 02",
		"Lightning Dagger 03",
		"Lightning Dagger",
		"Maelstrom",
		"Mana Crystal",
		"Martial Arts 01",
		"Martial Arts 02",
		"Martial Arts 03",
		"Meteor 01",
		"Meteor 02",
		"Meteor 03",
		"Meteor 04",
		"Multishot",
		"Poison Cloud",
		"Raise Undead",
		"Regrowth",
		"Revenge2",
		"Sap2",
		"Seismic Slam 01",
		"Seismic Slam 02",
		"Seismic Slam 03",
		"Sharpshooter",
		"Shieldwall",
		"Shock Wave",
		"Shred",
		"Starfall 01",
		"Starfall 02",
		"Stone Skin",
		"Summon Bat 01",
		"Summon Bat 02",
		"Summon Bat 03",
		"Summon Bat 04",
		"Summon Bear",
		"Summon Raven 01",
		"Summon Raven 02",
		"Summon Raven 03",
		"Summon Raven 04",
		"Summon Raven 05",
		"Summon Spirit Bear",
		"Summon Spirit Wolf",
		"Summon Wolf",
		"Thunder Strike 02",
		"Thunder Strike 03",
		"Thunder Strike 04",
		"Thunder Strike",
		"Tornado",
		"Track Beasts",
		"Tracking",
		"Volcanic Eruption",
		"Whirling Axe",
		"Whirlwind",
		"Wild Shot",
		"Windshot",
		"Wrath of Nature 01",
		"Wrath of Nature02",
		"Arrow Storm",
		"Bash",
		"Black Forest",
		"Blazing Speed",
		"Block",
		"Chill",
		"Cold Mastery",
		"Dawn",
		"Deep Cuts",
		"Dual Wield",
		"Fan of Daggers",
		"Far Sight",
		"Fire Bolt",
		"Fire Demon",
		"Fire Mastery",
		"Fire Nova",
		"Fire Spark",
		"Fireball",
		"Flame Wall",
		"Flame Whirl",
		"Flashing Strike",
		"Freezing Arrow",
		"Frost Bolt",
		"Frost Orb",
		"Holy Blast",
		"Holy Light",
		"Holy Mastery",
		"Ignite",
		"Illuminate",
		"Imbue Fire",
		"Imbue Frost",
		"Imbue Holy",
		"Imbue Lightning",
		"Imbue Unholy",
		"Lightning Bolt",
		"Lightning Mastery",
		"Lightning Nova",
		"Lightning Orb",
		"Lightning Reflexes",
		"Lightning Surge",
		"Magic Barrier",
		"Natures Grace",
		"Night",
		"Pathfinding",
		"Phantom",
		"Poison Arrow",
		"Poison Claws",
		"Poison Skull",
		"Poison Splash",
		"Quick Shot",
		"Quick Step",
		"Shield Breaker",
		"Slash",
		"Soothing Water",
		"Spectral Ball",
		"Spell Shield",
		"Stab",
		"Strike",
		"Summon Black Horse",
		"Summon Brown Horse",
		"Summon Crow",
		"Summon Grey Pony",
		"Summon White Horse",
		"Sure Strike",
		"Terrify",
		"Thunder Storm",
		"Unholy Blast",
		"Unholy Mastery",
		"Weapon Throw",		
	}

local commandArgs = ""

function GetCustomCommandAction(id,iconIndex)
	local command = "Empty"
	local tooltip = ""
	if(commandArgs ~= "") then		
		local args = StringSplit(commandArgs," ")
		command = args[1] or "Empty"
		tooltip = (commandArgs or "") 
	else
		tooltip = "IconName: "..icons[iconIndex]
	end

	return {
		ID=id,
		ActionType="CustomCommand",
		DisplayName=command,
		Tooltip=tooltip,
		Icon=icons[iconIndex],
		ServerCommand=commandArgs,
		Enabled=true,		
	}
end

function ShowCustomCommandWindow()
	dynWindow = nil
	local dynWindow = DynamicWindow("CustomCommand","Create Custom Command",480,380)

	local scrollWindow = ScrollWindow(20,10,420,250,50)	

	local iconsPerRow = 8
	for i=1,math.ceil(#icons/iconsPerRow)-1 do
		local scrollElement = ScrollElement()
		local startIndex = (i-1)*iconsPerRow + i
		for j=0,(iconsPerRow-1) do
			local iconIndex = startIndex + j
			if(iconIndex <= #icons) then				
				scrollElement:AddUserAction(j*50,0,GetCustomCommandAction(tostring(iconIndex),iconIndex))
			end
		end
		scrollWindow:Add(scrollElement)
	end

	dynWindow:AddScrollWindow(scrollWindow)
	dynWindow:AddLabel(20,290,"Command:",0,0,16)
	dynWindow:AddTextField(90,286,240,20,"Args",commandArgs)
	dynWindow:AddButton(340,280,"Args","Update",80,0,"","",false,"")	
	this:OpenDynamicWindow(dynWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"CustomCommand",
	function (user,buttonId,fieldData)
		if(buttonId == "Args") then
			commandArgs = fieldData.Args
			ShowCustomCommandWindow()
		end
	end)

RegisterEventHandler(EventType.ClientObjectCommand,"dropAction",
	function (user,sourceId,actionType,actionId,slot)
		if(sourceId == "CustomCommand" and slot ~= nil) then
			local args = StringSplit(commandArgs," ")
			local command = args[1]

			local commandAction = GetCustomCommandAction(command,tonumber(actionId))
			commandAction.Slot = tonumber(slot)
			
			AddUserActionToSlot(commandAction)
		end
	end)