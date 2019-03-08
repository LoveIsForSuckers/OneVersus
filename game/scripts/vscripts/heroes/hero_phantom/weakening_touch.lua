if weakening_touch == nil then
	weakening_touch = class({})
end

LinkLuaModifier("modifier_weakening_touch", "scripts/vscripts/heroes/hero_phantom/modifiers/modifier_weakening_touch.lua", LUA_MODIFIER_MOTION_NONE)

if IsServer() then
	PassiveTalentManager:RegisterLuaModifier("weakening_touch_talent_cooldown", "modifier_weakening_touch_cooldown", "scripts/vscripts/heroes/hero_phantom/modifiers/modifier_weakening_touch_cooldown.lua", LUA_MODIFIER_MOTION_NONE)
end

function weakening_touch:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	
	local caster = self:GetCaster()
	if caster ~= nil then
		if caster:HasModifier("modifier_weakening_touch_cooldown") then
			cooldown = cooldown - self:GetSpecialValueFor("cooldown_reduction_talent")
		end
	end
	
	return cooldown
end

function weakening_touch:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	if caster == nil then return nil end
	if target:IsMagicImmune() then return nil end
	
	local duration = self:GetLevelSpecialValueFor("duration", self:GetLevel() - 1)
	local duration_talent = caster:FindAbilityByName("weakening_touch_talent_duration")
	if duration_talent and duration_talent:GetLevel() > 0 then
		duration = duration + duration_talent:GetSpecialValueFor("value")
	end
	
	local damage = self:GetLevelSpecialValueFor("damage", self:GetLevel() - 1)
	if target:IsCreep() then
		local creep_dmg_talent = caster:FindAbilityByName("weakening_touch_talent_creep_dmg_mod")
		if creep_dmg_talent and creep_dmg_talent:GetLevel() > 0 then
			damage = damage * creep_dmg_talent:GetSpecialValueFor("value")
		end
	end
	
	ApplyDamage({ attacker = caster, victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })
	
	local modifier = "modifier_weakening_touch"
	local stacks = 0
	if target:HasModifier( modifier ) then
		stacks = target:GetModifierStackCount( modifier, caster )
		target:RemoveModifierByName( modifier )
	end
	
	target:EmitSound("Hero_TemplarAssassin.Meld.Move")
	
	target:AddNewModifier(caster, self, modifier, { duration = duration })
	target:SetModifierStackCount( modifier, caster, stacks + 1 )
end