LinkLuaModifier("modifier_alchemist_hand_of_midas", "abilities/alchemist_hand_of_midas", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alchemist_hand_of_midas_visual", "abilities/alchemist_hand_of_midas", LUA_MODIFIER_MOTION_NONE)

alchemist_hand_of_midas = class({})

function alchemist_hand_of_midas:IsRefreshable()
    return true
end

function alchemist_hand_of_midas:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level ) / ( self:GetCaster():GetCooldownReduction())
end

function alchemist_hand_of_midas:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function alchemist_hand_of_midas:OnSpellStart()
    if not IsServer() then return end
    local point = self:GetCursorPosition()
    local radius = self:GetSpecialValueFor("radius")
    self.units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    for _, unit in pairs(self.units) do
        unit:AddNewModifier(self:GetCaster(), nil, "modifier_alchemist_hand_of_midas_visual", {})
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_alchemist_hand_of_midas", {})
end

function alchemist_hand_of_midas:OnChannelFinish(bInterrupted)
    if not IsServer() then return end
    local modifier_alchemist_hand_of_midas = self:GetCaster():FindModifierByName("modifier_alchemist_hand_of_midas")
    if modifier_alchemist_hand_of_midas then
        modifier_alchemist_hand_of_midas:Destroy()
    end
    for _, unit in pairs(self.units) do
        if unit and not unit:IsNull() then
            unit:RemoveModifierByName("modifier_alchemist_hand_of_midas_visual")
        end
    end
    if bInterrupted then 
        self:EndCooldown()
        return 
    end
    if #self.units > 0 then
        self:GetCaster():EmitSound("alchemist_gold")
        for _, unit in pairs(self.units) do
            if unit and not unit:IsNull() and unit:IsAlive() and not unit:IsAncient() then
                self:Midas(unit)
            end
        end
    end
end

function alchemist_hand_of_midas:Midas(target)
	local bonus_gold = self:GetSpecialValueFor("gold")
	local xp_multiplier = self:GetSpecialValueFor("exp")
	local bonus_xp = target:GetDeathXP() * xp_multiplier
	--SendOverheadEventMessage(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), OVERHEAD_ALERT_GOLD, target, bonus_gold, nil)
	local midas_particle = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(midas_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), false)
    ParticleManager:ReleaseParticleIndex(midas_particle)
	target:SetDeathXP(0)
	target:SetMinimumGoldBounty(bonus_gold)
	target:SetMaximumGoldBounty(bonus_gold)
	target:Kill(self, self:GetCaster())
	self:GetCaster():AddExperience(bonus_xp, false, false)
end

modifier_alchemist_hand_of_midas = class({})
function modifier_alchemist_hand_of_midas:IsHidden() return true end
function modifier_alchemist_hand_of_midas:IsPurgable() return false end
function modifier_alchemist_hand_of_midas:IsPurgeException() return false end
function modifier_alchemist_hand_of_midas:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_alchemist_hand_of_midas:GetOverrideAnimation()
    return ACT_DOTA_TAUNT
end
function modifier_alchemist_hand_of_midas:GetActivityTranslationModifiers()
    return "ogre_hop_gesture"
end

modifier_alchemist_hand_of_midas_visual = class({})
function modifier_alchemist_hand_of_midas_visual:IsPurgable() return false end
function modifier_alchemist_hand_of_midas_visual:GetEffectName()
    return "particles/midas_effect/alchemist_overhead_coin.vpcf"
end
function modifier_alchemist_hand_of_midas_visual:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end