if modifier_trap_charges_initiator == nil then
	modifier_trap_charges_initiator = class({})
end

function modifier_trap_charges_initiator:IsHidden()
	return false
end

function modifier_trap_charges_initiator:IsPurgable()
	return false
end

function modifier_trap_charges_initiator:OnCreated(keys)
	if IsClient() then
		return
	end

	local caster = self:GetCaster()
	if caster == nil then
		return
	end
	
	local talent = self:GetAbility()
	local ability = caster:FindAbilityByName("engineer_trap")
	
	local maxCount = talent:GetSpecialValueFor("value") + ability:GetSpecialValueFor("max_charges")
	local cooldown = ability:GetSpecialValueFor("charge_restore_duration")
	caster:AddNewModifier(caster, ability, "modifier_charges", { max_count = maxCount, start_count = 1, replenish_time = cooldown})
	caster:RemoveModifierByName("modifier_trap_charges_initiator")
end