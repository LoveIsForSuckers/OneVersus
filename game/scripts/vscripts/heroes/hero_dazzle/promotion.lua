function OnSpellStart (keys)
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	
	target:EmitSound("Hero_Dazzle.Shadow_Wave")
	
	local healAmount = ability:GetLevelSpecialValueFor("heal", (ability:GetLevel() - 1))
	target:Heal(healAmount, caster)
	
	if not target:HasModifier("modifier_promotion") then
		local upscale = ability:GetLevelSpecialValueFor("upscale", (ability:GetLevel() - 1))
		UpScale(upscale, target)
	end
	
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local durationTalent = caster:FindAbilityByName("dazzle_promotion_talent_duration")
	if durationTalent and durationTalent:GetLevel() > 0 then
		duration = duration + durationTalent:GetSpecialValueFor("value")
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_promotion", { duration = duration })
end

function UpScale( upscale, target )
	local modelscale = target:GetModelScale()
	local finalscale = modelscale + (upscale/100)
	local scale_per_step = 100 / (finalscale - modelscale)

	for i=1,100 do
		Timers:CreateTimer(i/100, 
		function()
			target:SetModelScale(modelscale + i/scale_per_step)
		end)
	end
end