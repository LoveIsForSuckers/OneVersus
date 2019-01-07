function Cast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.Modifier
	local caster_shield_modifier = keys.CasterShieldModifier
	local shield_transfer = ability:GetLevelSpecialValueFor("shield_transfer", ability:GetLevel() - 1 )

	ability:ApplyDataDrivenModifier(caster, target, modifier, {} )

	if caster ~= target and caster:HasModifier(caster_shield_modifier) then
		local shield_drain = caster.ShieldLeft * shield_transfer / 100
		ApplyDamage({victim = caster, attacker = caster, damage = shield_drain, damage_type = DAMAGE_TYPE_PURE, ability = ability })
		target:Heal(shield_drain, caster)
	end
end	