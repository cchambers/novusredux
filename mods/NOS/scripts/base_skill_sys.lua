require 'default:base_skill_sys'

function ValidateSkillCapRequest(skillName, requestedCap, target)
	requestedCap = 100
	-- ensure cap is between 0 and max
	requestedCap = math.floor(requestedCap)
	requestedCap = math.min(requestedCap, ServerSettings.Skills.PlayerSkillCap.Single)
	requestedCap = math.max(requestedCap, 0)

	if not(IsValidSkill(skillName)) then
		return "Invalid skill '"..skillName.."'.", requestedCap
	end

	if(target == nil) or not(target:IsValid()) then
		return "Invalid Target", requestedCap
	end

	return nil, requestedCap

end
