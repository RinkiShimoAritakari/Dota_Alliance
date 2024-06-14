LinkLuaModifier( "modifier_alliance_you_shall_not_pass", "abilities/alliance_you_shall_not_pass", LUA_MODIFIER_MOTION_NONE )

alliance_you_shall_not_pass = class({CAddonTemplateGameMode})

function alliance_you_shall_not_pass:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	target:AddNewModifier(caster, self, "modifier_alliance_you_shall_not_pass", {duration = duration})
end

modifier_alliance_you_shall_not_pass = class({})

function modifier_alliance_you_shall_not_pass:IsHidden()
	return false
end

function modifier_alliance_you_shall_not_pass:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_alliance_you_shall_not_pass:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor( "attack_speed_bonus" )
end

function modifier_alliance_you_shall_not_pass:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor( "armor_bonus" )
end
