if modifier_trap_tracker == nil then
	modifier_trap_tracker = class({})
end

function modifier_trap_tracker:IsHidden()
	return true
end

function modifier_trap_tracker:IsPurgable()
	return false
end

function modifier_trap_tracker:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_trap_tracker:OnIntervalThink()
	local caster = self:GetCaster()
	local target = self:GetParent()
	local ability = self:GetAbility()
	local ability_level = ability:GetLevel() - 1

	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local delay = 0.3
	local vision_radius = radius
	local vision_duration = 4.0

	local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE
	
	local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_team, target_types, target_flags, FIND_CLOSEST, false) 
	
	-- If there is a valid unit in range then explode the mine
	if #units > 0 then
		target:EmitSound("Hero_Sniper.ShrapnelShoot")
		target:RemoveModifierByName("modifier_trap_tracker")
		
		Timers:CreateTimer(delay, function()
			if target:IsAlive() then
				target:EmitSound("Hero_TemplarAssassin.Trap.Explode")
				
				local slow_duration = ability:GetLevelSpecialValueFor("slow_duration", ability_level)
				local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
				local damageTalent = caster:FindAbilityByName("engineer_trap_talent_damage")
				if damageTalent and damageTalent:GetLevel() > 0 then
					damage = damage + damageTalent:GetSpecialValueFor("value")
				end
				local damageTable = { attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability }
				
				-- refresh units cause since delay they might have gone away or entered
				units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_team, target_types, target_flags, FIND_CLOSEST, false) 
				if #units > 0 then
					for _,enemy in pairs(units) do
						if enemy ~= nil and (not enemy:IsMagicImmune()) and (not enemy:IsInvulnerable()) then
							enemy:AddNewModifier(caster, ability, "modifier_trap_debuff", { duration = slow_duration } )
							damageTable.victim = enemy
							ApplyDamage(damageTable)
						end
					end
				end
				
				-- Create vision upon exploding
				ability:CreateVisibilityNode(target:GetAbsOrigin(), vision_radius, vision_duration)

				target:RemoveModifierByName("modifier_trap")
				target:ForceKill(true)
				UTIL_Remove(target)
			end
		end)
	end
end