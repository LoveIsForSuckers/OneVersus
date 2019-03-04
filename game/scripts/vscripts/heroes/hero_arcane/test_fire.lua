function OnProjectileHitUnit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	
	target:EmitSound("Hero_Oracle.FortunesEnd.Target")
	
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1) )
	local damage_talent = caster:FindAbilityByName("arcane_test_fire_talent_damage")
	if damage_talent and damage_talent:GetLevel() > 0 then
		damage = damage + damage_talent:GetSpecialValueFor("value")
	end
	
	ApplyDamage({ attacker = caster, victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })
end