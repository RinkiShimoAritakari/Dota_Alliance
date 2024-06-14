LinkLuaModifier("modifier_Alliance_Hunter_bonus", "abilities/Alliance_Hunter_bonus", LUA_MODIFIER_MOTION_NONE)

Alliance_Hunter_bonus = class({CAddonTemplateGameMode})

function Alliance_Hunter_bonus:GetIntrinsicModifierName()
	return "modifier_Alliance_Hunter_bonus"
end

modifier_Alliance_Hunter_bonus = class({})

function modifier_Alliance_Hunter_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
	}
end

function modifier_Alliance_Hunter_bonus:GetModifierProcAttack_BonusDamage_Pure()
	return self:GetAbility():GetSpecialValueFor("bonus_damage_pure")
end

function modifier_Alliance_Hunter_bonus:GetModifierBaseAttackTimeConstant()
	return self:GetAbility():GetSpecialValueFor("bonus_base_attack_time")
end
