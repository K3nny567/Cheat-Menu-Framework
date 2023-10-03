class Scene_Base
	alias_method :trigger_debug_window_entry_DEBUG, :trigger_debug_window_entry
	def trigger_debug_window_entry
		trigger_debug_window_entry_DEBUG
		CheatsMod.cheat_triggers if CheatUtils.ingame?
		if Input.trigger?(Input::F9)
			SceneManager.call(Scene_Debug) if CheatUtils.ingame?
		end
	end
end