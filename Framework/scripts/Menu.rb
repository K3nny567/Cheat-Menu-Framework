# Cheat Menu Framework: Menu

##---------------------------------------------------------------------------
## Hotkeys
##---------------------------------------------------------------------------
class CheatsMod
  alias_method :cheat_triggers_CHEATMENUFRAMEWORK, :cheat_triggers
  def cheat_triggers
    cheat_triggers_CHEATMENUFRAMEWORK
    if Input.trigger?(:F9)
      unless SceneManager.scene_is?(Scene_CheatMenu)
        SceneManager.call(Scene_CheatMenu) if CheatUtils.ingame?
      end
    end
  end
end

##---------------------------------------------------------------------------
## Installed Modules
##---------------------------------------------------------------------------
class Window_CheatMenuModules < Window_Command

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
    add_command("#{$mod_cheats.getText("menu:modules/installed_count")} #{$mod_cheats.modules.size}", :moduleToggle, false)
    add_command("--------------", :moduleToggle, false)
    $mod_cheats.modules.map { |key, _| add_command("#{$mod_cheats.getText("menu:modules/prefix")} #{key.to_sym}", :moduleToggle, false) }
  end

  def moduleToggle
    # leave empty
  end

  def draw_item(index)
    name = command_name(index)
    contents.clear_rect(item_rect_for_text(index))
    draw_text(item_rect_for_text(index), name, 0)
  end

  def cursor_left(wrap = false)
    cursor_pageup
  end

  def cursor_right(wrap = false)
    cursor_pagedown
  end
end # Window_CheatMenuModules

##---------------------------------------------------------------------------
## Cheats Menu
##---------------------------------------------------------------------------
class Window_CheatMenuCheats < Window_Command

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
    # override me
  end

  def cheatToggle
    name = current_ext
    refresh
  end

  def draw_item(index)
    # override me
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
end # Window_CheatMenuCheats

module CheatMenuFramework
  module MENU
    COMMANDS = Array.new
    COMMANDS << [:modules, "#{$mod_cheats.getText("menu:commands/modules")}"]
    COMMANDS << [:toggle_cheats, "#{$mod_cheats.getText("menu:commands/cheats")}"]
  end
end

#==============================================================================
# Window_CheatMenuCommand
#==============================================================================
class Window_CheatMenuCommand < Window_Command

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
    for command in CheatMenuFramework::MENU::COMMANDS
      add_command(command[1], command[0])
    end
  end
end # Window_CheatMenuCommand

class Scene_CheatMenu < Scene_MenuBase
  def start
    super
    create_command_window
    create_help_window
    create_dummy_window
  end

  def update
    super
    return_scene if Input.trigger?(:F9)
  end

  def terminate
    super
    #$game_map.refresh
  end

  def create_command_window
    @command_window = Window_CheatMenuCommand.new
    @command_window.set_handler(:cancel, method(:return_scene))
    @command_window.set_handler(:modules, method(:command_modules))
    @command_window.set_handler(:toggle_cheats, method(:command_toggle_cheats)) if CheatUtils.ingame?
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

  # Installed Modules Window
  def create_modules_window
    @modules_window = Window_CheatMenuModules.new
    @modules_window.set_handler(:ok, method(:on_modules_ok))
    @modules_window.set_handler(:cancel, method(:on_modules_cancel))
  end

  def on_modules_ok
    @modules_window.activate
  end

  def on_modules_cancel
    @dummy_window.show
    @modules_window.hide
    @command_window.activate
    refresh_help_window(:cancel, "")
  end

  def command_modules
    create_modules_window if @modules_window == nil
    @dummy_window.hide
    @modules_window.show
    @modules_window.activate
    refresh_help_window(:modules, "")
  end # Installed Modules Window

  # Toggle Cheats Window
  def create_cheats_window
    @cheats_window = Window_CheatMenuCheats.new
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
    refresh_help_window(:toggle_cheats, "#{$mod_cheats.getText("menu:command_help/cheats_0")}\n#{$mod_cheats.getText("menu:command_help/cheats_1")}\n\n")
  end # Toggle Cheats Window

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
