# Cheats Mod Module - Infinite Money Module

#

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
    $mod_cheats.config.write("Cheats Mod - Modules", "Infinite Money", $cheat_infinite_money)
  end
end

class CheatsMod
  alias_method :cheat_triggers_CHEATSMODULE_INFINITE_MONEY, :cheat_triggers

  ##---------------------------------------------------------------------------
  ## Hotkeys
  ##---------------------------------------------------------------------------
  def cheat_triggers
    cheat_triggers_CHEATSMODULE_INFINITE_MONEY
    if Input.trigger?(Input::F6)
      $game_party.gain_gold(99999) if CheatUtils.ingame?
      SndLib.sys_ok
    end
    if $cheat_infinite_money
      CheatUtils.set_gold if $game_party.gold != 99999
    end
  end
end

class Window_CheatMenuCheats
  alias_method :make_command_list_CHEATSMODULE_INFINITE_MONEY, :make_command_list
  alias_method :cheatToggle_CHEATSMODULE_INFINITE_MONEY, :cheatToggle
  alias_method :draw_item_CHEATSMODULE_INFINITE_MONEY, :draw_item

  def make_command_list
    make_command_list_CHEATSMODULE_INFINITE_MONEY
    add_command("#{$mod_cheats.getText("modules/infinitemoney:command")}", :cheatToggle, true, "toggle_infinite_money")
  end

  def cheatToggle
    name = current_ext
    begin
      if !name.nil?
        case name
        when "toggle_infinite_money"
          CheatUtils.toggle_infinite_money
        end
      end
    rescue => e
      p "Oops, something gone wrong: cannot do event #{name} because #{e.message}"
      SndLib.sys_buzzer
    end
    cheatToggle_CHEATSMODULE_INFINITE_MONEY
  end

  def draw_item(index)
    draw_item_CHEATSMODULE_INFINITE_MONEY(index)
    if @list[index][:ext] == "toggle_infinite_money"
      name = command_name(index)
      text = $cheat_infinite_money ? "[#{$mod_cheats.getText("menu:cheat_toggle/on")}]" : "[#{$mod_cheats.getText("menu:cheat_toggle/off")}]"
      draw_item_content(index, name, text)
    end
  end
end

if !$mod_cheats.modules["Infinite Money"]
  $cheat_infinite_money = $mod_cheats.config.read("Cheats Mod - Modules", "Infinite Money", false)
  $mod_cheats.modules["Infinite Money"] = true
end
