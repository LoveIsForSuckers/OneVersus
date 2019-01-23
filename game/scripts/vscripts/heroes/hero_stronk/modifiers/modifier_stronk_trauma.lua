if modifier_stronk_trauma == nil then
	modifier_stronk_trauma = class({})
end

function modifier_stronk_trauma:IsDebuff()
	return true
end

function modifier_stronk_trauma:IsHidden()
	return false
end

function modifier_stronk_trauma:GetEffectName()
	return "particles/units/heroes/hero_stronk/earth_trauma.vpcf"
end

function modifier_stronk_trauma:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_stronk_trauma:GetTexture()
	return "stomp"
end

function modifier_stronk_trauma:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	
	return funcs
end

function modifier_stronk_trauma:GetModifierPreAttack_BonusDamage()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("trauma_reduction")
end