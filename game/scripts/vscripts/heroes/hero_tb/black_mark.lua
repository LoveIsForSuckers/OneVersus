function check_target(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	if target:HasModifier("modifier_black_mark") then
		local agility = caster:GetAgility()
		local dmg_per_agi = ability:GetLevelSpecialValueFor("damage_per_agi", (ability:GetLevel() - 1))
		
		local damageTalent = caster:FindAbilityByName("tb_black_mark_talent_damage_per_agi")
		if damageTalent and damageTalent:GetLevel() > 0 then
			dmg_per_agi = dmg_per_agi + damageTalent:GetSpecialValueFor("value")
		end

		local enemy_agi = target:GetAgility()
		local dmg_per_enemy_agi = ability:GetLevelSpecialValueFor("damage_per_enemy_agi", (ability:GetLevel() - 1))

		local totalDamage = (dmg_per_agi * agility) + (dmg_per_enemy_agi * enemy_agi)
		
		if not caster:HasModifier("modifier_black_mark_preattack_damage") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_black_mark_preattack_damage", {})
		end
		caster:SetModifierStackCount("modifier_black_mark_preattack_damage", caster, totalDamage)
	else 
		if caster:HasModifier("modifier_black_mark_preattack_damage") then
			caster:RemoveModifierByName("modifier_black_mark_preattack_damage")
		end
	end
end

function apply_modifier (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	
	ability:ApplyDataDrivenModifier(caster, target, "modifier_black_mark", {})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_black_mark_preattack_checker", {})
	target:EmitSound("Hero_Terrorblade.Sunder.Cast")
end

function on_attack_landed (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	
	caster:RemoveModifierByName("modifier_black_mark_preattack_damage")
	caster:RemoveModifierByName("modifier_black_mark_preattack_checker")
	
	local stunTalent = caster:FindAbilityByName("tb_black_mark_talent_postattack_debuff")
	if stunTalent and stunTalent:GetLevel() > 0 then
		local stunDuration = stunTalent:GetSpecialValueFor("value")
		ability:ApplyDataDrivenModifier(caster, target, "modifier_black_mark_talent_postattack_debuff", { duration = stunDuration })
	end
	
	target:RemoveModifierByName("modifier_black_mark")
	target:EmitSound("Hero_Terrorblade.Sunder.Target")
end

function on_attack_failed (keys)
	local caster = keys.caster
	
	caster:RemoveModifierByName("modifier_black_mark_preattack_damage")
end