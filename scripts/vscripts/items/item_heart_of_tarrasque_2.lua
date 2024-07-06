if item_heart_of_tarrasque_2 == nil then
	item_heart_of_tarrasque_2 = class({})
end

function item_heart_of_tarrasque_2:GetIntrinsicModifierName()
	return "modifier_item_heart_of_tarrasque_2"
end

LinkLuaModifier("modifier_item_heart_of_tarrasque_2", "items/item_heart_of_tarrasque_2.lua", LUA_MODIFIER_MOTION_NONE)

modifier_item_heart_of_tarrasque_2 = class({})

function modifier_item_heart_of_tarrasque_2:IsHidden()
	return true
end

function modifier_item_heart_of_tarrasque_2:IsPurgable()
	return false
end

function modifier_item_heart_of_tarrasque_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return funcs
end

function modifier_item_heart_of_tarrasque_2:GetModifierHealthBonus()
	local bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	return bonus_health 
end

function modifier_item_heart_of_tarrasque_2:GetModifierHealthRegenPercentage()
	local health_regen_pct = self:GetAbility():GetSpecialValueFor("health_regen_pct")
	return health_regen_pct 
end

function modifier_item_heart_of_tarrasque_2:GetModifierBonusStats_Strength()
	local bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	return bonus_str 
end
