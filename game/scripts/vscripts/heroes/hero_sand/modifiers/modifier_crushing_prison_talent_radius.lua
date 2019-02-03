if modifier_crushing_prison_talent_radius == nil then
	modifier_crushing_prison_talent_radius = class({})
end

function modifier_crushing_prison_talent_radius:IsHidden()
	return true
end

function modifier_crushing_prison_talent_radius:IsPurgable()
	return false
end

function modifier_crushing_prison_talent_radius:IsPermanent()
	return true
end

function modifier_crushing_prison_talent_radius:RemoveOnDeath()
	return false
end