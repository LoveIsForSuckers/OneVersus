function gain_stack( keys )
	local modifier = keys.modifier
	local caster = keys.caster
	local ability = keys.ability
	local unit = keys.unit
	local max_stacks = ability:GetLevelSpecialValueFor( "max_stacks", ability:GetLevel() - 1 )
	local current_stack = caster:GetModifierStackCount( modifier, ability )
	if caster:GetTeam() ~= unit:GetTeam() and caster:CanEntityBeSeenByMyTeam(unit) then
		if not current_stack then
			ability:ApplyDataDrivenModifier( caster, caster, modifier, {} )
			current_stack = 0
		end
		if caster:HasModifier( modifier ) == false then
			ability:ApplyDataDrivenModifier( caster, caster, modifier, {} )
			current_stack = 0
		end
		local new_stacks = current_stack + 1
		if new_stacks <= max_stacks then
			caster:SetModifierStackCount( modifier, ability, new_stacks )
		else
			caster:SetModifierStackCount( modifier, ability, max_stacks )
		end
		current_stack = caster:GetModifierStackCount( modifier, ability )
	end
end

function remove_stacks( keys )
	local modifier = keys.modifier
	local caster = keys.caster
	local ability = keys.ability
	local current_stack = caster:GetModifierStackCount( modifier, ability )
	local halfstacks = math.ceil( current_stack * 0.5 )
	if current_stack then
		caster:SetModifierStackCount( modifier, ability, halfstacks )
	end
end