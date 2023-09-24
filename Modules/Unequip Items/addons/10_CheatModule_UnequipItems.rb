# Cheats Mod Module - Unequip Items

$CHEATSMOD_CHEATMODULES["Unequip Items"] = true

module CheatUtils
	def self.unequipall(force)
		if self.ingame?
			$game_player.actor.equip_slots.size.times do |i|
				$game_player.actor.change_equip(i, nil) if $game_player.actor.equip_change_ok?(i) or force
				SndLib.sound_equip_armor
			end
		end
	end
end

##---------------------------------------------------------------------------
## Hotkeys
##---------------------------------------------------------------------------
module CheatsMod
	self.singleton_class.send(:alias_method, :cheat_triggers_CHEATSMODULE_UNEQUIPITEMS, :cheat_triggers)
	def self.cheat_triggers
		cheat_triggers_CHEATSMODULE_UNEQUIPITEMS
		if Input.trigger?(Input::F3)
			CheatUtils.unequipall(false)
		end
		if Input.press?(:SHIFT) && Input.trigger?(Input::F3)
			CheatUtils.unequipall(true)
		end
	end
end
class Scene_Base
	alias_method :trigger_debug_window_entry_CHEATSMODULE_UNEQUIPITEMS, :trigger_debug_window_entry
	def trigger_debug_window_entry
		trigger_debug_window_entry_CHEATSMODULE_UNEQUIPITEMS
		if Input.trigger?(Input::F3)
			CheatUtils.unequipall(false)
		end
		if Input.press?(:SHIFT) && Input.trigger?(Input::F3)
			CheatUtils.unequipall(true)
		end
	end
end
