LinkLuaModifier("modifier_alliance_mechanic_bonus", "abilities/alliance_mechanic_bonus", LUA_MODIFIER_MOTION_NONE)

alliance_mechanic_bonus = class({CAddonTemplateGameMode})

function alliance_mechanic_bonus:GetIntrinsicModifierName()
    
    return "modifier_alliance_mechanic_bonus"
end

modifier_alliance_mechanic_bonus = class({})

function modifier_alliance_mechanic_bonus:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_alliance_mechanic_bonus:GetModifierExtraHealthBonus()
    local max_mana = self:GetParent():GetMaxMana()
    print(max_mana)
    local health_bonus = self:GetAbility():GetSpecialValueFor("health_bonus")
    local extra_heal_bonus = max_mana * health_bonus
    print(extra_heal_bonus)
    print("---------------------------")
    return extra_heal_bonus  
end

function modifier_alliance_mechanic_bonus:OnDeath(keys)
    if IsServer() then
        local hero = self:GetParent()
        
        -- Проверяем, что именно носитель способности умер
        if keys.unit ~= hero then return end
        -- Вычисляем максимальное значение здоровья
        local max_health = self:GetParent():GetMaxHealth()

        local radius = self:GetAbility():GetSpecialValueFor("radius")
        
        -- Наносим чистый урон равный максимальному значению здоровья всем юнитам в радиусе {radius} от носителя
        local units_in_range = FindUnitsInRadius(
            hero:GetTeamNumber(),                -- 1. Team number
            hero:GetAbsOrigin(),                 -- 2. Center position
            nil,                                  -- 3. Filter (optional)
            radius,                               -- 4. Radius
            DOTA_UNIT_TARGET_TEAM_ENEMY,         -- 5. Target team
            DOTA_UNIT_TARGET_ALL,                -- 6. Target type
            DOTA_UNIT_TARGET_FLAG_NONE,          -- 7. Target flags
            FIND_UNITS_EVERYWHERE,               -- 8. Order
            true                                  -- 9. Include inactive units
        )

        for i, unit in pairs(units_in_range) do
            if unit:GetTeamNumber() ~= hero:GetTeamNumber() then
                local damageTable = {
                    victim = unit,
                    attacker = hero,
                    damage = max_health,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = nil,
                }
                ApplyDamage(damageTable)
            end
        end
    end
end
        
