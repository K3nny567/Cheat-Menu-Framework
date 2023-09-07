# Into Shadow trait allows stealth use of the Confirm key

class Game_Player
	def update_nonmoving(last_moving)
		return if $game_map.interpreter.running?
		if last_moving
			$game_party.on_player_walk
			return if check_touch_event
		end
		if inputToTriggerEvent? && movable? && !actor.lonaDeath?
			@pathfinding = false
			return if Input.skillKeyPressed?
			move_normal unless self.actor.stat["IntoShadow"] == 1
			return if check_action_event(chkItemsPick=true)
			SndLib.sys_trigger
		end
	end
end
