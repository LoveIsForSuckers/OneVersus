function OnAttackLanded( keys )
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
	if caster:IsIllusion() then return nil end
	if not target:IsHero() then return nil end
	
	local damagemod
	
	if caster:IsRangedAttacker() then 
		damagemod = ability:GetLevelSpecialValueFor("hp_percent_dmg_ranged",ability:GetLevel() - 1)
	else
		damagemod = ability:GetLevelSpecialValueFor("hp_percent_dmg_melee",ability:GetLevel() - 1)
	end
	
	local damagedealt = (damagemod * target:GetMaxHealth()) / 100
	target:EmitSound("OneVersus.Desecrate")
	ApplyDamage({victim = target, damage = damagedealt, damage_type = DAMAGE_TYPE_PURE, attacker = caster, ability = ability })
end