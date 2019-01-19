if modifier_ritual_talent_cooldown == nil then
	modifier_ritual_talent_cooldown = class({})
end

function modifier_ritual_talent_cooldown:IsHidden()
	return true
end

function modifier_ritual_talent_cooldown:IsPurgable()
	return false
end

function modifier_ritual_talent_cooldown:IsPermanent()
	return true
end

function modifier_ritual_talent_cooldown:RemoveOnDeath()
	return false
end