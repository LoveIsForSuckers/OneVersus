function Consume( keys )
	local caster = keys.caster
	local refund_gold = keys.GoldAmount
	caster:ModifyGold(refund_gold, false, 0)
	caster:EmitSound("DOTA_Item.Hand_Of_Midas")
end

function TickGold ( keys )
	local caster = keys.caster
	if caster:IsAlive() then
		caster:ModifyGold(1, false, 0)
	end
end