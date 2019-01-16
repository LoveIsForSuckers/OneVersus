function second_skill( keys )
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
	local baseDamage = ability:GetSpecialValueFor("base_damage")
	local damageTalent = caster:FindAbilityByName("second_skill_talent_base_damage")
	if damageTalent and damageTalent:GetLevel() > 0 then
		baseDamage = baseDamage + damageTalent:GetSpecialValueFor("value")
	end
	
	local strength = caster:GetStrength()
	local damagemod = ability:GetLevelSpecialValueFor("damagemod", (ability:GetLevel() -1))
	local damagedealt = damagemod * strength + baseDamage

	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		ApplyDamage({victim = target, attacker = caster, damage = damagedealt, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , target, damagedealt, caster )
	end

end