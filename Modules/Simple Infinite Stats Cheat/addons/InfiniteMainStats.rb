# Cheats Mod Module - Infinite Main Stats

#

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
    return if $game_player.cannot_trigger
    $game_player.actor.sta += 999
  end

  def self.toggle_infinite_stats
    self.toggle_infinite_health
    self.toggle_infinite_food
    self.toggle_infinite_stamina
  end

  def self.toggle_infinite_health
    $cheat_infinite_health = !$cheat_infinite_health
    $mod_cheats.config.write("Cheats Mod - Modules", "Infinite Health", $cheat_infinite_health)
  end

  def self.toggle_infinite_food
    $cheat_infinite_food = !$cheat_infinite_food
    $mod_cheats.config.write("Cheats Mod - Modules", "Infinite Food", $cheat_infinite_food)
  end

  def self.toggle_infinite_stamina
    $cheat_infinite_stamina = !$cheat_infinite_stamina
    $mod_cheats.config.write("Cheats Mod - Modules", "Infinite Stamina", $cheat_infinite_stamina)
  end
end

class CheatsMod
  alias_method :cheat_triggers_CHEATSMODULE_AUTOHEAL, :cheat_triggers

  ##---------------------------------------------------------------------------
  ## Hotkeys
  ##---------------------------------------------------------------------------
  def cheat_triggers
    cheat_triggers_CHEATSMODULE_AUTOHEAL
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

class Window_CheatMenuCheats
  alias_method :make_command_list_CHEATSMODULE_AUTOHEAL, :make_command_list
  alias_method :cheatToggle_CHEATSMODULE_AUTOHEAL, :cheatToggle
  alias_method :draw_item_CHEATSMODULE_AUTOHEAL, :draw_item

  def make_command_list
    make_command_list_CHEATSMODULE_AUTOHEAL
    add_command("#{$mod_cheats.getText("modules/infinitestats:cheat/health")}", :cheatToggle, true, "toggle_infinite_health")
    add_command("#{$mod_cheats.getText("modules/infinitestats:cheat/food")}", :cheatToggle, true, "toggle_infinite_food")
    add_command("#{$mod_cheats.getText("modules/infinitestats:cheat/stamina")}", :cheatToggle, true, "toggle_infinite_stamina")
  end

  def cheatToggle
    name = current_ext
    begin
      if !name.nil?
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

  def draw_item(index)
    draw_item_CHEATSMODULE_AUTOHEAL(index)
    if @list[index][:ext] == "toggle_infinite_health"
      name = command_name(index)
      text = $cheat_infinite_health ? "[#{$mod_cheats.getText("menu:cheat_toggle/on")}]" : "[#{$mod_cheats.getText("menu:cheat_toggle/off")}]"
      draw_item_content(index, name, text)
    end
    if @list[index][:ext] == "toggle_infinite_food"
      name = command_name(index)
      text = $cheat_infinite_food ? "[#{$mod_cheats.getText("menu:cheat_toggle/on")}]" : "[#{$mod_cheats.getText("menu:cheat_toggle/off")}]"
      draw_item_content(index, name, text)
    end
    if @list[index][:ext] == "toggle_infinite_stamina"
      name = command_name(index)
      text = $cheat_infinite_stamina ? "[#{$mod_cheats.getText("menu:cheat_toggle/on")}]" : "[#{$mod_cheats.getText("menu:cheat_toggle/off")}]"
      draw_item_content(index, name, text)
    end
  end
end

if !$mod_cheats.modules["Infinite Main Stats"]
  $cheat_infinite_health = $mod_cheats.config.read("Cheats Mod - Modules", "Infinite Health", false)
  $cheat_infinite_food = $mod_cheats.config.read("Cheats Mod - Modules", "Infinite Food", false)
  $cheat_infinite_stamina = $mod_cheats.config.read("Cheats Mod - Modules", "Infinite Stamina", false)

  $mod_cheats.modules["Infinite Main Stats"] = true
end
