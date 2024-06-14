alliance_demon_hunter_bonus = class({})

LinkLuaModifier( "modifier_alliance_demon_hunter_bonus", "abilities/alliance_demon_hunter_bonus", LUA_MODIFIER_MOTION_NONE )

function alliance_demon_hunter_bonus:GetIntrinsicModifierName()
    return "modifier_alliance_demon_hunter_bonus"
end

function alliance_demon_hunter_bonus:OnUpgrade()
    local fromload = self:GetCaster():FindModifierByName( "modifier_alliance_demon_hunter_bonus" ):GetStackCount()
    local modifier = self:GetCaster():FindModifierByName('modifier_alliance_demon_hunter_bonus')
    if (modifier) then
        modifier:SetStackCount((fromload or modifier.attacks or 0))
    end
    
end

modifier_alliance_demon_hunter_bonus = class({})

function modifier_alliance_demon_hunter_bonus:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
    return funcs
end

function modifier_alliance_demon_hunter_bonus:OnAttackLanded(data)
    if (data.attacker ~= self:GetParent()) then return end
    fromload = self:GetCaster():FindModifierByName( "modifier_alliance_demon_hunter_bonus" ):GetStackCount()
    self.attacks = (fromload or self.attacks or 0) + 1
    self:SetStackCount(self.attacks)
    
end 

function modifier_alliance_demon_hunter_bonus:GetModifierPreAttack_BonusDamage()
    _G.modifier_essence_stacs = self:GetStackCount() * self:GetAbility():GetSpecialValueFor('soul_damage')
    return modifier_essence_stacs
end 
