LinkLuaModifier("modifier_alliance_mage_bonus", "abilities/alliance_mage_bonus", LUA_MODIFIER_MOTION_NONE)

alliance_mage_bonus = class({CAddonTemplateGameMode})

function alliance_mage_bonus:GetIntrinsicModifierName()
	
	return "modifier_alliance_mage_bonus"
end

modifier_alliance_mage_bonus = class({})

function modifier_alliance_mage_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS
	}
end

function modifier_alliance_mage_bonus:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("intelligence_bonus")
end
function modifier_alliance_mage_bonus:GetModifierCooldownReduction_Constant()
	return self:GetAbility():GetSpecialValueFor("cooldown_reduction_bonus")
end

function modifier_alliance_mage_bonus:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("spell_amplify_bonus")
end

function modifier_alliance_mage_bonus:GetModifierCastRangeBonus()
	return self:GetAbility():GetSpecialValueFor("cast_range_bonus")
end
