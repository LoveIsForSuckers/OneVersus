function UpdateStacks( keys )
	local modifier = keys.modifier
	local ability = keys.ability
	local caster = keys.caster
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1 ) )
	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, 0, false )	
	local new_stacks = 0
	
	for k, v in pairs( units ) do
		new_stacks = new_stacks + 1
	end

	units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )

	for k, v in pairs( units ) do
		new_stacks = new_stacks + 3
	end

	if not caster:HasModifier( modifier ) and new_stacks > 0 then
		ability:ApplyDataDrivenModifier( caster, caster, modifier, {} )
	end
	
	if new_stacks > 0 then
		caster:SetModifierStackCount( modifier, ability, new_stacks )
	else
		caster:RemoveModifierByName( modifier )
	end
end

function checkHealth( keys )
	local ability = keys.ability
	local caster = keys.caster
	local healthThreshold = ability:GetLevelSpecialValueFor("health_threshold", (ability:GetLevel() - 1 ) )
	local modifier = keys.modifier
	local cooldown = ability:GetCooldown( ability:GetLevel() )
	local health = caster:GetHealth()
	local percent = caster:GetMaxHealth() * healthThreshold * 0.01

	if health < percent and ability:GetCooldownTimeRemaining() == 0 then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {} )
		ability:StartCooldown( cooldown )
		caster:EmitSound("Hero_Centaur.Stampede.Cast")
	end
end