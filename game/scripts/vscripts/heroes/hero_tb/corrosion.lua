if tb_corrosion == nil then
	tb_corrosion = class({})
end

LinkLuaModifier("modifier_corrosion_damage", "scripts/vscripts/heroes/hero_tb/modifiers/modifier_corrosion_damage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_corrosion_disarm", "scripts/vscripts/heroes/hero_tb/modifiers/modifier_corrosion_disarm.lua", LUA_MODIFIER_MOTION_NONE)

function tb_corrosion:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	if caster == nil or target == nil or target:TriggerSpellAbsorb(this) then
		return
	end
	
	target:AddNewModifier(caster, self, "modifier_corrosion_damage", { duration = self:GetSpecialValueFor("duration") })
	target:EmitSound("OneVersus.Demon_Growl")
end