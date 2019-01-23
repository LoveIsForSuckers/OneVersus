require("scripts/vscripts/util/passiveTalentManager")

if stronk_stomp == nil then
	stronk_stomp = class({})
end

LinkLuaModifier("modifier_stronk_trauma", "scripts/vscripts/heroes/hero_stronk/modifiers/modifier_stronk_trauma.lua", LUA_MODIFIER_MOTION_NONE)

if IsServer() then
	PassiveTalentManager:RegisterLuaModifier("stronk_stomp_talent_cooldown", "modifier_stronk_stomp_cooldown", "scripts/vscripts/heroes/hero_stronk/modifiers/modifier_stronk_stomp_cooldown.lua", LUA_MODIFIER_MOTION_NONE)
end

function stronk_stomp:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	
	local caster = self:GetCaster()
	if caster ~= nil then
		if caster:HasModifier("modifier_stronk_stomp_cooldown") then
			cooldown = cooldown - self:GetSpecialValueFor("cooldown_reduction_talent")
		end
	end
	
	return cooldown
end

function stronk_stomp:OnSpellStart()
	local target_point = self:GetCursorPosition()
	local caster = self:GetCaster()
	
	if caster == nil then
		return
	end

	-- 0. check for targets
	local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE
	local ability_level = self:GetLevel() - 1
	local radius = self:GetLevelSpecialValueFor("radius", ability_level)
	
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_team, target_types, target_flags, FIND_ANY_ORDER, false)
	if #units == 0 then
		self:FireStompEffects(caster)
		return
	end
	
	-- 1. calc effect power
	local trauma_chance = self:GetLevelSpecialValueFor("trauma_chance", ability_level)
	local damage = self:GetLevelSpecialValueFor("damage", ability_level)
	local stun_duration = self:GetLevelSpecialValueFor("duration", ability_level)
	local trauma_duration = self:GetLevelSpecialValueFor("trauma_duration", ability_level)
	
	local trauma_chance_talent = caster:FindAbilityByName("stronk_stomp_talent_trauma_chance")
	if trauma_chance_talent and trauma_chance_talent:GetLevel() > 0 then
		trauma_chance = trauma_chance + trauma_chance_talent:GetSpecialValueFor("value")
	end
	
	local damage_talent = caster:FindAbilityByName("stronk_stomp_talent_damage")
	if damage_talent and damage_talent:GetLevel() > 0 then
		local extra_damage_per_target = damage_talent:GetSpecialValueFor("value")
		damage = damage + (#units * extra_damage_per_target)
		SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , caster, damage, caster )
	end
	
	local stun_duration_talent = caster:FindAbilityByName("stronk_stomp_talent_stunduration")
	if stun_duration_talent and stun_duration_talent:GetLevel() > 0 then
		stun_duration = stun_duration + stun_duration_talent:GetSpecialValueFor("value")
	end
	
	local damageTable = { attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self }
	
	-- 2. act on target units
	for _,enemy in pairs(units) do
		if enemy ~= nil and (not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
			enemy:AddNewModifier(caster, self, "modifier_stunned", { duration = stun_duration })
			damageTable.victim = enemy
			ApplyDamage(damageTable)
			
			local rand = math.random() * 100
			if rand < trauma_chance then
				enemy:EmitSound("OneVersus.Trauma")
				enemy:AddNewModifier(caster, self, "modifier_stronk_trauma", { duration = trauma_duration } )
			end
		end
	end
	
	-- 3. fire effects
	self:FireStompEffects(caster)
end

function stronk_stomp:FireStompEffects(caster)
	caster:EmitSound("Hero_Centaur.HoofStomp")
	ParticleManager:CreateParticle("particles/units/heroes/hero_stronk/earth_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
end