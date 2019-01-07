function TickGold ( keys )
	local caster = keys.caster
	if caster:IsAlive() then
		caster:ModifyGold(1, true, 0)
	end
end