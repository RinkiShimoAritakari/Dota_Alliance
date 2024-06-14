LinkLuaModifier("modifier_alliance_champion_bonus", "abilities/alliance_champion_bonus", LUA_MODIFIER_MOTION_NONE)

alliance_champion_bonus = class({CAddonTemplateGameMode})

function alliance_champion_bonus:GetIntrinsicModifierName()
	
	return "modifier_alliance_champion_bonus"
end

modifier_alliance_champion_bonus = class({})

function modifier_alliance_champion_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
end

function modifier_alliance_champion_bonus:GetModifierBonusStats_Strength()
	kills_enemy_heroes = self:GetParent():GetKills()
	strength_bonus_per_kill = kills_enemy_heroes * self:GetAbility():GetSpecialValueFor("strength_bonus_per_kill")

	return strength_bonus_per_kill
end

function modifier_alliance_champion_bonus:GetModifierBonusStats_Agility()
	kills_enemy_heroes = self:GetParent():GetKills()
	agility_bonus_per_kill = kills_enemy_heroes * self:GetAbility():GetSpecialValueFor("agility_bonus_per_kill")

	return agility_bonus_per_kill
end

function modifier_alliance_champion_bonus:GetModifierBonusStats_Intellect()
	kills_enemy_heroes = self:GetParent():GetKills()
	intelligence_bonus_per_kill = kills_enemy_heroes * self:GetAbility():GetSpecialValueFor("intelligence_bonus_per_kill")

	return intelligence_bonus_per_kill
end

function modifier_alliance_champion_bonus:GetModifierAttackRangeBonus()
	kills_enemy_heroes = self:GetParent():GetKills()
	attak_range_bonus_per_kill = kills_enemy_heroes * self:GetAbility():GetSpecialValueFor("attak_range_bonus_per_kill")

	return attak_range_bonus_per_kill
end

function modifier_alliance_champion_bonus:GetModifierMoveSpeedBonus_Constant()
	kills_enemy_heroes = self:GetParent():GetKills()
	movespeed_bonus_per_kill = kills_enemy_heroes * self:GetAbility():GetSpecialValueFor("movespeed_bonus_per_kill")

	return movespeed_bonus_per_kill
end

function modifier_alliance_champion_bonus:GetModifierConstantManaRegen()
	kills_enemy_heroes = self:GetParent():GetKills()
	mana_regen_bonus_per_kill = kills_enemy_heroes * self:GetAbility():GetSpecialValueFor("mana_regen_bonus_per_kill")

	return mana_regen_bonus_per_kill
end