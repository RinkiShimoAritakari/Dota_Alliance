LinkLuaModifier("modifier_mana_empowerment", "abilities/mana_empowerment", LUA_MODIFIER_MOTION_NONE)

modifier_mana_empowerment = class({})

function modifier_mana_empowerment:IsDebuff() return false end
function modifier_mana_empowerment:IsHidden() return false end
function modifier_mana_empowerment:IsPurgable() return false end

function modifier_mana_empowerment:OnCreated(params)
    self.damage_bonus = params.damage_bonus
end

function modifier_mana_empowerment:DeclareFunctions()
    return {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}
end

function modifier_mana_empowerment:GetModifierBaseAttack_BonusDamage()
    print("Current damage bonus: ", self.damage_bonus)
    return self.damage_bonus
end

mana_empowerment = class({})

function mana_empowerment:OnSpellStart()
    local caster = self:GetCaster()
    local current_mana = caster:GetMana()
    local duration = self:GetSpecialValueFor("duration")
    local damage_multiplier = self:GetSpecialValueFor("damage_multiplier")

    -- Проверяем, есть ли мана
    if current_mana > 0 then
        -- Тратим всю ману
        caster:SpendMana(current_mana, self)

        -- Вычисляем бонус к физическому урону
        local damage_bonus = current_mana * damage_multiplier
        print("damage_bonus: ", damage_bonus)

        -- Добавляем модификатор с бонусом к урону
        caster:AddNewModifier(caster, self, "modifier_mana_empowerment", {duration = duration, damage_bonus = damage_bonus})
    end
end

