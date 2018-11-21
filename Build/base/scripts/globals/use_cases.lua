--These are used in player.lua to determine if a use case is within range.
MAX_INTERACT_RANGE = 30
GOD_INTERACT_RANGE = 5000
INTERACT_ANYWHERE_RANGE = 9999999
AllUseCases = {
	[""] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["Use"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["Interact"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["Inspect"] = {
		Range = MAX_INTERACT_RANGE
	},
	["Kick from Group"] = {
		Range = INTERACT_ANYWHERE_RANGE
	},
	["Invite to Group"] = {
		Range = INTERACT_ANYWHERE_RANGE
	},
	["Invite to Guild"] = {
		Range = INTERACT_ANYWHERE_RANGE
	},
	["Trade"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["Duel"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["Loot All"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["God Info"] = {
		Range = GOD_INTERACT_RANGE,
		Restriction = "God",
	},
	["Pick Up"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["God Pick Up"] = {
		Range = GOD_INTERACT_RANGE,
		Restriction = "God",
	},
	["Quick Loot"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["Harvest"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["Chop"] = {
		Range = 4
	},
	["Mine"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["Skin"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["Forage"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["Equip"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["Unequip"] = {
		Range = OBJECT_INTERACTION_RANGE
	},
	["Sit"] = {
		Range = 2
	},
	["Lay Down"] = {
		Range = 2
	},
}