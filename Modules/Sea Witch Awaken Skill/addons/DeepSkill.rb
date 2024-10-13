module CheatUtils
  def self.deepone?
    case $game_player.actor.stat["RaceRecord"]
    when "PreDeepone"
      return true
    when "TrueDeepone"
      return true
    else
      return false
    end
  end

  def self.DeepSkill
    [65].each {
      |skillID|
      $game_player.actor.learn_skill(skillID) if self.deepone?
      $game_player.actor.forget_skill(skillID) if !self.deepone?
    }
  end
end

class Window_CheatMenuRace
  alias_method :raceCurrent_MODULE_DEEPSKILL, :raceCurrent

  def raceCurrent
    raceCurrent_MODULE_DEEPSKILL
    CheatUtils.DeepSkill
  end
end

$mod_cheats.modules["Sea Witch Awaken Skill"] = true
