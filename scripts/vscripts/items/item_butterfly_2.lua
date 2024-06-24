if item_butterfly_2 == nil then
    item_butterfly_2 = class({})
end

function item_butterfly_2:GetIntrinsicModifierName()
    return "modifier_item_butterfly_2"
end

LinkLuaModifier("modifier_item_butterfly_2", "items/item_butterfly_2.lua", LUA_MODIFIER_MOTION_NONE)

modifier_item_butterfly_2 = class({})

function modifier_item_butterfly_2:IsHidden()
    return true
end

function modifier_item_butterfly_2:IsPurgable()
    return false
end

function modifier_item_butterfly_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }
    return funcs
end

function modifier_item_butterfly_2:GetModifierAttackSpeedBonus_Constant()
    local bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    return bonus_attack_speed
end

function modifier_item_butterfly_2:GetModifierEvasion_Constant()
    local bonus_evasion = self:GetAbility():GetSpecialValueFor("bonus_evasion")
    return bonus_evasion
end

function modifier_item_butterfly_2:GetModifierBonusStats_Agility()
    local bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
    return bonus_agi
end

function modifier_item_butterfly_2:GetModifierBaseAttack_BonusDamage()
    local bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    return bonus_damage
end
