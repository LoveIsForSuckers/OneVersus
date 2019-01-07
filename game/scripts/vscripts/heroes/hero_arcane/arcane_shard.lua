function CreateShard( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier = keys.Modifier
	
	caster:EmitSound("Hero_Pugna.NetherWard")
	
	local ward_unit = CreateUnitByName("npc_arcane_shard", keys.target_points[1], false, caster, caster, caster:GetTeam() )
	ward_unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	ward_unit:SetOwner(caster)

	ward_unit:AddNewModifier(ward_unit, nil, "modifier_kill", {duration = keys.Duration})
	ward_unit:AddNewModifier(ward_unit, nil, "modifier_phased", {duration = 0.1})
	ability:ApplyDataDrivenModifier(caster, ward_unit, modifier, {duration = keys.Duration})

	local attacks_to_destroy = ability:GetLevelSpecialValueFor("attacks_to_destroy", ability:GetLevel() - 1 )
	ward_unit.attack_counter = attacks_to_destroy
end

function WardAttacked( keys )
	local target = keys.unit
	local attacker = keys.attacker
	local damage = keys.Damage
	local ability = keys.ability
	local hero_attack_damage = ability:GetLevelSpecialValueFor("hero_attack_damage", ability:GetLevel() - 1 )

	if attacker:IsRealHero() then
		target.attack_counter = target.attack_counter - hero_attack_damage
	else
		target.attack_counter = target.attack_counter - 1
	end

	if target.attack_counter <= 0 then
		target:RemoveModifierByName("modifier_arcane_shard")
	end

	target:SetHealth(target.attack_counter)
end

function TestFire( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("shard_check_radius", (ability:GetLevel() - 1) )
	local target = keys.target_points[1]
	local particle = keys.Particle
	local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1) )
	local width = ability:GetLevelSpecialValueFor("width", (ability:GetLevel() - 1) )
	local distance = ability:GetLevelSpecialValueFor("distance", (ability:GetLevel() - 1) )

	-- trying to find a shard to multiply cast
	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
	for k, v in pairs( units ) do
		if v:GetUnitName() == "npc_arcane_shard" then
			local direction = (target - v:GetAbsOrigin()):Normalized()
			direction.z = 0
			local proj_table =
			{
				Ability = ability,
				EffectName = particle,
				vSpawnOrigin = v:GetAbsOrigin(),
				fDistance = distance,
				fStartRadius = width,
				fEndRadius = width,
				Source = v,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        			fExpireTime = GameRules:GetGameTime() + 5.0,
				bDeleteOnHit = false,
				vVelocity = direction * speed,
				bProvidesVision = true,
				iVisionRadius = width,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			projectile = ProjectileManager:CreateLinearProjectile(proj_table)
		end
	end

	-- continuing regular cast
	local direction = (target - caster:GetAbsOrigin()):Normalized()
	direction.z = 0
	local proj_table =
	{
		Ability = ability,
		EffectName = particle,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = width,
		fEndRadius = width,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = direction * speed,
		bProvidesVision = true,
		iVisionRadius = width,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateLinearProjectile(proj_table)
end

function ForceField( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("shard_check_radius", (ability:GetLevel() - 1) )
	local modifier = keys.Modifier

	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
	for k, v in pairs( units ) do
		if v:GetUnitName() == "npc_arcane_shard" then
			ability:ApplyDataDrivenModifier(caster, v, modifier, {})
		end
	end
end

function EnergyOverflow( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local particle = keys.Particle

	local radius = ability:GetLevelSpecialValueFor("shard_check_radius", (ability:GetLevel() - 1) )
	local modifier = keys.Modifier

	ability:ApplyDataDrivenModifier(caster, target, modifier, {})
	local zap = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(zap, 1, target:GetAbsOrigin())

	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
	for k, v in pairs( units ) do
		if v:GetUnitName() == "npc_arcane_shard" then
			ability:ApplyDataDrivenModifier(v, target, modifier, {} )
			local zap2 = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, v)
			ParticleManager:SetParticleControl(zap2, 1, target:GetAbsOrigin())
		end
	end
end

function EnergyOverflowTick( keys )
	local target = keys.target
	local ability = keys.ability
	local caster = keys.caster

	local particle_buff = keys.ParticleBuff
	local particle_debuff = keys.ParticleDebuff

	local mana_base = ability:GetLevelSpecialValueFor("mana_restore_base", (ability:GetLevel() - 1) )
	local mana_per_int = ability:GetLevelSpecialValueFor("mana_restore_per_int_bonus", (ability:GetLevel() - 1) )
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1) )

	local mana = target:GetMana()
	local max_mana = target:GetMaxMana()

	local mana_boost_total = mana_base + ( target:GetIntellect() * mana_per_int )
	local mana_boost_per_tick = mana_boost_total / ( duration * 5 )

	if (mana + mana_boost_per_tick) > max_mana then
		target:SetMana(max_mana)
		local damage = mana_boost_per_tick - (max_mana - mana)
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})

		local zap = ParticleManager:CreateParticle(particle_debuff, PATTACH_ABSORIGIN_FOLLOW, target)
	else
		target:GiveMana(mana_boost_per_tick)

		local zap = ParticleManager:CreateParticle(particle_buff, PATTACH_ABSORIGIN_FOLLOW, target)
	end
end