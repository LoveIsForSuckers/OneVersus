function OnOrbImpact( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.Modifier
	local modifier_counter = keys.ModifierCount
	
	if target:IsBuilding() then return nil end
	if target:IsMagicImmune() then return nil end
	
	if caster:GetTeam() ~= target:GetTeam() then
		local maxstacks = ability:GetLevelSpecialValueFor("max_stacks_from_attack",ability:GetLevel()-1)
		local max_stacks_from_attack_talent = caster:FindAbilityByName("sand_neurotoxin_talent_max_stacks_from_attack")
		if max_stacks_from_attack_talent and max_stacks_from_attack_talent:GetLevel() > 0 then
			maxstacks = maxstacks + max_stacks_from_attack_talent:GetSpecialValueFor("value")
		end
	
		local currentstack = 0

		if target:HasModifier( modifier_counter ) then
			currentstack = target:GetModifierStackCount( modifier_counter , caster )
		end
		
		if currentstack < maxstacks then
			ability:ApplyDataDrivenModifier( caster, target, modifier, {} )
			ability:ApplyDataDrivenModifier( caster, target, modifier_counter, {} )
			target:SetModifierStackCount( modifier_counter, caster, currentstack + 1 )
		else
			target:SetModifierStackCount( modifier_counter, caster, maxstacks )
		end
	end
end

function DoubleStacks( keys )
	local caster = keys.caster
	local unit = keys.unit
	local ability = keys.ability
	local modifier = keys.Modifier
	local modifier_counter = keys.ModifierCount
	
	if unit:IsBuilding() then return nil end
	if unit:IsMagicImmune() then return nil end
	
	local maxstacks = ability:GetLevelSpecialValueFor("maxstacks",ability:GetLevel()-1)
	local max_stacks_talent = caster:FindAbilityByName("sand_neurotoxin_talent_max_stacks")
	if max_stacks_talent and max_stacks_talent:GetLevel() > 0 then
		maxstacks = maxstacks + max_stacks_talent:GetSpecialValueFor("value")
	end
	
	local currentstack = 0

	if unit:HasModifier( modifier_counter ) then
		currentstack = unit:GetModifierStackCount( modifier_counter , caster )
		unit:RemoveModifierByName( modifier_counter )
	end
		
	if currentstack < maxstacks then
		unit:SetModifierStackCount( modifier_counter, ability, currentstack + 1 ) 
		ability:ApplyDataDrivenModifier( caster, unit, modifier, {} )
		ability:ApplyDataDrivenModifier( caster, unit, modifier_counter, {} )
		unit:SetModifierStackCount( modifier_counter, caster, currentstack + 1 )
	else
		unit:SetModifierStackCount( modifier_counter, ability, maxstacks )
		ability:ApplyDataDrivenModifier( caster, unit, modifier_counter, {} )
		unit:SetModifierStackCount( modifier_counter, caster, maxstacks )
	end	
end

function RemoveStack( keys )
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local modifier_counter = keys.ModifierCount

	if target:HasModifier( modifier_counter ) then
		local prev_stacks = target:GetModifierStackCount( modifier_counter, caster )
		if prev_stacks > 1 then
			target:SetModifierStackCount( modifier_counter, caster, prev_stacks - 1 )
		else
			target:RemoveModifierByName( modifier_counter )
		end
	end
end