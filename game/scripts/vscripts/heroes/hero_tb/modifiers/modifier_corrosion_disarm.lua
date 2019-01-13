if modifier_corrosion_disarm == nil then
	modifier_corrosion_disarm = class({})
end

function modifier_corrosion_disarm:IsHidden()
	return false
end

function modifier_corrosion_disarm:IsDebuff()
	return true
end

function modifier_corrosion_disarm:IsPurgable()
	return true
end

function modifier_corrosion_disarm:GetEffectName()
	return "particles/units/heroes/hero_tb/corrosion_disarm.vpcf"
end

function modifier_corrosion_disarm:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_corrosion_disarm:GetTexture()
	return "corrosion"
end

function modifier_corrosion_disarm:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true
	}
	
	return state
end