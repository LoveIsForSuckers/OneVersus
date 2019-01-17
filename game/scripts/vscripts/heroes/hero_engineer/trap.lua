require("scripts/vscripts/util/passiveTalentManager")

if engineer_trap == nil then
	engineer_trap = class({})
end

LinkLuaModifier("modifier_trap", "scripts/vscripts/heroes/hero_engineer/modifiers/modifier_trap.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_trap_tracker", "scripts/vscripts/heroes/hero_engineer/modifiers/modifier_trap_tracker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_trap_debuff", "scripts/vscripts/heroes/hero_engineer/modifiers/modifier_trap_debuff.lua", LUA_MODIFIER_MOTION_NONE)

if IsServer() then
	PassiveTalentManager:RegisterLuaModifier("engineer_trap_talent_charges", "modifier_trap_charges_initiator", "scripts/vscripts/heroes/hero_engineer/modifiers/modifier_trap_charges_initiator.lua", LUA_MODIFIER_MOTION_NONE)
end

function engineer_trap:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

if IsServer() then
	function engineer_trap:OnUpgrade()
		local caster = self:GetCaster()
		if caster == nil then
			return
		end
		
		local maxCount = self:GetSpecialValueFor("max_charges")
		local cooldown = self:GetSpecialValueFor("charge_restore_duration")
		
		local talent = caster:FindAbilityByName("engineer_trap_talent_charges")
		if talent and talent:GetLevel() > 0 then
			maxCount = maxCount + talent:GetSpecialValueFor("value")
		end
		
		caster:AddNewModifier(caster, self, "modifier_charges", { max_count = maxCount, start_count = 1, replenish_time = cooldown})
	end
end

function engineer_trap:OnSpellStart()
	local target_point = self:GetCursorPosition()
	local caster = self:GetCaster()
	
	if caster == nil then
		return
	end
	
	EmitSoundOnLocationWithCaster(target_point, "Hero_TemplarAssassin.Trap.Cast", caster)
	self:CreateTrap(caster, target_point)
end

function engineer_trap:CreateTrap( caster, target_point )
	local ability_level = self:GetLevel() - 1
	local activation_time = 0.3
	local duration = self:GetLevelSpecialValueFor("duration", ability_level)

	local trap = CreateUnitByName("npc_dummy_unit", target_point, false, nil, nul, caster:GetTeamNumber())
	trap:AddNewModifier(caster, self,"modifier_kill", {Duration = duration})
	trap:AddNewModifier(caster, self, "modifier_trap", {})

	Timers:CreateTimer(activation_time, function()
		trap:AddNewModifier(caster, self, "modifier_trap_tracker", {})
	end)
end