function apply_effects(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_warpstrike_stun", { duration = duration })
	
	local resonance_reset_talent = caster:FindAbilityByName("venge_warpstrike_talent_resonance_synergy")
	if resonance_reset_talent and resonance_reset_talent:GetLevel() > 0 then
		local resonance_ability = caster:FindAbilityByName("venge_resonance")
		if resonance_ability and resonance_ability:GetLevel() > 0 then
			resonance_ability:EndCooldown()
		end
	end
	
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local damage_talent = caster:FindAbilityByName("venge_warpstrike_talent_damage")
	if damage_talent and damage_talent:GetLevel() > 0 then
		damage = damage + damage_talent:GetSpecialValueFor("value")
	end
	
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability})
end