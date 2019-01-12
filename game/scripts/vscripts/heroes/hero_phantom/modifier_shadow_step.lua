modifier_shadow_step = class({})

modifier_shadow_step.fadeTime = 0.5

function modifier_shadow_step:OnCreated(params)
	self.invisBrokenAt = 0
	if params.crit_dmg_pct ~= nil then
		self.crit_dmg_pct = params.crit_dmg_pct
	end
end

function modifier_shadow_step:CheckState()
	local state = {}
	if IsServer() then
		state[MODIFIER_STATE_INVISIBLE] = self:CalculateInvisibilityLevel() == 1.0
	end

	return state
end

function modifier_shadow_step:IsHidden()
	return true
end

function modifier_shadow_step:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_shadow_step:OnAbilityExecuted(event)
	if event.unit == self:GetParent() then
		self.invisBrokenAt = self:GetElapsedTime()
		self:GetModifierInvisibilityLevel()
		event.unit:RemoveModifierByName("modifier_shadow_step_fake")
		self:Destroy()
	end
end

function modifier_shadow_step:GetActivityTranslationModifiers( params)
	if self:GetParent() == self:GetCaster() then
		return "shadow_step"
	end

	return 0
end

function modifier_shadow_step:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() then
			local target = params.target
			if not target:IsBuilding() then
				EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), "Hero_TemplarAssassin.Meld.Attack", self:GetCaster() )
				local kek = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom/shadow_step_crit.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
				ParticleManager:SetParticleControl(kek,0,target:GetAbsOrigin())
				ParticleManager:SetParticleControl(kek,1,target:GetAbsOrigin())
			end
			params.attacker:RemoveModifierByName("modifier_shadow_step_fake")
			self:Destroy()
		end
	end
end

function modifier_shadow_step:CalculateInvisibilityLevel()
	return math.min((self:GetElapsedTime() - self.invisBrokenAt)/self.fadeTime, 1.0)
end

function modifier_shadow_step:GetModifierInvisibilityLevel(params)
	if IsClient() then
		return self:GetStackCount() / 100
	end
	local level = self:CalculateInvisibilityLevel()
	if IsServer() then
		self:SetStackCount(math.ceil(level*100))
	end
	return level
end

function modifier_shadow_step:GetModifierPreAttack_CriticalStrike(params)
	return self.crit_dmg_pct
end