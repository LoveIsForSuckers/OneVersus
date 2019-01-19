function OnProjectileHitUnit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	target:EmitSound("Hero_Dazzle.Poison_Touch")
	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_shadow_missile_slow", {})
	
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local damageTalent = caster:FindAbilityByName("dazzle_shadow_missile_talent_damage")
	if damageTalent and damageTalent:GetLevel() > 0 then
		local strength = caster:GetStrength()
		local strModifier = damageTalent:GetSpecialValueFor("value")
		local extraDamage = strength * strModifier
		damage = damage + extraDamage
	end
	ApplyDamage({victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = caster, ability = ability })
end