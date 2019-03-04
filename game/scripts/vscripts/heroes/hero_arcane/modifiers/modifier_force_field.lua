if modifier_force_field == nil then
	modifier_force_field = class({})
end

function modifier_force_field:IsHidden()
	return false
end

function modifier_force_field:IsDebuff()
	return false
end

function modifier_force_field:IsPurgable()
	return true
end

function modifier_force_field:GetEffectName()
	return "particles/units/heroes/hero_arcane/force_field.vpcf"
end

function modifier_force_field:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_force_field:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local target = self:GetParent()
		
		local pulse_delay = ability:GetLevelSpecialValueFor("pulse_delay", ability:GetLevel() - 1)
		local pulse_delay_talent = caster:FindAbilityByName("arcane_force_field_talent_pulse_delay_reduction")
		if pulse_delay_talent and pulse_delay_talent:GetLevel() > 0 then
			pulse_delay = pulse_delay + pulse_delay_talent:GetSpecialValueFor("value")
		end
		
		target:EmitSound("Hero_Oracle.FatesEdict.Cast")
		self:StartIntervalThink(pulse_delay)
	end
end

function modifier_force_field:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local target = self:GetParent()
		local caster = self:GetCaster()
		
		local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
		local stun_duration = ability:GetLevelSpecialValueFor("ministun", ability:GetLevel() - 1)
		local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
		local damage_talent = caster:FindAbilityByName("arcane_force_field_talent_damage")
		if damage_talent and damage_talent:GetLevel() > 0 then
			damage = damage + damage_talent:GetSpecialValueFor("value")
		end
		
		target:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
		
		local damageTable = { attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self }
		
		local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
		local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local target_flags = DOTA_UNIT_TARGET_FLAG_NONE
		
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_team, target_types, target_flags, FIND_ANY_ORDER, false)
		
		for _,enemy in pairs(units) do
			if enemy ~= nil and (not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
				enemy:AddNewModifier(caster, ability, "modifier_stunned", { duration = stun_duration })
				damageTable.victim = enemy
				ApplyDamage(damageTable)
			end
		end
	end
end