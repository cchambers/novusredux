PlayerObj = nil

local townSizes = {
	EasternFrontier = 280,
	UpperPlains = 100,
	SouthernHills = 140,
	SouthernRim = 170,
}

function RefreshAutoDimissTimer(time)
	local timer = time or 1
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(timer),"AutoDismiss")
end

function OnLoad()
	AddUseCase(this,"Interact",false, "IsController")
	AddUseCase(this,"Dismiss",false,"IsController")

	SummonSelf()
end

function IsSummoned()
	return this:ContainedBy() == nil
end

function DismissSelf()
	if not(IsSummoned()) then return end

	if ( PlayerObj == nil ) then return end

	local tempPack = PlayerObj:GetEquippedObject("TempPack")
	if( tempPack ~= nil ) then
		this:MoveToContainer(tempPack,Loc(0,0,0))
		this:RemoveTimer("DoWorldUpdate")
	end
end

function SummonSelf()

	-- update the timer no matter what
	oldSpeed = 0
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5),"DoWorldUpdate")

	-- should be in backpack.
	if(IsSummoned()) then return end

	local spawnLoc = GetNearbyPassableLoc(PlayerObj,360,2,4)
	this:SetWorldPosition(spawnLoc)

	this:SetObjectOwner(PlayerObj)

	RefreshAutoDimissTimer()
end

function SetOwner(ownerObj)
	PlayerObj = ownerObj
	this:SetObjVar("controller",PlayerObj)
	this:SetObjectOwner(PlayerObj)
end

RegisterEventHandler(EventType.Timer,"DoWorldUpdate",
	function ( ... )
		if not(IsSummoned()) then return end

		this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.5),"DoWorldUpdate")

		if(PlayerObj ~= nil and PlayerObj:IsValid()) then
			if(PlayerObj:DistanceFrom(this) > 20) then
				local spawnLoc = GetNearbyPassableLoc(PlayerObj,360,2,4)
				this:SetWorldPosition(spawnLoc)
				this:PlayEffect("TeleportToEffect")
				this:PlayObjectSound("event:/magic/air/magic_air_teleport")
			else
				local speedMod = ServerSettings.Pets.Follow.Speed.OnFoot
				if ( IsMounted(PlayerObj) ) then
					speedMod = ServerSettings.Pets.Follow.Speed.Mounted
				end
				speedMod = speedMod + 0.1

				if(speedMod ~= oldSpeed) then
					this:StopMoving()
					this:PathToTarget(PlayerObj,ServerSettings.Pets.Follow.Distance,speedMod)
					oldSpeed = speedMod
				end
			end

		end
	end)

-- NEW PLAYER DIALOG

Dialog = {}
function Dialog.OpenGuideDialog(user)
	RefreshAutoDimissTimer(5)

	user = user or PlayerObj

	local text = "What can I help you with initiate?"

	responses = {
		{
			text = "I need help with the user interface.",
			handle = "UserInterface",
		},
		{
			text = "I have a question.",
			handle = "Question",
		},
		{
			text = "I'm looking for something.",
			handle = "Looking",
		},
		{
			text = "Go away.",
			handle = "Dismiss",
		},
		{
			text = "Goodbye.",
			handle = "Close",
		},
	}

	if(IsDead(user)) then
		table.insert(responses,1,{ text = "I'm dead. What do I do?", handle = "Dead"})
	elseif ( HasMobileEffect(user, "LowVitality") ) then
		table.insert(responses,1,{ text = "I'm exhausted. What do I do?", handle = "Exhausted"})
	end

	NPCInteraction(text,this,PlayerObj,"Responses",responses)
end

function Dialog.OpenWelcomeDialog(user)
	RefreshAutoDimissTimer(5)

	user = user or PlayerObj

	local text = "Welcome to Celador! The gods have sent me to help you get started with your new life."

	responses = {
		{
			text = "Got it.",
			handle = "Welcome2",
		},		
	}

	NPCInteraction(text,this,PlayerObj,"Responses",responses)
end

function Dialog.OpenWelcome2Dialog(user)
	RefreshAutoDimissTimer(5)

	local text = "Why don't you take some time to get used to your new surroundings. When you are ready to learn more, you can summon or converse with me at any time.\n\n(Click the blue icon on the bottom of the screen)"

	responses = {
		{
			text = "Ok.",
			handle = "TempDismiss",
		},		
	}

	NPCInteraction(text,this,PlayerObj,"Responses",responses)
end

-- first level responses

function Dialog.OpenDeadDialog(user)
	local text = "Fortunately, in the world of Aria, there are many ways to return to the living. You can seek out someone skilled in the art of Manifestion to perform a ressurection. Or you can find an expert healer to mend your fatal wounds. As a last resort, you can seek out one of the many resurrection shrines that were created by the ancient gods."

	responses = {
		{
			text = "Got it.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,PlayerObj,"Responses",responses)
end

function Dialog.OpenExhaustedDialog(user)
	local text = "It appears you are completely drained of your vitality. This is caused by starvation. When you are exhausted, you will no longer gain skill. If you are hungry you should probably find something to eat. Then, you'll need to rest at an inn in one of the major towns to restore your vitality."

	responses = {
		{
			text = "Got it.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,PlayerObj,"Responses",responses)
end

function Dialog.OpenUserInterfaceDialog(user)
	user:SendMessage("ShowTutorialUI")
	user:CloseDynamicWindow("Responses")
end

function Dialog.OpenQuestionDialog(user)
	local text = "I have knowledge of many things. Tell me, what would you like to know?"

	responses = {
		{
			text = "What should I do?",
			handle = "WhatToDo",
		},		
		{
			text = "How do I learn new abilities?",
			handle = "LearnAbilities",
		},
		{
			text = "How do I learn to cast magical spells?",
			handle = "LearnSpells",
		},
		{
			text = "How do I get a house?",
			handle = "GetHouse",
		},
		{
			text = "How do I heal myself?",
			handle = "HealSelf",
		},
		{
			text = "Nevermind.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,PlayerObj,"Responses",responses)
end

function Dialog.OpenLookingDialog(user)
	local text = "Celador is filled with people to meet and new places to explore. What can I help you find?"

	responses = {		
		{
			text = "I'm looking for a shop.",
			handle = "FindShop",
		},
		{
			text = "I'm looking for somewhere to hunt.",
			handle = "FindMonsters",
		},
		{
			text = "I'm looking to craft something.",
			handle = "FindCraft",
		},
		{
			text = "I'm looking for the teleportation tower.",
			handle = "FindTower",
		},
		{
			text = "Nevermind.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,PlayerObj,"Responses",responses)
end

function Dialog.OpenDismissDialog(user)
	local text = "Of course! If you have questions, you can summon me at any time."

	responses = {
		{
			text = "Sounds good.",
			handle = "TempDismiss",
		},
		{
			text = "Nevermind.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,user,"Responses",responses)	
end

-- question answers

function Dialog.OpenWhatToDoDialog(user)
	local text = "That is a tough question. It's like asking what is the meaning of life? It all depends on your goals."

	responses = {
		{
			text = "I wish to earn coins.",
			handle = "MakeMoney",
		},
		{
			text = "I wish to hone my skills.",
			handle = "TrainSkills",
		},
		{
			text = "I want to hunt monsters.",
			handle = "HuntMonsters",
		},
		{
			text = "I want to create.",
			handle = "CreateItems",
		},
		{
			text = "Nevermind.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenMakeMoneyDialog(user)
	local text = "Just about any profession can earn money. Warriors, mages and other combat focused professions mainly earn coin by defeating the evil forces that threaten Celador."

	responses = {
		{
			text = "Go on.",
			handle = "MakeMoney2",
		},		
		{
			text = "Nevermind.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenMakeMoney2Dialog(user)
	local text = "There are folk in town who will pay coin for honest work. Mission dispatchers will reward you for assisting them with specific threats. Adventurers are always seeking companions and can lead you to some interesting places."

	responses = {
		{
			text = "Go on.",
			handle = "MakeMoney3",
		},		
		{
			text = "Nevermind.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenMakeMoney3Dialog(user)
	local text = "Those dedicated to the art of harvesting resources and crafting items make money by selling those items to other adventurers."

	responses = {
		{
			text = "Go on.",
			handle = "MakeMoney4",
		},		
		{
			text = "Nevermind.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenMakeMoney4Dialog(user)
	local text = "In addition, blacksmiths, carpenters and tailors in town are always looking to reward an honest day's work. Ask any of these craftsmen for work, and they will issue you an order to craft any number of goods."

	responses = {
		{
			text = "Go on.",
			handle = "MakeMoney5",
		},		
		{
			text = "Nevermind.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenMakeMoney5Dialog(user)
	local text = "And then there are those who choose less honest means. There too are theives and bandits who get rich by plundering those who rightfully earned their coin. Although, I do not suggest a greenhorn such as yourself start down that path."

	responses = {
		{
			text = "Ok.",
			handle = "Guide",
		},				
	}
	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenTrainSkillsDialog(user)
	local text = "Developing your skills only requires that you engage in activities that benefit from that particular skill. You can also seek out masters in the villages of Celador and they will train you to a basic level of understanding for a fee.\n\n(Open your Skills window to see a list of skills you can develop/train)"

	responses = {
		{
			text = "Ok.",
			handle = "Guide",
		},				
	}
	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenHuntMonstersDialog(user)
	local text = "The forces of evil are everywhere. However there are a few places near the main villages that folk like you can begin to make a name for yourself as a vanquisher of evil. I would start in either the sewers located beneath the village or the nearby graveyard."

	responses = {
		{
			text = "Ok.",
			handle = "Guide",
		},				
	}
	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenCreateItemsDialog(user)
	local text = "A crafter is nothing without his tools.\n\nFor blacksmiths use a forge, alchemists an alchemy table, fabricators of cloth and leather armor use a loom, scribes use an inscription table, carpenters use a carpentery table, and cooks use a cooking pot.\n\nCommunity stations for each of these crafts can be found in the largest villages of Celador."

	responses = {
		{
			text = "Go on.",
			handle = "CreateItems2",
		},		
		{
			text = "Nevermind.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenCreateItems2Dialog(user)
	local text = "While looking at the recipes of the items you can create, you will find they require resources.\n\nThese resources can be obtained through various forms of harvesting. Harvesting items from monsters, animals and plants require no skill. Harvesting things like ore, wood and fish all require specific skills and will take time to perfect."

	responses = {
		{
			text = "Ok.",
			handle = "Guide",
		},				
	}
	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenLearnAbilitiesDialog(user)
	local text = "Aside from the abilities granted to you from the item you hold in your right hand, you can perform up to three additional special abilities.\n\nThese abilities are trained by the various prestige trainers found throughout Celador. These trainers require that you bring them the training manual for the associated ability and that you have enough ability points. The training manuals for the most basic abilities can be obtained from corpses of any monsters, but a good place to look for them is in the local graveyard or sewers."

	responses = {
		{
			text = "Ok.",
			handle = "Guide",
		},				
	}
	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenLearnSpellsDialog(user)
	local text = "With only a little practice, anyone can learn to cast the most basic incantations.\n\nFirst, you will need a spell book. You can purchase empty ones at the local scribe. However, you may be able to find spellbooks for sale by other adventurers with some spells already inscribed into their pages."

	responses = {
		{
			text = "Go on.",
			handle = "LearnSpells2",
		},			
		{
			text = "Nevermind.",
			handle = "Guide",
		},	
	}
	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenLearnSpells2Dialog(user)
	local text = "If you are missing a spell, there are many ways to obtain spell scrolls. You can craft them with inscription, purchase from adventurers skilled in the art of inscription or find on the corpses of your enemies.\n\nYou can also directly cast a spell from the scroll. This requires less skill in the art of magic but will consume the spell scroll."

	responses = {
		{
			text = "Go on.",
			handle = "LearnSpells3",
		},			
		{
			text = "Nevermind.",
			handle = "Guide",
		},	
	}
	NPCInteraction(text,this,user,"Responses",responses)	
end

function Dialog.OpenLearnSpells3Dialog(user)
	local text = "Spells also require reagants. These reagants contain magical essence of which you must draw from to cast spells. Your spell book and spell scrolls will list the required reagants for each spell. You must have the correct reagants in your possession in order to successfully cast a spell. You can purchase reagents from the local alchemist or herbalist in any city, except Helm."

	responses = {
		{
			text = "Ok.",
			handle = "Guide",
		},				
	}
	NPCInteraction(text,this,user,"Responses",responses)
end

function Dialog.OpenGetHouseDialog(user)
	local text = "You must first obtain a land deed from the carpentry shop in town. I suggest you save every penny you can so can eventually afford one. Once you've got one, you can go out and find a small piece of the world you can call your own."

	responses = {
		{
			text = "Ok.",
			handle = "Guide",
		},				
	}
	NPCInteraction(text,this,user,"Responses",responses)
end

function Dialog.OpenHealSelfDialog(user)
	local text = "There are many ways to heal yourself. You can eat food after battle to restore some health.\n\nMages can use the art of Manifestion to cast heal spells, and warriors will more often rely on bandages and potions to recover health in combat."

	responses = {
		{
			text = "Ok.",
			handle = "Guide",
		},
	}
	NPCInteraction(text,this,user,"Responses",responses)
end

-- location answers

function TownCheck(user)
	local subregionName = ServerSettings.SubregionName
	if(ServerSettings.WorldName ~= "NewCelador" or (subregionName ~= "UpperPlains" and subregionName ~= "SouthernHills" and subregionName ~= "SouthernRim" and subregionName ~= "EasternFrontier")) then 
		local text = "You are really far from one of the main villages. Head back the way you came."
		
		NPCInteraction(text,this,user,"Responses")

		return false
	else
		local villageName = nil
		local villageLoc = nil
		if(subregionName == "UpperPlains") then
			villageName = "Eldeir Village"
			villageLoc = MapLocations.NewCelador["Upper Plains: Eldeir Village Spawn"]
		elseif(subregionName == "SouthernHills") then
			villageName = "Valus"
			villageLoc = MapLocations.NewCelador["Southern Hills: Valus Spawn"]
		elseif(subregionName == "SouthernRim") then
			villageName = "Pyros Landing"
			villageLoc = MapLocations.NewCelador["Southern Rim: Pyros Spawn"]
		elseif(subregionName == "EasternFrontier") then
			villageName = "Helm"
			villageLoc = MapLocations.NewCelador["Eastern Frontier: Helm Spawn"]
		end
		
		if(user:GetLoc():Distance(villageLoc) > townSizes[subregionName]) then
			PlayerObj:SendMessage("SetGuideWaypoint",user,villageName,villageLoc)

			local text = "Let's get you back to the village first. I've marked the location on your map!\n\n(Go to the waypoint on your mini-map for "..villageName..")"
		
			NPCInteraction(text,this,user,"Responses")

			return false
		end
	end

	return true
end

function Dialog.OpenFindShopDialog(user)
	if not(TownCheck(user)) then return end

	local text = "Sure I can help you find a shop. What are you looking for?"

	responses = {
		{
			text = "General supplies like tools and food.",
			handle = "FindGeneral",
		},
		{
			text = "Clothing and light armors.",
			handle = "FindTailor",
		},
		{
			text = "Weapons and heavy armor.",
			handle = "FindBlacksmith",
		},
		{
			text = "Mage supplies.",
			handle = "FindMage",
		},
		{
			text = "Horse stables.",
			handle = "FindStables",
		},
		{
			text = "Nevermind.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,PlayerObj,"Responses",responses)
end

function Dialog.OpenFindMonstersDialog(user)
	if not(TownCheck(user)) then return end

	local text = "Sure I can help you find something to kill. Which do you prefer?"

	responses = {
		{
			text = "Let's go to the sewers.",
			handle = "FindSewers",
		},
		{
			text = "Take me to the graveyard.",
			handle = "FindGraveyard",
		},		
		{
			text = "Nevermind.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,PlayerObj,"Responses",responses)
end

function Dialog.OpenFindCraftDialog(user)
	if not(TownCheck(user)) then return end

	local text = "Sure what sort of crafting are you looking to do?"

	responses = {
		{
			text = "I want to practice Fabrication.",
			handle = "FindLoom",
		},
		{
			text = "I want to practice Blacksmithing.",
			handle = "FindForge",
		},		
		{
			text = "I want to practice Carpentry.",
			handle = "FindCarpentry",
		},		
		{
			text = "I want to practice Alchemy.",
			handle = "FindAlchemy",
		},	
		{
			text = "I want to practice Inscription.",
			handle = "FindScribe",
		},		
		{
			text = "Nevermind.",
			handle = "Guide",
		},
	}

	NPCInteraction(text,this,PlayerObj,"Responses",responses)
end

function Dialog.OpenFindTowerDialog(user)
	local towerObj = FindObject(SearchTemplate("mage_tower",400))
	if not(towerObj) then
		local text = "Hmm, I can't seem to locate that right now. Ask me again later."

		NPCInteraction(text,this,PlayerObj,"Responses")
	else
		PlayerObj:SendMessage("SetGuideWaypoint",user,"Teleportation Tower",nil,towerObj)
		
		local text = "Ah so you are looking to travel to the far reaches of Celador. Yes I know exactly where the nearest teleportation tower is! I've marked the location on your map!\n\n(Go to the waypoint on your mini-map)"
	
		NPCInteraction(text,this,user,"Responses")
	end
end

function DoFindTownObj(user,eldeirTemplate,valusTemplate,pyrosTemplate,helmTemplate)
	local templateName = eldeirTemplate
	local subregionName = ServerSettings.SubregionName
	if(valusTemplate ~= nil) then				
		if(subregionName == "UpperPlains") then
			templateName = eldeirTemplate
		elseif(subregionName == "SouthernHills") then
			templateName = valusTemplate
		elseif(subregionName == "SouthernRim") then
			templateName = pyrosTemplate
		elseif(subregionName == "EasternFrontier") then
			templateName = helmTemplate
		end
	end

	local townObj = FindObject(SearchTemplate(templateName,townSizes[subregionName]))
	if not(townObj) then
		local text = "Hmm, I can't seem to locate that right now. Ask me again later."

		NPCInteraction(text,this,PlayerObj,"Responses")
	else
		local npcName = townObj:GetName()

		PlayerObj:SendMessage("SetGuideWaypoint",user,npcName,nil,townObj)
		
		local text = "Yes I know exactly where "..npcName.." is. I've marked the location on your map!\n\n(Go to the waypoint on your mini-map)"
	
		NPCInteraction(text,this,user,"Responses")
	end
end

function Dialog.OpenFindGeneralDialog(user)
	DoFindTownObj(user,"cel_merchant_general_store","val_merchant","pyros_merchant_general_store","helm_merchant_general_store")
end

function Dialog.OpenFindTailorDialog(user)
	DoFindTownObj(user,"cel_merchant_armorer","val_tailor","pyros_tailor","helm_tailor")
end

function Dialog.OpenFindBlacksmithDialog(user)
	DoFindTownObj(user,"cel_blacksmith","val_blacksmith","pyros_blacksmith","helm_blacksmith")
end

function Dialog.OpenFindMageDialog(user)
	DoFindTownObj(user,"cel_merchant_mage","val_alchemist","pyros_alchemist","helm_alchemist")
end

function Dialog.OpenFindStablesDialog(user)
	DoFindTownObj(user,"cel_merchant_stable_master","val_stable_master","pyros_stable_master","helm_stable_master")
end

function DoFindTownLoc(user,eldeirLocationName,valusLocationName,pyrosLocationName,helmLocationName)
	local destLoc = nil
	local destName = nil
	local subregionName = ServerSettings.SubregionName
	if(subregionName == "UpperPlains") then
		destLoc = MapLocations.NewCelador[eldeirLocationName]
		destName = eldeirLocationName
	elseif(subregionName == "SouthernHills") then
		destLoc = MapLocations.NewCelador[valusLocationName]
		destName = valusLocationName
	elseif(subregionName == "SouthernRim") then
		destLoc = MapLocations.NewCelador[pyrosLocationName]
		destName = pyrosLocationName
	elseif(subregionName == "EasternFrontier") then
		destLoc = MapLocations.NewCelador[helmLocationName]
		destName = helmLocationName
	end
	
	PlayerObj:SendMessage("SetGuideWaypoint",user,destName,destLoc)

	local text = "Yes I know exactly where the "..destName.." is. Just follow my directions!\n\n(Go to the waypoint on your mini-map)"

	NPCInteraction(text,this,user,"Responses")	
end

function Dialog.OpenFindSewersDialog(user)
	DoFindTownLoc(user,"Upper Plains: Sewer Entrance","Southern Hills: Sewer Entrance","Southern Rim: Sewer Entrance","Eastern Frontier: Sewer Entrance")
end

function Dialog.OpenFindGraveyardDialog(user)
	DoFindTownLoc(user,"Upper Plains: Graveyard","Southern Hills: Graveyard","Southern Rim: Graveyard","Eastern Frontier: Graveyard")
end

function Dialog.OpenFindLoomDialog(user)
	DoFindTownObj(user,"tool_loom")
end

function Dialog.OpenFindForgeDialog(user)
	DoFindTownObj(user,"tool_forge")
end

function Dialog.OpenFindCarpentryDialog(user)
	DoFindTownObj(user,"tool_carpentry_table")
end

function Dialog.OpenFindAlchemyDialog(user)
	DoFindTownObj(user,"workbench_alchemy")
end

function Dialog.OpenFindScribeDialog(user)
	DoFindTownObj(user,"workbench_inscription")
end

-- dismiss answers

function Dialog.OpenTempDismissDialog(user)
	DismissSelf()
	user:CloseDynamicWindow("Responses")
	PlayerObj:SendMessage("GuideDismissed")	
end

RegisterEventHandler(EventType.DynamicWindowResponse, "Responses",
	function(user,buttonID) 
		if ( Dialog["Open"..buttonID.."Dialog"] ~= nil) then 
			Dialog["Open"..buttonID.."Dialog"](user)
		elseif(buttonID == "Close") then
			RefreshAutoDimissTimer()
        	user:CloseDynamicWindow("Responses")
        end
	end)

RegisterEventHandler(EventType.Message,"Summon",function(...) SummonSelf() end)
RegisterEventHandler(EventType.Message,"Dismiss",function(...) DismissSelf() end)
RegisterEventHandler(EventType.Message,"SetOwner",function(...) SetOwner(...) end)
RegisterEventHandler(EventType.Message, "UseObject", function(user, usedType)
	if (user ~= PlayerObj) then
		user:SystemMessage("That is not your guide!","info")
		return
	end
	if ( usedType == "Interact" ) then
		Dialog.OpenGuideDialog(user)
	elseif(usedType == "Dismiss" ) then
		DismissSelf()
		PlayerObj:SendMessage("GuideDismissed")
	end
end)
RegisterEventHandler(EventType.Message,"Interact", function ( ... )	Dialog.OpenGuideDialog(...) end)

RegisterEventHandler(EventType.Message,"Welcome", function ( ... ) Dialog.OpenWelcomeDialog(...) end)

RegisterEventHandler(EventType.LoadedFromBackup,"",
	function ()
		PlayerObj = this:GetObjVar("controller")
		if not(PlayerObj) or not(PlayerObj:IsValid()) then
			this:Destroy()
			return
		end
		OnLoad()
	end)

RegisterEventHandler(EventType.ModuleAttached,"npe_magical_guide",
	function()
		OnLoad()
	end)

RegisterEventHandler(EventType.Timer,"AutoDismiss",
	function()
		DismissSelf()
		if(PlayerObj ~= nil and PlayerObj:IsValid()) then
			PlayerObj:SendMessage("GuideDismissed")
		end
	end)

RegisterEventHandler(EventType.Message,"RefreshAutoDimissTimer",
	function ()
		RefreshAutoDimissTimer()
	end)