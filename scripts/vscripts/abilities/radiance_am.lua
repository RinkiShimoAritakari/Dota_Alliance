LinkLuaModifier( "modifier_item_radiance_custom", "abilities/radiance_am", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_radiance_custom_aura", "abilities/radiance_am", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_radiance_custom_burn", "abilities/radiance_am", LUA_MODIFIER_MOTION_NONE )

radiance_am = class({})

function radiance_am:GetIntrinsicModifierName()
    return "modifier_item_radiance_custom" 
end

function radiance_am:OnSpellStart()
    if IsServer() then
        if self:GetCaster():HasModifier("modifier_item_radiance_custom_aura") then
            self:GetCaster():RemoveModifierByName("modifier_item_radiance_custom_aura")
        else
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_radiance_custom_aura", {})
        end
    end
end

function radiance_am:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_item_radiance_custom_aura") then
        return "radiance_am"
    else
        return "radiance_am_inactive"
    end
end

modifier_item_radiance_custom = class({})

function modifier_item_radiance_custom:IsHidden() return true end
function modifier_item_radiance_custom:IsPurgable() return false end
function modifier_item_radiance_custom:IsPurgeException() return false end

function modifier_item_radiance_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_radiance_custom:OnCreated(keys)
    if not IsServer() then return end
    if not self:GetParent():HasModifier("modifier_item_radiance_custom_aura") then
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_radiance_custom_aura", {})
    end
    Timers:CreateTimer(FrameTime(), function()
        if self:GetParent():IsIllusion() then
            local modifier_illusion = self:GetParent():FindModifierByName("modifier_illusion")
            if modifier_illusion then
                local caster = modifier_illusion:GetCaster()
                if not caster:HasModifier("modifier_item_radiance_custom_aura") then
                    self:GetParent():RemoveModifierByName("modifier_item_radiance_custom_aura")
                end
            end
        end
    end)
end

function modifier_item_radiance_custom:OnDestroy(keys)
    if not IsServer() then return end
    self:GetParent():RemoveModifierByName("modifier_item_radiance_custom_aura")
end

function modifier_item_radiance_custom:DeclareFunctions()
    return 
    { 
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT
    }
end

function modifier_item_radiance_custom:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_radiance_custom:GetModifierEvasion_Constant()
    return self:GetAbility():GetSpecialValueFor("evasion")
end

modifier_item_radiance_custom_aura = class({})

function modifier_item_radiance_custom_aura:IsAura() return true end
function modifier_item_radiance_custom_aura:IsHidden() return true end
function modifier_item_radiance_custom_aura:IsDebuff() return false end
function modifier_item_radiance_custom_aura:IsPurgable() return false end

function modifier_item_radiance_custom_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_item_radiance_custom_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_item_radiance_custom_aura:GetModifierAura()
    return "modifier_item_radiance_custom_burn"
end

function modifier_item_radiance_custom_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_item_radiance_custom_aura:GetAuraDuration()
    return 0
end

function modifier_item_radiance_custom_aura:OnCreated()
    if not IsServer() then return end
    local particle = ParticleManager:CreateParticle("particles/items2_fx/radiance_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle(particle, false, false, -1, false, false)
end

modifier_item_radiance_custom_burn = class({})

function modifier_item_radiance_custom_burn:IsDebuff() return true end
function modifier_item_radiance_custom_burn:IsPurgable() return false end
function modifier_item_radiance_custom_burn:GetTexture() return "radiance_am_inactive" end

function modifier_item_radiance_custom_burn:OnCreated()
    if not IsServer() then return end
    self.particle = ParticleManager:CreateParticle("particles/items2_fx/radiance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    if self.particle then
        ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())
        self:AddParticle(self.particle, false, false, -1, false, false)
    end
    EmitSoundOnEntityForPlayer("DOTA_Item.Radiance.Target.Loop", self:GetParent(), self:GetParent():GetPlayerOwnerID())
    self:StartIntervalThink(1)
end

function modifier_item_radiance_custom_burn:OnIntervalThink()
    if not IsServer() then return end
        local damage = self:GetAbility():GetSpecialValueFor("damage_no_radiance")
        local caster = self:GetCaster()

        -- Проверяем, есть ли Радианс
        if caster:HasItemInInventory("item_radiance") then
            damage = self:GetAbility():GetSpecialValueFor("damage")
        end
    ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
    if self.particle then
        ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())
    end
end

function modifier_item_radiance_custom_burn:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MISS_PERCENTAGE
    }
end

function modifier_item_radiance_custom_burn:GetModifierMiss_Percentage()
    return self:GetAbility():GetSpecialValueFor("blind_pct")
end