-- Ссылка на модификаторы
LinkLuaModifier("modifier_attribute_switch_resist", "abilities/attribute_switch_ability/modifier_attribute_switch_resist.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attribute_switch_evasion", "abilities/attribute_switch_ability/modifier_attribute_switch_evasion.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attribute_switch_cdr", "abilities/attribute_switch_ability/modifier_attribute_switch_cdr.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attribute_switch_attributes", "abilities/attribute_switch_ability/modifier_attribute_switch_attributes.lua", LUA_MODIFIER_MOTION_NONE)

-- Основной класс способности
attribute_switch_ability = class({})

function attribute_switch_ability:OnCreated()
	local caster = self:GetCaster()
	-- caster:AddNewModifier(caster, ability, "modifier_attribute_switch_resist", {special_value = str_magical_resistance})
end

function attribute_switch_ability:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	
	local str_magical_resistance = ability:GetSpecialValueFor("str_magical_resistance")
	local agi_evasion = ability:GetSpecialValueFor("agi_evasion")
	local int_cooldown_reduction = ability:GetSpecialValueFor("int_cooldown_reduction")
	local all_attr = ability:GetSpecialValueFor("all_attr")

	-- DOTA_ATTRIBUTE_AGILITY DOTA_ATTRIBUTE_STRENGTH DOTA_ATTRIBUTE_INTELLECT DOTA_ATTRIBUTE_ALL

	if caster:HasModifier("modifier_attribute_switch_resist") then
		caster:RemoveModifierByName("modifier_attribute_switch_resist")
		caster:AddNewModifier(caster, ability, "modifier_attribute_switch_evasion", {special_value = agi_evasion})
		caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_AGILITY)

	elseif caster:HasModifier("modifier_attribute_switch_evasion") then
		caster:RemoveModifierByName("modifier_attribute_switch_evasion")
		caster:AddNewModifier(caster, ability, "modifier_attribute_switch_cdr", {special_value = int_cooldown_reduction})
		caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_INTELLECT)

	elseif caster:HasModifier("modifier_attribute_switch_cdr") then
		caster:RemoveModifierByName("modifier_attribute_switch_cdr")
		caster:AddNewModifier(caster, ability, "modifier_attribute_switch_attributes", {special_value = all_attr})
		caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_ALL)

	elseif caster:HasModifier("modifier_attribute_switch_attributes") then
		caster:RemoveModifierByName("modifier_attribute_switch_attributes")
		caster:AddNewModifier(caster, ability, "modifier_attribute_switch_resist", {special_value = str_magical_resistance})
		caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH)

	else
		caster:AddNewModifier(caster, ability, "modifier_attribute_switch_resist", {special_value = str_magical_resistance})
	end
end