##---------------------------------------------------------------------------
  ## CheatUtils Module
##---------------------------------------------------------------------------
module CheatUtils
  #List of Scenes classed as being out of game
  @outgame_scenes = [
    ModManagerScene,
    Scene_MapTitle,
    Scene_AdultContentWarning,
    Scene_FirstTimeSetup,
    Scene_Title,
    Scene_TitleOptions,
    Scene_TitleOptInputMenu,
    Scene_ACHlistMenu,
    Scene_Credits,
    Scene_Menu,
    Scene_File,
    Scene_Save,
    Scene_Load_OnGameMenu,
    Scene_Load
  ]
  #Check if a game is loaded
  def self.ingame?
    return (!@outgame_scenes.any? {
      |outgame_scene|
      SceneManager.scene_is?(outgame_scene)
    } and $loading_screen.disposed?)
  end
end
