-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

require("timers")

HeroExpTable = {0}

for i=2,100 do 
	HeroExpTable[i] = HeroExpTable[i-1] + (i*100) - 100
end

-- Чем я занимаюсь??
count_demon_hunter = 0
count_forester = 0
count_demon = 0
count_hand_of_midas = 0
count_archmages = 0
count_depths = 0
count_TDT = 0 			-- you_shall_not_pass ( Ты не пройдёшь )
count_spirits = 0
count_assassin = 0
count_brawny = 0
count_DrW = 0       	--Drow_Ranger_Windranger_bonus
count_gods = 0
count_mage = 0
count_circus = 0
count_mechanic = 0
count_hunter = 0


function CAddonTemplateGameMode:InitGameMode()
	local gEntity = GameRules:GetGameModeEntity()

	-- Основные настройки игры
	gEntity:SetCustomBackpackCooldownPercent(1.0)  -- Процент времени перезарядки для рюкзака
	gEntity:SetCustomBackpackSwapCooldown(0.0)  -- Время перезарядки при смене предметов в рюкзаке

	gEntity:SetBotsInLateGame(false)  -- Не использовать ботов в конце игры
	gEntity:SetBotThinkingEnabled(true)  -- Включить логику мышления для ботов
	gEntity:SetDeathTipsDisabled(true)  -- Отключить подсказки о смерти
	gEntity:SetFreeCourierModeEnabled(true)  -- Включить бесплатный курьер
	gEntity:SetGiveFreeTPOnDeath(true)  -- Дать бесплатные свитки телепортации при смерти
	gEntity:SetBountyRuneSpawnInterval(144.0)  -- Интервал появления рун удачи
	gEntity:SetCustomGlyphCooldown(240.0)  -- Кулдаун глифа
	gEntity:SetCustomScanCooldown(168.0)  -- Кулдаун сканирования
	gEntity:SetLoseGoldOnDeath(false)  -- Не терять золото при смерти
	gEntity:SetPowerRuneSpawnInterval(100.0)  -- Интервал появления рун силы
	gEntity:SetRandomHeroBonusItemGrantDisabled(true)  -- Отключить случайное получение бонусных предметов
	gEntity:SetRecommendedItemsDisabled(true)  -- Отключить рекомендуемые предметы
	gEntity:SetRespawnTimeScale(0.8)  -- Масштаб времени респауна
	gEntity:SetUseDefaultDOTARuneSpawnLogic(true)  -- Использовать стандартную логику появления рун
	gEntity:SetUseTurboCouriers(true)  -- Использовать курьеров в режиме Turbo
	gEntity:SetXPRuneSpawnInterval(150)  -- Интервал появления рун опыта
	gEntity:SetCanSellAnywhere(true)  -- Разрешить продажу предметов в любом месте
	gEntity:SetTowerBackdoorProtectionEnabled(true)  -- Включить защиту для башен

	-- Настройки экономики и времени
	GameRules:SetStartingGold(1000)  -- Начальное количество золота
	GameRules:SetUseUniversalShopMode(true)  -- Установить универсальный магазин
	GameRules:SetHeroSelectionTime(300)  -- Время выбора героев
	GameRules:SetGoldTickTime(0.1)  -- Время, за которое золото будет прибавляться

	GameRules:SetPreGameTime(5)  -- Время перед началом игры
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 5)  -- Максимум игроков на стороне добра
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 5)  -- Максимум игроков на стороне зла

	-- Установка времени стратегии и шоукейса
	GameRules:SetStrategyTime(0.0)
	GameRules:SetShowcaseTime(0.0)

	-- Установка пользовательских уровней героев
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true)
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(HeroExpTable)  -- Таблица опыта для уровней

	-- Настройки для режима
	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
	GameRules:GetGameModeEntity():SetHeroMaxLevel(100)  -- Максимальный уровень героев
	GameRules:GetGameModeEntity():SetGoldPerTick(2)  -- Золото, получаемое за тик
	GameRules:GetGameModeEntity():SetRespawnTime(5)  -- Время респауна
	GameRules:GetGameModeEntity():SetCustomRespawnTime(5)  -- Настройка кастомного времени респауна

	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self, 'Bonus_Alliance'), self)
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
			if hero_name == "npc_dota_hero_mars" or hero_name == "npc_dota_hero_dawnbreaker" or hero_name == "npc_dota_hero_zuus" then
				count_gods = count_gods + 1
			end
			if hero_name == "npc_dota_hero_lina" or hero_name == "npc_dota_hero_puck" or hero_name == "npc_dota_hero_lion" or hero_name == "npc_dota_hero_batrider" or hero_name == "npc_dota_hero_leshrac" or hero_name == "npc_dota_hero_nyx_assassin" or hero_name == "npc_dota_hero_skywrath_mage" or hero_name == "npc_dota_hero_winter_wyvern" or hero_name == "npc_dota_hero_venomancer" or hero_name == "npc_dota_hero_phoenix" or hero_name == "npc_dota_hero_jakiro" or hero_name == "npc_dota_hero_dark_willow" or hero_name == "npc_dota_hero_razor" or hero_name == "npc_dota_hero_crystal_maiden" then
				count_mage = count_mage + 1
			end
			if hero_name == "npc_dota_hero_ringmaster" or hero_name == "npc_dota_hero_lycan" or hero_name == "npc_dota_hero_ursa" then
				count_circus = count_circus + 1
			end
			if hero_name == "npc_dota_hero_techies" or hero_name == "npc_dota_hero_gyrocopter" or hero_name == "npc_dota_hero_rattletrap" or hero_name == "npc_dota_hero_tinker" or hero_name == "npc_dota_hero_shredder" or hero_name == "npc_dota_hero_snapfire" or hero_name == "npc_dota_hero_sniper" then
				count_mechanic = count_mechanic + 1
			end
			if hero_name == "npc_dota_hero_drow_ranger" or hero_name == "npc_dota_hero_windrunner" or hero_name == "npc_dota_hero_mirana" or hero_name == "npc_dota_hero_luna" or hero_name == "npc_dota_hero_hoodwink" then
				count_hunter = count_hunter + 1
			end			
			if hero_name == "npc_dota_hero_skeleton_king" or hero_name == "npc_dota_hero_antimage" or hero_name == "npc_dota_hero_phantom_assassin" or hero_name == "npc_dota_hero_juggernaut" or hero_name == "npc_dota_hero_alchemist" then
				count_forester = count_forester + 1
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
			if hero_name == "npc_dota_hero_mars" or hero_name == "npc_dota_hero_dawnbreaker" or hero_name == "npc_dota_hero_zuus" then
				hero:FindAbilityByName("alliance_gods_bonus"):SetLevel(count_gods)
			end
			if hero_name == "npc_dota_hero_lina" or hero_name == "npc_dota_hero_puck" or hero_name == "npc_dota_hero_lion" or hero_name == "npc_dota_hero_batrider" or hero_name == "npc_dota_hero_leshrac" or hero_name == "npc_dota_hero_nyx_assassin" or hero_name == "npc_dota_hero_skywrath_mage" or hero_name == "npc_dota_hero_winter_wyvern" or hero_name == "npc_dota_hero_venomancer" or hero_name == "npc_dota_hero_phoenix" or hero_name == "npc_dota_hero_jakiro" or hero_name == "npc_dota_hero_dark_willow" or hero_name == "npc_dota_hero_razor" or hero_name == "npc_dota_hero_crystal_maiden" then
				if count_mage > 5 then
					hero:FindAbilityByName("alliance_mage_bonus"):SetLevel(5)
				else
					hero:FindAbilityByName("alliance_mage_bonus"):SetLevel(count_mage)
				end
			end
			if hero_name == "npc_dota_hero_ringmaster" or hero_name == "npc_dota_hero_lycan" or hero_name == "npc_dota_hero_ursa" then
				hero:FindAbilityByName("alliance_circus"):SetLevel(count_circus)
			end
			if hero_name == "npc_dota_hero_techies" or hero_name == "npc_dota_hero_gyrocopter" or hero_name == "npc_dota_hero_rattletrap" or hero_name == "npc_dota_hero_tinker" or hero_name == "npc_dota_hero_shredder" or hero_name == "npc_dota_hero_snapfire" or hero_name == "npc_dota_hero_sniper" then
				if count_mechanic > 5 then
					hero:FindAbilityByName("alliance_mechanic_bonus"):SetLevel(5)
				else
					hero:FindAbilityByName("alliance_mechanic_bonus"):SetLevel(count_mechanic)
				end
			end
			if hero_name == "npc_dota_hero_drow_ranger" or hero_name == "npc_dota_hero_windrunner" or hero_name == "npc_dota_hero_mirana" or hero_name == "npc_dota_hero_luna" or hero_name == "npc_dota_hero_hoodwink" then
				hero:FindAbilityByName("Alliance_Hunter_bonus"):SetLevel(count_hunter)
			end
			if hero_name == "npc_dota_hero_skeleton_king" or hero_name == "npc_dota_hero_antimage" or hero_name == "npc_dota_hero_phantom_assassin" or hero_name == "npc_dota_hero_juggernaut" or hero_name == "npc_dota_hero_alchemist" then
				hero:FindAbilityByName("Alliance_Forester_bonus"):SetLevel(count_forester)
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
