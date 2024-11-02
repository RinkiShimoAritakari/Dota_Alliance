
v1_revolver = class({})
LinkLuaModifier( "modifier_v1_revolver", "abilities/V1/modifier_v1_revolver", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_v1_revolver_slow", "abilities/V1/modifier_v1_revolver_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_vector_target", "abilities/V1/modifier_generic_vector_target", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function v1_revolver:Precache( context )
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_muerta.vsndevts", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_deadshot_creep_impact.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_deadshot_debuff_slow.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_deadshot_linear.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_deadshot_linear_tree.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_deadshot_tracking_proj.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_spell_fear_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_spell_fear_debuff_status.vpcf", context )
end

function v1_revolver:GetIntrinsicModifierName()
    return "modifier_generic_vector_target"
end

--------------------------------------------------------------------------------
-- Ability Start
v1_revolver.projectiles = {}
function v1_revolver:OnSpellStart()
    -- unit identifier
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local vector_point = self.vector_position
    if not vector_point then
        -- likely reflected, otherwise set forward as default
        vector_point = v1_revolver.reflect_location or (target:GetOrigin() + target:GetForwardVector())
    end

    -- load data
    local speed = self:GetSpecialValueFor( "speed" )
    local damage = self:GetSpecialValueFor( "damage" )

    local effect_name_tracking = "particles/units/heroes/hero_muerta/muerta_deadshot_tracking_proj.vpcf"
    local effect_name_tree = "particles/units/heroes/hero_muerta/muerta_deadshot_linear_tree.vpcf"

    -- calculate ricochet direction
    local direction = vector_point - target:GetOrigin()
    direction.z = 0
    direction = direction:Normalized()

    if target:GetClassname()=="ent_dota_tree" then
        -- if tree
        local tree_radius = self:GetSpecialValueFor( "radius" )
        local tree_direction = target:GetOrigin() - caster:GetOrigin()
        local tree_distance = tree_direction:Length2D()
        tree_direction.z = 0
        tree_direction = tree_direction:Normalized()

        -- create linear projectile
        local info = {
            Source = caster,
            Ability = self,
            vSpawnOrigin = caster:GetOrigin() + Vector(0,0,200),
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
            
            bDeleteOnHit = true,
            
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_NONE,
            
            EffectName = effect_name_tree,
            fDistance = tree_distance,
            fStartRadius = tree_radius,
            fEndRadius = tree_radius,
            vVelocity = tree_direction * speed,
        
            bProvidesVision = true,
            iVisionRadius = tree_radius,
            iVisionTeamNumber = caster:GetTeamNumber(),
        }
        local projID = ProjectileManager:CreateLinearProjectile( info )

        local data = {}
        self.projectiles[projID] = data
        data.info = info
        data.OnDestroy = function( this, location )
            return self:OnTreeHit( target, direction, location )
        end
    else
        -- target unit

        -- Create Tracking Projectile
        local info = {
            Source = caster,
            Target = target,
            Ability = self,
            iMoveSpeed = speed,
            EffectName = effect_name_tracking,
            bDodgeable = true,
        }
        local projID = ProjectileManager:CreateTrackingProjectile( info )

        local data = {}
        self.projectiles[projID] = data
        data.info = info
        data.OnHit = function( this, target, location )
            return self:OnInitialHit( direction, target, location )
        end
    end

    EmitSoundOn( "Hero_Muerta.DeadShot.Cast", caster )
    EmitSoundOn( "Hero_Muerta.DeadShot.Layer", caster )
end

function v1_revolver:OnTreeHit( tree, direction, location )
    -- ricochet
    -- self:LaunchRicochet( tree, direction )
    GridNav:DestroyTreesAroundPoint(tree:GetOrigin(), 0, true)

    EmitSoundOnLocationWithCaster( location, "Hero_Muerta.DeadShot.Tree", self:GetCaster() )
end

function v1_revolver:OnInitialHit( direction, target, location )
    local caster = self:GetCaster()

    if target:IsMagicImmune() or target:IsInvulnerable() then return end

    -- NOTE: Lotus reflects direction to the opposite of original cast
    -- this code below create static variable for reflected ability to use
    v1_revolver.reflect_location = caster:GetOrigin() - direction
    v1_revolver.reflected = true
    local reflect = target:TriggerSpellAbsorb( self )
    v1_revolver.reflect_location = nil
    v1_revolver.reflected = nil

    if reflect then return end

    local damage = self:GetSpecialValueFor( "damage" )
    local slow_duration = self:GetSpecialValueFor( "impact_slow_duration" )
    
    -- damage
    local damageTable = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self, --Optional.
    }
    ApplyDamage( damageTable )

    -- slow
    target:AddNewModifier(
        caster,
        self,
        "modifier_v1_revolver_slow",
        {duration = slow_duration}
    )

    EmitSoundOn( "Hero_Muerta.DeadShot.Slow", target )
end

--------------------------------------------------------------------------------
-- Projectile
function v1_revolver:OnProjectileThinkHandle( handle )
    local data = self.projectiles[handle]
    if not data then return end

    local pos = ProjectileManager:GetLinearProjectileLocation( handle )

    if data.OnThink then
        data:OnThink( pos )
    end
end

function v1_revolver:OnProjectileHitHandle( target, location, handle )
    local data = self.projectiles[handle]
    if not data then return end

    if not target then
        if data.OnDestroy then
            data:OnDestroy( location )
        end
        self.projectiles[handle] = nil
        return
    end

    if data.OnHit then
        return data:OnHit( target, location )
    end
end

--------------------------------------------------------------------------------
-- Effects
function v1_revolver:PlayEffects( target )
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_muerta/muerta_deadshot_creep_impact.vpcf"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT, target )
    ParticleManager:SetParticleControlEnt(
        effect_cast,
        0,
        target,
        PATTACH_POINT,
        "attach_hitloc",
        Vector(), -- unknown
        true -- unknown, true
    )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end