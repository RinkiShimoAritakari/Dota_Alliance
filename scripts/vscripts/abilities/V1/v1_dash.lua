if v1_dash == nil then
   v1_dash = class({})
end

function v1_dash:OnSpellStart()
   local caster = self:GetCaster()
   -- Растояние перемещения
   local distance = self:GetSpecialValueFor("distance")

   -- Телепортируем героя в направлении, куда он смотрит
   local forwardVec = caster:GetForwardVector() * distance
   local newOrigin = caster:GetAbsOrigin() + forwardVec
   caster:SetAbsOrigin(newOrigin)
end