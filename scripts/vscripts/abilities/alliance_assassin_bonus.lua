LinkLuaModifier("modifier_alliance_assassin_bonus", "abilities/alliance_assassin_bonus", LUA_MODIFIER_MOTION_NONE)

alliance_assassin_bonus = class({CAddonTemplateGameMode})


function alliance_assassin_bonus:GetIntrinsicModifierName()
    return "modifier_alliance_assassin_bonus"
end

modifier_alliance_assassin_bonus = class({})

function modifier_alliance_assassin_bonus:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }
end

function modifier_alliance_assassin_bonus:GetModifierPreAttack_CriticalStrike( params )
    local agi = self:GetParent():GetAgility()
    local crit_chance = self:GetAbility():GetSpecialValueFor('crit_chance')
    local crit_mult = self:GetAbility():GetSpecialValueFor('crit_mult')
    local crit_damage = self:GetAbility():GetSpecialValueFor('crit_damage')
    local rand = math.random(100)

    if rand<crit_chance then
        local critDmg = crit_damage + (crit_mult * agi)
        return critDmg
    end
    print(rand)
    print(critDmg)
end
