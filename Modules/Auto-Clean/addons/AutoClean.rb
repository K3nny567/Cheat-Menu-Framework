# Cheats Mod Module - Auto-Clean Module

#
module CheatUtils
  def self.clean_player
    $game_player.actor.cumsMap.each do |state, id|
      $game_player.actor.healCums(state, 1000) if self.ingame?
    end
  end

  def self.toggle_autoclean
    $autoclean = !$autoclean
    $mod_cheats.config.write("Cheats Mod - Modules", "Auto-Clean", $autoclean)
  end
end

class CheatsMod
  alias_method :cheat_triggers_CHEATSMODULE_AUTOCLEAN, :cheat_triggers

  ##---------------------------------------------------------------------------
  ## Hotkeys
  ##---------------------------------------------------------------------------
  def cheat_triggers
    cheat_triggers_CHEATSMODULE_AUTOCLEAN
    if Input.trigger?(Input::F7)
      CheatUtils.clean_player
      SndLib.sound_WaterSpla
    end
    if Input.trigger?(Input::F4)
      CheatUtils.toggle_autoclean
      SndLib.sys_ok
    end
    if $autoclean
      CheatUtils.clean_player
    end
  end
end

class Window_CheatMenuCheats
  alias_method :make_command_list_CHEATSMODULE_AUTOCLEAN, :make_command_list
  alias_method :cheatToggle_CHEATSMODULE_AUTOCLEAN, :cheatToggle
  alias_method :draw_item_CHEATSMODULE_AUTOCLEAN, :draw_item

  def make_command_list
    make_command_list_CHEATSMODULE_AUTOCLEAN
    add_command("#{$mod_cheats.getText("modules/autoclean:command")}", :cheatToggle, true, "toggle_autoclean")
  end

  def cheatToggle
    name = current_ext
    begin
      if !name.nil?
        case name
        when "toggle_autoclean"
          CheatUtils.toggle_autoclean
        end
      end
    rescue => e
      p "Oops, something gone wrong: cannot do event #{name} because #{e.message}"
      SndLib.sys_buzzer
    end
    cheatToggle_CHEATSMODULE_AUTOCLEAN
  end

  def draw_item(index)
    draw_item_CHEATSMODULE_AUTOCLEAN(index)
    if @list[index][:ext] == "toggle_autoclean"
      name = command_name(index)
      text = $autoclean ? "[#{$mod_cheats.getText("menu:cheat_toggle/on")}]" : "[#{$mod_cheats.getText("menu:cheat_toggle/off")}]"
      draw_item_content(index, name, text)
    end
  end
end

if !$mod_cheats.modules["Auto-Clean"]
  $autoclean = $mod_cheats.config.read("Cheats Mod - Modules", "Auto-Clean", false)
  $mod_cheats.modules["Auto-Clean"] = true
end
