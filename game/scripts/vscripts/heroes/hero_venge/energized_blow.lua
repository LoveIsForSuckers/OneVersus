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
		
		local illusion_talent = caster:FindAbilityByName("venge_energized_blow_talent_illusion")
		if illusion_talent and illusion_talent:GetLevel() > 0 then
			self:MakeIllusion(illusion_talent, location, target)
		end
		
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

function venge_energized_blow:MakeIllusion(illusion_talent, origin, target)
	local caster = self:GetCaster()
	local player = caster:GetPlayerID()
	local unit_name = caster:GetUnitName()
	
	local duration = illusion_talent:GetSpecialValueFor("value")
	local outgoingDamage = illusion_talent:GetSpecialValueFor( "illusion_outgoing_damage")
	local incomingDamage = illusion_talent:GetSpecialValueFor( "illusion_incoming_damage")

	target:EmitSound("Hero_PhantomLancer.SpiritLance.Impact")
	
	local illusion = CreateUnitByName(unit_name, origin, true, caster, nil, caster:GetTeamNumber())
	
	illusion:SetPlayerID(player)
	illusion:SetControllableByPlayer(player, true)
	illusion:SetOwner(caster:GetPlayerOwner())
	
	-- Level Up the unit to the casters level
	local casterLevel = caster:GetLevel()
	for i=1,casterLevel-1 do
		illusion:HeroLevelUp(false)
	end

	-- Set the skill points to 0 and learn the skills of the caster
	illusion:SetAbilityPoints(0)
	for abilitySlot=0,15 do
		local ability = caster:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			illusionAbility:SetLevel(abilityLevel)
		end
	end


	-- Recreate the items of the caster
	for itemSlot=0,5 do
		local item = caster:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
		end
	end

	illusion:SetHealth(caster:GetHealth())
	illusion:SetMana(caster:GetMana())
	
	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, illusion_talent, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
	
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()
end