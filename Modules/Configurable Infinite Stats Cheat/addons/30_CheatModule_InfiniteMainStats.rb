# Cheats Mod Module - Infinite Main Stats

#

module CheatUtils
  def self.heal_player
    self.player_heal(999, true)
    self.player_feed(999, true)
    self.player_rest(999, true)
  end

  def self.player_heal(value, mode)
    return if !self.ingame?
    $game_player.actor.health += value if mode
    return if mode
    @health_max = $game_player.actor.actStat.get_stat("health", 2)
    @health_limit = @health_max * $cheat_infinite_health_limit
    @health_rate = @health_max * $cheat_infinite_health_rate
    case $cheat_infinite_health_mode
    when "OnlyBelow"
      if $game_player.actor.health < @health_limit
        $game_player.actor.health += @health_rate
      end
    when "DropsBelow"
      if $game_player.actor.health < @health_limit
        $cheat_infinite_health_loop = true
      end
      if $game_player.actor.health < @health_max && $cheat_infinite_health_loop
        $game_player.actor.health += @health_rate
      end
      if $game_player.actor.health >= @health_max && $cheat_infinite_health_loop
        $cheat_infinite_health_loop = false
      end
    end
  end

  def self.player_feed(value, mode)
    return if !self.ingame?
    $game_player.actor.sat += value if mode
    return if mode
    @food_max = $game_player.actor.actStat.get_stat("sat", 2)
    @food_limit = @food_max * $cheat_infinite_food_limit
    @food_rate = @food_max * $cheat_infinite_food_rate
    case $cheat_infinite_food_mode
    when "OnlyBelow"
      if $game_player.actor.sat < @food_limit
        $game_player.actor.sat += @food_rate
      end
    when "DropsBelow"
      if $game_player.actor.sat < @food_limit
        $cheat_infinite_food_loop = true
      end
      if $game_player.actor.sat < @food_max && $cheat_infinite_food_loop
        $game_player.actor.sat += @food_rate
      end
      if $game_player.actor.sat >= @food_max && $cheat_infinite_food_loop
        $cheat_infinite_food_loop = false
      end
    end
  end

  def self.player_rest(value, mode)
    return if !self.ingame?
    $game_player.actor.sta += value if mode
    return if mode
    @stamina_max = $game_player.actor.actStat.get_stat("sta", 2)
    @stamina_limit = @stamina_max * $cheat_infinite_stamina_limit
    @stamina_rate = @stamina_max * $cheat_infinite_stamina_rate
    case $cheat_infinite_stamina_mode
    when "OnlyBelow"
      if $game_player.actor.sta < @stamina_limit
        $game_player.actor.sta += @stamina_rate
      end
    when "DropsBelow"
      if $game_player.actor.sta < @stamina_limit
        $cheat_infinite_stamina_loop = true
      end
      if $game_player.actor.sta < @stamina_max && $cheat_infinite_stamina_loop
        $game_player.actor.sta += @stamina_rate
      end
      if $game_player.actor.sta >= @stamina_max && $cheat_infinite_stamina_loop
        $cheat_infinite_stamina_loop = false
      end
    end
  end

  def self.toggle_infinite_stats
    self.toggle_infinite_health
    self.toggle_infinite_food
    self.toggle_infinite_stamina
  end

  def self.load_infinite_stats_config
    $cheat_infinite_health_limit = FileGetter.cheat_load("Cheats Mod - Infinite Main Stats: Config", "HealthRegenLimit", 0.20)
    $cheat_infinite_health_rate = FileGetter.cheat_load("Cheats Mod - Infinite Main Stats: Config", "HealthRegenRate", 0.01)
    $cheat_infinite_food_limit = FileGetter.cheat_load("Cheats Mod - Infinite Main Stats: Config", "FoodRegenLimit", 0.10)
    $cheat_infinite_food_rate = FileGetter.cheat_load("Cheats Mod - Infinite Main Stats: Config", "FoodRegenRate", 0.005)
    $cheat_infinite_stamina_limit = FileGetter.cheat_load("Cheats Mod - Infinite Main Stats: Config", "StaminaRegenLimit", 0.40)
    $cheat_infinite_stamina_rate = FileGetter.cheat_load("Cheats Mod - Infinite Main Stats: Config", "StaminaRegenRate", 0.002)
    $cheat_infinite_health_mode = FileGetter.cheat_load("Cheats Mod - Infinite Main Stats: Config", "HealthRegenMode", "OnlyBelow")
    $cheat_infinite_food_mode = FileGetter.cheat_load("Cheats Mod - Infinite Main Stats: Config", "FoodRegenMode", "OnlyBelow")
    $cheat_infinite_stamina_mode = FileGetter.cheat_load("Cheats Mod - Infinite Main Stats: Config", "StaminaRegenMode", "OnlyBelow")
  end

  def self.save_infinite_stats_config
    FileGetter.cheat_save("Cheats Mod - Infinite Main Stats: Config", "HealthRegenLimit", $cheat_infinite_health_limit)
    FileGetter.cheat_save("Cheats Mod - Infinite Main Stats: Config", "HealthRegenRate", $cheat_infinite_health_rate)
    FileGetter.cheat_save("Cheats Mod - Infinite Main Stats: Config", "FoodRegenLimit", $cheat_infinite_food_limit)
    FileGetter.cheat_save("Cheats Mod - Infinite Main Stats: Config", "FoodRegenRate", $cheat_infinite_food_rate)
    FileGetter.cheat_save("Cheats Mod - Infinite Main Stats: Config", "StaminaRegenLimit", $cheat_infinite_stamina_limit)
    FileGetter.cheat_save("Cheats Mod - Infinite Main Stats: Config", "StaminaRegenRate", $cheat_infinite_stamina_rate)
    FileGetter.cheat_save("Cheats Mod - Infinite Main Stats: Config", "HealthRegenMode", $cheat_infinite_health_mode)
    FileGetter.cheat_save("Cheats Mod - Infinite Main Stats: Config", "FoodRegenMode", $cheat_infinite_food_mode)
    FileGetter.cheat_save("Cheats Mod - Infinite Main Stats: Config", "StaminaRegenMode", $cheat_infinite_stamina_mode)
  end

  def self.toggle_infinite_health
    $cheat_infinite_health = !$cheat_infinite_health
    FileGetter.cheat_save("Cheats Mod - Modules", "Infinite Health", $cheat_infinite_health)
  end

  def self.toggle_infinite_food
    $cheat_infinite_food = !$cheat_infinite_food
    FileGetter.cheat_save("Cheats Mod - Modules", "Infinite Food", $cheat_infinite_food)
  end

  def self.toggle_infinite_stamina
    $cheat_infinite_stamina = !$cheat_infinite_stamina
    FileGetter.cheat_save("Cheats Mod - Modules", "Infinite Stamina", $cheat_infinite_stamina)
  end
end

module CheatsMod
  self.singleton_class.send(:alias_method, :cheat_triggers_CHEATSMODULE_AUTOHEAL, :cheat_triggers)

  ##---------------------------------------------------------------------------
  ## Hotkeys
  ##---------------------------------------------------------------------------
  def self.cheat_triggers
    cheat_triggers_CHEATSMODULE_AUTOHEAL
    if Input.trigger?(Input::F8)
      CheatUtils.heal_player
      SndLib.buff_life
    end
    if Input.trigger?(Input::F5)
      CheatUtils.toggle_infinite_stats
      SndLib.sys_ok
    end
    if $cheat_infinite_health
      CheatUtils.player_heal(nil, false)
    end
    if $cheat_infinite_food
      CheatUtils.player_feed(nil, false)
    end
    if $cheat_infinite_stamina
      CheatUtils.player_rest(nil, false)
    end
  end
end

class Window_DebugCheats
  alias_method :make_command_list_CHEATSMODULE_AUTOHEAL, :make_command_list
  alias_method :cheatToggle_CHEATSMODULE_AUTOHEAL, :cheatToggle
  alias_method :draw_item_CHEATSMODULE_AUTOHEAL, :draw_item

  def make_command_list
    make_command_list_CHEATSMODULE_AUTOHEAL
    add_command("#{CheatsMod.getTextInfo("modules/infinitestats:cheat/health")}", :cheatToggle, true, "toggle_infinite_health")
    add_command("#{CheatsMod.getTextInfo("modules/infinitestats:cheat/food")}", :cheatToggle, true, "toggle_infinite_food")
    add_command("#{CheatsMod.getTextInfo("modules/infinitestats:cheat/stamina")}", :cheatToggle, true, "toggle_infinite_stamina")
  end

  def cheatToggle
    name = current_ext
    begin
      if !name.nil?
        case name
        when "toggle_infinite_health"
          CheatUtils.toggle_infinite_health
        when "toggle_infinite_food"
          CheatUtils.toggle_infinite_food
        when "toggle_infinite_stamina"
          CheatUtils.toggle_infinite_stamina
        end
      end
    rescue => e
      p "Oops, something gone wrong: cannot do event #{name} because #{e.message}"
      SndLib.sys_buzzer
    end
    cheatToggle_CHEATSMODULE_AUTOHEAL
  end

  def draw_item(index)
    draw_item_CHEATSMODULE_AUTOHEAL(index)
    if @list[index][:ext] == "toggle_infinite_health"
      name = command_name(index)
      text = $cheat_infinite_health ? "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/on")}]" : "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/off")}]"
      draw_item_content(index, name, text)
    end
    if @list[index][:ext] == "toggle_infinite_food"
      name = command_name(index)
      text = $cheat_infinite_food ? "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/on")}]" : "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/off")}]"
      draw_item_content(index, name, text)
    end
    if @list[index][:ext] == "toggle_infinite_stamina"
      name = command_name(index)
      text = $cheat_infinite_stamina ? "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/on")}]" : "[#{CheatsMod.getTextInfo("CheatMod:cheat_toggle/off")}]"
      draw_item_content(index, name, text)
    end
  end
end

if !$CHEATSMOD_CHEATMODULES["Infinite Main Stats"]
  $cheat_infinite_health = FileGetter.cheat_load("Cheats Mod - Modules", "Infinite Health", false)
  $cheat_infinite_food = FileGetter.cheat_load("Cheats Mod - Modules", "Infinite Food", false)
  $cheat_infinite_stamina = FileGetter.cheat_load("Cheats Mod - Modules", "Infinite Stamina", false)

  CheatUtils.load_infinite_stats_config

  $cheat_infinite_health_loop = false
  $cheat_infinite_food_loop = false
  $cheat_infinite_stamina_loop = false

  $CHEATSMOD_CHEATMODULES["Infinite Main Stats"] = true
end
