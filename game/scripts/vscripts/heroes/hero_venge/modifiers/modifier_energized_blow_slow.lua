if modifier_energized_blow_slow == nil then
	modifier_energized_blow_slow = class({})
end

function modifier_energized_blow_slow:IsHidden()
	return false
end

function modifier_energized_blow_slow:IsDebuff()
	return true
end

function modifier_energized_blow_slow:IsPurgable()
	return true
end

function modifier_energized_blow_slow:GetEffectName()
	return "particles/units/heroes/hero_venge/energized_hit.vpcf"
end

function modifier_energized_blow_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_energized_blow_slow:GetTexture()
	return "energized"
end

function modifier_energized_blow_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	
	return funcs
end

function modifier_energized_blow_slow:GetModifierAttackSpeedBonus_Constant()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("as_slow")
end

function modifier_energized_blow_slow:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("ms_slow")
end

function modifier_energized_blow_slow:GetModifierPhysicalArmorBonus()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("minusarmor")
end