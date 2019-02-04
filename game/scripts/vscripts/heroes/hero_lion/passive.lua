function gain_stack_from_cast( keys )
	local caster = keys.caster
	local unit = keys.unit
	
	if caster:GetTeam() ~= unit:GetTeam() and caster:CanEntityBeSeenByMyTeam(unit) then
		increase_stacks(keys, 1)
	end
end

function try_gain_stack_from_hero_killed( keys )
	local caster = keys.caster
	local talent = caster:FindAbilityByName("lion_passive_talent_stacks_for_kill")
	if talent and talent:GetLevel() > 0 then
		local amount = talent:GetSpecialValueFor("value")
		increase_stacks(keys, amount)
	end
end

function increase_stacks( keys, amount )
	local modifier = keys.modifier
	local caster = keys.caster
	local ability = keys.ability
	
	local current_stack = caster:GetModifierStackCount( modifier, ability )
	local max_stacks = ability:GetLevelSpecialValueFor( "max_stacks", ability:GetLevel() - 1 )
	local max_stacks_talent = caster:FindAbilityByName("lion_passive_talent_max_stacks")
	if max_stacks_talent and max_stacks_talent:GetLevel() > 0 then
		max_stacks = max_stacks + max_stacks_talent:GetSpecialValueFor("value")
	end
	
	if not current_stack then
		ability:ApplyDataDrivenModifier( caster, caster, modifier, {} )
		current_stack = 0
	end
	if caster:HasModifier( modifier ) == false then
		ability:ApplyDataDrivenModifier( caster, caster, modifier, {} )
		current_stack = 0
	end
	
	local new_stacks = current_stack + amount
	if new_stacks <= max_stacks then
		caster:SetModifierStackCount( modifier, ability, new_stacks )
	else
		caster:SetModifierStackCount( modifier, ability, max_stacks )
	end
	current_stack = caster:GetModifierStackCount( modifier, ability )
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