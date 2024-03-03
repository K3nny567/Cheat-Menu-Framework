module GIM_ADDON
    def achCheckDate
        return if $story_stats["Setup_HardcoreAmt"] != [1772,3,1]
        #Doomsday Mode
        case $game_date.date[0..2]
        when [1772,3,2]
            GabeSDK.getAchievement("HellModDateT1") if $story_stats["Setup_Hardcore"] >= 1
            GabeSDK.getAchievement("DoomModDateT1") if $story_stats["Setup_Hardcore"] >= 2
        when [1773,3,1]
            GabeSDK.getAchievement("HellModDateT2") if $story_stats["Setup_Hardcore"] >= 1
            GabeSDK.getAchievement("DoomModDateT2") if $story_stats["Setup_Hardcore"] >= 2
        when [1774,3,1]
            GabeSDK.getAchievement("HellModDateT3") if $story_stats["Setup_Hardcore"] >= 1
        when [1776,6,6]
            GabeSDK.getAchievement("DoomModDateT3") if $story_stats["Setup_Hardcore"] >= 2
        end
    end
end