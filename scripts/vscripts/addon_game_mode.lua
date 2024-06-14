-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end


HeroExpTable = {0}

for i=2,100 do 
	HeroExpTable[i] = HeroExpTable[i-1] + (i*100) - 100
end

-- Чем я занимаюсь??
count_demon_hunter = 0
-- count_forester = 0
count_demon = 0
count_hand_of_midas = 0
count_archmages = 0
count_depths = 0
count_TDT = 0 			-- you_shall_not_pass ( Ты не пройдёшь )
count_spirits = 0
count_assassin = 0
count_brawny = 0
count_DrW = 0       	--Drow_Ranger_Windranger_bonus



function CAddonTemplateGameMode:InitGameMode()
	-- GameRules:SetCustomGameTeamMaxPlayer(DOTA_TEAM_GOODGUYS)

	GameRules:SetStartingGold(90000)
	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetPreGameTime(5)
	GameRules:SetGoldTickTime(0.1)

	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 5 )

	-- GameRules:SetUseUniversalShopMode(true)
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )

	GameRules:GetGameModeEntity():SetUseCustomHeroLevels( true )
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( HeroExpTable )

	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self , 'Bonus_Alliance'), self)

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CAddonTemplateGameMode:Bonus_Alliance(keys)
	-- local newState = GameRules:State_Get()
	
	-- if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	for index=0,PlayerResource:GetPlayerCount() do
		if PlayerResource:HasSelectedHero(index) then
			local player = PlayerResource:GetPlayer(index)
			local hero = PlayerResource:GetSelectedHeroEntity(index)
			local hero_name = hero:GetUnitName()

			if hero_name == "npc_dota_hero_antimage" or hero_name == "npc_dota_hero_terrorblade" then
				count_demon_hunter = count_demon_hunter + 1
			end
			if hero_name == "npc_dota_hero_windrunner" or hero_name == "npc_dota_hero_drow_ranger" then
				count_DrW = count_DrW + 1
			end
			if hero_name == "npc_dota_hero_alchemist" or hero_name == "npc_dota_hero_bounty_hunter" then
				count_hand_of_midas = count_hand_of_midas + 1
			end
			if hero_name == "npc_dota_hero_rubick" or hero_name == "npc_dota_hero_obsidian_destroyer" or hero_name == "npc_dota_hero_silencer" or hero_name == "npc_dota_hero_invoker" then
				count_archmages = count_archmages + 1
			end
			if hero_name == "npc_dota_hero_morphling" or hero_name == "npc_dota_hero_medusa" or hero_name == "npc_dota_hero_slark" or hero_name == "npc_dota_hero_slardar" then
				count_depths = count_depths + 1
			end
			if hero_name == "npc_dota_hero_lich" or hero_name == "npc_dota_hero_ogre_magi" or hero_name == "npc_dota_hero_treant" then
				count_TDT = count_TDT + 1
			end
			if hero_name == "npc_dota_hero_earth_spirit" or hero_name == "npc_dota_hero_ember_spirit" or hero_name == "npc_dota_hero_storm_spirit" or hero_name == "npc_dota_hero_void_spirit" then
				count_spirits = count_spirits + 1
			end
			if hero_name == "npc_dota_hero_sven" or hero_name == "npc_dota_hero_night_stalker" or hero_name == "npc_dota_hero_pangolier" or hero_name == "npc_dota_hero_troll_warlord" or hero_name == "npc_dota_hero_riki" or hero_name == "npc_dota_hero_phantom_assassin" or hero_name == "npc_dota_hero_juggernaut" or hero_name == "npc_dota_hero_monkey_king" or hero_name == "npc_dota_hero_bloodseeker" or hero_name == "npc_dota_hero_faceless_void" then
				count_assassin = count_assassin + 1
			end
			if hero_name == "npc_dota_hero_axe" or hero_name == "npc_dota_hero_centaur" or hero_name == "npc_dota_hero_disruptor" or hero_name == "npc_dota_hero_snapfire" or hero_name == "npc_dota_hero_juggernaut" or hero_name == "npc_dota_hero_beastmaster" or hero_name == "npc_dota_hero_bristleback" then
				count_brawny = count_brawny + 1
			end

		end
	end
-- -createhero 
	for index=0 ,PlayerResource:GetPlayerCount() do
		if PlayerResource:HasSelectedHero(index) then
			local player = PlayerResource:GetPlayer(index)
			local hero = PlayerResource:GetSelectedHeroEntity(index)
			local hero_name = hero:GetUnitName()

			if hero_name == "npc_dota_hero_antimage" or hero_name == "npc_dota_hero_terrorblade" then
				hero:FindAbilityByName("alliance_demon_hunter_bonus"):SetLevel(count_demon_hunter)
			end
			if hero_name == "npc_dota_hero_windrunner" or hero_name == "npc_dota_hero_drow_ranger" then
				hero:FindAbilityByName("Drow_Ranger_Windranger_bonus"):SetLevel(count_DrW)
			end
			if hero_name == "npc_dota_hero_alchemist" or hero_name == "npc_dota_hero_bounty_hunter" then
				hero:FindAbilityByName("alchemist_hand_of_midas"):SetLevel(count_hand_of_midas)
			end
			if hero_name == "npc_dota_hero_rubick" or hero_name == "npc_dota_hero_obsidian_destroyer" or hero_name == "npc_dota_hero_silencer" or hero_name == "npc_dota_hero_invoker" then
				hero:FindAbilityByName("alliance_archmages_bonus"):SetLevel(count_archmages)
			end
			if hero_name == "npc_dota_hero_morphling" or hero_name == "npc_dota_hero_medusa" or hero_name == "npc_dota_hero_slark" or hero_name == "npc_dota_hero_slardar" then
				hero:FindAbilityByName("alliance_depths_bonus"):SetLevel(count_depths)
			end
			if hero_name == "npc_dota_hero_lich" or hero_name == "npc_dota_hero_ogre_magi" or hero_name == "npc_dota_hero_treant" then
				hero:FindAbilityByName("alliance_you_shall_not_pass"):SetLevel(count_TDT)
			end
			if hero_name == "npc_dota_hero_earth_spirit" or hero_name == "npc_dota_hero_ember_spirit" or hero_name == "npc_dota_hero_storm_spirit" or hero_name == "npc_dota_hero_void_spirit" then
				hero:FindAbilityByName("alliance_instant_teleport_to_ally"):SetLevel(1)
				if count_spirits == 4 then
					hero:FindAbilityByName("attribute_switch_ability"):SetLevel(1)
				end
			end
			if hero_name == "npc_dota_hero_sven" or hero_name == "npc_dota_hero_night_stalker" or hero_name == "npc_dota_hero_pangolier" or hero_name == "npc_dota_hero_troll_warlord" or hero_name == "npc_dota_hero_riki" or hero_name == "npc_dota_hero_phantom_assassin" or hero_name == "npc_dota_hero_juggernaut" or hero_name == "npc_dota_hero_monkey_king" or hero_name == "npc_dota_hero_bloodseeker" or hero_name == "npc_dota_hero_faceless_void" then
				if count_assassin > 5 then
					hero:FindAbilityByName("alliance_assassin_bonus"):SetLevel(5)
				else
					hero:FindAbilityByName("alliance_assassin_bonus"):SetLevel(count_assassin)
				end
			end
			if hero_name == "npc_dota_hero_axe" or hero_name == "npc_dota_hero_centaur" or hero_name == "npc_dota_hero_disruptor" or hero_name == "npc_dota_hero_snapfire" or hero_name == "npc_dota_hero_juggernaut" or hero_name == "npc_dota_hero_beastmaster" or hero_name == "npc_dota_hero_bristleback" then
				if count_brawny > 5 then
					hero:FindAbilityByName("alliance_brawny_bonus"):SetLevel(5)
				else
					hero:FindAbilityByName("alliance_brawny_bonus"):SetLevel(count_brawny)
				end
			end

			-- Кто один в Альянсе
			if hero_name == "npc_dota_hero_legion_commander" then
				hero:FindAbilityByName("alliance_champion_bonus"):SetLevel(1)
			end
			if hero_name == "npc_dota_hero_warlock" then
				hero:FindAbilityByName("alliance_warlock_supremacy_bonus"):SetLevel(1)
			end


		end
	end
end
-- 	local spawnedUnit = kv.entindex and EntIndexToHScript(kv.entindex)


		
-- 		if spawnedUnit ~= nil then
-- 			if spawnedUnit:GetUnitName() == "npc_dota_hero_antimage" or "npc_dota_hero_terrorblade" then
-- 				if spawnedUnit:HasAbility("abaddon_borrowed_time") then

-- 					spawnedUnit:RemoveAbility("abaddon_borrowed_time")

-- 					spawnedUnit:AddAbility("abaddon_borrowed_time"):SetLevel(2)
-- 				else
-- 					spawnedUnit:AddAbility("abaddon_borrowed_time"):SetLevel(1)		
-- 				end
-- 			end
-- 		end
-- 	end
-- end
