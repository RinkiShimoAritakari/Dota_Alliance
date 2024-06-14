modifier_attribute_switch_evasion = class({})

function modifier_attribute_switch_evasion:OnCreated(params)
	-- self.agi_evasion = params.agi_evasion
	self.agi_evasion = 0.3
end

function modifier_attribute_switch_evasion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
end

function modifier_attribute_switch_evasion:GetModifierEvasion_Constant()
	local agility = self:GetParent():GetAgility()
	return agility * self.agi_evasion
end
