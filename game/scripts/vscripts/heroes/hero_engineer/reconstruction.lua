LinkLuaModifier("modifier_reconstruct_talent_health_tooltip", "scripts/vscripts/heroes/hero_engineer/modifiers/modifier_reconstruct_talent_health_tooltip.lua", LUA_MODIFIER_MOTION_NONE)

function OnSpellStart( keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	target:EmitSound("Hero_Tinker.RearmStart")
	ability:ApplyDataDrivenModifier(caster, target, "modifier_reconstruct_heal", {})
	
	local healthBuffTalent = caster:FindAbilityByName("engineer_reconstruction_talent_permanent_health_boost")
	if healthBuffTalent and healthBuffTalent:GetLevel() > 0 then
		local talentModifier = target:FindModifierByName("modifier_reconstruct_talent_health_tooltip")
		if talentModifier then
			talentModifier:IncrementStackCount()
		else
			talentModifier = target:AddNewModifier(caster, healthBuffTalent, "modifier_reconstruct_talent_health_tooltip", {})
			talentModifier:SetStackCount(1)
		end
	end
end

function ApplyBuff( keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	target:EmitSound("OneVersus.MetalScree")
	ability:ApplyDataDrivenModifier(caster, target, "modifier_reconstruct_buff", {})
end

function ArmorParticle( event )
	local target = event.target
	local location = target:GetAbsOrigin()
	local particleName = event.EffectName

	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function()
		target.ArmorParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.ArmorParticle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.ArmorParticle, 1, Vector(1,0,0))

		ParticleManager:SetParticleControlEnt(target.ArmorParticle, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
	end)
end

-- Destroys the particle when the modifier is destroyed
function EndArmorParticle( event )
	local target = event.target
	ParticleManager:DestroyParticle(target.ArmorParticle,false)
end