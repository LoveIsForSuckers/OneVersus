if modifier_frostball_root == nil then
	modifier_frostball_root = class({})
end

function modifier_frostball_root:IsHidden()
	return false
end

function modifier_frostball_root:IsDebuff()
	return true
end

function modifier_frostball_root:IsPurgable()
	return true
end

function modifier_frostball_root:GetEffectName()
	return "particles/units/heroes/hero_frost/abzero_debuff.vpcf"
end

function modifier_frostball_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_frostball_root:GetTexture()
	return "frostball"
end

function modifier_frostball_root:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_DISARMED] = true
	}
	
	return state
end