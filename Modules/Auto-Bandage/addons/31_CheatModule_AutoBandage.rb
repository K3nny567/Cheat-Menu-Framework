# Cheats Mod Module - Auto-Bandage Module

#
module CheatUtils
  def self.bandage_player
    $game_player.actor.heal_wound if self.ingame?
  end

  def self.toggle_autobandage
    $autobandage = !$autobandage
    FileGetter.cheat_save("Cheats Mod - Modules", "Auto-Bandage", $autobandage)
  end
end

module CheatsMod
  self.singleton_class.send(:alias_method, :cheat_triggers_CHEATSMODULE_AUTOBANDAGE, :cheat_triggers)

  ##---------------------------------------------------------------------------
  ## Hotkeys
  ##---------------------------------------------------------------------------
  def self.cheat_triggers
    cheat_triggers_CHEATSMODULE_AUTOBANDAGE
    if Input.trigger?(Input::F7)
      CheatUtils.bandage_player
      SndLib.sound_equip_armor
    end
    if Input.trigger?(Input::F4)
      CheatUtils.toggle_autobandage
      SndLib.sys_ok
    end
    if $autobandage
      CheatUtils.bandage_player
    end
  end
end

class Window_DebugCheats
  alias_method :make_command_list_CHEATSMODULE_AUTOBANDAGE, :make_command_list
  alias_method :cheatToggle_CHEATSMODULE_AUTOBANDAGE, :cheatToggle
  alias_method :draw_item_CHEATSMODULE_AUTOBANDAGE, :draw_item

  def make_command_list
    make_command_list_CHEATSMODULE_AUTOBANDAGE
    add_command("#{$game_text["cheatmenu:modules/autobandage:command"]}", :cheatToggle, true, "toggle_autobandage")
  end

  def cheatToggle
    name = current_ext
    begin
      if !name.nil?
        case name
        when "toggle_autobandage"
          CheatUtils.toggle_autobandage
        end
      end
    rescue => e
      p "Oops, something gone wrong: cannot do event #{name} because #{e.message}"
      SndLib.sys_buzzer
    end
    cheatToggle_CHEATSMODULE_AUTOBANDAGE
  end

  def draw_item(index)
    draw_item_CHEATSMODULE_AUTOBANDAGE(index)
    if @list[index][:ext] == "toggle_autobandage"
      name = command_name(index)
      text = $autobandage ? "[#{$game_text["cheatmenu:menu:cheat_toggle/on"]}]" : "[#{$game_text["cheatmenu:menu:cheat_toggle/off"]}]"
      draw_item_content(index, name, text)
    end
  end
end

if !$CHEATSMOD_CHEATMODULES["Auto-Bandage"]
  $autobandage = FileGetter.cheat_load("Cheats Mod - Modules", "Auto-Bandage", false)
  $CHEATSMOD_CHEATMODULES["Auto-Bandage"] = true
end
