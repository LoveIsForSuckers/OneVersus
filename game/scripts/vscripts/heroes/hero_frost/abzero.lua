function AbZeroParticle ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = keys.Radius
	local duration = keys.Duration
	local delay = keys.Delay
	local origin = keys.target_points[1]
	local particleName = keys.EffectName
	local groundParticle = keys.GroundEffect
	
	ability.abzero_start = GameRules:GetGameTime() + delay
	ability.abzero_end = GameRules:GetGameTime() + delay + duration
	
	

	ability.origin = origin

	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
	local pfxGround = ParticleManager:CreateParticle( groundParticle, PATTACH_ABSORIGIN, caster )

	ParticleManager:SetParticleControl( pfxGround, 1, origin )
	ParticleManager:SetParticleControl( pfx, 1, origin )

	ability.pfx = pfx

	ProjectileManager:CreateLinearProjectile( {
		Ability = ability,
		vSpawnOrigin = origin,
		fDistance = 64,
		fStartRadius = radius,
		fEndRadius = radius,
		Source = caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime			= ability.abzero_end,
		bDeleteOnHit		= false,
		vVelocity			= Vector( 0, 0, 0 ),	-- Don't move!
		bProvidesVision		= true,
		iVisionRadius		= 600,
		iVisionTeamNumber = caster:GetTeamNumber(),

	} )
	
end

function DestroyParticle ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local pfx = ability.pfx

	ParticleManager:DestroyParticle( pfx, false )
	
	ability.pfx = nil
end

function ApplyDummyModifier( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local modifierName = event.Modifier

	local duration = ability.abzero_end - GameRules:GetGameTime()

	ability:ApplyDataDrivenModifier( caster, target, modifierName, { duration = duration } )
end

function CheckRange ( event )
	local caster		= event.caster
	local target		= event.target
	local ability		= event.ability
	local pathRadius	= event.Radius

	local stunModifierName	= "modifier_abzero_root"

	if GameRules:GetGameTime() < ability.abzero_start then
		-- Not yet.
		return
	end

	if target:HasModifier( stunModifierName ) then
		-- Already stunned.
		return
	end

	local targetPos = target:GetAbsOrigin()
	targetPos.z = 0

	local targetPos = target:GetAbsOrigin()

	local distance = ( ability.origin - targetPos ):Length2D()

	if distance < pathRadius then
		local duration = ability.abzero_end - GameRules:GetGameTime()
		ability:ApplyDataDrivenModifier( caster, target, stunModifierName, { duration = duration } )
	end
end