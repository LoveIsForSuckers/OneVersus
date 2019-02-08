function add_stack( keys )
	local caster = keys.caster
	local ability = keys.ability

	local previous_stack_count = 0
	if caster:HasModifier("modifier_killstreak_counter") then
		previous_stack_count = caster:GetModifierStackCount("modifier_killstreak_counter", caster)
		caster:RemoveModifierByNameAndCaster("modifier_killstreak_counter",caster)
	end
	
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local duration_talent = caster:FindAbilityByName("venge_killstreak_talent_duration")
	if duration_talent and duration_talent:GetLevel() > 0 then
		duration = duration + duration_talent:GetSpecialValueFor("value")
	end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_killstreak_counter", { duration = duration })
	caster:SetModifierStackCount("modifier_killstreak_counter", caster, previous_stack_count + 1)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_killstreak_buff", { duration = duration })
end

function remove_stack( keys )
	local caster = keys.caster
	
	if caster:HasModifier("modifier_killstreak_counter") then
		local previous_stack_count = caster:GetModifierStackCount("modifier_killstreak_counter", caster)
		if previous_stack_count > 1 then
			caster:SetModifierStackCount("modifier_killstreak_counter", caster, previous_stack_count - 1)
		else
			caster:RemoveModifierByNameAndCaster("modifier_killstreak_counter", caster)
		end
	end
end