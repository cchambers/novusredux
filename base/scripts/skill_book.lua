-- SKILL BOOK NEEDS COMPLETE REFACTOR
--[[

mUser = nil
DEFAULT_SKILL_GAIN = 5
GAIN_EFFECT_DIVISOR = ServerSettings.Skills.SkillFactorDivisor or 10 --Default 1850 (The higher this number the faster the gain)
GAIN_RATE_MULTIPLIER = ServerSettings.Skills.SkillGainMultiplier or 1 --Default 1 (2.55 For Demo, The higher this number the faster the gain Doubling cuts standard gain times in half)

function UpdateSkillBookTooltipString()
	local skillName = this:GetObjVar("Skill")
	if( skillName ~= nil ) then	
		SetTooltipEntry(this,"skill_book","[F7CC0A]" .. GetSkillDisplayName(skillName) .. " - 101 \n" .. GetSkillDescription(skillName))
	end
end

function ValidateUse(user)
	if( user == nil or not(user:IsValid()) ) then
		return false
	end

	if( this:TopmostContainer() ~= user ) then
		user:SystemMessage("[$2593]")
		return false
	end

	if (user:HasTimer("SkillBookCooldownTimer"..this:GetObjVar("Skill"))) then
		user:SystemMessage("[$2594]")
		return false
	end

	local mySkill = this:GetObjVar("Skill")
	if (mySkill == nil) then 
		user:SystemMessage("[F7CC0A] Invalid Book")
		return false
	end

	return true
end

function ItemUsed(user)
	this:PlayObjectSound("Use",true)
	user:ScheduleTimerDelay(TimeSpan.FromHours(24),"SkillBookCooldownTimer"..this:GetObjVar("Skill"))
	this:Destroy()
end

function GetLevelMaxXP(level)
	if(level <= 1) then return 1 end
	local sumSk = GetSkillSumLevel(level)
	local levLog =  math.log(level) / math.log(40)
	local sumSkLog = math.log(sumSk) / math.log(10)
	local gFac = levLog * sumSkLog
	local fFac = (sumSk * math.pow(gFac,5)) / (math.max(.01,GAIN_RATE_MULTIPLIER) * math.max(.01,GAIN_EFFECT_DIVISOR))
	--DebugMessage("XP Cap for Level: " ..tostring(level) .. " is " ..tostring(math.ceil(fFac)))
	--DebugMessage("sumSk:" ..tostring(sumSk).."levLog:"..tostring(levLog).."sumSkLog:"..tostring(sumSkLog).."gFac:"..tostring(gFac).."gFac4:"..tostring(math.pow(gFac,4)))
	local minXpPerLev = ServerSettings.Skills.MinXpPerLevel or 3
	return math.max(minXpPerLev,math.ceil(fFac))
end

function CalculateXPGain()
	local amount = this:GetObjVar("SkillGainAmount") or DEFAULT_SKILL_GAIN	
	local XPcount = 0
	for i=1,amount do 
		XPcount = XPcount + GetLevelMaxXP(i)
	end
	return XPcount
end

function HandleUseSkillBook(user,buttonId)
	if( user ~= mUser ) then
		return
	end

	buttonId = tonumber(buttonId)
	if (buttonId == 0 and ValidateUse(user)) then	

		mySkill = this:GetObjVar("Skill")
		
		user:SystemMessage("[$2595]")

		user:SendMessage("AddXPLevel",mySkill,CalculateXPGain())
		ItemUsed(user)				
	end
	mUser = nil
end

RegisterEventHandler(EventType.Message, "UseObject", 
	function(user,usedType)
		if(usedType ~= "Use" and usedType ~= "Learn" and usedType ~= "Read") then return end

		-- using without canceling previous? odd
		if(mUser == user) then
			return
		end

		if not(ValidateUse(user)) then
			return
		end
		
		local mySkill = this:GetObjVar("Skill")

		ClientDialog.Show{
			TargetUser = user,
			DialogId = "UseSkillBook",
			TitleStr = "Learn Skill",
			DescStr = "Do you wish to learn the basics of "..GetSkillDisplayName(mySkill).."?",
			ResponseFunc = HandleUseSkillBook
		}

		mUser = user
	end)

RegisterEventHandler(EventType.Message, "TooltipUpdate", 
	function()
		UpdateSkillBookTooltipString()
	end)

RegisterSingleEventHandler(EventType.ModuleAttached, "skill_book", 
	function()
		AddUseCase(this,"Learn",true,"HasObject")
		-- give other scripts some time to add bonuses before we update the tooltip
		CallFunctionDelayed(TimeSpan.FromSeconds(1), UpdateSkillBookTooltipString)
	end)
]]