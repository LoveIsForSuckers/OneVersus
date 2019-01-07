function Restore( keys )
	local caster = keys.caster
	local ability = keys.ability
	local restore = ability:GetLevelSpecialValueFor("restore", ability:GetLevel() - 1 )
	caster:GiveMana(restore)
	caster:Heal(restore, caster)
end

function OnTick( keys )
	local caster = keys.caster
	local ability = keys.ability
	local particle_heal = keys.particle_heal
	local particle_mana = keys.particle_mana
	
	local hp_regen = caster:GetHealthRegen()

	if caster:GetHealth() == caster:GetMaxHealth() and caster:GetMana() < caster:GetMaxMana() then
		caster:GiveMana(hp_regen)
		local meh = ParticleManager:CreateParticle(particle_mana, PATTACH_ABSORIGIN_FOLLOW, caster)
	elseif caster:GetHealth() < caster:GetMaxHealth() and caster:GetMana() == caster:GetMaxMana() then
		caster:Heal(hp_regen, caster)
		local meh = ParticleManager:CreateParticle(particle_heal, PATTACH_ABSORIGIN_FOLLOW, caster)
	end
end