function ArmorParticle( event )
	local target = event.target
	local location = target:GetAbsOrigin()
	local particleName = event.EffectName

	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function()
		target.ArmorParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.ArmorParticle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.ArmorParticle, 1, Vector(1,0,0))

		ParticleManager:SetParticleControlEnt(target.ArmorParticle, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
	end)
end

-- Destroys the particle when the modifier is destroyed
function EndArmorParticle( event )
	local target = event.target
	ParticleManager:DestroyParticle(target.ArmorParticle,false)
end