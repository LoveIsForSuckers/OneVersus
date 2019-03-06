function StateUpdate( keys )
	local target = keys.caster
	local ability = keys.ability
	local modifier = keys.Modifier

	if not target:HasModifier( modifier ) and ( ability:GetCooldownTimeRemaining() <= 0 )  then
		ability:ApplyDataDrivenModifier( target, target, modifier, {} )
	end
end

function OnUpgrade( keys )
	local target = keys.caster
	local ability = keys.ability
	local start_shield = keys.ability:GetLevelSpecialValueFor("start_shield", ability:GetLevel() - 1)
	if target.ShieldLeft then
		if target.ShieldLeft < start_shield then
			target.ShieldLeft = nil
			DestroyParticles( keys )
			target.Numbers = nil
			target:RemoveModifierByName(keys.Modifier)
		end
	end
end

function Cast( keys )
	local target = keys.caster
	local particle = keys.Particle
	local ability = keys.ability
	local start_shield = keys.ability:GetLevelSpecialValueFor("start_shield", ability:GetLevel() - 1)
	local targetloc = target:GetAbsOrigin()

	if not target:IsRealHero() then
		return nil
	end

	target.ShieldLeft = start_shield
	
	if target.Numbers then
		DestroyParticles( keys )
	end

	local digits = string.len(tostring(math.floor(start_shield))) + 1

	target.Numbers = ParticleManager:CreateParticleForPlayer(particle, PATTACH_OVERHEAD_FOLLOW, target, target:GetPlayerOwner())
	ParticleManager:SetParticleControl(target.Numbers, 0, targetloc)
	ParticleManager:SetParticleControl(target.Numbers, 1, Vector(2,target.ShieldLeft,7))
	ParticleManager:SetParticleControl(target.Numbers, 2, Vector(9000,digits,0))
end

function ShieldAbsorb( keys )
	local damage = keys.DamageTaken
	local unit = keys.unit
	local ability = keys.ability
	local particle = keys.Particle
	local cooldown = ability:GetCooldown(ability:GetLevel())

	if not unit:IsRealHero() then
		return nil
	end

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
		ParticleManager:SetParticleControl(unit.Numbers, 2, Vector(9000,digits,0))
	else
		DestroyParticles( keys )
	end

	if unit.ShieldLeft <= 0 then
		unit.ShieldLeft = nil
		DestroyParticles( keys )
		unit.Numbers = nil
		unit:RemoveModifierByName(keys.Modifier)
		ability:StartCooldown( cooldown )
	end
end

function ShieldAttackBoost( keys )
	local target = keys.caster
	local victim = keys.target
	local particle = keys.Particle
	local ability = keys.ability
	local modifier = keys.Modifier
	
	if not target:IsRealHero() then
		return nil
	end

	if victim:IsBuilding() then return nil end

	if victim:IsInvulnerable() then return nil end


	local boost = ability:GetLevelSpecialValueFor("attack_boost",ability:GetLevel() - 1 )
	local boost_talent = target:FindAbilityByName("shield_passive_talent_attack_boost")
	if boost_talent and boost_talent:GetLevel() > 0 then
		boost = boost + boost_talent:GetSpecialValueFor("value")
	end
	
	local maxshield = ability:GetLevelSpecialValueFor("max_shield",ability:GetLevel() - 1 )
	local max_shield_talent = target:FindAbilityByName("shield_passive_talent_max_shield_per_int")
	if max_shield_talent and max_shield_talent:GetLevel() > 0 then
		maxshield = maxshield + (target:GetIntellect() * max_shield_talent:GetSpecialValueFor("value"))
	end

	ApplyDamage({victim = victim, attacker = target, damage = boost, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , victim, boost, target )

	if target.ShieldLeft > maxshield then return nil end

	if target.ShieldLeft + boost < maxshield then
		target.ShieldLeft = target.ShieldLeft + boost
	else
		target.ShieldLeft = maxshield
	end

	target:EmitSound("OneVersus.EnergyAttack")

	if target.Numbers then
		DestroyParticles( keys )
	end

	local digits = string.len(tostring(math.floor(target.ShieldLeft))) + 1
	local targetloc = target:GetAbsOrigin()

	target.Numbers = ParticleManager:CreateParticleForPlayer(particle, PATTACH_OVERHEAD_FOLLOW, target, target:GetPlayerOwner())
	ParticleManager:SetParticleControl(target.Numbers, 0, targetloc)
	ParticleManager:SetParticleControl(target.Numbers, 1, Vector(2,target.ShieldLeft,7))
	ParticleManager:SetParticleControl(target.Numbers, 2, Vector(9000,digits,0))

	local poof = ParticleManager:CreateParticle("particles/units/heroes/hero_shield/s_attack.vpcf", PATTACH_POINT_FOLLOW, victim)
	ParticleManager:SetParticleControl(poof, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(poof, 3, victim:GetAbsOrigin())
end

function ShieldHealth( keys )
	local target = keys.target
	target.OldHealth = target:GetHealth()
end

function DestroyParticles( keys )
	local caster = keys.caster

	if caster.Numbers then
		ParticleManager:DestroyParticle(caster.Numbers, true)
	end
end
