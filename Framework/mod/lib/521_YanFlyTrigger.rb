class Scene_Base
  alias_method :trigger_debug_window_entry_CHEATMENUFRAMEWORK, :trigger_debug_window_entry

  def trigger_debug_window_entry
    trigger_debug_window_entry_CHEATMENUFRAMEWORK
    CheatsMod.cheat_triggers if CheatUtils.ingame?
  end
end
