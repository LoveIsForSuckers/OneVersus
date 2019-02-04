require("scripts/vscripts/util/passiveTalentManager")

if crushing_prison == nil then
	crushing_prison = class({})
end

LinkLuaModifier("modifier_crushing_prison", "scripts/vscripts/heroes/hero_sand/modifiers/modifier_crushing_prison.lua", LUA_MODIFIER_MOTION_NONE)

if IsServer() then
	PassiveTalentManager:RegisterLuaModifier("sand_crushing_prison_talent_radius", "modifier_crushing_prison_talent_radius", "scripts/vscripts/heroes/hero_sand/modifiers/modifier_crushing_prison_talent_radius.lua", LUA_MODIFIER_MOTION_NONE)
	PassiveTalentManager:RegisterLuaModifier("sand_crushing_prison_talent_cooldown", "modifier_crushing_prison_talent_cooldown", "scripts/vscripts/heroes/hero_sand/modifiers/modifier_crushing_prison_talent_cooldown.lua", LUA_MODIFIER_MOTION_NONE)
end

function crushing_prison:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	
	local caster = self:GetCaster()
	if caster ~= nil then
		if caster:HasModifier("modifier_crushing_prison_talent_cooldown") then
			cooldown = cooldown - self:GetSpecialValueFor("cooldown_reduction_talent")
		end
	end
	
	return cooldown
end

function crushing_prison:GetAOERadius()
	local radius = self:GetSpecialValueFor("radius")
	local caster = self:GetCaster()
	if caster ~= nil then
		if caster:HasModifier("modifier_crushing_prison_talent_radius") then
			radius = radius + self:GetSpecialValueFor("radius_talent_bonus")
		end
	end
	
	return radius
end

function crushing_prison:OnSpellStart()
	local caster = self:GetCaster()
	local radius = self:GetAOERadius()
	local target = self:GetCursorTarget()
	local duration = self:GetLevelSpecialValueFor("duration", self:GetLevel() - 1)
	
	if target ~= nil and ( not target:IsInvulnerable() ) and ( not target:TriggerSpellAbsorb( self ) ) then
		target:EmitSound("Ability.SandKing_BurrowStrike")
		target:EmitSound("Ability.SandKing_Epicenter")
		
		target:AddNewModifier(caster, self, "modifier_crushing_prison", { duration = duration })
	end
end