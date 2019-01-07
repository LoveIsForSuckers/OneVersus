function ApplyStack(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.Modifier
	local counter = keys.Counter
	local stacks = 0

	if target:HasModifier( counter ) then
		stacks = target:GetModifierStackCount( counter, caster )
		target:RemoveModifierByName( counter )
	end

	target:EmitSound("Hero_TemplarAssassin.Meld.Move")

	ability:ApplyDataDrivenModifier( caster, target, counter, {} )
	target:SetModifierStackCount( counter, caster, stacks + 1 )
	ability:ApplyDataDrivenModifier( caster, target, modifier, {} )
end

function RemoveStack(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local counter = keys.Counter
	
	if target:HasModifier( counter) then
		local stacks = target:GetModifierStackCount( counter , caster )
		if stacks > 1 then
			target:SetModifierStackCount( counter, caster, stacks - 1)
		else
			target:RemoveModifierByName( counter )
		end
	end
end