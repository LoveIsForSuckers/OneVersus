function projectile_hit( keys )
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local modifier = keys.modifier
	local base_ability = caster:FindAbilityByName( keys.base_ability )
	local current_stack = caster:GetModifierStackCount( modifier, base_ability )
	if not current_stack then
		current_stack = 0
	end
	if caster:HasModifier( modifier ) == false then
		current_stack = 0
	end
	local damagemod = ability:GetLevelSpecialValueFor("arrows_dmg_per_charge", (ability:GetLevel() - 1))
	local damagebase = ability:GetLevelSpecialValueFor("arrows_base_dmg", (ability:GetLevel() - 1))
	local damagedealt = damagebase + ( damagemod * current_stack )
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		ApplyDamage({victim = target, attacker = caster, damage = damagedealt, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	end
end

function launch_arrows( keys )
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local speed = ability:GetLevelSpecialValueFor("arrows_speed", (ability:GetLevel() - 1))
	local particle_name = "particles/units/heroes/hero_lion/ult_arrow.vpcf"
	local projTable = {
		EffectName = particle_name,
		Ability = ability,
		Target = target,
		Source = caster,
		bDodgeable = true,
		bProvidesVision = false,
		vSpawnOrigin = caster:GetAbsOrigin(),
		iMoveSpeed = speed,
		iVisionRadius = 0,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}
	ProjectileManager:CreateTrackingProjectile( projTable )
end