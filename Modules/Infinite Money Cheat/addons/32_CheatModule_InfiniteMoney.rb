# Cheats Mod Module - Infinite Money Module

$cheat_infinite_money = FileGetter.cheat_load("Cheats Mod - Modules", "Infinite Money", false)

class Game_Party
	def set_gold_only(amount)
		@gold = amount
	end
end

module CheatUtils
	def self.set_gold
		$game_party.set_gold_only(99999) if self.ingame?
	end
	
	def self.toggle_infinite_money
		$cheat_infinite_money = !$cheat_infinite_money
		FileGetter.cheat_save("Cheats Mod - Modules", "Infinite Money", $cheat_infinite_money)
	end
end

class Scene_Base
	alias_method :trigger_debug_window_entry_CHEATSMODULE_INFINITE_MONEY, :trigger_debug_window_entry
	def trigger_debug_window_entry
		trigger_debug_window_entry_CHEATSMODULE_INFINITE_MONEY
		if $cheat_infinite_money
			CheatUtils.set_gold if $game_party.gold != 99999
		end
	end
end

class Window_DebugCheats
	alias_method :make_command_list_CHEATSMODULE_INFINITE_MONEY, :make_command_list
	def make_command_list
		make_command_list_CHEATSMODULE_INFINITE_MONEY
		add_command("#{CheatsMod.getTextInfo("modules/infinitemoney:command")}", :cheatToggle, true, "toggle_infinite_money")
	end

	alias_method :cheatToggle_CHEATSMODULE_INFINITE_MONEY, :cheatToggle
	def cheatToggle
		name = current_ext
		begin
			if !name.nil? then
				case name
				when 'toggle_infinite_money'
					CheatUtils.toggle_infinite_money
				end
			end
		rescue => e
			p "Oops, something gone wrong: cannot do event #{name} because #{e.message}"
			SndLib.sys_buzzer
		end
		cheatToggle_CHEATSMODULE_INFINITE_MONEY
	end

	alias_method :draw_item_CHEATSMODULE_INFINITE_MONEY, :draw_item
	def draw_item(index)
		draw_item_CHEATSMODULE_INFINITE_MONEY(index)
		if @list[index][:ext] == 'toggle_infinite_money'
			name = command_name(index)
			text = $cheat_infinite_money ? "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/on")}]" : "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/off")}]"
			draw_item_content(index, name, text)
		end
	end
end
