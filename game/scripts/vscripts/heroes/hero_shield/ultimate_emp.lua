function Cast( keys )
	local target = keys.caster
	local ability = keys.ability
	local s_ability = keys.ShieldAbility
	local shield_ability = target:FindAbilityByName(s_ability)
	local modifier = keys.Modifier
	local slow_modifier = keys.SlowModifier
	local particle = keys.Particle
	local delay = ability:GetLevelSpecialValueFor("delay", ability:GetLevel() - 1)
	local damage = ability:GetLevelSpecialValueFor("basic_damage", ability:GetLevel() - 1)
	local aoe = ability:GetLevelSpecialValueFor("area_of_effect", ability:GetLevel() - 1 )

	target:EmitSound("OneVersus.EnergyCharge5Sec")

	local effect = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, target )

	Timers:CreateTimer({
		endTime = delay,
		callback = function()

			ParticleManager:DestroyParticle(effect, false)
			target:EmitSound("OneVersus.EnergyBlast")

			if target:HasModifier( modifier ) then
				local cooldown = shield_ability:GetCooldown( shield_ability:GetLevel() - 1 )
				local shield_factor = ability:GetLevelSpecialValueFor("damage_per_shield", ability:GetLevel() - 1)
				local shield_factor_talent = target:FindAbilityByName("ultimate_emp_talent_damage_per_shield")
				if shield_factor_talent and shield_factor_talent:GetLevel() > 0 then
					shield_factor = shield_factor + shield_factor_talent:GetSpecialValueFor("value")
				end
				
				damage = damage + target.ShieldLeft * shield_factor
		
				target.ShieldLeft = nil
				if target.Numbers then
					ParticleManager:DestroyParticle(target.Numbers, true)
				end
				target.Numbers = nil
				target:RemoveModifierByName(modifier)
				shield_ability:StartCooldown( cooldown )
			end

			local nearbyEnemies = FindUnitsInRadius(target:GetTeam(), target:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
			for i, unit in ipairs(nearbyEnemies) do
				ApplyDamage( { victim = unit, attacker = target, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = ability } )
				ability:ApplyDataDrivenModifier(target, unit, slow_modifier, {} )
			end

		end
	})
end