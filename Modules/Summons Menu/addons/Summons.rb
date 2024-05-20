# Cheats Mod Module - Summons Menu

##---------------------------------------------------------------------------
## Summon Menu
##---------------------------------------------------------------------------
class Window_CheatMenuSummon < Window_Command
  #--------------------------------------------------------------------------
  # initialize
  #-------------------------------------------------------------------------
  def initialize
    begin
      @prefix = ""
      @summonable = []
      $data_npcs.all? { |npc| @summonable += [npc[0]] }
      compute_folders
    rescue => e
      p "Oops, something gone wrong: cannot summon event because #{e.message}"
    end
    super(160, 0)
    deactivate
    hide
    refresh
  end

  #--------------------------------------------------------------------------
  # compute_folders
  #-------------------------------------------------------------------------
  def compute_folders
    @folders = []
    $data_EventLib.each_key do |key|
      begin
        next if !@summonable.include? key
        camel_split = key.split(/(?=[A-Z])/).reject { |x| x.empty? }
        unless camel_split.empty?
          @folders.push(camel_split[0])
        end
      rescue => e
        p "Oops, something gone wrong: cannot compute folders because #{e.message}"
      end
    end
    @folders.uniq!
    @folders.sort!
  end

  #--------------------------------------------------------------------------
  # window_width
  #-------------------------------------------------------------------------
  def window_width; return Graphics.width - 160; end

  #--------------------------------------------------------------------------
  # window_height
  #-------------------------------------------------------------------------
  def window_height; return Graphics.height - 120; end

  #--------------------------------------------------------------------------
  # make_command_list
  #-------------------------------------------------------------------------
  def make_command_list
    unless @prefix.empty?
      add_command("#{$mod_cheats.getText("menu:commands/back")}", :subfolder, true, "")
      $data_EventLib.each_key { |key|
        next if !@summonable.include? key
        name = key
        camel_split = name.split(/(?=[A-Z])/).reject { |x| x.empty? }
        if camel_split[0] == @prefix
          text = camel_split.join("")
          add_command(text, :summon, true, key)
        end
      }
    else
      @folders.each { |folder|
        add_command(folder, :subfolder, true, folder)
      }
    end
  rescue => e
    p "Oops, something gone wrong: cannot because #{e.message}"
  end

  def subfolder
    name = current_ext
    begin
      if name.nil?
        name = ""
      end
      @prefix = name
      clear_command_list
      make_command_list
      refresh
      select(0)
      activate
    rescue => e
      p "Oops, something gone wrong: cannot summon event #{name} because #{e.message}"
      SndLib.sys_buzzer
    end
  end

  def summonCurrent
    name = current_ext
    if @prefix.empty? || name == "#{$mod_cheats.getText("menu:commands/back")}" || name.empty?
      return subfolder
    end

    begin
      if !name.nil?
        $game_map.summon_event(name, $game_player.x, $game_player.y)
      end
    rescue => e
      p "Oops, something gone wrong: cannot summon event #{name} because #{e.message}"
      SndLib.sys_buzzer
    end
  end

  def cursor_left(wrap = false)
    cursor_pageup
  end

  def cursor_right(wrap = false)
    cursor_pagedown
  end
end # Window_CheatMenuSummon

module CheatMenuFramework
  module MENU
    COMMANDS << [:summon, "#{$mod_cheats.getText("modules/summons:commands/summon")}"]
  end
end

class Scene_CheatMenu
  alias_method :create_command_window_MODULE_SUMMONS, :create_command_window

  def create_command_window
    create_command_window_MODULE_SUMMONS
    @command_window.set_handler(:summon, method(:command_summon)) if CheatUtils.ingame?
  end

  # Summon Window
  def create_summon_window
    @summon_window = Window_CheatMenuSummon.new
    @summon_window.set_handler(:ok, method(:on_summon_ok))
    @summon_window.set_handler(:cancel, method(:on_summon_cancel))
  end

  def on_summon_ok
    @summon_window.activate
    @summon_window.summonCurrent
  end

  def on_summon_cancel
    @dummy_window.show
    @summon_window.hide
    @command_window.activate
    refresh_help_window(:cancel, "")
  end

  def command_summon
    create_summon_window if @summon_window == nil
    @dummy_window.hide
    @summon_window.show
    @summon_window.activate
    refresh_help_window(:summon, "#{$mod_cheats.getText("modules/summons:command_help/summon_0")}\n#{$mod_cheats.getText("modules/summons:command_help/summon_1")}\n\n")
  end # Summon window
end

$mod_cheats.modules["Summons Menu"] = true
