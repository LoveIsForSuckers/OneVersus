function add_stack( keys )
	local caster = keys.caster
	local ability = keys.ability

	local previous_stack_count = 0
	if caster:HasModifier("modifier_killstreak_counter") then
		previous_stack_count = caster:GetModifierStackCount("modifier_killstreak_counter", caster)
		caster:RemoveModifierByNameAndCaster("modifier_killstreak_counter",caster)
	end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_killstreak_counter", nil)
	caster:SetModifierStackCount("modifier_killstreak_counter", caster, previous_stack_count + 1)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_killstreak_buff", nil)
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