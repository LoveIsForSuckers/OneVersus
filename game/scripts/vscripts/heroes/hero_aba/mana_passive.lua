function Lifesteal(keys)
	if keys.target.GetInvulnCount == nil then
		keys.ability:ApplyDataDrivenModifier(keys.attacker, keys.attacker, "modifier_mana_passive_lifesteal", {duration = 0.03})
	end
end