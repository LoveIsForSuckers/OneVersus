function Buff( keys )
	local duration = keys.ability:GetCurrentCharges()

	if duration > 0 and not keys.caster:HasModifier(keys.Modifier) then
		keys.caster:EmitSound("DOTA_Item.LinkensSphere.Activate")
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, keys.Modifier, {duration = duration - 1}) 
		keys.ability:SetCurrentCharges(0)
		keys.caster:EmitSound("DOTA_Item.Satanic.Activate")
	end
end

function GainCharge( keys )
	local oldest_unfilled_stick = nil
		
	for i=0, 5, 1 do
		local current_item = keys.caster:GetItemInSlot(i)
		if current_item ~= nil and current_item:GetName() == "item_genies_mask" and current_item:GetCurrentCharges() < keys.MaxCharges then
			if oldest_unfilled_stick == nil or current_item:GetEntityIndex() < oldest_unfilled_stick:GetEntityIndex() then
				oldest_unfilled_stick = current_item
			end
		end
	end
		
	if oldest_unfilled_stick ~= nil then
		oldest_unfilled_stick:SetCurrentCharges(oldest_unfilled_stick:GetCurrentCharges() + 1)
	end
end

function Punish( keys )
	keys.caster:EmitSound("DOTA_Item.LinkensSphere.Target")
	local mana = keys.caster:GetMana()
	keys.caster:SpendMana(mana,keys.ability)
	keys.caster:EmitSound("DOTA_Item.AbyssalBlade.Activate")
end