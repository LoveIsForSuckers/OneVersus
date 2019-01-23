if modifier_frostball_talent_radius == nil then
	modifier_frostball_talent_radius = class({})
end

function modifier_frostball_talent_radius:IsHidden()
	return true
end

function modifier_frostball_talent_radius:IsPurgable()
	return false
end

function modifier_frostball_talent_radius:IsPermanent()
	return true
end

function modifier_frostball_talent_radius:RemoveOnDeath()
	return false
end