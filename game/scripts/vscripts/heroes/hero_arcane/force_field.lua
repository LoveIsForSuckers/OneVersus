if force_field == nil then
	force_field = class({})
end

LinkLuaModifier("modifier_force_field", "scripts/vscripts/heroes/hero_arcane/modifiers/modifier_force_field.lua", LUA_MODIFIER_MOTION_NONE)

function force_field:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetLevelSpecialValueFor("duration", self:GetLevel() - 1)
	local radius = self:GetLevelSpecialValueFor("shard_check_radius", self:GetLevel() - 1) -- TODO: rework this sheit
	caster:AddNewModifier(caster, self, "modifier_force_field", { duration = duration })
	
	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
	for k, v in pairs( units ) do
		if v:GetUnitName() == "npc_arcane_shard" then
			v:AddNewModifier(caster, self, "modifier_force_field", { duration = duration })
		end
	end
end