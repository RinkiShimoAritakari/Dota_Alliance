-- Основной класс способности
alliance_instant_teleport_to_ally = class({})

-- Функция, вызываемая при активации способности
function alliance_instant_teleport_to_ally:OnSpellStart()
	local caster = self:GetCaster() -- Получаем героя, который использовал способность
	local target = self:GetCursorTarget() -- Получаем цель, выбранную при использовании способности

	-- Проверяем, является ли цель союзным героем
	if target:GetTeam() == caster:GetTeam() and target:IsHero() then
		-- Телепортируем кастера к цели
		FindClearSpaceForUnit(caster, target:GetAbsOrigin(), true)
		-- Создаем эффекты телепортации на месте кастера и цели
		ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_WORLDORIGIN, target)
		-- Звук телепортации
		caster:EmitSound("Hero_Chen.TeleportIn")
		target:EmitSound("Hero_Chen.TeleportOut")
	else
	-- Если цель не является союзным героем, возвращаем способность в исходное состояние
	self:EndCooldown()
	self:RefundManaCost()
	end
end
