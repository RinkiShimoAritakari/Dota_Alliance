LinkLuaModifier("modifier_alliance_gods_bonus", "abilities/alliance_gods_bonus", LUA_MODIFIER_MOTION_NONE)


if alliance_gods_bonus == nil then
    alliance_gods_bonus = class({})
end

function alliance_gods_bonus:GetIntrinsicModifierName()
    return "modifier_alliance_gods_bonus"
end

modifier_alliance_gods_bonus = class({})

function modifier_alliance_gods_bonus:IsHidden()
    return true
end

function modifier_alliance_gods_bonus:IsPurgable()
    return false
end

function modifier_alliance_gods_bonus:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_alliance_gods_bonus:GetModifierBonusStats_Strength()
    str_base = self:GetCaster():GetStrengthGain()
    print("str_base" + str_base)
    stats_bonus = self:GetAbility():GetSpecialValueFor("stats_bonus")
    return str_base + (stats_bonus/100)
end

function modifier_alliance_gods_bonus:GetModifierBonusStats_Agility()
    stats_bonus = self:GetAbility():GetSpecialValueFor("stats_bonus")
    return stats_bonus
end

function modifier_alliance_gods_bonus:GetModifierBonusStats_Intellect()
    stats_bonus = self:GetAbility():GetSpecialValueFor("stats_bonus")
    return stats_bonus
end

function modifier_alliance_gods_bonus:GetModifierBaseDamageOutgoing_Percentage()
    damage_bonus = self:GetAbility():GetSpecialValueFor("damage_bonus")
    return damage_bonus
end

function modifier_alliance_gods_bonus:GetModifierPhysicalArmorBonus()
    armor_bonus = self:GetAbility():GetSpecialValueFor("armor_bonus")
    return armor_bonus
end

function modifier_alliance_gods_bonus:GetModifierMoveSpeedBonus_Constant()
    movespeed_bonus = self:GetAbility():GetSpecialValueFor("movespeed_bonus")
    return movespeed_bonus
end

function modifier_alliance_gods_bonus:GetModifierAttackSpeedBonus_Constant()
    atack_speed_bonus = self:GetAbility():GetSpecialValueFor("atack_speed_bonus")
    return atack_speed_bonus
end

function modifier_alliance_gods_bonus:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_alliance_gods_bonus:OnIntervalThink()
    if IsServer() then
        local hero = self:GetParent()
        local maxHealth = hero:GetMaxHealth()
        local maxMana = hero:GetMaxMana()
        hero:Heal(maxHealth * 0.02, hero)
        hero:GiveMana(maxMana * 0.02)
    end
end
