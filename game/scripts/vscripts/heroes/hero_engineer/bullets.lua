function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	caster:EmitSound("Ability.AssassinateLoad")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bullets", {})
	
	local damageTalent = caster:FindAbilityByName("engineer_bullets_talent_damage")
	if damageTalent and damageTalent:GetLevel() > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_bullets_talent", {})
	end
end