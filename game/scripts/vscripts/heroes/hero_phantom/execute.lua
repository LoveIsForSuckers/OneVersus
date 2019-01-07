function AttackLanded(keys)
	local caster = keys.attacker
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.Modifier
	local counter = keys.Counter
	
	local stacks = 0
	if target:HasModifier( counter ) then
		stacks = target:GetModifierStackCount( counter, caster )
		target:RemoveModifierByName( counter )
		local damage = ability:GetLevelSpecialValueFor("dmg_base", ability:GetLevel() - 1 ) + stacks * ability:GetLevelSpecialValueFor("dmg_per_stack", ability:GetLevel() - 1 )
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end

end