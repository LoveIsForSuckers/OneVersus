function RememberState( keys )
	local caster = keys.caster
	local ability = keys.ability
	if not ability.snapshot then ability.snapshot = {} end
	ability.snapshot["health"] = caster:GetHealth()
	ability.snapshot["mana"] = caster:GetMana()
	ability.snapshot["position"] = caster:GetAbsOrigin()
end

function Rewind( keys )
	local caster = keys.caster
	local ability = keys.ability
	local health = ability.snapshot["health"]
	local mana = ability.snapshot["mana"]
	local position = ability.snapshot["position"]
	local particleName = keys.Particle
	if caster.Rewind then ParticleManager:DestroyParticle(caster.Rewind, true) end
	caster.Rewind = ParticleManager:CreateParticle(particleName,PATTACH_ABSORIGIN_FOLLOW,caster)
	caster:Interrupt()
	caster:SetHealth(health)
	caster:SetMana(mana)
	caster:Purge(false,true,false,true,false)
	caster:EmitSound("Hero_Weaver.TimeLapse")
	FindClearSpaceForUnit(caster,position,true)
end