modifier_intellect_heap = class({})

function modifier_intellect_heap:IsHidden()
	return false
end

function modifier_intellect_heap:IsPurgable()
	return false
end

function modifier_intellect_heap:RemoveOnDeath()
	return false
end

function modifier_intellect_heap:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_HERO_KILLED,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_intellect_heap:OnHeroKilled(params)
	if IsServer() then
		local hero = self:GetParent()
		if hero:IsRealHero() and params.attacker == hero then
			local victim_position = params.target:GetAbsOrigin()
			local hero_position = hero:GetAbsOrigin()
			local distance = (victim_position - hero_position):Length2D()
			if distance <= 400 then
				self:IncrementStackCount()
			end
		end
	end
end

function modifier_intellect_heap:GetModifierBonusStats_Intellect()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("intellect_per_stack")
end
