LinkLuaModifier("modifier_Drow_Ranger_Windranger_bonus", "abilities/Drow_Ranger_Windranger_bonus", LUA_MODIFIER_MOTION_NONE)

Drow_Ranger_Windranger_bonus = class({CAddonTemplateGameMode})

function Drow_Ranger_Windranger_bonus:GetIntrinsicModifierName()
	return "modifier_Drow_Ranger_Windranger_bonus"
end

modifier_Drow_Ranger_Windranger_bonus = class({})

function modifier_Drow_Ranger_Windranger_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		--MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end

function modifier_Drow_Ranger_Windranger_bonus:GetModifierBaseAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

-- function modifier_Drow_Ranger_Windranger_bonus:GetModifierBaseAttackTimeConstant()
-- 	return self:GetAbility():GetSpecialValueFor("bonus_base_attack_time")
-- end

function modifier_Drow_Ranger_Windranger_bonus:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_magical_resistance")
end

function modifier_Drow_Ranger_Windranger_bonus:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_evasion")
end