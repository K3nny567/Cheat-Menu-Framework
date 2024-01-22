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
    add_command("#{CheatsMod.getTextInfo("CheatMod:cheat/dirt")}", :cheatToggle, true, "toggle_dirt")
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
    refresh
  end

  def draw_item(index)
    if @list[index][:ext] == "toggle_dirt"
      name = command_name(index)
      text = $game_player.actor.actStat.get_stat("dirt", 3) == 0 ? "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/off")}]" : "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/on")}]"
      draw_item_content(index, name, text)
    end
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

##---------------------------------------------------------------------------
## Race Menu
##---------------------------------------------------------------------------
class Window_DebugRace < Window_Command

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
    add_command("#{CheatsMod.getTextInfo("CheatMod:commands_race/human")}", :raceCurrent, true, "Human")
    add_command("#{CheatsMod.getTextInfo("CheatMod:commands_race/moot")}", :raceCurrent, true, "Moot")
    add_command("#{CheatsMod.getTextInfo("CheatMod:commands_race/deepone")}", :raceCurrent, true, "Deepone")
    add_command("#{CheatsMod.getTextInfo("CheatMod:commands_race/truedeepone")}", :raceCurrent, true, "TrueDeepone")
    add_command("#{CheatsMod.getTextInfo("CheatMod:commands_race/abom_human")}", :raceCurrent, true, "HumanAbomination")
    add_command("#{CheatsMod.getTextInfo("CheatMod:commands_race/abom_moot")}", :raceCurrent, true, "MootAbomination")
  end

  def raceCurrent
    name = current_ext
    begin
      if !name.nil?
        $story_stats["DreamPTSD"] = 0
        $game_player.actor.erase_state("AbomSickly")
        $game_player.actor.erase_state("TrueDeepone")
        $game_player.actor.erase_state("PreDeepone")
        $game_player.actor.erase_state("Moot")
        $game_player.actor.erase_state("Tail")
        case name
        when "Moot"
          $game_player.actor.record_lona_race = "Moot"
          $game_player.actor.stat["Race"] = "Moot"
          $game_player.actor.race = "Moot"
          $game_player.actor.add_state("Moot")
          $game_player.actor.add_state("Tail")
        when "Deepone"
          $game_player.actor.record_lona_race = "PreDeepone"
          $game_player.actor.stat["Race"] = "Human"
          $game_player.actor.race = "Human"
          $game_player.actor.add_state("PreDeepone")
        when "TrueDeepone"
          $game_player.actor.record_lona_race = "TrueDeepone"
          $game_player.actor.stat["Race"] = "Deepone"
          $game_player.actor.race = "Deepone"
          $game_player.actor.add_state("TrueDeepone")
        when "HumanAbomination"
          $game_player.actor.record_lona_race = "Abomination"
          $game_player.actor.stat["Race"] = "Human"
          $game_player.actor.race = "Human"
          $story_stats["DreamPTSD"] = "Abomination"
          $game_player.actor.add_state("AbomSickly")
        when "MootAbomination"
          $game_player.actor.record_lona_race = "Abomination"
          $game_player.actor.stat["Race"] = "Moot"
          $game_player.actor.race = "Moot"
          $story_stats["DreamPTSD"] = "Abomination"
          $game_player.actor.add_state("AbomSickly")
          $game_player.actor.add_state("Moot")
        else # Human
          $game_player.actor.record_lona_race = "Human"
          $game_player.actor.stat["Race"] = "Human"
          $game_player.actor.race = "Human"
        end
      end
    rescue => e
      p "Oops, something gone wrong: cannot do event #{name} because #{e.message}"
      SndLib.sys_buzzer
    end
  end

  def cursor_left(wrap = false)
    cursor_pageup
  end

  def cursor_right(wrap = false)
    cursor_pagedown
  end
end # Window_DebugRace

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
    add_command("", :morality, true, "#{CheatsMod.getTextInfo("CheatMod:commands_morality/command")}")
  end

  def morality
    # dummy
  end

  def updateMorality
    $game_player.actor.morality = $game_player.actor.morality_lona
  end

  #--------------------------------------------------------------------------
  # draw_item
  #--------------------------------------------------------------------------
  def draw_item(index)
    updateMorality
    contents.clear_rect(item_rect_for_text(index))
    rect = item_rect_for_text(index)
    name = @list[index][:ext]
    change_color(param_change_color($game_player.actor.morality_lona))
    draw_text(rect, command_name(index))
    rect.x += text_size(command_name(index)).width
    rect.width -= text_size(command_name(index)).width
    draw_text(rect, name)
    text = sprintf("%s", $game_player.actor.morality_lona)
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
    COMMANDS = [
      [:toggle_cheats, "#{CheatsMod.getTextInfo("CheatMod:commands/cheats")}"],
      [:make_race, "#{CheatsMod.getTextInfo("CheatMod:commands/race")}"],
      [:set_morality, "#{CheatsMod.getTextInfo("CheatMod:commands/morality")}"],
      [:heal, "#{CheatsMod.getTextInfo("CheatMod:commands/heal")}"],
      [:healw, "#{CheatsMod.getTextInfo("CheatMod:commands/healw")}"],
      [:fall, "#{CheatsMod.getTextInfo("CheatMod:commands/fall")}"],
      [:gib, "#{CheatsMod.getTextInfo("CheatMod:commands/gib")}"],
      [:lvl99, "#{CheatsMod.getTextInfo("CheatMod:commands/lvl99")}"],
      [:stronk, "#{CheatsMod.getTextInfo("CheatMod:commands/stronk")}"],
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
    @command_window.set_handler(:make_race, method(:command_race)) if CheatUtils.ingame?
    @command_window.set_handler(:set_morality, method(:command_morality)) if CheatUtils.ingame?
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
    refresh_help_window(:toggle_cheats, "#{CheatsMod.getTextInfo("CheatMod:command_help/cheats_0")}\n#{CheatsMod.getTextInfo("CheatMod:command_help/cheats_1")}\n\n")
  end # Toggle Cheats Window

  # Race Window
  def create_race_window
    @race_window = Window_DebugRace.new
    @race_window.set_handler(:ok, method(:on_race_ok))
    @race_window.set_handler(:cancel, method(:on_race_cancel))
  end

  def on_race_ok
    @race_window.activate
    @race_window.raceCurrent
  end

  def on_race_cancel
    @dummy_window.show
    @race_window.hide
    @command_window.activate
    refresh_help_window(:cancel, "")
  end

  def command_race
    create_race_window if @race_window == nil
    @dummy_window.hide
    @race_window.show
    @race_window.activate
    refresh_help_window(:make_race, "#{CheatsMod.getTextInfo("CheatMod:command_help/race_0")}\n#{CheatsMod.getTextInfo("CheatMod:command_help/race_1")}\n\n")
  end # Race Window

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
    refresh_help_window(@command_window.current_symbol, "#{CheatsMod.getTextInfo("CheatMod:command_help/morality_0")}\n#{CheatsMod.getTextInfo("CheatMod:command_help/morality_1")}\n#{CheatsMod.getTextInfo("CheatMod:command_help/morality_2")}\n#{CheatsMod.getTextInfo("CheatMod:command_help/morality_3")}")
  end # Morality Window

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
