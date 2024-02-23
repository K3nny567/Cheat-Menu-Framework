# Cheat Menu Framework: Menu

##---------------------------------------------------------------------------
## Hotkeys
##---------------------------------------------------------------------------
module CheatsMod
  self.singleton_class.send(:alias_method, :cheat_triggers_CHEATMENUFRAMEWORK, :cheat_triggers)
  def self.cheat_triggers
    cheat_triggers_CHEATMENUFRAMEWORK
    if Input.trigger?(Input::F9)
      SceneManager.call(Scene_Debug) if CheatUtils.ingame?
    end
  end
end

##---------------------------------------------------------------------------
## Cheats Menu
##---------------------------------------------------------------------------
class Window_DebugCheats < Window_Command

  #--------------------------------------------------------------------------
  # initialize
  #-------------------------------------------------------------------------
  def initialize
    super(160, 0)
    deactivate
    hide
    refresh
  end

  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return Graphics.width - 160; end

  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height - 120; end

  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
  end

  def cheatToggle
    name = current_ext
    refresh
  end

  def draw_item(index)
  end

  def draw_item_content(index, name = "", text = "")
    contents.clear_rect(item_rect_for_text(index))
    draw_text(item_rect_for_text(index), name, 0)
    draw_text(item_rect_for_text(index), text, 2)
  end

  def cursor_left(wrap = false)
    cursor_pageup
  end

  def cursor_right(wrap = false)
    cursor_pagedown
  end
end # Window_DebugCheats

module YEA
  module DEBUG
    COMMANDS = [
      [:toggle_cheats, "#{$game_text["cheatmenu:menu:commands/cheats"]}"],
      [:heal, "#{$game_text["cheatmenu:menu:commands/heal"]}"],
      [:healw, "#{$game_text["cheatmenu:menu:commands/healw"]}"],
      [:fall, "#{$game_text["cheatmenu:menu:commands/fall"]}"],
      [:gib, "#{$game_text["cheatmenu:menu:commands/gib"]}"],
      [:lvl99, "#{$game_text["cheatmenu:menu:commands/lvl99"]}"],
      [:stronk, "#{$game_text["cheatmenu:menu:commands/stronk"]}"],
    ]
  end
end

#==============================================================================
# Window_DebugCommand
#==============================================================================
class Window_DebugCommand < Window_Command

  #--------------------------------------------------------------------------
  # initialize
  #--------------------------------------------------------------------------
  def initialize; super(0, 0); end

  #--------------------------------------------------------------------------
  # window_width
  #--------------------------------------------------------------------------
  def window_width; return 160; end

  #--------------------------------------------------------------------------
  # window_height
  #--------------------------------------------------------------------------
  def window_height; return Graphics.height; end

  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    for command in YEA::DEBUG::COMMANDS
      add_command(command[1], command[0])
    end
  end
end # Window_DebugCommand

class Scene_Debug < Scene_MenuBase
  def start
    super
    create_all_windows
  end

  def update
    super
    return_scene if Input.trigger?(:F9)
  end

  def create_all_windows
    create_command_window
    create_help_window
    create_dummy_window
  end

  def create_command_window
    @command_window = Window_DebugCommand.new
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:toggle_cheats, method(:command_toggle_cheats)) if CheatUtils.ingame?
    @command_window.set_handler(:heal, method(:command_heal)) if CheatUtils.ingame?
    @command_window.set_handler(:healw, method(:command_healwound)) if CheatUtils.ingame?
    @command_window.set_handler(:fall, method(:command_exhaust)) if CheatUtils.ingame?
    @command_window.set_handler(:gib, method(:command_gib_moneh)) if CheatUtils.ingame?
    @command_window.set_handler(:lvl99, method(:command_lvl_99)) if CheatUtils.ingame?
    @command_window.set_handler(:stronk, method(:command_make_stronk)) if CheatUtils.ingame?
  end

  def create_help_window
    wx = @command_window.width
    wy = Graphics.height - 120
    ww = Graphics.width - wx
    wh = 120
    @help_window = Window_Base.new(wx, wy, ww, wh)
  end

  def create_dummy_window
    wx = @command_window.width
    ww = Graphics.width - wx
    wh = Graphics.height - @help_window.height
    @dummy_window = Window_Base.new(wx, 0, ww, wh)
  end

  # Toggle Cheats Window
  def create_cheats_window
    @cheats_window = Window_DebugCheats.new
    @cheats_window.set_handler(:ok, method(:on_cheats_ok))
    @cheats_window.set_handler(:cancel, method(:on_cheats_cancel))
  end

  def on_cheats_ok
    @cheats_window.activate
    @cheats_window.cheatToggle
  end

  def on_cheats_cancel
    @dummy_window.show
    @cheats_window.hide
    @command_window.activate
    refresh_help_window(:cancel, "")
  end

  def command_toggle_cheats
    create_cheats_window if @cheats_window == nil
    @dummy_window.hide
    @cheats_window.show
    @cheats_window.activate
    refresh_help_window(:toggle_cheats, "#{$game_text["cheatmenu:menu:command_help/cheats_0"]}\n#{$game_text["cheatmenu:menu:command_help/cheats_1"]}\n\n")
  end # Toggle Cheats Window

  def command_heal
    $game_player.actor.health += 999
    $game_player.actor.sta += 999
    $game_player.actor.sat += 999
    @command_window.activate
    refresh_help_window(:heal, "")
  end

  def command_healwound
    $game_player.actor.heal_wound
    @command_window.activate
    refresh_help_window(:healw, "")
  end

  def command_exhaust
    $game_player.actor.sta = -100
    @command_window.activate
    refresh_help_window(:fall, "")
  end

  def command_gib_moneh
    $game_party.gain_gold(99999)
    @command_window.activate
    refresh_help_window(:gib, "")
  end

  def command_lvl_99
    $game_player.actor.change_level(99, true)
    @command_window.activate
    refresh_help_window(:lvl99, "")
  end

  def command_make_stronk
    $game_player.actor.trait_point = 999
    @command_window.activate
    refresh_help_window(:stronk, "")
  end

  def refresh_help_window(symbolName, symbolText)
    if @command_window.active
      text = ""
    else
      case @command_window.current_symbol
      when symbolName
        text = symbolText
      else
        text = ""
      end
    end
    @help_window.contents.clear
    @help_window.draw_text_ex(4, 0, text)
  end
end
