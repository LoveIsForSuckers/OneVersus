function CheckAttack (keys)
	local ability = keys.ability
	local attacker = keys.attacker
	local target = keys.target
	local from_max_mana_damage = ability:GetLevelSpecialValueFor("from_max_mana_damage", ability:GetLevel()-1)/100
	
	if target:IsRooted() then
		EmitSoundOn(keys.Sound, target)
		local poof = ParticleManager:CreateParticle(keys.Particle, PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControl(poof, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(poof, 3, target:GetAbsOrigin())
		ApplyDamage({victim = target, attacker = attacker, damage = attacker:GetMaxMana() * from_max_mana_damage, damage_type = ability:GetAbilityDamageType()})
	end
end