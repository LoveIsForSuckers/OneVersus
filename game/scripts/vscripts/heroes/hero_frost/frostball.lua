require("scripts/vscripts/util/passiveTalentManager")

if lich_frostball == nil then
	lich_frostball = class({})
end

LinkLuaModifier("modifier_frostball_root", "scripts/vscripts/heroes/hero_frost/modifiers/modifier_frostball_root.lua", LUA_MODIFIER_MOTION_NONE)

if IsServer() then
	PassiveTalentManager:RegisterLuaModifier("lich_frostball_talent_radius", "modifier_frostball_talent_radius", "scripts/vscripts/heroes/hero_frost/modifiers/modifier_frostball_talent_radius.lua", LUA_MODIFIER_MOTION_NONE)
end

function lich_frostball:GetAOERadius()
	local radius = self:GetSpecialValueFor("radius")
	local caster = self:GetCaster()
	if caster ~= nil then
		if caster:HasModifier("modifier_frostball_talent_radius") then
			radius = radius + self:GetSpecialValueFor("radius_talent_bonus")
		end
	end
	
	return radius
end

function lich_frostball:OnSpellStart()
	local caster = self:GetCaster()
	local radius = self:GetAOERadius()
	local speed = self:GetSpecialValueFor("speed")
	
	local proj_data = {
		EffectName = "particles/units/heroes/hero_frost/frostball.vpcf",
		Ability = self,
		iMoveSpeed = speed,
		Source = self:GetCaster(),
		Target = self:GetCursorTarget(),
		bDodgeable = true,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iVisionRadius = radius,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION, 
	}
	ProjectileManager:CreateTrackingProjectile( proj_data )
	
	caster:EmitSound("Ability.FrostNova")
end

function lich_frostball:OnProjectileHit( target, location )
	if target ~= nil and ( not target:IsInvulnerable() ) and ( not target:TriggerSpellAbsorb( self ) ) then
		EmitSoundOn( "Hero_Lich.ChainFrostImpact.Hero", target )
		
		local caster = self:GetCaster()
		local radius = self:GetAOERadius()
		local damage = self:GetSpecialValueFor( "damage" )
		local duration = self:GetSpecialValueFor( "duration" )
		
		local damagePerIntTalent = caster:FindAbilityByName("lich_frostball_talent_damage_per_int")
		if damagePerIntTalent and damagePerIntTalent:GetLevel() > 0 then
			local damageIntFactor = damagePerIntTalent:GetSpecialValueFor("value")
			damage = damage + (caster:GetIntellect() * damageIntFactor)
			SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , target, damage, attacker )
		end

		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetOrigin(), target, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

					local damage = {
						victim = enemy,
						attacker = caster,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}

					ApplyDamage( damage )
					enemy:AddNewModifier( caster, self, "modifier_frostball_root", { duration = duration } )
				end
			end
		end
	end

	return true
end