modifier_attribute_switch_resist = class({})

function modifier_attribute_switch_resist:OnCreated(params)
	-- self.str_magical_resistance = params.str_magical_resistance
	self.str_magical_resistance = 0.3
end

function modifier_attribute_switch_resist:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_attribute_switch_resist:GetModifierMagicalResistanceBonus()
	local strength = self:GetParent():GetStrength()
	return strength * self.str_magical_resistance
end
