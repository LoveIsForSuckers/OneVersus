function TryCast( keys )
	local caster = keys.caster
	local ability = keys.ability
	if not caster:HasModifier("modifier_shield_passive_shield") then
		ability:ApplyDataDrivenModifier( caster, caster, keys.ModifierName, {} )
	end
end

function Cast( keys )
	local target = keys.target
	local particle = keys.Particle
	local max_damage_absorb = keys.ability:GetLevelSpecialValueFor("guard_health", keys.ability:GetLevel() - 1 )
	local targetloc = target:GetAbsOrigin()

	if target.ShieldLeft and target.ShieldLeft > 0 then
		target:RemoveModifierByName("modifier_flame_guard_ability")
		return nil
	end

	target.ShieldLeft = max_damage_absorb
	
	if target.Numbers then
		DestroyParticles( keys )
	end

	target.Numbers = ParticleManager:CreateParticleForPlayer(particle, PATTACH_OVERHEAD_FOLLOW, target, target:GetPlayerOwner())
	ParticleManager:SetParticleControl(target.Numbers, 0, targetloc)
	ParticleManager:SetParticleControl(target.Numbers, 1, Vector(2,target.ShieldLeft,7))
	ParticleManager:SetParticleControl(target.Numbers, 2, Vector(5,4,0))
end

function ShieldAbsorb( keys )
	local damage = keys.DamageTaken
	local unit = keys.unit
	local ability = keys.ability
	local particle = keys.Particle
	local enemy = keys.attacker
	local enemyDamage = ability:GetLevelSpecialValueFor("guard_damage",(ability:GetLevel() - 1))
	local minEnemyDamageToTrigger = ability:GetLevelSpecialValueFor("guard_damage_minimum_trigger", (ability:GetLevel() -1))

	local shield_rem = unit.ShieldLeft

	if damage > shield_rem then
		local newHealth = unit.OldHealth - damage + shield_rem
		unit:SetHealth(newHealth)
	else
		local newHealth = unit.OldHealth
		unit:SetHealth(newHealth)
	end

	unit.ShieldLeft = unit.ShieldLeft - damage

	if unit.Numbers and unit.ShieldLeft > 0 then
		local targetloc = unit:GetAbsOrigin()
		local digits = string.len(tostring(math.floor(unit.ShieldLeft))) + 1
		
		ParticleManager:DestroyParticle(unit.Numbers, true)

		unit.Numbers = ParticleManager:CreateParticleForPlayer(particle, PATTACH_OVERHEAD_FOLLOW, unit, unit:GetPlayerOwner())
		ParticleManager:SetParticleControl(unit.Numbers, 0, targetloc)
		ParticleManager:SetParticleControl(unit.Numbers, 1, Vector(2,math.floor(unit.ShieldLeft),7))
		ParticleManager:SetParticleControl(unit.Numbers, 2, Vector(5,digits,0))
	else
		DestroyParticles( keys )
	end

	if not enemy:IsMagicImmune() and not enemy:IsTower() and damage > minEnemyDamageToTrigger then
		ApplyDamage({victim = enemy, damage = enemyDamage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = unit, ability = ability })
	end

	if unit.ShieldLeft <= 0 then
		DestroyParticles( keys )
		unit.ShieldLeft = nil
		unit.Numbers = nil
		unit:RemoveModifierByName("modifier_flame_guard_ability")
	end
end

function ShieldHealth( keys )
	local target = keys.target
	target.OldHealth = target:GetHealth()
end

function RemoveShield( keys )
	local unit = keys.target
	DestroyParticles( keys )
	if unit.ShieldLeft and unit.ShieldLeft > 0 then
		unit.ShieldLeft = nil
		unit.Numbers = nil
	end
	if unit:HasModifier( "modifier_flame_guard_ability" ) then
		unit:RemoveModifierByName("modifier_flame_guard_ability")
	end
end

function DestroyParticles( keys )
	local caster = keys.caster

	if caster.Numbers then
		ParticleManager:DestroyParticle(caster.Numbers, true)
	end
end
