class Scene_Base
  alias_method :update_CHEATMENUFRAMEWORK, :update

  def update
    update_CHEATMENUFRAMEWORK
    $mod_cheats.cheat_triggers if CheatUtils.ingame?
  end
end
