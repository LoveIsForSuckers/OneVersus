function on_spell_start (keys)
	local ability = keys.ability
	ability.affected_targets = 0
end

function on_projectile_finish( keys )
	local point = keys.target_points[1]
	local caster = keys.caster
	local ability = keys.ability
	
	FindClearSpaceForUnit( caster, point, false )
	
	local heal_talent = caster:FindAbilityByName("lion_dash_talent_heal_per_target")
	if heal_talent and heal_talent:GetLevel() > 0 then
		local heal_amount = ability.affected_targets * heal_talent:GetSpecialValueFor("value")
		caster:Heal(heal_amount, caster)
		SendOverheadEventMessage( nil, OVERHEAD_ALERT_HEAL , caster, heal_amount, caster )
	end
	
	ability.affected_targets = 0
end

function affect_target(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	target:EmitSound("Hero_Lion.ImpaleHitTarget")
	
	local damage = ability:GetLevelSpecialValueFor("hero_dmg", ability:GetLevel() - 1)
	
	if not target:IsHero() then
		damage = damage * 2 -- maybe unhack into ability_special?
	end
	
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	
	local slow_talent = caster:FindAbilityByName("lion_dash_talent_slow")
	if slow_talent and slow_talent:GetLevel() > 0 then
		local slow_duration = slow_talent:GetSpecialValueFor("value")
		ability:ApplyDataDrivenModifier(caster, target, "dash_talent_debuff", { duration = slow_duration })
	end
	
	if ability.affected_targets then
		ability.affected_targets = ability.affected_targets + 1
	else
		ability.affected_targets = 1
	end
end