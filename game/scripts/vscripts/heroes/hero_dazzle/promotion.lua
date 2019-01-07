function upscale( keys )
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	local upscale = ability:GetLevelSpecialValueFor("upscale", (ability:GetLevel() - 1))

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