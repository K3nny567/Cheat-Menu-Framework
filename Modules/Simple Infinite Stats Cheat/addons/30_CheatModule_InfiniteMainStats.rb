# Cheats Mod Module - Infinite Main Stats

# load toggle state from ini
$cheat_infinite_health = FileGetter.cheat_load("Cheats Mod - Modules", "Infinite Health", false)
$cheat_infinite_food = FileGetter.cheat_load("Cheats Mod - Modules", "Infinite Food", false)
$cheat_infinite_stamina = FileGetter.cheat_load("Cheats Mod - Modules", "Infinite Stamina", false)

module CheatUtils
	def self.heal_player
		self.player_heal
		self.player_feed
		self.player_rest
	end

	def self.player_heal
		return if !self.ingame?
		$game_player.actor.health += 999
	end

	def self.player_feed
		return if !self.ingame?
		$game_player.actor.sat += 999
	end

	def self.player_rest
		return if !self.ingame?
		$game_player.actor.sta += 999
	end

	def self.toggle_infinite_stats
		self.toggle_infinite_health
		self.toggle_infinite_food
		self.toggle_infinite_stamina
	end
	
	def self.toggle_infinite_health
		$cheat_infinite_health = !$cheat_infinite_health
		FileGetter.cheat_save("Cheats Mod - Modules", "Infinite Health", $cheat_infinite_health)
	end

	def self.toggle_infinite_food
		$cheat_infinite_food = !$cheat_infinite_food
		FileGetter.cheat_save("Cheats Mod - Modules", "Infinite Food", $cheat_infinite_food)
	end

	def self.toggle_infinite_stamina
		$cheat_infinite_stamina = !$cheat_infinite_stamina
		FileGetter.cheat_save("Cheats Mod - Modules", "Infinite Stamina", $cheat_infinite_stamina)
	end
end

class Scene_Base
	alias_method :trigger_debug_window_entry_CHEATSMODULE_AUTOHEAL, :trigger_debug_window_entry
	def trigger_debug_window_entry
		trigger_debug_window_entry_CHEATSMODULE_AUTOHEAL
		if Input.trigger?(Input::F8)
			CheatUtils.heal_player
			SndLib.buff_life
		end
		if Input.trigger?(Input::F5)
			CheatUtils.toggle_infinite_stats
			SndLib.sys_ok
		end
		if $cheat_infinite_health
			CheatUtils.player_heal
		end
		if $cheat_infinite_food
			CheatUtils.player_feed
		end
		if $cheat_infinite_stamina
			CheatUtils.player_rest
		end
	end
end

class Window_DebugCheats
	alias_method :make_command_list_CHEATSMODULE_AUTOHEAL, :make_command_list
	def make_command_list
		make_command_list_CHEATSMODULE_AUTOHEAL
		add_command("#{CheatsMod.getTextInfo("modules/infinitestats:cheat/health")}", :cheatToggle, true, "toggle_infinite_health")
		add_command("#{CheatsMod.getTextInfo("modules/infinitestats:cheat/food")}", :cheatToggle, true, "toggle_infinite_food")
		add_command("#{CheatsMod.getTextInfo("modules/infinitestats:cheat/stamina")}", :cheatToggle, true, "toggle_infinite_stamina")
	end

	alias_method :cheatToggle_CHEATSMODULE_AUTOHEAL, :cheatToggle
	def cheatToggle
		name = current_ext
		begin
			if !name.nil? then
				case name
				when "toggle_infinite_health"
					CheatUtils.toggle_infinite_health
				when "toggle_infinite_food"
					CheatUtils.toggle_infinite_food
				when "toggle_infinite_stamina"
					CheatUtils.toggle_infinite_stamina
				end
			end
		rescue => e
			p "Oops, something gone wrong: cannot do event #{name} because #{e.message}"
			SndLib.sys_buzzer
		end
		cheatToggle_CHEATSMODULE_AUTOHEAL
	end

	alias_method :draw_item_CHEATSMODULE_AUTOHEAL, :draw_item
	def draw_item(index)
		draw_item_CHEATSMODULE_AUTOHEAL(index)
		if @list[index][:ext] =='toggle_infinite_health'
			name = command_name(index)
			text = $cheat_infinite_health ? "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/on")}]" : "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/off")}]"
			draw_item_content(index, name, text)
		end
		if @list[index][:ext] =='toggle_infinite_food'
			name = command_name(index)
			text = $cheat_infinite_food ? "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/on")}]" : "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/off")}]"
			draw_item_content(index, name, text)
		end
		if @list[index][:ext] =='toggle_infinite_stamina'
			name = command_name(index)
			text = $cheat_infinite_stamina ? "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/on")}]" : "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/off")}]"
			draw_item_content(index, name, text)
		end
	end
end
