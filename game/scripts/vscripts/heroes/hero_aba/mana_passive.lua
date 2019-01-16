function OnOrbImpact(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	if target.GetInvulnCount == nil and not target:IsMagicImmune() then
		-- mana gain
		local manaGain = ability:GetSpecialValueFor("mana_gain")
		caster:GiveMana(manaGain)
		
		-- mana burn by talent
		local targetMana = target:GetMana()
		if targetMana > 0 then
			local talentManaburn = caster:FindAbilityByName("mana_passive_talent_manaburn")
			if talentManaburn and talentManaburn:GetLevel() > 0 then
				local manaBurn = 0
				if targetMana > manaGain then
					manaBurn = manaGain
				else
					manaBurn = targetMana
				end
				
				local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				target:ReduceMana(manaBurn)
				ApplyDamage({victim = target, attacker = caster, damage = manaBurn, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})
			end
		end
	end
end