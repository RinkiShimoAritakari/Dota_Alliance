LinkLuaModifier("modifier_item_octarine_core_2", "items/item_octarine_core_2.lua", LUA_MODIFIER_MOTION_NONE)

item_octarine_core_2 = class({})

function item_octarine_core_2:GetIntrinsicModifierName()
	return "modifier_item_octarine_core_2"
end

modifier_item_octarine_core_2 = class({})

function modifier_item_octarine_core_2:IsHidden()
	return true
end

function modifier_item_octarine_core_2:IsPurgable()
	return false
end

function modifier_item_octarine_core_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
end

function modifier_item_octarine_core_2:GetModifierPercentageCooldown()
	local cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
	return cooldown_reduction
end

function modifier_item_octarine_core_2:GetModifierHealthBonus()
	local bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	return bonus_health
end

function modifier_item_octarine_core_2:GetModifierManaBonus()
	local bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	return bonus_mana
end

function modifier_item_octarine_core_2:GetModifierConstantManaRegen()
	local bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	return bonus_mana_regen
end

function modifier_item_octarine_core_2:GetModifierConstantHealthRegen()
	local bonus_hp_regen = self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
	return bonus_hp_regen
end

function modifier_item_octarine_core_2:GetModifierBonusStats_Strength()
    local bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
    return bonus_stats
end

function modifier_item_octarine_core_2:GetModifierBonusStats_Agility()
    local bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
    return bonus_stats
end

function modifier_item_octarine_core_2:GetModifierBonusStats_Intellect()
    local bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
    return bonus_stats
end
