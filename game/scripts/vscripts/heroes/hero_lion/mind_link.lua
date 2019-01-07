function mind_link_cast( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	
	ability.enemy = target

	track_caster_mana( event )

end

function mind_link_damage( event )
	local caster = event.caster
	local ability = event.ability
	local target = ability.enemy
	local targetmana = target:GetMana()
	local manadrained = caster.last_mana - caster:GetMana()
	local damage_per_mana_drained = ability:GetLevelSpecialValueFor("damage_per_mana_drained", ability:GetLevel() - 1 )
	local damaged = manadrained * damage_per_mana_drained
	if manadrained < 0 then
		return
	end
	if manadrained > targetmana then
		manadrained = targetmana
	end
	target:ReduceMana( manadrained )
	ApplyDamage({victim = target, attacker = caster, damage = damaged, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function track_caster_mana( event )
	local caster = event.caster
	caster.last_mana = caster:GetMana()
end