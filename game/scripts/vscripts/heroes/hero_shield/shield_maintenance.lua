function OnTick( keys )
	local target = keys.caster
	local particle = keys.Particle
	local ability = keys.ability
	local s_ability = keys.ShieldAbility
	local shield_ability = target:FindAbilityByName(s_ability)
	local modifier = keys.Modifier

	local s_level = shield_ability:GetLevel()

	if (s_level) <= 0 then
		local hep = ability:GetLevelSpecialValueFor("unlearned_heal", ability:GetLevel() - 1)
		target:Heal(hep,target)
		return nil
	end

	if target:HasModifier( modifier ) then
		local maxshield = shield_ability:GetLevelSpecialValueFor("max_shield",shield_ability:GetLevel() - 1 )
		local max_shield_talent = target:FindAbilityByName("shield_passive_talent_max_shield_per_int")
		if max_shield_talent and max_shield_talent:GetLevel() > 0 then
			maxshield = maxshield + (target:GetIntellect() * max_shield_talent:GetSpecialValueFor("value"))
		end
		
		if target.ShieldLeft > maxshield then return nil end
		
		local charge = ability:GetLevelSpecialValueFor("charge_per_sec",ability:GetLevel() - 1 )
		local charge_talent = target:FindAbilityByName("shield_maintenance_talent_charge_per_sec")
		if charge_talent and charge_talent:GetLevel() > 0 then
			charge = charge + charge_talent:GetSpecialValueFor("value")
		end
		
		if target.ShieldLeft + charge < maxshield then
			target.ShieldLeft = target.ShieldLeft + charge
		else
			target.ShieldLeft = maxshield
		end
		if target.Numbers then
			DestroyParticles( keys )
		end

		local digits = string.len(tostring(math.floor(target.ShieldLeft))) + 1
		local targetloc = target:GetAbsOrigin()

		target.Numbers = ParticleManager:CreateParticleForPlayer(particle, PATTACH_OVERHEAD_FOLLOW, target, target:GetPlayerOwner())
		ParticleManager:SetParticleControl(target.Numbers, 0, targetloc)
		ParticleManager:SetParticleControl(target.Numbers, 1, Vector(2,target.ShieldLeft,7))
		ParticleManager:SetParticleControl(target.Numbers, 2, Vector(9000,digits,0))
	else
		local cd = shield_ability:GetCooldownTimeRemaining()
		local reduction = ability:GetLevelSpecialValueFor("cooldown_charge",ability:GetLevel() - 1 )
		cd = cd - reduction
		if cd > reduction then 
			shield_ability:EndCooldown()
			shield_ability:StartCooldown(cd) 
		else 
			shield_ability:EndCooldown()
		end
	end
end

function DestroyParticles( keys )
	local caster = keys.caster

	if caster.Numbers then
		ParticleManager:DestroyParticle(caster.Numbers, true)
	end
end