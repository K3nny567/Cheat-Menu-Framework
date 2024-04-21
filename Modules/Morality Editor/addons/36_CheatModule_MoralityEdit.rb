# Cheats Mod Module - Morality Editor

#==============================================================================
# Window_DebugMorals
#==============================================================================
class Window_DebugMorals < Window_Command

  #--------------------------------------------------------------------------
  # initialize
  #-------------------------------------------------------------------------
  def initialize
    super(160, 0)
    deactivate
    hide
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
    add_command("", :morality, true, "#{$game_text["cheatmenu:modules/moralityedit:commands_morality/command"]}")
  end

  def morality
    # dummy
  end

  def updateMorality
    $game_player.actor.morality = $game_player.actor.morality_lona + ($game_player.actor.morality_plus-200)
  end

  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    updateMorality
    contents.clear_rect(item_rect_for_text(index))
    rect = item_rect_for_text(index)
    name = @list[index][:ext]
    change_color(param_change_color($game_player.actor.morality))
    draw_text(rect, command_name(index))
    rect.x += text_size(command_name(index)).width
    rect.width -= text_size(command_name(index)).width
    draw_text(rect, name)
    text = sprintf("%s", $game_player.actor.morality)
    draw_text(rect, text, 2)
  end

  #--------------------------------------------------------------------------
  # cursor_right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    SndLib.play_cursor
    $game_player.actor.morality_lona += Input.press?(Input::KEYMAP[:SHIFT]) ? 10 : 1
    $game_player.actor.morality_lona += Input.press?(Input::KEYMAP[:ALT]) ? 99 : 0
    draw_item(index)
  end

  #--------------------------------------------------------------------------
  # cursor_left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    SndLib.play_cursor
    $game_player.actor.morality_lona -= Input.press?(Input::KEYMAP[:SHIFT]) ? 10 : 1
    $game_player.actor.morality_lona -= Input.press?(Input::KEYMAP[:ALT]) ? 99 : 0
    draw_item(index)
  end
end # Window_DebugMorals

module YEA
  module DEBUG
    COMMANDS << [:set_morality, "#{$game_text["cheatmenu:modules/moralityedit:commands/morality"]}"]
  end
end

class Scene_Debug
  alias_method :create_command_window_MODULE_MORALITYEDIT, :create_command_window

  def create_command_window
    create_command_window_MODULE_MORALITYEDIT
    @command_window.set_handler(:set_morality, method(:command_morality)) if CheatUtils.ingame?
  end

  # Morality Window
  def create_morals_windows
    @morals_window = Window_DebugMorals.new
    @morals_window.set_handler(:cancel, method(:on_morals_cancel))
  end

  def on_morals_cancel
    @dummy_window.show
    @morals_window.hide
    @command_window.activate
    refresh_help_window(:cancel, "")
  end

  def command_morality
    create_morals_windows if @morals_window == nil
    @dummy_window.hide
    @morals_window.show
    @morals_window.activate
    refresh_help_window(@command_window.current_symbol, "#{$game_text["cheatmenu:modules/moralityedit:command_help/morality_0"]}\n#{$game_text["cheatmenu:modules/moralityedit:command_help/morality_1"]}\n#{$game_text["cheatmenu:modules/moralityedit:command_help/morality_2"]}\n#{$game_text["cheatmenu:modules/moralityedit:command_help/morality_3"]}")
  end # Morality Window
end

$CHEATSMOD_CHEATMODULES["Morality Editor"] = true
