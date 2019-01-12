function Init(keys)
	local target = keys.target
	if not target.SilencedDamage or target.SilencedDamage == nil then
		target.SilencedDamage = 0
	end
end

function AddDamage(keys)
	local target = keys.unit
	local dmg = keys.AtkDamage
	target.SilencedDamage = target.SilencedDamage + dmg
end

function DealDamage(keys)
	local caster = keys.caster
	local target = keys.target
	if target:IsMagicImmune() then return nil end
	local ability = keys.ability
	local particleName = keys.Particle
	local damagemod = ability:GetLevelSpecialValueFor("final_damage_pct",ability:GetLevel()-1)
	local damagedealt = damagemod * target.SilencedDamage / 100
	local poof = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
	target:EmitSound("DOTA_Item.Bloodthorn.Activate")
	ApplyDamage({victim = target, attacker = caster, damage = damagedealt, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , target, damagedealt, caster )
	target.SilencedDamage = 0
end