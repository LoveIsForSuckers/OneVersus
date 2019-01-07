function dash_teleport( keys )
	local point = keys.target_points[1]
	local caster = keys.caster
	FindClearSpaceForUnit( caster, point, false )
end