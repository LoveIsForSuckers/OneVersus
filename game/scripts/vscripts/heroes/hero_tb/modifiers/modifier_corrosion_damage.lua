if modifier_corrosion_damage == nil then
	modifier_corrosion_damage = class({})
end

function modifier_corrosion_damage:IsHidden()
	return false
end

function modifier_corrosion_damage:IsDebuff()
	return true
end

function modifier_corrosion_damage:IsPurgable()
	return true
end

function modifier_corrosion_damage:GetEffectName()
	return "particles/units/heroes/hero_tb/corrosion_damage.vpcf"
end

function modifier_corrosion_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_corrosion_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK
	}
	
	return funcs
end

function modifier_corrosion_damage:OnCreated(keys)
	if IsServer() then
		self:UpdateCachedValues()
		self:StartIntervalThink(1)
	end
end

function modifier_corrosion_damage:OnRefresh(keys)
	if IsServer() then
		self:UpdateCachedValues()
	end
end

function modifier_corrosion_damage:OnAttack(keys)
	if IsServer() then
		local unit = keys.attacker
		if unit == self:GetParent() then
			local caster = self:GetCaster()
			local ability = self:GetAbility()
		
			unit:AddNewModifier(caster, self:GetAbility(), "modifier_corrosion_disarm", { duration = ability:GetSpecialValueFor("disarm_duration") })
			ApplyDamage({victim = unit, attacker = caster, damage = self.disarm_damage, damage_type = self.damage_type})
		
			unit:EmitSound("OneVersus.Metal_Deep_Boom")
		
			self:StartIntervalThink(-1)
			self:Destroy()
		end
	end
end

function modifier_corrosion_damage:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		
		ApplyDamage({victim = target, attacker = caster, damage = self.damage_per_sec, damage_type = self.damage_type})
	end
end

function modifier_corrosion_damage:UpdateCachedValues()
	local ability = self:GetAbility()
	self.damage_per_sec = ability:GetSpecialValueFor("damage_per_sec")
	self.damage_type = ability:GetAbilityDamageType()
	self.disarm_damage = ability:GetSpecialValueFor("disarm_damage")
	
	local caster = self:GetCaster()
	local talent = caster:FindAbilityByName("tb_corrosion_talent_disarm_damage")
	if talent and talent:GetLevel() > 0 then
		self.disarm_damage = self.disarm_damage + talent:GetSpecialValueFor("value")
	end
end