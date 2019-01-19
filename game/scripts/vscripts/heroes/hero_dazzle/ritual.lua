require("scripts/vscripts/util/passiveTalentManager")

if dazzle_ritual == nil then
	dazzle_ritual = class({})
end

if IsServer() then
	PassiveTalentManager:RegisterLuaModifier("dazzle_ritual_talent_cooldown", "modifier_ritual_talent_cooldown", "scripts/vscripts/heroes/hero_dazzle/modifiers/modifier_ritual_talent_cooldown.lua", LUA_MODIFIER_MOTION_NONE)
	PassiveTalentManager:RegisterLuaModifier("dazzle_ritual_talent_puredamage", "modifier_ritual_talent_puredamage", "scripts/vscripts/heroes/hero_dazzle/modifiers/modifier_ritual_talent_puredamage.lua", LUA_MODIFIER_MOTION_NONE )
end

function dazzle_ritual:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	
	local caster = self:GetCaster()
	if caster ~= nil then
		if caster:HasModifier("modifier_ritual_talent_cooldown") then
			cooldown = cooldown - self:GetSpecialValueFor("cooldown_reduction_talent")
		end
	end
	
	return cooldown
end

function dazzle_ritual:GetAbilityDamageType()
	local caster = self:GetCaster()
	if caster ~= nil then
		if caster:HasModifier("modifier_ritual_talent_puredamage") then
			return DAMAGE_TYPE_PURE
		end
	end
	
	return DAMAGE_TYPE_MAGICAL
end

function dazzle_ritual:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	caster:EmitSound("Hero_Dazzle.BadJuJu.Cast")
	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/ritual.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(particle)
	
	local hp_percent = self:GetLevelSpecialValueFor("hp_percent", (self:GetLevel() - 1))
	
	local target_hp = target:GetHealth()
	local damage_dealt = (target_hp * hp_percent) / 100
	
	ApplyDamage({ victim = target, attacker = caster, damage = damage_dealt, damage_type = self:GetAbilityDamageType(), ability = self })
	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , target, damage_dealt, caster )
end