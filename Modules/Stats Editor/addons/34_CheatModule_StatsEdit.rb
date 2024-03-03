# Cheats Mod Module - Stats Editor

#

class Game_Actor
  def remove_one_state(state_id)
    state_id = $data_StateName[state_id].id if state_id.is_a?(String)
    return prp "erase_state #{state_id} not found", 1 if !state_id
    @states.delete_at(@states.index(state_id) || @states.length) ## Line added to remove only one instance.
    return if state?(state_id) ## Line added to prevent a stack from bugging.
    @state_turns.delete(state_id)
    @state_steps.delete(state_id)
  end
end

class Window_DebugStats < Window_Command
  def initialize(help_window)
    @stats_help_window = help_window
    super(160, 0)
    deactivate
    hide
    refresh
  end

  def window_width
    return ((Graphics.width - 160) / 2)
  end

  def window_height
    return Graphics.height - 120
  end

  def make_command_list
    $data_StateName.each_pair do |k, v|
      if v != nil and k != nil
        add_command("", :drawStat, true, [k, v])
      end
    end
  end

  def drawStat
  end

  def activate
    super
    if @list.size > 0
      @stats_help_window.draw_text_ex(4, 0, prep_desc(@list[0][:ext][1].description))
    end
  end

  def draw_item(index)
    contents.clear_rect(item_rect_for_text(index))
    rect = item_rect_for_text(index)
    item = @list[index][:ext][1]
    name = @list[index][:ext][0]
    stack = $game_player.actor.state_stack(name)
    change_color(normal_color, stack)
    draw_icon(item.icon_index, rect.x, rect.y, stack)
    rect.x += 24
    rect.width -= 24
    if item.name.empty?
      draw_text(rect, name)
    else
      draw_text(rect, item.name)
    end
    text = sprintf("%s/%s", stack, item.max_stacks)
    draw_text(rect, text, 2)
  end

  def cursor_right(wrap = false)
    SndLib.play_cursor
    $game_player.actor.add_state(current_ext[0])
    draw_item(index)
  end

  def cursor_left(wrap = false)
    SndLib.play_cursor
    $game_player.actor.remove_one_state(current_ext[0])
    $game_player.actor.update_state_portrait_stat(current_ext[0])
    draw_item(index)
  end

  def prep_desc(desc)
    begin
      desc.gsub "\\n", "\n"
    rescue => e
      p "Got #{e.message}"
      ""
    end
  end

  def cursor_down(wrap = false)
    super wrap
    @stats_help_window.contents.clear
    @stats_help_window.draw_text_ex(4, 0, prep_desc(current_ext[1].description))
  end

  def cursor_up(wrap = false)
    super wrap
    @stats_help_window.contents.clear
    @stats_help_window.draw_text_ex(4, 0, prep_desc(current_ext[1].description))
  end
end

module YEA
  module DEBUG
    COMMANDS << [:stats, "#{$game_text["cheatmenu:modules/statsedit:commands/stats"]}"]
  end
end

class Scene_Debug
  alias_method :create_command_window_MODULE_STATSEDIT, :create_command_window

  def create_command_window
    create_command_window_MODULE_STATSEDIT
    @command_window.set_handler(:stats, method(:command_stats)) if CheatUtils.ingame?
  end

  def create_stats_window
    @stats_help_window = Window_Base.new(((Graphics.width - 160) / 2) + 160, 0, (Graphics.width - 160) / 2, Graphics.height - 120)
    @stats_window = Window_DebugStats.new(@stats_help_window)
    @stats_window.set_handler(:cancel, method(:on_stats_cancel))
  end

  def command_stats
    create_stats_window if @stats_window == nil
    @dummy_window.hide
    @stats_window.show
    @stats_help_window.show
    @stats_window.activate
    refresh_help_window(:stats, "#{$game_text["cheatmenu:modules/statsedit:command_help/stats_0"]}\n#{$game_text["cheatmenu:modules/statsedit:command_help/stats_1"]}\n\n")
  end

  def on_stats_cancel
    @dummy_window.show
    @stats_window.hide
    @stats_help_window.hide
    @command_window.activate
    refresh_help_window(:cancel, "")
  end
end

$CHEATSMOD_CHEATMODULES["Stats Editor"] = true
