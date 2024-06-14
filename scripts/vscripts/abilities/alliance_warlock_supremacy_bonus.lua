LinkLuaModifier("modifier_alliance_warlock_supremacy_bonus", "abilities/alliance_warlock_supremacy_bonus", LUA_MODIFIER_MOTION_NONE)

alliance_warlock_supremacy_bonus = class({CAddonTemplateGameMode})

function alliance_warlock_supremacy_bonus:GetIntrinsicModifierName()
	
	return "modifier_alliance_warlock_supremacy_bonus"
end

modifier_alliance_warlock_supremacy_bonus = class({})

function modifier_alliance_warlock_supremacy_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_alliance_warlock_supremacy_bonus:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("intelligence_bonus")
end