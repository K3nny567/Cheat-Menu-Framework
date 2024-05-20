# Cheats Mod Module - Legacy module

#
module CheatMenuFramework
  module MENU
    COMMANDS << [:heal, "#{$mod_cheats.getText("modules/legacy:commands/heal")}"]
    COMMANDS << [:healw, "#{$mod_cheats.getText("modules/legacy:commands/healw")}"]
    COMMANDS << [:fall, "#{$mod_cheats.getText("modules/legacy:commands/fall")}"]
    COMMANDS << [:gib, "#{$mod_cheats.getText("modules/legacy:commands/gib")}"]
    COMMANDS << [:lvl99, "#{$mod_cheats.getText("modules/legacy:commands/lvl99")}"]
    COMMANDS << [:stronk, "#{$mod_cheats.getText("modules/legacy:commands/stronk")}"]
  end
end

class Scene_CheatMenu
  alias_method :create_command_window_MODULE_LEGACY, :create_command_window

  def create_command_window
    create_command_window_MODULE_LEGACY
    @command_window.set_handler(:heal, method(:command_heal)) if CheatUtils.ingame?
    @command_window.set_handler(:healw, method(:command_healwound)) if CheatUtils.ingame?
    @command_window.set_handler(:fall, method(:command_exhaust)) if CheatUtils.ingame?
    @command_window.set_handler(:gib, method(:command_gib_moneh)) if CheatUtils.ingame?
    @command_window.set_handler(:lvl99, method(:command_lvl_99)) if CheatUtils.ingame?
    @command_window.set_handler(:stronk, method(:command_make_stronk)) if CheatUtils.ingame?
  end

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
end

$mod_cheats.modules["Legacy"] = true
