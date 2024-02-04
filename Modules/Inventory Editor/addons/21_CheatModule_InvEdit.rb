# Cheats Mod Module - Inventory Editor

#--------------------------------------------------------------------------
# Window_DebugItem
#--------------------------------------------------------------------------

class Window_DebugItem < Window_Command

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
  # set_type
  #--------------------------------------------------------------------------
  def set_type(type)
    @type = type
    refresh
    select(0)
  end

  #--------------------------------------------------------------------------
  # make_command_list
  #--------------------------------------------------------------------------
  def make_command_list
    case @type
    when :items
      group = $data_items
      fmt = "I%03d:"
    when :weapons
      group = $data_weapons
      fmt = "W%03d:"
    else
      group = $data_armors
      fmt = "A%03d:"
    end
    for i in 1...group.size
      text = sprintf(fmt, i)
      add_command(text, :item, true, group[i]) if !group[i].item_name.nil?
    end
  end

  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    contents.clear_rect(item_rect_for_text(index))
    rect = item_rect_for_text(index)
    item = @list[index][:ext]
    name = item.name
    change_color(normal_color, $game_party.item_number(item) > 0)
    if $game_party.item_number(item) > 0 && item.name == ""
      change_color(knockout_color)
      name = "#{$game_text["cheatmenu:menu:info/alert"]}"
    end
    draw_text(rect, command_name(index))
    rect.x += text_size(command_name(index)).width
    rect.width -= text_size(command_name(index)).width
    draw_icon(item.icon_index, rect.x, rect.y, $game_party.item_number(item) > 0)
    rect.x += 24
    rect.width -= 24
    draw_text(rect, name)
    text = sprintf("×%s", $game_party.item_number(item))
    draw_text(rect, text, 2)
  end

  #--------------------------------------------------------------------------
  # cursor_right
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    SndLib.play_cursor
    $game_party.gain_item(current_ext, Input.press?(Input::KEYMAP[:SHIFT]) ? 10 : 1)
    $game_party.gain_item(current_ext, Input.press?(Input::KEYMAP[:ALT]) ? 99 : 0)
    draw_item(index)
  end

  #--------------------------------------------------------------------------
  # cursor_left
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    SndLib.play_cursor
    $game_party.lose_item(current_ext, Input.press?(Input::KEYMAP[:SHIFT]) ? 10 : 1)
    $game_party.lose_item(current_ext, Input.press?(Input::KEYMAP[:ALT]) ? 99 : 0)
    draw_item(index)
  end
end # Window_DebugItem

module YEA
  module DEBUG
    COMMANDS.insert(1, [:items, "#{$game_text["cheatmenu:modules/invedit:commands/items"]}"])
    COMMANDS.insert(2, [:weapons, "#{$game_text["cheatmenu:modules/invedit:commands/weapons"]}"])
    COMMANDS.insert(3, [:armors, "#{$game_text["cheatmenu:modules/invedit:commands/armors"]}"])
  end
end

class Scene_Debug
  alias_method :create_command_window_MODULE_INVEDIT, :create_command_window

  def create_command_window
    create_command_window_MODULE_INVEDIT
    @command_window.set_handler(:items, method(:command_items)) if CheatUtils.ingame?
    @command_window.set_handler(:weapons, method(:command_items)) if CheatUtils.ingame?
    @command_window.set_handler(:armors, method(:command_items)) if CheatUtils.ingame?
  end

  #--------------------------------------------------------------------------
  # new method: create_item_windows
  #--------------------------------------------------------------------------
  def create_item_windows
    @item_window = Window_DebugItem.new
    @item_window.set_handler(:cancel, method(:on_item_cancel))
  end

  #--------------------------------------------------------------------------
  # new method: command_items
  #--------------------------------------------------------------------------
  def command_items
    create_item_windows if @item_window == nil
    @dummy_window.hide
    @item_window.show
    @item_window.activate
    @item_window.set_type(@command_window.current_symbol)
    refresh_help_window(@command_window.current_symbol, "#{$game_text["cheatmenu:modules/invedit:command_help/items_0"]}\n#{$game_text["cheatmenu:modules/invedit:command_help/items_1"]}\n#{$game_text["cheatmenu:modules/invedit:command_help/items_2"]}\n#{$game_text["cheatmenu:modules/invedit:command_help/items_3"]}")
  end

  #--------------------------------------------------------------------------
  # new method: on_item_cancel
  #--------------------------------------------------------------------------
  def on_item_cancel
    @dummy_window.show
    @item_window.hide
    @command_window.activate
    refresh_help_window(:cancel, "")
  end
end

$CHEATSMOD_CHEATMODULES["Inventory Editor"] = true
