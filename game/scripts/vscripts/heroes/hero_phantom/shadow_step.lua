shadow_step = class({})

LinkLuaModifier("modifier_shadow_step", "scripts/vscripts/heroes/hero_phantom/modifiers/modifier_shadow_step.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shadow_step_fake", "scripts/vscripts/heroes/hero_phantom/modifiers/modifier_shadow_step_fake.lua", LUA_MODIFIER_MOTION_NONE)

function shadow_step:OnSpellStart()
	local hero = self:GetCaster()
	if hero == nil then return nil end
	
	local crit_dmg_pct = self:GetLevelSpecialValueFor("crit_dmg_pct", (self:GetLevel() - 1))
	local crit_dmg_pct_talent = hero:FindAbilityByName("shadow_step_talent_crit_dmg_pct")
	if crit_dmg_pct_talent and crit_dmg_pct_talent:GetLevel() > 0 then
		crit_dmg_pct = crit_dmg_pct + crit_dmg_pct_talent:GetSpecialValueFor("value")
	end
	
	hero:AddNewModifier(hero, self, "modifier_shadow_step", { fadeTime = 0.5, duration = 6.0, crit_dmg_pct = crit_dmg_pct })
	hero:AddNewModifier(hero, self, "modifier_shadow_step_fake", { duration = 6.0 })
	hero:EmitSound("Hero_TemplarAssassin.Meld")
	local kek = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero)
end