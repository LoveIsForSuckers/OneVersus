function SpendMana( keys )
	local caster = keys.caster
	local ability = keys.ability
	if not caster:IsAlive() then
		ability:ToggleAbility()
		caster:RemoveModifierByName("modifier_sandstorm_toggle")
		-- doesn't work without RemoveModifierByName for some reason (modifier remains on dead caster despite of toggling off the ability)
	end
	local mana = ability:GetLevelSpecialValueFor("mana_per_sec",ability:GetLevel()-1)
	if caster:GetMana() >= mana then
		caster:SpendMana(mana,ability)
	else
		ability:ToggleAbility()
	end
end

function OnDestroy( keys )
	local ability = keys.ability
	local caster = keys.caster
	if not caster or caster == nil then
		caster = keys.unit
	end
	local sound_name = "Ability.SandKing_SandStorm.loop"
	StopSoundEvent( sound_name, keys.caster )
	if caster.Sandstorm then ParticleManager:DestroyParticle(caster.Sandstorm, true) end
	local cd = ability:GetCooldown(ability:GetLevel() - 1)
	ability:StartCooldown(cd)
end

function MakeParticle( keys )
	local ability = keys.ability
	local caster = keys.caster
	local radius = ability:GetLevelSpecialValueFor("radius",ability:GetLevel()-1)
	local particleName = keys.Particle
	if caster.Sandstorm then ParticleManager:DestroyParticle(caster.Sandstorm, true) end
	caster.Sandstorm = ParticleManager:CreateParticle(particleName,PATTACH_ABSORIGIN_FOLLOW,caster)
	ParticleManager:SetParticleControl(caster.Sandstorm,0,Vector(radius,radius,radius))
	ParticleManager:SetParticleControl(caster.Sandstorm,1,Vector(radius,radius,radius))
end