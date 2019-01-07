function Shockwave( keys )
	local caster = keys.caster
	local ability = keys.ability
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = keys.target_points[1]
	local explosions = ability:GetLevelSpecialValueFor("explosions", ability:GetLevel() - 1)
	local explosion_delay = ability:GetLevelSpecialValueFor("explosion_delay", ability:GetLevel() - 1)
	local width = ability:GetLevelSpecialValueFor("width", ability:GetLevel() - 1)
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local dummyModifierName = "modifier_dummy"
	local burnModifierName = "modifier_great_shockwave_burn"

	local distance = 0.5 * width
	local step = 0.8 * width
	
	local forwardVec = targetLoc - casterLoc
	forwardVec = forwardVec:Normalized()

	local dummy = CreateUnitByName( "npc_dummy_unit", casterLoc, false, caster, caster, caster:GetTeam() )
	ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )
	dummy.explosionsMade = 0

	Timers:CreateTimer( function ()
		local newVector = GetGroundPosition( forwardVec * distance, caster )
		newVector = newVector:Normalized()

		local spawnLoc = casterLoc + newVector * distance
		
		distance = distance + step

		-- Some Shit Here

 		local pulse = ParticleManager:CreateParticle("particles/units/heroes/hero_stronk/shockwave.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(pulse, 1, spawnLoc)
		dummy:EmitSound("OneVersus.ShockBoom")
		dummy:SetAbsOrigin(spawnLoc)
		
		local nearbyEnemies = FindUnitsInRadius(caster:GetTeam(), dummy:GetAbsOrigin(), nil, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		for i, unit in ipairs(nearbyEnemies) do
			ApplyDamage( { victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability } )
			ability:ApplyDataDrivenModifier(caster, unit, burnModifierName, {} )
		end

		-- End Shit Here

		dummy.explosionsMade = dummy.explosionsMade + 1

		if dummy.explosionsMade == explosions then
			dummy:Destroy()
			return nil
		else
			return explosion_delay
		end
	end
	)	
end