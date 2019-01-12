function cast_ritual( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local hp_percent = ability:GetLevelSpecialValueFor("hp_percent", (ability:GetLevel() - 1))
	local radius = ability:GetLevelSpecialValueFor("damage_radius", (ability:GetLevel() - 1))
	local target_hp = target:GetHealth()
	
	damage_dealt = (target_hp * hp_percent) / 100

	local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), target, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false )

	ApplyDamage({ victim = target, attacker = caster, damage = damage_dealt, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , target, damage_dealt, caster )

end