if modifier_crushing_prison == nil then
	modifier_crushing_prison = class({})
end

function modifier_crushing_prison:IsHidden()
	return false
end

function modifier_crushing_prison:IsDebuff()
	return true
end

function modifier_crushing_prison:IsPurgable()
	return true
end

function modifier_crushing_prison:GetEffectName()
	return "particles/units/heroes/hero_sand/crushing_prison.vpcf"
end

function modifier_crushing_prison:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_crushing_prison:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_crushing_prison:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	
	return funcs
end

function modifier_crushing_prison:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}
	
	return state
end

function modifier_crushing_prison:GetModifierMagicalResistanceBonus()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("magic_resist")
end

function modifier_crushing_prison:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_crushing_prison:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local ability = self:GetAbility()
		local radius = ability:GetAOERadius()
		
		local damage_type = ability:GetAbilityDamageType()
		local damage = ability:GetLevelSpecialValueFor("damage_per_tick", ability:GetLevel() - 1)
		local damageTalent = caster:FindAbilityByName("sand_crushing_prison_talent_damage")
		if damageTalent and damageTalent:GetLevel() > 0 then
			damage = damage + damageTalent:GetSpecialValueFor("value")
		end
		
		local nearbyEnemies = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		for i, unit in ipairs(nearbyEnemies) do
			ApplyDamage( { victim = unit, attacker = caster, damage = damage, damage_type = damage_type, ability = ability } )
		end
	end
end