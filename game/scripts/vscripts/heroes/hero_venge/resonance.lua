function apply_effects(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	caster:EmitSound("OneVersus.Resonance_Long")
	
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_resonance", { duration = duration })
	caster:RemoveModifierByName("modifier_resonance_disarm")
	
	local extra_as_talent = caster:FindAbilityByName("venge_resonance_talent_as_boost")
	if extra_as_talent and extra_as_talent:GetLevel() > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_resonance_talent_buff", { duration = duration })
	end
end
