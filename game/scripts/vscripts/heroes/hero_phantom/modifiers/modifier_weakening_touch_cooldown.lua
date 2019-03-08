if modifier_weakening_touch_cooldown == nil then
	modifier_weakening_touch_cooldown = class({})
end

function modifier_weakening_touch_cooldown:IsHidden()
	return true
end

function modifier_weakening_touch_cooldown:IsPurgable()
	return false
end

function modifier_weakening_touch_cooldown:IsPermanent()
	return true
end

function modifier_weakening_touch_cooldown:RemoveOnDeath()
	return false
end