# Cheats Mod Module - Unlocks Tool

# Add silent variant to Scene_Base
class Scene_Base
	def achievementGetSilently(tmpAchName="",tmpIcon=nil)
		achievementPopup("Achievement unlocked",tmpAchName,300,achIcon=tmpIcon)
	end
end

# Add silent variant to GabeSDK
module GabeSDK
	def self.getAchievementSilently(ach_id)
		ach_idSYM = ach_id.to_sym
		return if !AchievementsData[ach_idSYM]
		return if AchievementsData[ach_idSYM][0] >= AchievementsData[ach_idSYM][1]
		AchievementsData[ach_idSYM][0] = AchievementsData[ach_idSYM][1]
		DataManager.write_constant("ACH",ach_id,AchievementsData[ach_idSYM][1])
		tmpName = AchievementsData[ach_idSYM][4] ? AchievementsData[ach_idSYM][4] : $game_text["DataACH:#{ach_id}/item_name"]
		SceneManager.scene.achievementGetSilently(tmpAchName=tmpName,tmpIcon=ach_id)
	end
end

# Core of the Unlock Tool cheatmodule
module CheatUtils
	def self.unlock_cg
		DataManager.write_rec_constant('RecHevCargoSaveCecilyRape', 1)
		DataManager.write_rec_constant('RecHevLisaAbom', 1)
		DataManager.write_rec_constant('RecHevScoutCampOrkind3CG', 1)
		DataManager.write_rec_constant('RecHevCoconaBath', 1)
		DataManager.write_rec_constant('RecHevTellerSakaGBoss', 1)
		DataManager.write_rec_constant('RecHevFishKindDockSlave', 1)
		DataManager.write_rec_constant('RecHevCecilyHijack1', 1)
		DataManager.write_rec_constant('RecHevFishCaveHunt2CG', 1)
		DataManager.write_rec_constant('RecHevSeaWitchReverseRape', 1)
		DataManager.write_rec_constant('RecHevCoconaPriest', 1)
		DataManager.write_rec_constant('RecHevLisaAbomHive3', 1)
		DataManager.write_rec_constant('RecHevTellerGoldenBar4some', 1)
		DataManager.write_rec_constant('RecHevUniqueEvent_CoconaVag', 1)
	end
	
	def self.unlock_ach
		GabeSDK.GetACHlist.each_key {|ach_id| GabeSDK.getAchievementSilently(ach_id) }
	end
	
	def self.reset_cg
		DataManager.write_rec_constant('RecHevCargoSaveCecilyRape', 0)
		DataManager.write_rec_constant('RecHevLisaAbom', 0)
		DataManager.write_rec_constant('RecHevScoutCampOrkind3CG', 0)
		DataManager.write_rec_constant('RecHevCoconaBath', 0)
		DataManager.write_rec_constant('RecHevTellerSakaGBoss', 0)
		DataManager.write_rec_constant('RecHevFishKindDockSlave', 0)
		DataManager.write_rec_constant('RecHevCecilyHijack1', 0)
		DataManager.write_rec_constant('RecHevFishCaveHunt2CG', 0)
		DataManager.write_rec_constant('RecHevSeaWitchReverseRape', 0)
		DataManager.write_rec_constant('RecHevCoconaPriest', 0)
		DataManager.write_rec_constant('RecHevLisaAbomHive3', 0)
		DataManager.write_rec_constant('RecHevTellerGoldenBar4some', 0)
		DataManager.write_rec_constant('RecHevUniqueEvent_CoconaVag', 0)
	end
	
	def self.reset_ach
		GabeSDK.reset
	end
end
