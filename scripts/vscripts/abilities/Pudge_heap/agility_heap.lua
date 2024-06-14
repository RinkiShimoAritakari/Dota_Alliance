LinkLuaModifier("modifier_agility_heap", "abilities/Pudge_heap/modifier_agility_heap.lua", LUA_MODIFIER_MOTION_NONE)

agility_heap = class({})

function agility_heap:GetIntrinsicModifierName()
	return "modifier_agility_heap"
end
