alliance_archmages_bonus = class({})

LinkLuaModifier( "modifier_alliance_archmages_bonus", "abilities/alliance_archmages_bonus", LUA_MODIFIER_MOTION_NONE )

function alliance_archmages_bonus:GetIntrinsicModifierName()
    return "modifier_alliance_archmages_bonus"
end

function alliance_archmages_bonus:OnUpgrade()
    local fromload = self:GetCaster():FindModifierByName( "modifier_alliance_archmages_bonus" ):GetStackCount()
    local modifier = self:GetCaster():FindModifierByName('modifier_alliance_archmages_bonus')
    if (modifier) then
        modifier:SetStackCount((fromload or modifier.attacks or 0))
    end
end

modifier_alliance_archmages_bonus = class({})

function modifier_alliance_archmages_bonus:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
    return funcs
end

function modifier_alliance_archmages_bonus:OnAttackLanded(data)
    if (data.attacker ~= self:GetParent()) then return end
    fromload = self:GetCaster():FindModifierByName( "modifier_alliance_archmages_bonus" ):GetStackCount()

    chance = self:GetAbility():GetSpecialValueFor( "chance" )
    ultra_chance = self:GetAbility():GetSpecialValueFor( "ultra_chance" )
    
    ultra_intelligence_bonus = self:GetAbility():GetSpecialValueFor( "ultra_intelligence_bonus" )

    local rand = math.random(100)
    local rand_ultra = math.random(100) 

    if rand<chance then
        self.attacks = (fromload or self.attacks or 0) + 1
    elseif rand_ultra<ultra_chance then
        self.attacks = (fromload or self.attacks or 0) + ultra_intelligence_bonus
    else
        self.attacks = (fromload or self.attacks or 0) + 0
    end
    self:SetStackCount(self.attacks)
end 

function modifier_alliance_archmages_bonus:GetModifierBonusStats_Intellect()
    _G.modifier_essence_stacs = self:GetStackCount() * self:GetAbility():GetSpecialValueFor('intelligence_bonus')
    return modifier_essence_stacs
end 
