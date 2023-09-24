class Scene_Base
	alias_method :trigger_debug_window_entry_DEBUG, :trigger_debug_window_entry
	def trigger_debug_window_entry
		trigger_debug_window_entry_DEBUG
		CheatsMod.cheat_triggers
		if Input.trigger?(Input::F9)
			SceneManager.call(Scene_Debug)
		end
	end
end