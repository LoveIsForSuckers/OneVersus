function CheckAttack (keys)
	local ability = keys.ability
	local attacker = keys.attacker
	local target = keys.target
	
	if target:IsMagicImmune() then
		return nil
	end
	
	if target:IsRooted() then
		EmitSoundOn(keys.Sound, target)
		
		local poof = ParticleManager:CreateParticle(keys.Particle, PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControl(poof, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(poof, 3, target:GetAbsOrigin())
		
		local from_max_mana_damage = ability:GetLevelSpecialValueFor("from_max_mana_damage", ability:GetLevel() - 1) / 100
		local extra_max_mana_damage_talent = attacker:FindAbilityByName("lich_deep_freeze_talent_from_max_mana_damage")
		if extra_max_mana_damage_talent and extra_max_mana_damage_talent:GetLevel() > 0 then
			local talent_value = extra_max_mana_damage_talent:GetSpecialValueFor("value") / 100
			from_max_mana_damage = from_max_mana_damage + talent_value
		end
		
		local totalDamage = attacker:GetMaxMana() * from_max_mana_damage
		ApplyDamage({victim = target, attacker = attacker, damage = totalDamage, damage_type = ability:GetAbilityDamageType()})
		
		SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , target, totalDamage, attacker )
	end
end