if modifier_trap == nil then
	modifier_trap = class({})
end

function modifier_trap:IsHidden()
	return true
end

function modifier_trap:IsPurgable()
	return false
end

function modifier_trap:GetEffectName()
	return "particles/units/heroes/hero_engineer/trap.vpcf"
end

function modifier_trap:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_trap:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_FLYING] = true
	}
	
	return state
end