if IsServer() then
	if PassiveTalentManager == nil then
		PassiveTalentManager = class({})
	end

	function PassiveTalentManager:RegisterLuaModifier(talentAbilityName, modifierName, modifierCodePath, modifierMotionType)
		if self.PassiveTalentTable == nil then
			self.PassiveTalentTable = {}
		end
		
		LinkLuaModifier(modifierName, modifierCodePath, modifierMotionType)
		self.PassiveTalentTable[talentAbilityName] = modifierName
		print("[PassiveTalentManager] Registered talent modifier:", modifierName, "for ability", talentAbilityName)
	end

	function PassiveTalentManager:OnPlayerLearnedAbility(keys)
		if self.PassiveTalentTable == nil then
			return
		end

		local player = EntIndexToHScript(keys.player)
		local abilityName = keys.abilityname
		local pID = keys.PlayerID
		if not pID then
			return
		end
		
		local hero = PlayerResource:GetSelectedHeroEntity( pID )
		if hero == nil then
			return
		end
		
		local ability = hero:FindAbilityByName(abilityName)
		local modifierName = self.PassiveTalentTable[abilityName]
		if modifierName == nil then
			return
		end
		
		hero:AddNewModifier(hero, ability, modifierName, {})
	end
end