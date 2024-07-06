if alliance_warlock_bonus == nil then
    alliance_warlock_bonus = class({})
end

LinkLuaModifier("modifier_alliance_warlock_bonus", "abilities/alliance_warlock_bonus.lua", LUA_MODIFIER_MOTION_NONE)

function alliance_warlock_bonus:GetIntrinsicModifierName()
    return "modifier_alliance_warlock_bonus"
end

modifier_alliance_warlock_bonus = class({})

function modifier_alliance_warlock_bonus:IsHidden()
    return true
end

function modifier_alliance_warlock_bonus:IsPurgable()
    return false
end

function modifier_alliance_warlock_bonus:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_VAMP_PERCENTAGE,
        MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
    }
    return funcs
end

function modifier_alliance_warlock_bonus:GetModifierSpellVampPercentage()
    local magic_vampirism_heal = self:GetAbility():GetSpecialValueFor("magic_vampirism_heal")
    return magic_vampirism_heal
end

function modifier_alliance_warlock_bonus:GetModifierTotal_ConstantBlock()
    local vampirism_heal = self:GetAbility():GetSpecialValueFor("vampirism_heal")
    return vampirism_heal
end