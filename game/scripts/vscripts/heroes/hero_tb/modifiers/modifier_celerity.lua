if modifier_celerity == nil then
	modifier_celerity = class({})
end

function modifier_celerity:IsHidden()
	return false
end

function modifier_celerity:IsDebuff()
	return false
end

function modifier_celerity:IsPurgable()
	return true
end

function modifier_celerity:GetEffectName()
	return "particles/units/heroes/hero_tb/celerity.vpcf"
end

function modifier_celerity:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_celerity:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	
	return funcs
end

function modifier_celerity:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	
	return state
end

function modifier_celerity:GetModifierEvasion_Constant()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("dodge")
end

function modifier_celerity:GetModifierMoveSpeedBonus_Constant()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("movespeed")
end