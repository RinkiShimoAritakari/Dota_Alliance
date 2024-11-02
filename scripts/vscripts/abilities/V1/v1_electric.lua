-- Создание класса способности
v1_electric = class({})

function v1_electric:OnSpellStart()
    local caster = self:GetCaster()
    local targetPoint = self:GetCursorPosition()
    local distance = 2000

    -- Направление луча
    local direction = (targetPoint - caster:GetOrigin()):Normalized()

    -- Конечная точка луча
    local endPoint = caster:GetOrigin() + direction * distance

    -- Получение всех врагов в линии
    local enemies = FindUnitsInLine(
        caster:GetTeam(),
        caster:GetOrigin(),
        endPoint,
        nil,
        1000, -- Ширина луча
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        0
    )

    -- Наносим урон всем врагам
    for _, enemy in pairs(enemies) do
        local damageTable = {
            victim = enemy,
            attacker = caster,
            damage = 1000,
            damage_type = DAMAGE_TYPE_PURE, -- Чистый урон
            ability = self,
        }
        ApplyDamage(damageTable)
    end

    -- Эффект визуализации
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_deadshot_linear.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
    ParticleManager:SetParticleControl(particle, 1, endPoint)
    ParticleManager:ReleaseParticleIndex(particle)

    -- Звук способности
    EmitSoundOn("Hero_Muerta.DeadShot.Cast", caster)
end
