module CheatUtils
  def self.abom?
    return $game_player.actor.stat["RaceRecord"] == "Abomination"
  end

  def self.AbomSkills
    [66, 67].each {
      |skillID|
      $game_player.actor.learn_skill(skillID) if self.abom?
      $game_player.actor.forget_skill(skillID) if !self.abom?
    }
  end
end

class Window_CheatMenuRace
  alias_method :raceCurrent_MODULE_ABOMSKILLS, :raceCurrent

  def raceCurrent
    raceCurrent_MODULE_ABOMSKILLS
    CheatUtils.AbomSkills
  end
end

$mod_cheats.modules["Abomination Skills"] = true
