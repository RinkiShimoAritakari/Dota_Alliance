LinkLuaModifier("modifier_Alliance_Forester_bonus", "abilities/Alliance_Forester_bonus", LUA_MODIFIER_MOTION_NONE)

Alliance_Forester_bonus = class({CAddonTemplateGameMode})


function Alliance_Forester_bonus:GetIntrinsicModifierName()
	return "modifier_Alliance_Forester_bonus"
end

modifier_Alliance_Forester_bonus = class({})

function modifier_Alliance_Forester_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_Alliance_Forester_bonus:GetModifierAttackRangeBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_range")
end

function modifier_Alliance_Forester_bonus:GetModifierProcAttack_Feedback(keys)
	if not(keys.attacker:IsRangedAttacker()) and keys.attacker and keys.target and not (keys.attacker:IsNull() or keys.target:IsNull() or keys.attacker:GetTeam() == keys.target:GetTeam()) then
	
		local ability = self:GetAbility()

		-- cleave_starting_width = 150 
		-- cleave_ending_width = 360
		-- distance = 700

		cleave_starting_width = self:GetAbility():GetSpecialValueFor("cleave_starting_width") 
		cleave_ending_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
		cleave_distance = self:GetAbility():GetSpecialValueFor("cleave_distance")
		cleave_damage_per_kill = self:GetAbility():GetSpecialValueFor("cleave_damage_per_kill")

		kills_enemy_heroes = keys.attacker:GetKills()
		-- print(kills_enemy_heroes)

		local cleave_damage = ((kills_enemy_heroes + cleave_damage_per_kill) * cleave_damage_per_kill / 100) * keys.damage
		print(cleave_damage)
		return DoCleaveAttack(keys.attacker, keys.target, self:GetAbility(), cleave_damage, cleave_starting_width, cleave_ending_width, cleave_distance, nil)
	end
end