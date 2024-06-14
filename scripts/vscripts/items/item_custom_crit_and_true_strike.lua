LinkLuaModifier("modifier_divine_barrage", "items/divine_barrage.lua", LUA_MODIFIER_MOTION_NONE)

divine_barrage = class({})

function divine_barrage:GetIntrinsicModifierName()
	return "modifier_divine_barrage"
end

modifier_divine_barrage = class({})

function modifier_divine_barrage:IsHidden()
	return true -- Скрыт от инвентаря
end

function modifier_divine_barrage:IsPurgable()
	return false
end

function modifier_divine_barrage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR,
	}
end

function modifier_divine_barrage:GetModifierPreAttack_CriticalStrike(params)
	local chance = self:GetAbility():GetSpecialValueFor("crit_chance")
	if RollPercentage(chance) then
		return self:GetAbility():GetSpecialValueFor("crit_multiplier")
	end
	return nil
end

function modifier_divine_barrage:GetModifierIgnorePhysicalArmor(params)
	return 1
end

