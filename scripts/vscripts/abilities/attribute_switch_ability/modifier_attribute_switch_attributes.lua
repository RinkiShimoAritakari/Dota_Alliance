modifier_attribute_switch_attributes = class({})

function modifier_attribute_switch_attributes:OnCreated(params)
	-- self.all_attr = params.all_attr
	self.all_attr = 50
end

function modifier_attribute_switch_attributes:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		}
end

function modifier_attribute_switch_attributes:GetModifierBonusStats_Strength()
	return self.all_attr
end

function modifier_attribute_switch_attributes:GetModifierBonusStats_Agility()
	return self.all_attr
end

function modifier_attribute_switch_attributes:GetModifierBonusStats_Intellect()
	return self.all_attr
end
