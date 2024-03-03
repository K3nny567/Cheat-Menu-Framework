# Cheats Mod Module - Race Changer

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
    add_command("#{$game_text["cheatmenu:modules/race:commands_race/human"]}", :raceCurrent, true, "Human")
    add_command("#{$game_text["cheatmenu:modules/race:commands_race/moot"]}", :raceCurrent, true, "Moot")
    add_command("#{$game_text["cheatmenu:modules/race:commands_race/deepone"]}", :raceCurrent, true, "Deepone")
    add_command("#{$game_text["cheatmenu:modules/race:commands_race/truedeepone"]}", :raceCurrent, true, "TrueDeepone")
    add_command("#{$game_text["cheatmenu:modules/race:commands_race/abom_human"]}", :raceCurrent, true, "HumanAbomination")
    add_command("#{$game_text["cheatmenu:modules/race:commands_race/abom_moot"]}", :raceCurrent, true, "MootAbomination")
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

module YEA
  module DEBUG
    COMMANDS << [:make_race, "#{$game_text["cheatmenu:modules/race:commands/race"]}"]
  end
end

class Scene_Debug
  alias_method :create_command_window_MODULE_RACECHANGER, :create_command_window

  def create_command_window
    create_command_window_MODULE_RACECHANGER
    @command_window.set_handler(:make_race, method(:command_race)) if CheatUtils.ingame?
  end

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
    refresh_help_window(:make_race, "#{$game_text["cheatmenu:modules/race:command_help/race_0"]}\n#{$game_text["cheatmenu:modules/race:command_help/race_1"]}\n\n")
  end # Race Window
end

$CHEATSMOD_CHEATMODULES["Race Changer"] = true
