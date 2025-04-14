# Cheats Mod Module - DisplayPortrait Module

#

module CheatUtils

  def self.toggle_displayportrait
    $cheat_displayportrait = !$cheat_displayportrait
    $mod_cheats.config.write("Cheats Mod - Modules", "Display Portrait", $cheat_displayportrait)
  end
end

class CheatsMod
  alias_method :cheat_triggers_CHEATSMODULE_DISPLAYPORTRAIT, :cheat_triggers

  ##---------------------------------------------------------------------------
  ## Hotkeys
  ##---------------------------------------------------------------------------
  def cheat_triggers
    cheat_triggers_CHEATSMODULE_DISPLAYPORTRAIT
    if $cheat_displayportrait
      $game_player.actor.portrait.portrait.visible = true
      $game_player.actor.portrait.portrait.update
    end
  end
end

class Window_CheatMenuCheats
  alias_method :make_command_list_CHEATSMODULE_DISPLAYPORTRAIT, :make_command_list
  alias_method :cheatToggle_CHEATSMODULE_DISPLAYPORTRAIT, :cheatToggle
  alias_method :draw_item_CHEATSMODULE_DISPLAYPORTRAIT, :draw_item

  def make_command_list
    make_command_list_CHEATSMODULE_DISPLAYPORTRAIT
    add_command("#{$mod_cheats.getText("modules/displayportrait:command")}", :cheatToggle, true, "toggle_displayportrait")
  end

  def cheatToggle
    name = current_ext
    begin
      if !name.nil?
        case name
        when "toggle_displayportrait"
          CheatUtils.toggle_displayportrait
        end
      end
    rescue => e
      p "Oops, something gone wrong: cannot do event #{name} because #{e.message}"
      SndLib.sys_buzzer
    end
    cheatToggle_CHEATSMODULE_DISPLAYPORTRAIT
  end

  def draw_item(index)
    draw_item_CHEATSMODULE_DISPLAYPORTRAIT(index)
    if @list[index][:ext] == "toggle_displayportrait"
      name = command_name(index)
      text = $cheat_displayportrait ? "[#{$mod_cheats.getText("menu:cheat_toggle/on")}]" : "[#{$mod_cheats.getText("menu:cheat_toggle/off")}]"
      draw_item_content(index, name, text)
    end
  end
end

if !$mod_cheats.modules["Display Portrait"]
  $cheat_displayportrait = $mod_cheats.config.read("Cheats Mod - Modules", "Display Portrait", false)
  $mod_cheats.modules["Display Portrait"] = true
end
