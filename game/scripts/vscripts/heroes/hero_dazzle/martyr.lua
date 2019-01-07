function suffer( keys )
	local caster = keys.caster
	local ability = keys.ability
	local hp_conv_rate = ability:GetLevelSpecialValueFor("hp_conversion", (ability:GetLevel() - 1) )
	local maxhealth = caster:GetMaxHealth()
	local health = caster:GetHealth()
	local maxmana = caster:GetMaxMana()
	local mana = caster:GetMana()

	hp_conv_rate = hp_conv_rate / 2 --Ticks twice per second

	local bonusmana = (maxmana * hp_conv_rate) / 100
	local minushealth = (maxhealth * hp_conv_rate) / 100

	health = health - minushealth
	mana = mana + bonusmana
	
	if health <= 1 then
		caster:Interrupt()
	else
		caster:SetHealth(health)
	end

	if mana >= maxmana then
		caster:Interrupt()
	else
		caster:SetMana(mana)
	end
end

function lightning( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability

	local damage = ability:GetLevelSpecialValueFor("lightning_damage", (ability:GetLevel() - 1 ) )

	if not attacker:IsMagicImmune() and not attacker:IsTower() then
		local lightning = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/martyr_lightning.vpcf", PATTACH_WORLDORIGIN, keys.attacker)
		local loc = keys.attacker:GetAbsOrigin()
		ParticleManager:SetParticleControl(lightning, 0, loc + Vector(0, 0, 1000))
		ParticleManager:SetParticleControl(lightning, 1, loc)
		ParticleManager:SetParticleControl(lightning, 2, loc)

		ApplyDamage({victim = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = caster, ability = ability })
	end
end