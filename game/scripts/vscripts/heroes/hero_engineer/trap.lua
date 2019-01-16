function CreateTrap( keys )
	local caster = keys.caster
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local modifier_tracker = keys.modifier_trap_tracker
	local modifier_trap = keys.modifier_trap

	local activation_time = 0.3
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	local trap = CreateUnitByName("npc_dummy_unit", target_point, false, nil, nul, caster:GetTeamNumber())
	trap:AddNewModifier(caster,ability,"modifier_kill", {Duration = duration})
	ability:ApplyDataDrivenModifier(caster, trap, modifier_trap, {})

	Timers:CreateTimer(activation_time, function()
		ability:ApplyDataDrivenModifier(caster, trap, modifier_tracker, {})
	end)
end

function TrapTracker( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
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
							ability:ApplyDataDrivenModifier(caster, enemy, "modifier_trap_stun", {} )
							damageTable.victim = enemy
							ApplyDamage(damageTable)
							PrintTable(damageTable)
						end
					end
				end
				
				-- Create vision upon exploding
				ability:CreateVisibilityNode(target:GetAbsOrigin(), vision_radius, vision_duration)

				target:RemoveModifierByName("modifier_trap")
				target:ForceKill(true)
			end
		end)
	end
end