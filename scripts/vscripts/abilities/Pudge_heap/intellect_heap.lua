LinkLuaModifier("modifier_intellect_heap", "abilities/Pudge_heap/modifier_intellect_heap.lua", LUA_MODIFIER_MOTION_NONE)

intellect_heap = class({})

function intellect_heap:GetIntrinsicModifierName()
    return "modifier_intellect_heap"
end