RES_PERCENTAGE = 0.6
MAX_MINIONS = ServerSettings.Combat.MaxMinions
SKILL_PER_SKELETON = 15
--DebugMessage(1)

function HandleLoaded(source,target)
	--DFB TODO: THIS SHOULD BE MORE SOPHISTICATED
	local myResSource = this:GetObjVar("sp_spawn_skeleton_effectSource")
	
	local currentMinions = FindObjects(SearchObjVar("controller",myResSource))
	--DebugMessage("followers = "..#currentFollowers)
	if (#currentMinions >= MAX_MINIONS and not IsDemiGod(myResSource)) then
		myResSource:SystemMessage("[D70000]You have too many minions in play![-]")
		EndEffect()
		return
	end

	local maxFollowers = math.max(1,math.min(GetSkillLevel(myResSource,"NecromancySkill")/SKILL_PER_SKELETON,MAX_MINIONS))
	if (#currentMinions >= maxFollowers and not IsDemiGod(myResSource)) then
		myResSource:SystemMessage("[$2622]")
		EndEffect()
		return
	end

	if not(this:HasObjVar("sp_spawn_skeleton_effectSource")) then
		EndEffect()
		return
	end
	if (this:HasObjVar("controller") and this:GetObjVar("controller") == myResSource) then
		myResSource:SystemMessage("[$2623]")
		EndEffect()
		return
	end
	if not(myResSource:IsValid()) then
		EndEffect()
		return
	end

	if (this:HasObjVar("noloot")) then
		myResSource:SystemMessage("[$2624]")
		EndEffect()
		return
	end

	if (not IsDead(this)) then
		myResSource:SystemMessage("[D70000]Your target must be dead![-]")
		EndEffect()
		return
	end
	if (this:IsPlayer()) then
		myResSource:SystemMessage("[$2625]")
		EndEffect()
		return
	end
	if (this:HasObjVar("NoSkele")) then
		myResSource:SystemMessage("[$2626]")
		EndEffect()
		return
	end
	if (not IsHuman(this) and not IsUndead(this)) then
		myResSource:SystemMessage("[$2627]")
		EndEffect()
		return
	end
	--this:SystemMessage("[F7CC0A] Life sturs from your dead body.[-]")
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "ResurrectTimer", myResSource)
	this:PlayEffect("VoidAuraEffect",4)
	this:PlayAnimation("revive")
end

function EndEffect()
	this:DelModule("sp_spawn_skeleton_effect")
end

RegisterEventHandler(EventType.Timer, "EndResEffect", 
	function ()
		EndEffect()
	end)
RegisterEventHandler(EventType.ModuleAttached, "sp_spawn_skeleton_effect", 
	function (source,target,location)
		--DebugMessage(2)
		HandleLoaded(source,target,location)
	end)

--RegisterSingleEventHandler(EventType.ModuleAttached, "sp_spawn_skeleton_effect", 
--	function ()
--		HandleLoaded()
--	end)

RegisterEventHandler(EventType.Timer, "ResurrectTimer", 
	function (resSource)
		--DebugMessage("Creating skelton")
		CreateObj("skeleton_minion",this:GetLoc(),"CreateSkeleton")
		this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(1500), "EndResEffect")
	end)

RegisterEventHandler(EventType.CreatedObject,"CreateSkeleton",
function (success,objRef)
	local myResSource = this:GetObjVar("sp_spawn_skeleton_effectSource")
	if myResSource == nil or not(myResSource:IsValid()) then
		DebugMessage("[sp_spawnskeleton_effect] ERROR: Could not find assigned spell source")
		EndEffect()
		return
	end
	objRef:SetObjVar("NoReset",true)
    if (not myResSource:HasTimer("FollowerSkillGain")) then
        myResSource:SendMessage("RequestSkillGainCheck", "NecromancySkill")
    end
    myResSource:ScheduleTimerDelay(TimeSpan.FromSeconds(45),"FollowerSkillGain")

	objRef:SetObjVar("ControllingSkill","NecromancySkill")
	objRef:SetObjVar("Summon", true)
	myResSource:SendMessage("AddFollowerMessage", {["pet"] = objRef})
	AutoEquipMob(objRef,this)
	objRef:SendMessage("ReassignSuperior",myResSource)
	this:SendMessage("MoveToGround")
	--DFB HACK: Because if you equip or move items while destroying them on the same frame it seems to destroy the objects as well.
	RegisterSingleEventHandler(EventType.Message,"MoveToGround",function() 
		MoveEquipmentToGround(this)
		this:SendMessage("DestroyMe")
		RegisterSingleEventHandler(EventType.Message,"DestroyMe",function() 
			EndEffect()
			this:Destroy()
		end)
		--this:Destroy() 
	end)
end)

