if modifier_weakening_touch == nil then
	modifier_weakening_touch = class({})
end

function modifier_weakening_touch:IsHidden()
	return false
end

function modifier_weakening_touch:IsDebuff()
	return true
end

function modifier_weakening_touch:IsPurgable()
	return true
end

function modifier_weakening_touch:GetEffectName()
	return "particles/units/heroes/hero_phantom/weakening_touch.vpcf"
end

function modifier_weakening_touch:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_weakening_touch:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_weakening_touch:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	
	return funcs
end

function modifier_weakening_touch:GetModifierPhysicalArmorBonus()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("minus_armor") * self:GetStackCount()
end