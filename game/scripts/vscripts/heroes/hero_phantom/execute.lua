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
	end
	
	local totalDamage = ability:GetLevelSpecialValueFor("dmg_base", ability:GetLevel() - 1 ) + stacks * ability:GetLevelSpecialValueFor("dmg_per_stack", ability:GetLevel() - 1 )
	ApplyDamage({victim = target, attacker = caster, damage = totalDamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , target, totalDamage, caster )

end