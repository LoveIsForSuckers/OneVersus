function ApplyFieryStack( keys )
	local ability = keys.ability
	local modifier = keys.Modifier
	local modifier_counter = keys.ModifierCounter
	local caster = keys.caster
	local target = keys.target

	if target:IsMagicImmune() then return nil end

	if target:IsInvulnerable() then return nil end

	local fire_stacks = 0

	if target:HasModifier( modifier_counter ) then
		fire_stacks = target:GetModifierStackCount( modifier_counter , caster )
		target:RemoveModifierByName( modifier_counter )
	end

	ability:ApplyDataDrivenModifier( caster, target, modifier_counter, {} )
	target:SetModifierStackCount( modifier_counter, caster, fire_stacks + 1 )
	ability:ApplyDataDrivenModifier( caster, target, modifier, {} )

end

function StackBasedBurn( keys )
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local modifier = keys.Modifier
	local damage_per_stack = keys.Damage

	local fire_stacks = target:GetModifierStackCount( modifier , caster )

	ApplyDamage( { victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability } )
end

function RemoveStack( keys )
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local modifier_counter = keys.ModifierCounter

	if target:HasModifier( modifier_counter ) then
		local prev_stacks = target:GetModifierStackCount( modifier_counter, caster )
		if prev_stacks > 1 then
			target:SetModifierStackCount( modifier_counter, caster, prev_stacks - 1 )
		else
			target:RemoveModifierByName( modifier_counter )
		end
	end
 
end