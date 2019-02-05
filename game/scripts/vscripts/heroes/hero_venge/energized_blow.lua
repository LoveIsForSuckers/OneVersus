if venge_energized_blow == nil then
	venge_energized_blow = class({})
end

LinkLuaModifier("modifier_energized_blow", "scripts/vscripts/heroes/hero_venge/modifiers/modifier_energized_blow.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_energized_blow_slow", "scripts/vscripts/heroes/hero_venge/modifiers/modifier_energized_blow_slow.lua", LUA_MODIFIER_MOTION_NONE)

function venge_energized_blow:OnSpellStart()
	local caster = self:GetCaster()
	
	caster:EmitSound("Hero_StormSpirit.ElectricVortexCast")
	caster:AddNewModifier(caster, self, "modifier_energized_blow", {})
end

function venge_energized_blow:OnProjectileHit( target, location )
	if IsServer() then
		local caster = self:GetCaster()
		
		if target == nil or target:GetTeamNumber() == caster:GetTeamNumber() or target:IsMagicImmune() then
			self:ClearRicochetData()
			return
		end
		
		target:EmitSound("OneVersus.Ptoom")
		local duration = self:GetLevelSpecialValueFor("duration", self:GetLevel() - 1)
		target:AddNewModifier(caster, self, "modifier_energized_blow_slow", { duration = duration })
		
		local damage = caster:GetAttackDamage()
		ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self })
		
		local ricochet_talent = caster:FindAbilityByName("venge_energized_blow_talent_ricochet")
		local max_targets = ricochet_talent:GetSpecialValueFor("max_targets")
		
		if self.processed_ricochet_target_count >= max_targets then
			self:ClearRicochetData()
			return
		else
			self:TryFireRicochetProjectile(target)
		end
	end
end

function venge_energized_blow:TryFireRicochetProjectile(prevTarget)
	local caster = self:GetCaster()
	
	local ricochet_talent = caster:FindAbilityByName("venge_energized_blow_talent_ricochet")
	local ricochet_range = ricochet_talent:GetSpecialValueFor("value")
	
	local iTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local iType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING
	local iFlag = DOTA_UNIT_TARGET_FLAG_NONE
	
	local potential_targets = FindUnitsInRadius(caster:GetTeamNumber(), prevTarget:GetAbsOrigin(), nil, ricochet_range, iTeam, iType, iFlag, FIND_ANY_ORDER, false)
	
	local newTarget
	for _,v in pairs(potential_targets) do
		if self.processed_ricochet_targets[v] == nil and (not v:IsMagicImmune()) then
			newTarget = v
			break
		end
	end
	
	if newTarget == nil then
		self:ClearRicochetData()
		return
	end
	
	local projectile = {
        Target = newTarget,
        Source = prevTarget,
        EffectName = "particles/units/heroes/hero_vengeful/vengeful_base_attack.vpcf",
        Ability = self,
        bDodgeable = false,
        bProvidesVision = false,
        iMoveSpeed = 1500,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	}
	
	ProjectileManager:CreateTrackingProjectile( projectile )
	
	self.processed_ricochet_targets[newTarget] = true
	self.processed_ricochet_target_count = self.processed_ricochet_target_count + 1
end

function venge_energized_blow:ClearRicochetData()
	for k,_ in pairs(self.processed_ricochet_targets) do
		self.processed_ricochet_targets[k] = nil
	end
	
	self.processed_ricochet_target_count = 0
end