LinkLuaModifier("modifier_alliance_depths_bonus", "abilities/alliance_depths_bonus", LUA_MODIFIER_MOTION_NONE)

alliance_depths_bonus = class({CAddonTemplateGameMode})

function alliance_depths_bonus:GetIntrinsicModifierName()
	
	return "modifier_alliance_depths_bonus"
end

modifier_alliance_depths_bonus = class({})

function modifier_alliance_depths_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_alliance_depths_bonus:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("magical_resistance_bonus")
end
