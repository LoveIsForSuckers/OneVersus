function second_skill( keys )
	local ability = keys.ability
	local caster = keys.caster
	local strength = caster:GetStrength()
	local target = keys.target
	local damagemod = ability:GetLevelSpecialValueFor("damagemod", (ability:GetLevel() -1))
	local damagedealt = damagemod * strength

	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		ApplyDamage({victim = target, attacker = caster, damage = damagedealt, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
		SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , target, damagedealt, caster )
	end

end