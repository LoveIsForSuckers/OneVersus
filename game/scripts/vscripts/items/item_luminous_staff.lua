function SpawnVisionDummy(keys)
	local caster = keys.caster
	local ability = keys.ability
	local targetLoc = keys.target_points[1]
	local particleName = keys.Particle
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	
	AddFOWViewer(caster:GetTeamNumber(),targetLoc,radius,duration,false)
end