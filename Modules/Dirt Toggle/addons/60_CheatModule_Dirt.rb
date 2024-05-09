# Cheats Mod Module - Dirt Module

#
class Window_CheatMenuCheats
  alias_method :make_command_list_CHEATSMODULE_DIRT, :make_command_list
  alias_method :cheatToggle_CHEATSMODULE_DIRT, :cheatToggle
  alias_method :draw_item_CHEATSMODULE_DIRT, :draw_item

  def make_command_list
    make_command_list_CHEATSMODULE_DIRT
    add_command("#{$mod_cheats.getText("modules/dirt:cheat/dirt")}", :cheatToggle, true, "toggle_dirt")
  end

  def cheatToggle
    name = current_ext
    begin
      if !name.nil?
        case name
        when "toggle_dirt"
          if ($game_player.actor.actStat.get_stat("dirt", 3) == 0)
            $game_player.actor.actStat.set_stat("dirt", 255, 3)
          else
            $game_player.actor.actStat.set_stat("dirt", 0, 3)
          end
          $game_player.actor.actStat.check_stat
        end
      end
    rescue => e
      p "Oops, something gone wrong: cannot do event #{name} because #{e.message}"
      SndLib.sys_buzzer
    end
    cheatToggle_CHEATSMODULE_DIRT
  end

  def draw_item(index)
    draw_item_CHEATSMODULE_DIRT(index)
    if @list[index][:ext] == "toggle_dirt"
      name = command_name(index)
      text = $game_player.actor.actStat.get_stat("dirt", 3) == 0 ? "[#{$mod_cheats.getText("menu:cheat_toggle/off")}]" : "[#{$mod_cheats.getText("menu:cheat_toggle/on")}]"
      draw_item_content(index, name, text)
    end
  end
end

if !$mod_cheats.modules["Dirt"]
  $mod_cheats.modules["Dirt"] = true
end
