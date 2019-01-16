function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability

	-- primary projectile
	local target = keys.target_points[1]
	local distance = ability:GetLevelSpecialValueFor("distance", (ability:GetLevel() - 1) )
	local direction = (target - caster:GetAbsOrigin()):Normalized()
	direction.z = 0
	LaunchProjectile(keys, direction, distance)
	
	-- talent projectiles
	local extraProjectilesTalent = caster:FindAbilityByName("dragon_fire_new_talent_extra_waves")
	if extraProjectilesTalent and extraProjectilesTalent:GetLevel() > 0 then
		LaunchExtraWaves(keys, extraProjectilesTalent, direction, distance)
	end
end

function LaunchExtraWaves(keys, extraProjectilesTalent, primaryDirection, primaryDistance)
	local extraWaveCount = extraProjectilesTalent:GetSpecialValueFor("value")
	local offsetAngle = extraProjectilesTalent:GetSpecialValueFor("offset_angle_radian")
	local distanceReductionMultiplier = extraProjectilesTalent:GetSpecialValueFor("distance_reduction_mult")
	
	local secondaryDistance = primaryDistance
	local leftDirection = primaryDirection
	local rightDirection = primaryDirection
	for i = 0, extraWaveCount, 2 do
		secondaryDistance = secondaryDistance * distanceReductionMultiplier
		leftDirection = RotateVector2D(leftDirection, -1 * offsetAngle)
		rightDirection = RotateVector2D(rightDirection, offsetAngle)
		
		LaunchProjectile(keys, leftDirection, secondaryDistance)
		LaunchProjectile(keys, rightDirection, secondaryDistance)
	end
end

function RotateVector2D(vector, radians)
	local xNew = vector.x * math.cos(radians) - vector.y * math.sin(radians)
	local yNew = vector.x * math.sin(radians) + vector.y * math.cos(radians)
	return Vector(xNew, yNew, vector.z)
end

function LaunchProjectile(keys, direction, distance)
	local caster = keys.caster
	local ability = keys.ability
	local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1) )
	local width = ability:GetLevelSpecialValueFor("width", (ability:GetLevel() - 1) )
	local particle = keys.Particle
	
	local proj_table =
	{
		Ability = ability,
		EffectName = particle,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = 128,
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