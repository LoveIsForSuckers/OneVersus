function OnAttackLanded(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local cooldown = ability:GetCooldown(ability:GetLevel())
	local duration = ability:GetLevelSpecialValueFor("slow_duration",ability:GetLevel()-1)
	local eviscerator = nil
	
	
  for i=0, 5, 1 do
    local current_item = caster:GetItemInSlot(i)
    if current_item ~= nil then
      local item_name = current_item:GetName()
      if item_name == "item_eviscerator" then
        eviscerator = current_item
      end
    end
  end
  
  if not caster:IsRangedAttacker() and ability:IsCooldownReady() and eviscerator ~= nil then
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_eviscerator_flurry_buff",{})
	ability:ApplyDataDrivenModifier(caster,target,"modifier_eviscerator_flurry_slow",{duration=duration})
	ability:StartCooldown(cooldown)
  end
end

function OnAttackFailed(keys)
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetCooldown(ability:GetLevel())
	local eviscerator = nil
	
	for i=0, 5, 1 do
		local current_item = caster:GetItemInSlot(i)
		if current_item ~= nil then
				local item_name = current_item:GetName()
			if item_name == "item_eviscerator" then
				eviscerator = current_item
			end
		end
	end
	
	if not caster:IsRangedAttacker() and ability:IsCooldownReady() and eviscerator ~= nil then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_eviscerator_flurry_buff",{})
		ability:StartCooldown(cooldown)
	end
end