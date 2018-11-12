--require 'base_magic_sys'
local GRIMAURA_DAMAGE_RANGE = 3.5
local mTargetLoc = nil
local function ValidateGrimAura(targetLoc)
	--DebugMessage("Debuggery Deh Yah")
	if( not(IsPassable(targetLoc)) ) then
		this:SystemMessage("[$2609]")
		return false
	end

	if not(this:HasLineOfSightToLoc(targetLoc,ServerSettings.Combat.LOSEyeLevel)) then
		this:SystemMessage("[$2610]")
		return false
	end
	return true
end

RegisterEventHandler(EventType.Message,"GrimauraSpellTargetResult",
	function (targetLoc)
		-- validate FlamePillar
--DebugMessage("Debuggery Here2")
		if not(ValidateGrimAura(targetLoc)) then
			EndEffect()
			return
		end
		--DebugMessage("TARGETED!!")
	--DebugMessage("Debuggery Here")
		PlayEffectAtLoc("GrimAuraEffect",targetLoc, 8)
		--CreateTempObj("spell_aoe",targetLoc,"aoe_created")
		this:FireTimer("GrimAuraPulse",targetLoc)
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(4),"GrimAuraRemove")
	end)


RegisterEventHandler(EventType.CreatedObject,"aoe_created",function (success,objRef)
	if (success) then
		objRef:SetObjVar("DecayTime",4)
	end
end)

RegisterEventHandler(EventType.Timer, "GrimAuraPulse",
	function(targetLoc)
	--DebugMessage("PULSE!!")
	local mobiles = FindObjects(SearchMulti({
					SearchRange(targetLoc,GRIMAURA_DAMAGE_RANGE),
					SearchMobile()}), GameObj(0))
	local myDSkill = GetSkillLevel(this,"ChannelingSkill")
	local myTSkill = GetSkillLevel(this,"NecromancySkill")
	for i,v in pairs(mobiles) do
		--v:NpcSpeech("Burning Burning burning")
		if(not IsDead(v)) and not(v == this) then
			if not(v:HasModule("sp_armor_reduction_effect")) then v:AddModule("sp_armor_reduction_effect") end
			v:SendMessage("INIT_GRIM_AURA", this, myTSkill, myDSkill)

			if (v:IsPlayer()) then
				--(target,identifier,displayName,icon,tooltip,isDebuff,timespan)
				AddBuffIcon(v,"GrimAura","Grim Aura","grimaura","Damage taken increased by 10%",true,8)
			end
			v:PlayEffectWithArgs("GrimAuraDebuffEffect",0.0,"Bone=Ground")
		end
	end

end)

RegisterEventHandler(EventType.Timer,"GrimAuraRemove",
	function()
		EndEffect()
	end)


function EndEffect()
	--DebugMessage("Ending!!")
	if(this:HasTimer("GrimAuraPulse")) then this:RemoveTimer("GrimAuraPulse") end
	if(this:HasTimer("GrimAuraRemove")) then this:RemoveTimer("GrimAuraRemove") end
	this:DelModule("sp_grim_aura_effect")
end