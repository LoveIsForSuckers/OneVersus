if modifier_trap_debuff == nil then
	modifier_trap_debuff = class({})
end

function modifier_trap_debuff:IsHidden()
	return false
end

function modifier_trap_debuff:IsDebuff()
	return true
end

function modifier_trap_debuff:IsPurgable()
	return true
end

function modifier_trap_debuff:GetEffectName()
	return "particles/units/heroes/hero_engineer/trapped.vpcf"
end

function modifier_trap_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_trap_debuff:GetTexture()
	return "trap"
end

function modifier_trap_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	
	return funcs
end

function modifier_trap_debuff:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("slow")
end