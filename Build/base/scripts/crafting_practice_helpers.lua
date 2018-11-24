
mSkillName = nil
mTool = nil
mLoc = nil

SKILL_TOOLS = {
	MetalsmithSkill = {
		Template = "tool_anvil",
		Name = "an Anvil",
		Distance = 2
	},
	FabricationSkill = {
		Template = "tool_loom",
		Name = "a Loom",
		Distance = 2
	},
	WoodsmithSkill = {
		Template = "tool_carpentry_table",
		Name = "a Work Bench",
		Distance = 2
	}
}

function BeginPracticeSkill(skillName)

	if ( this:HasTimer("CraftingPracticeTimer") ) then
		this:SystemMessage("You are already practicing.","info")
		return
	end

	mSkillName = skillName
	mLoc = this:GetLoc()

	if not( ResourcesAvailable() ) then
		this:SystemMessage("You don't have enough resources to practice.","info")
		CleanUp()
		return
	end

	Practice()
end

function Practice()

	if not( mLoc == this:GetLoc() ) then
		EndPractice("Practice interrupted.")
		return
	end

	mTool = GetNearbyTool()

	if ( mTool == nil ) then
		this:SystemMessage("You must be near ".. SKILL_TOOLS[mSkillName].Name .." to practice this skill.","info")
		CleanUp()
		return
	end

	local toolAnim = mTool:GetObjVar("ToolAnimation")
	if(toolAnim ~= nil) then
		this:PlayAnimation(toolAnim)
	end

	local toolSound = mTool:GetObjVar("ToolSound")
	if(toolSound ~= nil) then
		this:PlayObjectSound(toolSound, false, SkillData.AllSkills[mSkillName].Practice.Seconds)
	end

	FaceObject(this,mTool)

	this:ScheduleTimerDelay(TimeSpan.FromSeconds(SkillData.AllSkills[mSkillName].Practice.Seconds), "CraftingPracticeTimer")
	--this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(250), "CraftingPracticeTimer")
	ProgressBar.Show(
	{
		TargetUser = this,
		Label="Practicing",
		Duration=TimeSpan.FromSeconds(SkillData.AllSkills[mSkillName].Practice.Seconds),
		DialogId="PracticingProgressBar"
	})

	mTool = nil
end

function ConsumeResources()
	RequestConsumeResource(this,SkillData.AllSkills[mSkillName].Practice.ResourceType, SkillData.AllSkills[mSkillName].Practice.ConsumeAmount, "PracticeConsumeResource", this)
end

function ResourcesAvailable()
	if ( mSkillName == nil ) then
		DebugMessage("No skill provided for ResourcesAvailable in "..GetCurrentModule())
		return false
	end

	if ( SkillData.AllSkills[mSkillName].Practice.ResourceType == nil ) then
		DebugMessage("Crafting skill "..skillName.." does not have a practice resource type.")
		return false
	end

	local backpack = this:GetEquippedObject("Backpack")
	if ( backpack ~= nil ) then
		return ( CountResourcesInContainer(backpack,SkillData.AllSkills[mSkillName].Practice.ResourceType) >= SkillData.AllSkills[mSkillName].Practice.ConsumeAmount )
	end

	return false
end

function GetNearbyTool()
	return FindObject(SearchMulti(
    {
        SearchRange(mLoc, SKILL_TOOLS[mSkillName].Distance),
        SearchTemplate(SKILL_TOOLS[mSkillName].Template)
    }))
end

function EndPractice(message)
	this:SystemMessage(message)
	this:PlayAnimation("idle")
	CleanUp()
end

function CleanUp()
	ProgressBar.Cancel("PracticingProgressBar",this)
	this:RemoveTimer("CraftingPracticeTimer")
	this:DelModule(GetCurrentModule())
end

RegisterEventHandler(EventType.Timer, "CraftingPracticeTimer", function()
	ConsumeResources()
end)

RegisterEventHandler(EventType.Message, "ConsumeResourceResponse", 
	function (success, transactionId, user)
		if ( transactionId == "PracticeConsumeResource" ) then
			if ( success ) then
				local currentSkillLevel = GetSkillLevel(user,mSkillName)
				local chance = (1.037 ^ -currentSkillLevel) * ( SkillData.AllSkills[mSkillName].Practice.GainModifier or 1 )
				--user:NpcSpeech("Chance: "..chance)
				--SkillGainByChance(user, mSkillName, chance) -- if this ever gets used this should be updated, this implentation doesn't work.
				--user:SendMessage("RequestSkillGainCheckByChance", mSkillName, chance )
			end
		end

		if ( ResourcesAvailable() ) then
			Practice()
		else
			EndPractice("You have run out of material to practice on.")
		end
	end)

RegisterEventHandler(EventType.StartMoving, "", function()
	EndPractice("Practicing stopped.")
end)