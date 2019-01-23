if modifier_stronk_stomp_cooldown == nil then
	modifier_stronk_stomp_cooldown = class({})
end

function modifier_stronk_stomp_cooldown:IsHidden()
	return true
end

function modifier_stronk_stomp_cooldown:IsPurgable()
	return false
end

function modifier_stronk_stomp_cooldown:IsPermanent()
	return true
end

function modifier_stronk_stomp_cooldown:RemoveOnDeath()
	return false
end