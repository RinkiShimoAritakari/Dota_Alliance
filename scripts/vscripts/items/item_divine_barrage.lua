LinkLuaModifier("modifier_item_divine_barrage", "items/item_divine_barrage.lua", LUA_MODIFIER_MOTION_NONE)

item_divine_barrage = class({})

function item_divine_barrage:GetIntrinsicModifierName()
	return "modifier_item_divine_barrage"
end

modifier_item_divine_barrage = class({})

function modifier_item_divine_barrage:IsHidden()
	return true -- Скрыт от инвентаря
end

function modifier_item_divine_barrage:IsPurgable()
	return false
end

function modifier_item_divine_barrage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_divine_barrage:GetModifierPreAttack_CriticalStrike(params)
	local chance = self:GetAbility():GetSpecialValueFor("crit_chance")
	if RollPercentage(chance) then
		return self:GetAbility():GetSpecialValueFor("crit_multiplier")
	end
	return nil
end

function modifier_item_divine_barrage:GetModifierIgnorePhysicalArmor(params)
	return 1
end

function modifier_item_divine_barrage:GetModifierPreAttack_BonusDamage(params)
	local damage_bonus = self:GetAbility():GetSpecialValueFor("damage_bonus")
	return damage_bonus
end


function modifier_item_divine_barrage:GetModifierAttackSpeedBonus_Constant(params)
	local attack_speed_bonus = self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
	return attack_speed_bonus
end
