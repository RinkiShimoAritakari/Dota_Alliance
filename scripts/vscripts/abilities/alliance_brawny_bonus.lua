LinkLuaModifier("modifier_alliance_brawny_bonus", "abilities/alliance_brawny_bonus", LUA_MODIFIER_MOTION_NONE)

alliance_brawny_bonus = class({})

function alliance_brawny_bonus:GetIntrinsicModifierName()
	return "modifier_alliance_brawny_bonus"	
end

modifier_alliance_brawny_bonus = class({})

function modifier_alliance_brawny_bonus:IsHidden()
	return true
end

function modifier_alliance_brawny_bonus:OnCreated(kv)
	if IsServer() then
		self.nKills = 0
		ListenToGameEvent("entity_killed", Dynamic_Wrap(modifier_alliance_brawny_bonus, 'OnEntityKilled'), self)
	end
end

function modifier_alliance_brawny_bonus:OnEntityKilled(keys)
	local killedUnit = EntIndexToHScript(keys.entindex_killed)
	local killerEntity = EntIndexToHScript(keys.entindex_attacker)

	if killedUnit and killerEntity then
		if killedUnit:GetTeam() ~= killerEntity:GetTeam() and killerEntity == self:GetParent() then
  			self.nKills = self.nKills + 1
  			
		end
	end
end
-- -createhero axe enemy
function modifier_alliance_brawny_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
	}
end

function modifier_alliance_brawny_bonus:GetModifierExtraHealthBonus()
	local kill_health_bonus = self:GetAbility():GetSpecialValueFor("bonus_health_per_kill")
	if self.nKills then
		return kill_health_bonus * nKills
	else
		return 0
	end
end
