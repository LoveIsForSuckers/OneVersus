if modifier_reconstruct_talent_health_tooltip == nil then
	modifier_reconstruct_talent_health_tooltip = class({})
end

function modifier_reconstruct_talent_health_tooltip:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS 
	}
	
	return funcs
end

function modifier_reconstruct_talent_health_tooltip:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_reconstruct_talent_health_tooltip:OnTooltip(keys)
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("value") * self:GetStackCount()
end

function modifier_reconstruct_talent_health_tooltip:GetModifierExtraHealthBonus()
	local ability = self:GetAbility()
	local value = ability:GetSpecialValueFor("value")
	local stackcount = self:GetStackCount()
	return value * stackcount
end

function modifier_reconstruct_talent_health_tooltip:GetTexture()
	return "reconstruction"
end