if tb_celerity == nil then
	tb_celerity = class({})
end

LinkLuaModifier("modifier_celerity", "scripts/vscripts/heroes/hero_tb/modifiers/modifier_celerity.lua", LUA_MODIFIER_MOTION_NONE)

function tb_celerity:OnSpellStart()
	local caster = self:GetCaster()
	
	if caster == nil then
		return
	end
	
	local duration = self:GetSpecialValueFor("duration")
	local durationTalent = caster:FindAbilityByName("tb_celerity_talent_duration")
	if durationTalent and durationTalent:GetLevel() > 0 then
		duration = duration + durationTalent:GetSpecialValueFor("value")
	end
	
	caster:AddNewModifier(caster, self, "modifier_celerity", { duration = duration })
	caster:EmitSound("OneVersus.Demon_Swoosh")
end