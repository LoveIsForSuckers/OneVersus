function Restore( keys )
	keys.caster:EmitSound("DOTA_Item.MagicStick.Activate")
	
	local amount_to_restore = keys.ability:GetCurrentCharges() * keys.RestorePerCharge
	keys.caster:Heal(amount_to_restore, keys.caster)
	keys.caster:GiveMana(amount_to_restore)
	
	keys.ability:SetCurrentCharges(0)

	local zap = ParticleManager:CreateParticle(keys.Particle, PATTACH_OVERHEAD_FOLLOW, keys.caster)
end

function Banish( keys )
	if keys.target == nil then
		return nil
	end

	if keys.target:IsCreep() then
		if not keys.target:IsMagicImmune() then
			local oldest_unfilled_stick = nil
		
			for i=0, 5, 1 do
				local current_item = keys.caster:GetItemInSlot(i)
				if current_item ~= nil and current_item:GetName() == "item_banishing_wand" and current_item:GetCurrentCharges() < keys.MaxCharges then
					if oldest_unfilled_stick == nil or current_item:GetEntityIndex() < oldest_unfilled_stick:GetEntityIndex() then
						oldest_unfilled_stick = current_item
					end
				end
			end
		
			if oldest_unfilled_stick ~= nil then
				oldest_unfilled_stick:SetCurrentCharges(oldest_unfilled_stick:GetCurrentCharges() + 1)
			end

			EmitSoundOn( "OneVersus.BanishingWand" , keys.target )

			local zap = ParticleManager:CreateParticle(keys.Particle, PATTACH_OVERHEAD_FOLLOW, keys.caster)

			ApplyDamage({victim = keys.target, attacker = keys.caster, damage = keys.Damage, damage_type = DAMAGE_TYPE_PURE, ability = keys.ability})
		end
	end
end