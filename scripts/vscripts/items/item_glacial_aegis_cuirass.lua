LinkLuaModifier("modifier_item_glacial_aegis_cuirass_add_modifier", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
-- Уменьшение брони
LinkLuaModifier("modifier_item_glacial_aegis_cuirass_aura", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_glacial_aegis_cuirass_effect_reduction", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
-- Увеличение брони
LinkLuaModifier("modifier_item_glacial_aegis_cuirass_increase_aura", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_glacial_aegis_cuirass_increase_aura_effect", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
-- Эффект шивы активный 
LinkLuaModifier("modifier_item_glacial_aegis_cuirass_blast", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
-- Статы предмета
LinkLuaModifier("modifier_item_glacial_aegis_cuirass_stats", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
-- Уменьшение регенирации 
LinkLuaModifier("modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura_effect", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
-- Уменьшения скорости атаки
LinkLuaModifier("modifier_item_glacial_aegis_cuirass_attack_speed_reduction_aura", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_glacial_aegis_cuirass_attack_speed_reduction_effect", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
-- Эффект дискорда
LinkLuaModifier("modifier_item_glacial_aegis_cuirass_veil_of_discord_aura", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_glacial_aegis_cuirass_veil_of_discord_debuff", "items/item_glacial_aegis_cuirass.lua", LUA_MODIFIER_MOTION_NONE)

item_glacial_aegis_cuirass = class({})

function item_glacial_aegis_cuirass:GetIntrinsicModifierName()
    return "modifier_item_glacial_aegis_cuirass_add_modifier"
end

modifier_item_glacial_aegis_cuirass_add_modifier = class({})

function modifier_item_glacial_aegis_cuirass_add_modifier:IsHidden()
    return true
end

function modifier_item_glacial_aegis_cuirass_add_modifier:OnCreated(kv)
    if IsServer() then
        local parent = self:GetParent()
        parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_glacial_aegis_cuirass_aura", {})
        parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_glacial_aegis_cuirass_increase_aura", {})
        parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_glacial_aegis_cuirass_stats", {})
        parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura", {})
        parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_glacial_aegis_cuirass_attack_speed_reduction_aura", {})
        parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_glacial_aegis_cuirass_veil_of_discord_aura", {})
    end
end

function modifier_item_glacial_aegis_cuirass_add_modifier:OnDestroy()
    if IsServer() then
        local parent = self:GetParent()
        parent:RemoveModifierByName("modifier_item_glacial_aegis_cuirass_aura")
        parent:RemoveModifierByName("modifier_item_glacial_aegis_cuirass_increase_aura")
        parent:RemoveModifierByName("modifier_item_glacial_aegis_cuirass_stats")
        parent:RemoveModifierByName("modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura")
        parent:RemoveModifierByName("modifier_item_glacial_aegis_cuirass_attack_speed_reduction_aura")
        parent:RemoveModifierByName("modifier_item_glacial_aegis_cuirass_veil_of_discord_aura")
    end
end


function item_glacial_aegis_cuirass:OnSpellStart()
    local caster = self:GetCaster()
    local blast_radius = self:GetSpecialValueFor("blast_radius")
    local blast_damage = self:GetSpecialValueFor("blast_damage")
    local blast_duration = self:GetSpecialValueFor("blast_duration")

    -- Эффекты и звук Arctic Blast здесь

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
    for _,enemy in pairs(enemies) do
        -- Нанесение урона
        local damage = {victim = enemy, attacker = caster, damage = blast_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self}
        ApplyDamage(damage)

        -- Применение замедления
        enemy:AddNewModifier(caster, self, "modifier_item_glacial_aegis_cuirass_blast", {duration = blast_duration})
    end
end

modifier_item_glacial_aegis_cuirass_aura = class({})

function modifier_item_glacial_aegis_cuirass_aura:IsHidden()
    return true
end

function modifier_item_glacial_aegis_cuirass_aura:IsAura()
    return true
end

function modifier_item_glacial_aegis_cuirass_aura:GetAuraRadius()
    local aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
    return aura_radius
end

function modifier_item_glacial_aegis_cuirass_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_glacial_aegis_cuirass_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_glacial_aegis_cuirass_aura:GetModifierAura()
    return "modifier_item_glacial_aegis_cuirass_effect_reduction"
end

-- Аура Уменьшания брони
modifier_item_glacial_aegis_cuirass_effect_reduction = class({})

function modifier_item_glacial_aegis_cuirass_effect_reduction:IsHidden()
    return true
end

function modifier_item_glacial_aegis_cuirass_effect_reduction:IsPurgable()
    return false
end

function modifier_item_glacial_aegis_cuirass_effect_reduction:DeclareFunctions()
    return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_item_glacial_aegis_cuirass_effect_reduction:GetModifierPhysicalArmorBonus()
    local aura_armor_reduction = self:GetAbility():GetSpecialValueFor("aura_armor_reduction")
    return aura_armor_reduction
end

-- Aura modifier for increasing ally armor
modifier_item_glacial_aegis_cuirass_increase_aura = class({})

function modifier_item_glacial_aegis_cuirass_increase_aura:IsHidden()
    return true
end

function modifier_item_glacial_aegis_cuirass_increase_aura:IsAura()
    return true
end

function modifier_item_glacial_aegis_cuirass_increase_aura:GetAuraRadius()
    local aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
    return aura_radius
end

function modifier_item_glacial_aegis_cuirass_increase_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_glacial_aegis_cuirass_increase_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_glacial_aegis_cuirass_increase_aura:GetModifierAura()
    return "modifier_item_glacial_aegis_cuirass_increase_aura_effect"
end

-- Effect modifier for increasing ally armor
modifier_item_glacial_aegis_cuirass_increase_aura_effect = class({})

function modifier_item_glacial_aegis_cuirass_increase_aura_effect:IsHidden()
    return true
end

function modifier_item_glacial_aegis_cuirass_increase_aura_effect:IsPurgable()
    return false
end

function modifier_item_glacial_aegis_cuirass_increase_aura_effect:DeclareFunctions()
    return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_item_glacial_aegis_cuirass_increase_aura_effect:GetModifierPhysicalArmorBonus()
	local aura_armor_bonus = self:GetAbility():GetSpecialValueFor("aura_armor_bonus")
    return aura_armor_bonus
end


-- =============================================================================================
modifier_item_glacial_aegis_cuirass_blast = class({})

function modifier_item_glacial_aegis_cuirass_blast:DeclareFunctions()
    return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_item_glacial_aegis_cuirass_blast:GetModifierMoveSpeedBonus_Percentage()
	local blast_slow = self:GetAbility():GetSpecialValueFor("blast_slow")
    return blast_slow
end

modifier_item_glacial_aegis_cuirass_stats = class({})

function modifier_item_glacial_aegis_cuirass_stats:IsHidden()
    return true -- Set to false if you want it to be visible
end

function modifier_item_glacial_aegis_cuirass_stats:IsPurgable()
    return false
end

function modifier_item_glacial_aegis_cuirass_stats:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
end

function modifier_item_glacial_aegis_cuirass_stats:GetModifierPhysicalArmorBonus()
    local bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    return bonus_armor
end

function modifier_item_glacial_aegis_cuirass_stats:GetModifierAttackSpeedBonus_Constant()
    local attack_speed_bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
    return attack_speed_bonus
end

function modifier_item_glacial_aegis_cuirass_stats:GetModifierBonusStats_Strength()
    local bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
    return bonus_stats
end

function modifier_item_glacial_aegis_cuirass_stats:GetModifierBonusStats_Agility()
    local bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
    return bonus_stats
end

function modifier_item_glacial_aegis_cuirass_stats:GetModifierBonusStats_Intellect()
    local bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
    return bonus_stats
end

-- Аура снижения восстановления здоровья
modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura = class({})

function modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura:IsHidden()
    return true
end

function modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura:IsAura()
    return true
end

function modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura:GetAuraRadius()
	local aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
    return aura_radius
end

function modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura:GetModifierAura()
    return "modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura_effect"
end

-- Эффект ауры снижения восстановления здоровья
modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura_effect = class({})

function modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura_effect:IsHidden()
    return true
end

function modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura_effect:IsPurgable()
    return false
end

function modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura_effect:DeclareFunctions()
    return {MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET}
end

function modifier_item_glacial_aegis_cuirass_health_regen_reduction_aura_effect:GetModifierHealAmplify_PercentageTarget()
	local regen_reduction = self:GetAbility():GetSpecialValueFor("regen_reduction")
    return regen_reduction
end

-- Аура уменьшения скорости атаки
modifier_item_glacial_aegis_cuirass_attack_speed_reduction_aura = class({})

function modifier_item_glacial_aegis_cuirass_attack_speed_reduction_aura:IsHidden()
    return true
end

function modifier_item_glacial_aegis_cuirass_attack_speed_reduction_aura:IsAura()
    return true
end

function modifier_item_glacial_aegis_cuirass_attack_speed_reduction_aura:GetAuraRadius()
	local aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
    return aura_radius
end

function modifier_item_glacial_aegis_cuirass_attack_speed_reduction_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_glacial_aegis_cuirass_attack_speed_reduction_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_glacial_aegis_cuirass_attack_speed_reduction_aura:GetModifierAura()
    return "modifier_item_glacial_aegis_cuirass_attack_speed_reduction_effect"
end

-- Эффект ауры уменьшения скорости атаки
modifier_item_glacial_aegis_cuirass_attack_speed_reduction_effect = class({})

function modifier_item_glacial_aegis_cuirass_attack_speed_reduction_effect:IsHidden()
    return true
end

function modifier_item_glacial_aegis_cuirass_attack_speed_reduction_effect:IsPurgable()
    return false
end

function modifier_item_glacial_aegis_cuirass_attack_speed_reduction_effect:DeclareFunctions()
    return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_item_glacial_aegis_cuirass_attack_speed_reduction_effect:GetModifierAttackSpeedBonus_Constant()
	local attack_speed_reduction = self:GetAbility():GetSpecialValueFor("attack_speed_reduction")
    return attack_speed_reduction
end

-- Аура дискорда
modifier_item_glacial_aegis_cuirass_veil_of_discord_aura = class({})

function modifier_item_glacial_aegis_cuirass_veil_of_discord_aura:IsHidden()
    return true
end

function modifier_item_glacial_aegis_cuirass_veil_of_discord_aura:IsAura()
    return true
end

function modifier_item_glacial_aegis_cuirass_veil_of_discord_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_item_glacial_aegis_cuirass_veil_of_discord_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_glacial_aegis_cuirass_veil_of_discord_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_glacial_aegis_cuirass_veil_of_discord_aura:GetModifierAura()
    return "modifier_item_glacial_aegis_cuirass_veil_of_discord_debuff"
end

-- Дебафф, применяемый дискордом
modifier_item_glacial_aegis_cuirass_veil_of_discord_debuff = class({})

function modifier_item_glacial_aegis_cuirass_veil_of_discord_debuff:IsHidden()
    return true
end

function modifier_item_glacial_aegis_cuirass_veil_of_discord_debuff:IsPurgable()
    return true
end

function modifier_item_glacial_aegis_cuirass_veil_of_discord_debuff:DeclareFunctions()
    return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

function modifier_item_glacial_aegis_cuirass_veil_of_discord_debuff:GetModifierMagicalResistanceBonus()
    return self:GetAbility():GetSpecialValueFor("magic_resistance_reduction")
end