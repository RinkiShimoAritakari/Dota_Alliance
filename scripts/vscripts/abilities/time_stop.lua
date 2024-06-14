tw_wamp = class({})
LinkLuaModifier("modifier_tw_wamp", "heroes/anime_hero_tw", LUA_MODIFIER_MOTION_NONE)


function tw_wamp:GetIntrinsicModifierName()
    return "modifier_tw_wamp"
end
---------------------------------------------------------------------------------------------------------------------
modifier_tw_wamp = class({})
function modifier_tw_wamp:IsDebuff() return false end
function modifier_tw_wamp:IsPurgeException() return false end
function modifier_tw_wamp:RemoveOnDeath() return false end
function modifier_tw_wamp:DeclareFunctions()
    local func = {  MODIFIER_EVENT_ON_ATTACK_LANDED,}
    return func
end
function modifier_tw_wamp:OnAttackLanded(keys)
    if not IsServer() then
        return nil
    end
    if keys.attacker ~= self:GetParent() then
        return nil
    end
    if keys.target == self:GetParent() then
        return nil
    end
    if self:GetParent():PassivesDisabled() then
        return nil
    end
    if self:GetParent():IsIllusion() then
        return nil
    end
    if keys.target:IsBoss() then
        return nil
    end
    if keys.target:IsBuilding() then
        return nil
    end

    self:GetAbility().anime_special_lifesteal = true

    self:GetAbility().anime_overhead_effect_damage = OVERHEAD_ALERT_DAMAGE

    self:GetAbility().anime_overhead_effect_heal = OVERHEAD_ALERT_HEAL

    local damage_table = {  victim = keys.target,
                            damage = keys.target:GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("lifesteal") + self:GetParent():FindTalentValue("special_bonus_anime_tw_20L")) * 0.01,
                            damage_type = self:GetAbility():GetAbilityDamageType(),
                            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                            attacker = self:GetParent(),
                            ability = self:GetAbility() }

    ApplyDamage(damage_table)
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
tw_wry = class({})
LinkLuaModifier("modifier_tw_wry_debuff", "heroes/anime_hero_tw", LUA_MODIFIER_MOTION_NONE)


function tw_wry:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function tw_wry:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function tw_wry:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration") + caster:FindTalentValue("special_bonus_anime_tw_10R")

    EmitSoundOn("TW.Cast.Wry", caster)

    local wry_particle = ParticleManager:CreateParticle("particles/heroes/anime_hero_tw/tw_wry_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    --ParticleManager:ReleaseParticleIndex(wry_particle)

    local enemies = FindUnitsInRadius(  caster:GetTeamNumber(),
                                        caster:GetAbsOrigin(),
                                        nil,
                                        self:GetAOERadius(),
                                        self:GetAbilityTargetTeam(),
                                        self:GetAbilityTargetType(),
                                        self:GetAbilityTargetFlags(),
                                        FIND_ANY_ORDER,
                                        false)
    for _,enemy in pairs(enemies) do
        local vector = (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
        local point = caster:GetAbsOrigin() + vector * (self:GetAOERadius() + 50)
        local table_knockback = {   should_stun = 0,
                                    knockback_duration = 0.2,
                                    duration = 0.2,
                                    knockback_distance = CalcDistanceBetweenEntityOBB(caster, enemy),
                                    knockback_height = 125,
                                    center_x = point.x,
                                    center_y = point.y,
                                    center_z = point.z }

        enemy:AddNewModifier(caster, self, "modifier_tw_wry_debuff", {duration = duration}, enemy:IsOpposingTeam(caster:GetTeamNumber()))
        enemy:AddNewModifier(caster, self, "modifier_knockback", table_knockback, enemy:IsOpposingTeam(caster:GetTeamNumber()))
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_tw_wry_debuff = class({})
function modifier_tw_wry_debuff:IsDebuff() return true end
function modifier_tw_wry_debuff:IsPurgeException() return true end
function modifier_tw_wry_debuff:RemoveOnDeath() return true end
function modifier_tw_wry_debuff:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
                    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,}
    return func
end
function modifier_tw_wry_debuff:GetModifierTotalDamageOutgoing_Percentage()
    return self:GetAbility():GetSpecialValueFor("reduce") + self:GetCaster():FindTalentValue("special_bonus_anime_tw_15L")
end
function modifier_tw_wry_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("slow") + self:GetCaster():FindTalentValue("special_bonus_anime_tw_10L")
end
function modifier_tw_wry_debuff:GetEffectName()
    return "particles/heroes/anime_hero_tw/tw_wry_debuff.vpcf"
end
function modifier_tw_wry_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
tw_time = tw_time or class({})

function tw_time:GetIntrinsicModifierName()
    return "modifier_tw_time_radius"
end
function tw_time:GetBehavior()
    local hCaster = self:GetCaster()
    local iBehavior = self.BaseClass.GetBehavior(self)
    if hCaster:HasModifier("modifier_tw_time_debuff")
        or hCaster:HasModifier("modifier_sakuya_time_debuff")
        or hCaster:HasModifier("modifier_sp_time_debuff") then
        iBehavior = bit.bor(iBehavior, DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE)
    end
    return iBehavior
end
function tw_time:GetAOERadius()
    local hCaster = self:GetCaster()
    return self:GetSpecialValueFor("start_radius") + hCaster:GetModifierStackCount("modifier_tw_time_radius", hCaster)
end
function tw_time:OnAbilityPhaseStart()
    EmitSoundOn("TW.Cast.Ult", self:GetCaster())
    return true
end
function tw_time:OnAbilityPhaseInterrupted()
    StopSoundOn("TW.Cast.Ult", self:GetCaster())
end
function tw_time:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = self:GetSpecialValueFor("duration") + hCaster:FindTalentValue("special_bonus_anime_tw_25R")

    if hCaster:HasTalent("special_bonus_anime_tw_25L") then
        hCaster:AddNewModifier(hCaster, self, "modifier_tw_time", {duration = fDuration})
    else
        CreateModifierThinker(hCaster, self, "modifier_tw_time", {duration = fDuration}, hCaster:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
    end

    local iIncreaseRadius = hCaster:GetModifierStackCount("modifier_tw_time_radius", hCaster)
    hCaster:SetModifierStackCount("modifier_tw_time_radius", hCaster, iIncreaseRadius + self:GetSpecialValueFor("increase_radius"))
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_tw_time_radius", "heroes/anime_hero_tw", LUA_MODIFIER_MOTION_NONE)

modifier_tw_time_radius = modifier_tw_time_radius or class({})

function modifier_tw_time_radius:IsDebuff()                             return false end
function modifier_tw_time_radius:IsPurgeException()                     return false end
function modifier_tw_time_radius:RemoveOnDeath()                        return false end
function modifier_tw_time_radius:GetTexture()
    return "anime_hero_tw/tw_time"
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_tw_time", "heroes/anime_hero_tw", LUA_MODIFIER_MOTION_NONE)

modifier_tw_time = modifier_tw_time or class({})

function modifier_tw_time:IsDebuff()                                                    return false end
function modifier_tw_time:IsPurgeException()                                            return true end
function modifier_tw_time:RemoveOnDeath()                                               return true end
function modifier_tw_time:GetPriority()                                                 return MODIFIER_PRIORITY_HIGH end
function modifier_tw_time:IsAura()                                                      return true end
function modifier_tw_time:IsAuraActiveOnDeath()                                         return false end
function modifier_tw_time:IsPermanent()                                                 return false end
function modifier_tw_time:CheckState()
    local hState =  {
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
                    }
    return hState
end
function modifier_tw_time:GetAuraEntityReject(hEntity)
    if IsServer() then
        if hEntity:GetOwner() == self.hCaster:GetOwner() then
            hEntity:AddNewModifier(hEntity, self.hAbility, "modifier_tw_time_buff", {duration = 0.1})
            return true
        end
        if hEntity:HasModifier("modifier_tw_time_buff")
            or hEntity:HasModifier("modifier_sakuya_time_buff")
            or hEntity:HasModifier("modifier_sp_time_buff") then
            return true
        end
    end
end
function modifier_tw_time:GetAuraDuration()
    return 0.1
end
function modifier_tw_time:GetAuraRadius()
    return self.fCurrentRadius
end
function modifier_tw_time:GetAuraSearchTeam()
    return self.iABILITY_TARGET_TEAM
end
function modifier_tw_time:GetAuraSearchType()
    return self.iABILITY_TARGET_TYPE
end
function modifier_tw_time:GetAuraSearchFlags()
    return self.iABILITY_TARGET_FLAGS
end
function modifier_tw_time:GetModifierAura()
    return "modifier_tw_time_debuff"
end
function modifier_tw_time:OnCreated(hTable)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()

    self.fMaxRadius     = self.hAbility:GetAOERadius()
    self.fStartRadius   = self.hAbility:GetSpecialValueFor("start_radius")
    self.fCurrentRadius = self.fStartRadius

    if IsServer() then
        self.iCASTER_TEAM          = self.hCaster:GetTeamNumber()
        self.iABILITY_TARGET_TEAM  = self.hAbility:GetAbilityTargetTeam() 
        self.iABILITY_TARGET_TYPE  = self.hAbility:GetAbilityTargetType() 
        self.iABILITY_TARGET_FLAGS = self.hAbility:GetAbilityTargetFlags()

        self.fIncreaseRadius = ( self.fMaxRadius - self.fStartRadius ) / ( self:GetDuration() * 0.5 )

        if not self.iStopTimePFX then
            self.iStopTimePFX = ParticleManager:CreateParticle("particles/heroes/anime_hero_tw/tw_time.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hParent)
                                --ParticleManager:SetParticleShouldCheckFoW(self.iStopTimePFX, false)
                                ParticleManager:SetParticleControl(self.iStopTimePFX, 0, self.hParent:GetAbsOrigin())
                                ParticleManager:SetParticleControl(self.iStopTimePFX, 1, Vector(self.fStartRadius, self.fStartRadius, self.fStartRadius))

            self:AddParticle(self.iStopTimePFX, false, false, -1, false, false)
        end

        EmitSoundOnLocationWithCaster(self.hParent:GetAbsOrigin(), "TW.Sound.Ult", self.hCaster)

        self:OnIntervalThink()
        self:StartIntervalThink(0.1)
    end
end
function modifier_tw_time:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_tw_time:OnIntervalThink()
    if IsServer() then
        local vParentLoc = self.hParent:GetAbsOrigin()
        local iAddRadius = ( self.fIncreaseRadius * self:GetElapsedTime() )
        self.fCurrentRadius = self:GetElapsedTime() > ( self:GetDuration() * 0.5 )
                              and self.fCurrentRadius - ( self.fIncreaseRadius * 0.1 )
                              or self.fStartRadius + iAddRadius

        AddFOWViewer(self.iCASTER_TEAM, vParentLoc, self.fCurrentRadius, 0.1, false)

        ParticleManager:SetParticleControl(self.iStopTimePFX, 0, self.hParent:GetAbsOrigin())
        ParticleManager:SetParticleControl(self.iStopTimePFX, 1, Vector(self.fCurrentRadius, self.fCurrentRadius, self.fCurrentRadius))
    end
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_tw_time_debuff", "heroes/anime_hero_tw", LUA_MODIFIER_MOTION_NONE)

modifier_tw_time_debuff = modifier_tw_time_debuff or class({})

function modifier_tw_time_debuff:IsDebuff()                                                     return self.bIsOpposite end
function modifier_tw_time_debuff:IsPurgeException()                                             return false end
function modifier_tw_time_debuff:RemoveOnDeath()                                                return true end
function modifier_tw_time_debuff:GetPriority()                                                  return MODIFIER_PRIORITY_ULTRA end
function modifier_tw_time_debuff:GetAttributes()                                                return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_tw_time_debuff:CheckState()
    local hState =  {
                        [MODIFIER_STATE_ROOTED]   = true,
                        [MODIFIER_STATE_FROZEN]   = true,
                        [MODIFIER_STATE_DISARMED] = true,
                    }
    if self.bIsOpposite then
        hState[MODIFIER_STATE_INVISIBLE] = false
    end
    return hState
end
function modifier_tw_time_debuff:DeclareFunctions()
    local hFunc =   {
                        MODIFIER_PROPERTY_DISABLE_TURNING
                    }
    return hFunc
end
function modifier_tw_time_debuff:GetModifierTotalDamageDeposit(keys)
    if IsServer() then
        local hDamageTable =    {
                                    victim       = keys.target,
                                    attacker     = keys.attacker, 
                                    damage       = keys.damage,
                                    damage_type  = keys.damage_type,
                                    ability      = keys.inflictor or self.hAbility,
                                    damage_flags = keys.damage_flags
                                }

        table.insert(self.hDelayDamage, hDamageTable)

        local vColor = Vector(255, 0, 0)
        local iTotalDamageDeposit_Absorb_PFX =  ParticleManager:CreateParticle("particles/generic_gameplay/total_damage_deposit/deposit_damage_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hParent)
                                                ParticleManager:SetParticleControl(iTotalDamageDeposit_Absorb_PFX, 60, vColor)
                                                ParticleManager:SetParticleControl(iTotalDamageDeposit_Absorb_PFX, 61, vColor)
                                                ParticleManager:SetParticleControl(iTotalDamageDeposit_Absorb_PFX, 62, vColor)
                                                ParticleManager:ReleaseParticleIndex(iTotalDamageDeposit_Absorb_PFX)

        return 1
    end
end
function modifier_tw_time_debuff:GetModifierDisableTurning(keys)
    --if not self.hParent:IsDebuffImmune() then
        return 1
    --end
end
function modifier_tw_time_debuff:OnCreated(hTable)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()

    self.bIsOpposite = self.hParent:GetTeamNumber() ~= self.hCaster:GetTeamNumber()

    if IsServer() then
        self.hDelayDamage = self.hDelayDamage or {}

        self:SetFrozenCooldowns(self.hParent, true)

        if not self.iTotalDamageDeposit_Indicator_PFX then
            local vColor = Vector(255, 0, 0)
            self.iTotalDamageDeposit_Indicator_PFX =    ParticleManager:CreateParticle("particles/generic_gameplay/total_damage_deposit/deposit_damage_indicator.vpcf", PATTACH_OVERHEAD_FOLLOW, self.hParent)
                                                        ParticleManager:SetParticleControl(self.iTotalDamageDeposit_Indicator_PFX, 1, Vector(1, 0, 0))
                                                        ParticleManager:SetParticleControl(self.iTotalDamageDeposit_Indicator_PFX, 2, Vector(50, 0, 0))
                                                        ParticleManager:SetParticleControl(self.iTotalDamageDeposit_Indicator_PFX, 60, vColor)
                                                        ParticleManager:SetParticleControl(self.iTotalDamageDeposit_Indicator_PFX, 61, vColor)
                                                        ParticleManager:SetParticleControl(self.iTotalDamageDeposit_Indicator_PFX, 62, vColor)

            self:AddParticle(self.iTotalDamageDeposit_Indicator_PFX, false, false, -1, false, true)
        end

        self:StartIntervalThink(0.1)
    end
end
function modifier_tw_time_debuff:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_tw_time_debuff:OnIntervalThink()
    if IsServer() then
        if self.iTotalDamageDeposit_Indicator_PFX then
            local fDamageDone = 0
            for iKey, hValue in pairs(self.hDelayDamage) do
                fDamageDone = fDamageDone + hValue.damage
            end

            local iParticleCount = math.floor( ( 500 / self.hParent:GetHealth() ) * fDamageDone )
                  iParticleCount = iParticleCount > 500
                                   and 500
                                   or iParticleCount

            ParticleManager:SetParticleControl(self.iTotalDamageDeposit_Indicator_PFX, 1, Vector(iParticleCount, 0, 0))
        end
    end
end
function modifier_tw_time_debuff:OnRemoved()
    if IsServer() then
        for iKey, hValue in pairs(self.hDelayDamage) do
            hValue.damage_flags = bit.bor(hValue.damage_flags,  --DOTA_DAMAGE_FLAG_NONE +
                                                                DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR +
                                                                DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR +
                                                                DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY +
                                                                DOTA_DAMAGE_FLAG_BYPASSES_BLOCK +
                                                                --DOTA_DAMAGE_FLAG_REFLECTION +
                                                                DOTA_DAMAGE_FLAG_HPLOSS +
                                                                DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT +
                                                                --DOTA_DAMAGE_FLAG_NON_LETHAL +
                                                                --DOTA_DAMAGE_FLAG_USE_COMBAT_PROFICIENCY +
                                                                DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS +
                                                                DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION-- +
                                                                --DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN +
                                                                --DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL +
                                                                --DOTA_DAMAGE_FLAG_PROPERTY_FIRE +
                                                                --DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR
                                                                )              
            ApplyDamage(hValue)
        end

        self:SetFrozenCooldowns(self.hParent, false)

        local vColor = Vector(255, 0, 0)
        local iTotalDamageDeposit_Release_PFX = ParticleManager:CreateParticle("particles/generic_gameplay/total_damage_deposit/deposit_damage_release.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hParent)
                                                ParticleManager:SetParticleControl(iTotalDamageDeposit_Release_PFX, 60, vColor)
                                                ParticleManager:SetParticleControl(iTotalDamageDeposit_Release_PFX, 61, vColor)
                                                ParticleManager:SetParticleControl(iTotalDamageDeposit_Release_PFX, 62, vColor)
                                                ParticleManager:ReleaseParticleIndex(iTotalDamageDeposit_Release_PFX)
    end
end
function modifier_tw_time_debuff:SetFrozenCooldowns(hUnit, bFrozen)
    self.tFrozenCooldowns = self.tFrozenCooldowns or {}

    if bFrozen then
        local nAC = hUnit:GetAbilityCount() - 1
        for nID = 0, nAC do
            local hAbility = hUnit:GetAbilityByIndex(nID)
            if IsNotNull(hAbility)
                and not hAbility:IsAttributeBonus()
                and hAbility:GetCooldown(-1) > 0
                and hAbility:IsTrained() then
                --and hAbility:IsUltimate() then
                self.tFrozenCooldowns[hAbility] = bFrozen--hAbility:IsFrozenCooldown()
                hAbility:SetFrozenCooldown(bFrozen)
            end

            local hItem = hUnit:GetItemInSlot(nID)
            if IsNotNull(hItem)
                and not hItem:IsAttributeBonus()
                and hItem:GetAbilityName() ~= "item_tpscroll"
                and hItem:GetCooldown(-1) > 0 then
                self.tFrozenCooldowns[hItem] = bFrozen--hItem:IsFrozenCooldown()
                hItem:SetFrozenCooldown(bFrozen)
            end
        end
    else
        for hAbility, bIsFrozen in pairs(self.tFrozenCooldowns) do
            if IsNotNull(hAbility) then
                hAbility:SetFrozenCooldown(false)
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_tw_time_buff", "heroes/anime_hero_tw", LUA_MODIFIER_MOTION_NONE)

modifier_tw_time_buff = modifier_tw_time_buff or class({})


function modifier_tw_time_buff:IsDebuff()                           return false end
function modifier_tw_time_buff:IsPurgeException()                   return false end
function modifier_tw_time_buff:RemoveOnDeath()                      return true end
function modifier_tw_time_buff:DeclareFunctions()
    local hFunc =   {
                        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
                        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
                    }
    return hFunc
end
function modifier_tw_time_buff:GetModifierMoveSpeed_Absolute()
    return self.fMsAbsolute
end
function modifier_tw_time_buff:GetModifierAttackSpeedBonus_Constant()
    return self.fAsAbsolute
end
function modifier_tw_time_buff:GetModifierTotalDamageNullify(keys)
    if IsServer() and IsNotNull(keys.attacker) then
        local hModifier = keys.attacker:FindModifierByNameAndCaster("modifier_tw_time_debuff", self.hCaster)
        if IsNotNull(hModifier)
            --and IsNotNull(hModifier:GetCaster())
            --and hModifier:GetCaster():GetOwner() == self.hCaster:GetOwner()
            and bit.band(keys.damage_flags or DOTA_DAMAGE_FLAG_NONE, DOTA_DAMAGE_FLAG_REFLECTION) == 0 then
            --SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCKED, keys.target, keys.original_damage, nil)
            return DAMAGE_TYPE_ALL
        end
    end
end
function modifier_tw_time_buff:OnCreated(hTable)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()

    self.fMsAbsolute = self.hAbility:GetSpecialValueFor("ms_absolute")
    self.fAsAbsolute = self.hAbility:GetSpecialValueFor("as_absolute")

    if IsServer() then
    end
end
function modifier_tw_time_buff:OnRefresh(hTable)
    self:OnCreated(hTable)
end