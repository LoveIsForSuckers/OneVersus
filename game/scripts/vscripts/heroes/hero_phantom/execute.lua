function AttackLanded(keys)
	local caster = keys.attacker
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.Modifier
	
	local stacks = 0
	if target:HasModifier( modifier ) then
		stacks = target:GetModifierStackCount( modifier, caster )
		target:RemoveModifierByName( modifier )
	end
	
	local base_damage = ability:GetLevelSpecialValueFor("dmg_base", ability:GetLevel() - 1 ) 
	if target:HasModifier( "modifier_disorientation" ) then
		local disorient_damage_talent = caster:FindAbilityByName("phantom_execute_talent_disorient_damage")
		if disorient_damage_talent and disorient_damage_talent:GetLevel() > 0 then
			base_damage = base_damage + disorient_damage_talent:GetSpecialValueFor("value")
		end
	end
	
	local dmg_per_stack = ability:GetLevelSpecialValueFor("dmg_per_stack", ability:GetLevel() - 1 )
	local dmg_per_stack_talent = caster:FindAbilityByName("phantom_execute_talent_dmg_per_stack")
	if dmg_per_stack_talent and dmg_per_stack_talent:GetLevel() > 0 then
		dmg_per_stack = dmg_per_stack + dmg_per_stack_talent:GetSpecialValueFor("value")
	end
	
	local totalDamage = base_damage + stacks * dmg_per_stack
	
	ApplyDamage({victim = target, attacker = caster, damage = totalDamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , target, totalDamage, caster )
end