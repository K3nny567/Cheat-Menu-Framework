##---------------------------------------------------------------------------
## CheatUtils Module
##---------------------------------------------------------------------------
module CheatUtils
  #Check if a game is loaded
  def self.ingame?
    return (!SceneManager.scene_is?(Scene_MapTitle) and !SceneManager.scene_is?(Scene_AdultContentWarning) and !SceneManager.scene_is?(Scene_FirstTimeSetup) and !SceneManager.scene_is?(Scene_Title) and !SceneManager.scene_is?(Scene_TitleOptions) and !SceneManager.scene_is?(Scene_TitleOptInputMenu) and !SceneManager.scene_is?(Scene_ACHlistMenu) and !SceneManager.scene_is?(Scene_Credits) and !SceneManager.scene_is?(Scene_Load) and $loading_screen.disposed?)
  end
end

module CheatsMod
  #Get text from translation
  def self.getTextInfo(_info)
    fileName = _info.split(":")[0]
    title = _info.split(":")[1]
    return TextCache.txt_info("#{MOD_FOLDER}/text/#{$lang}", fileName, title)
  end
end
