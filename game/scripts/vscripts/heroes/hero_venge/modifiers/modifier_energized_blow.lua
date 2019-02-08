if modifier_energized_blow == nil then
	modifier_energized_blow = class({})
end

function modifier_energized_blow:IsHidden()
	return false
end

function modifier_energized_blow:IsDebuff()
	return false
end

function modifier_energized_blow:IsPurgable()
	return true
end

function modifier_energized_blow:GetEffectName()
	return "particles/units/heroes/hero_venge/energized_buff.vpcf"
end

function modifier_energized_blow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_energized_blow:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
	
	return state
end

function modifier_energized_blow:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	
	return funcs
end

function modifier_energized_blow:OnAttackLanded(keys)
	if IsServer() then
		local unit = keys.attacker
		if unit == self:GetParent() then
			local caster = self:GetCaster()
			local ability = self:GetAbility()
			local target = keys.target
			
			if target ~= nil and target:GetTeamNumber() ~= unit:GetTeamNumber() and (not target:IsMagicImmune()) then
				target:EmitSound("OneVersus.Ptoom")
				local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
				target:AddNewModifier(caster, ability, "modifier_energized_blow_slow", { duration = duration })
				
				local illusion_talent = caster:FindAbilityByName("venge_energized_blow_talent_illusion")
				if illusion_talent and illusion_talent:GetLevel() > 0 then
					ability:MakeIllusion(illusion_talent, target:GetOrigin(), target)
				end
				
				local ricochet_talent = caster:FindAbilityByName("venge_energized_blow_talent_ricochet")
				if ricochet_talent and ricochet_talent:GetLevel() > 0 then
					if not ability.processed_ricochet_targets then
						ability.processed_ricochet_targets = {}
					end
					
					ability.processed_ricochet_targets[target] = true
					ability.processed_ricochet_target_count = 1
					
					ability:TryFireRicochetProjectile(target)
				end
				
				self:Destroy()
			end
		end
	end
end