if modifier_ritual_talent_puredamage == nil then
	modifier_ritual_talent_puredamage = class({})
end

function modifier_ritual_talent_puredamage:IsHidden()
	return true
end

function modifier_ritual_talent_puredamage:IsPurgable()
	return false
end

function modifier_ritual_talent_puredamage:IsPermanent()
	return true
end

function modifier_ritual_talent_puredamage:RemoveOnDeath()
	return false
end