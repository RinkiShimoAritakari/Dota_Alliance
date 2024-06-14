modifier_attribute_switch_cdr = class({})

function modifier_attribute_switch_cdr:OnCreated(params)
	-- self.int_cooldown_reduction = params.int_cooldown_reduction
	self.int_cooldown_reduction = 0.3
end

function modifier_attribute_switch_cdr:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
	}
end

function modifier_attribute_switch_cdr:GetModifierCooldownReduction_Constant()
	local intellect = self:GetParent():GetIntellect(true)
	return intellect * self.int_cooldown_reduction
end
