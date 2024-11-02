LinkLuaModifier("modifier_damage_bonus", "abilities/alliance_circus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_health_bonus", "abilities/alliance_circus.lua", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------------------------------------------------------
-- Модификатор для увеличения урона
modifier_damage_bonus = class({})

function modifier_damage_bonus:OnCreated(params)
    self.damage_bonus = params.damage_bonus
    -- print("damage_bonus_OnCreated ", self.damage_bonus)
end

function modifier_damage_bonus:IsDebuff() return false end
function modifier_damage_bonus:IsHidden() return false end
function modifier_damage_bonus:IsPurgable() return true end

function modifier_damage_bonus:DeclareFunctions()
    return {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}
end

function modifier_damage_bonus:GetModifierBaseAttack_BonusDamage()
    -- print("damage_bonus ", self.damage_bonus)
    return self.damage_bonus or 0
end
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- Модификатор для увеличения здоровья 
modifier_health_bonus = class({})

function modifier_health_bonus:OnCreated(params)
    self.health_bonus = params.health_bonus
end

function modifier_health_bonus:IsDebuff() return false end
function modifier_health_bonus:IsHidden() return false end
function modifier_health_bonus:IsPurgable() return true end

function modifier_health_bonus:DeclareFunctions()
    return {MODIFIER_PROPERTY_HEALTH_BONUS}
end

function modifier_health_bonus:GetModifierHealthBonus()
    -- print("health_bonus ", self.health_bonus)
    return self.health_bonus or 0
end
------------------------------------------------------------------------------------------------------------

-- Создание класса способности
alliance_circus = class({})

function alliance_circus:OnSpellStart()
    local caster = self:GetCaster()

    -- Значения
    local min_damage_bonus = self:GetSpecialValueFor("min_damage_bonus")
    local max_damage_bonus = self:GetSpecialValueFor("max_damage_bonus")

    local min_health_bonus = self:GetSpecialValueFor("min_health_bonus")
    local max_health_bonus = self:GetSpecialValueFor("max_health_bonus")    

    local min_gold_bonus = self:GetSpecialValueFor("min_gold_bonus")
    local max_gold_bonus = self:GetSpecialValueFor("max_gold_bonus")


    -- Генерация случайного числа от 1 до 5 для выбора бонуса
    local random_choice = RandomInt(1, 5)
    -- print("random_choice: ", random_choice)

    if random_choice == 1 then
        if caster:HasModifier("modifier_damage_bonus") then
            caster:RemoveModifierByName("modifier_damage_bonus")
        end  
        -- Увеличение урона
        local damage_bonus = RandomInt(min_damage_bonus, max_damage_bonus)
        -- print("damage_bonus_first ", damage_bonus)
        caster:AddNewModifier(caster, self, "modifier_damage_bonus", {duration = 20, damage_bonus = damage_bonus})

    elseif random_choice == 2 then
        if caster:HasModifier("modifier_health_bonus") then
            caster:RemoveModifierByName("modifier_health_bonus")
        end  
        -- Увеличение здоровья
        local health_bonus = RandomInt(min_health_bonus, max_health_bonus)
        caster:AddNewModifier(caster, self, "modifier_health_bonus", {duration = 20, health_bonus = health_bonus})

    elseif random_choice == 3 then
        -- Бонус к золоту
        local gold_bonus = RandomInt(min_gold_bonus, max_gold_bonus)
        -- print("gold_bonus ", gold_bonus)
        local current_gold = PlayerResource:GetGold(caster:GetPlayerID())
        PlayerResource:SetGold(caster:GetPlayerID(), current_gold + gold_bonus, false)

    elseif random_choice == 4 then
        -- Случайный предмет
        if RollPercentage(50) then
            local item_name = "item_blink"
            caster:AddItem(CreateItem(item_name, caster, caster))
        else
            -- Удаление случайного предмета
            for i = 0, 5 do
                local item = caster:GetItemInSlot(i)
                if item then
                    caster:RemoveItem(item)
                    break
                end
            end
        end

    elseif random_choice == 5 then
        -- Убийство героя 
        if caster:IsAlive() then
            caster:Kill(self, caster)
        end
    end
end