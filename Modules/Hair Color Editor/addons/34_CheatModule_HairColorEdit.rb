# Cheats Mod Module - Hair Color Editor

#--------------------------------------------------------------------------
# Window_CheatMenuHairColor
#--------------------------------------------------------------------------

class Window_CheatMenuHairColor < Window_Command
  def minmaxHairColor(value)
    return 5 if value < 0
    return 0 if value > 5
    return value
  end

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
    add_command("", :colorCurrent, true, "#{$mod_cheats.getText("modules/haircoloredit:command_ext")}")
  end

  def colorCurrent
    # dummy
  end

  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    contents.clear_rect(item_rect_for_text(index))
    rect = item_rect_for_text(index)
    name = @list[index][:ext]
    change_color(param_change_color($game_player.actor.record_HairColor))
    draw_text(rect, command_name(index))
    rect.x += text_size(command_name(index)).width
    rect.width -= text_size(command_name(index)).width
    draw_text(rect, name)
    text = sprintf("%s", $game_player.actor.record_HairColor)
    draw_text(rect, text, 2)
  end

  #--------------------------------------------------------------------------
  # cursor_right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    SndLib.play_cursor
    $game_player.actor.record_HairColor += 1
    $game_player.actor.record_HairColor = minmaxHairColor($game_player.actor.record_HairColor)
    draw_item(index)
  end

  #--------------------------------------------------------------------------
  # cursor_left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    SndLib.play_cursor
    $game_player.actor.record_HairColor -= 1
    $game_player.actor.record_HairColor = minmaxHairColor($game_player.actor.record_HairColor)
    draw_item(index)
  end
end # Window_CheatMenuHairColor

module CheatMenuFramework
  module MENU
    COMMANDS << [:haircolor, "#{$mod_cheats.getText("modules/haircoloredit:command_desc")}"]
  end
end

class Scene_CheatMenu
  alias_method :create_command_window_MODULE_HAIRCOLOREDIT, :create_command_window

  def create_command_window
    create_command_window_MODULE_HAIRCOLOREDIT
    @command_window.set_handler(:haircolor, method(:command_haircolor)) if CheatUtils.ingame?
  end

  def create_haircolor_window
    @haircolor_window = Window_CheatMenuHairColor.new
    @haircolor_window.set_handler(:cancel, method(:on_haircolor_cancel))
  end

  def command_haircolor
    create_haircolor_window if @haircolor_window == nil
    @dummy_window.hide
    @haircolor_window.show
    @haircolor_window.activate
    refresh_help_window(:haircolor, "#{$mod_cheats.getText("modules/haircoloredit:command_help_0")}\n#{$mod_cheats.getText("modules/haircoloredit:command_help_1")}\n#{$mod_cheats.getText("modules/haircoloredit:command_help_2")}\n#{$mod_cheats.getText("modules/haircoloredit:command_help_3")}")
  end

  def on_haircolor_cancel
    @dummy_window.show
    @haircolor_window.hide
    @command_window.activate
    refresh_help_window(:cancel, "")
  end
end

$mod_cheats.modules["Hair Color Editor"] = true
